
obj/user/sh.debug:     formato del fichero elf32-i386


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
  80002c:	e8 d1 09 00 00       	call   800a02 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 0c             	sub    $0xc,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800043:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800046:	85 db                	test   %ebx,%ebx
  800048:	74 1a                	je     800064 <_gettoken+0x31>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80004a:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800051:	7f 31                	jg     800084 <_gettoken+0x51>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800053:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800059:	8b 45 10             	mov    0x10(%ebp),%eax
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  800062:	eb 3a                	jmp    80009e <_gettoken+0x6b>
		return 0;
  800064:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800069:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800070:	7e 59                	jle    8000cb <_gettoken+0x98>
			cprintf("GETTOKEN NULL\n");
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	68 00 35 80 00       	push   $0x803500
  80007a:	e8 d6 0a 00 00       	call   800b55 <cprintf>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	eb 47                	jmp    8000cb <_gettoken+0x98>
		cprintf("GETTOKEN: %s\n", s);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	53                   	push   %ebx
  800088:	68 0f 35 80 00       	push   $0x80350f
  80008d:	e8 c3 0a 00 00       	call   800b55 <cprintf>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	eb bc                	jmp    800053 <_gettoken+0x20>
		*s++ = 0;
  800097:	83 c3 01             	add    $0x1,%ebx
  80009a:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	0f be 03             	movsbl (%ebx),%eax
  8000a4:	50                   	push   %eax
  8000a5:	68 1d 35 80 00       	push   $0x80351d
  8000aa:	e8 29 12 00 00       	call   8012d8 <strchr>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	85 c0                	test   %eax,%eax
  8000b4:	75 e1                	jne    800097 <_gettoken+0x64>
	if (*s == 0) {
  8000b6:	0f b6 03             	movzbl (%ebx),%eax
  8000b9:	84 c0                	test   %al,%al
  8000bb:	75 2a                	jne    8000e7 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000bd:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000c2:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c9:	7f 0a                	jg     8000d5 <_gettoken+0xa2>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000cb:	89 f0                	mov    %esi,%eax
  8000cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
			cprintf("EOL\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 22 35 80 00       	push   $0x803522
  8000dd:	e8 73 0a 00 00       	call   800b55 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb e4                	jmp    8000cb <_gettoken+0x98>
	if (strchr(SYMBOLS, *s)) {
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	50                   	push   %eax
  8000ee:	68 33 35 80 00       	push   $0x803533
  8000f3:	e8 e0 11 00 00       	call   8012d8 <strchr>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	74 2c                	je     80012b <_gettoken+0xf8>
		t = *s;
  8000ff:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800102:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800104:	c6 03 00             	movb   $0x0,(%ebx)
  800107:	83 c3 01             	add    $0x1,%ebx
  80010a:	8b 45 10             	mov    0x10(%ebp),%eax
  80010d:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800116:	7e b3                	jle    8000cb <_gettoken+0x98>
			cprintf("TOK %c\n", t);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	68 27 35 80 00       	push   $0x803527
  800121:	e8 2f 0a 00 00       	call   800b55 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	eb a0                	jmp    8000cb <_gettoken+0x98>
	*p1 = s;
  80012b:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012d:	eb 03                	jmp    800132 <_gettoken+0xff>
		s++;
  80012f:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800132:	0f b6 03             	movzbl (%ebx),%eax
  800135:	84 c0                	test   %al,%al
  800137:	74 18                	je     800151 <_gettoken+0x11e>
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	0f be c0             	movsbl %al,%eax
  80013f:	50                   	push   %eax
  800140:	68 2f 35 80 00       	push   $0x80352f
  800145:	e8 8e 11 00 00       	call   8012d8 <strchr>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	85 c0                	test   %eax,%eax
  80014f:	74 de                	je     80012f <_gettoken+0xfc>
	*p2 = s;
  800151:	8b 45 10             	mov    0x10(%ebp),%eax
  800154:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800156:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  80015b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800162:	0f 8e 63 ff ff ff    	jle    8000cb <_gettoken+0x98>
		t = **p2;
  800168:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  80016b:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 37                	pushl  (%edi)
  800173:	68 3b 35 80 00       	push   $0x80353b
  800178:	e8 d8 09 00 00       	call   800b55 <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 38 ff ff ff       	jmp    8000cb <_gettoken+0x98>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char *np1, *np2;

	if (s) {
  8001a0:	85 c0                	test   %eax,%eax
  8001a2:	74 22                	je     8001c6 <gettoken+0x33>
		nc = _gettoken(s, &np1, &np2);
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 0c 50 80 00       	push   $0x80500c
  8001ac:	68 10 50 80 00       	push   $0x805010
  8001b1:	50                   	push   %eax
  8001b2:	e8 7c fe ff ff       	call   800033 <_gettoken>
  8001b7:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
	c = nc;
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001d0:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 0c 50 80 00       	push   $0x80500c
  8001e3:	68 10 50 80 00       	push   $0x805010
  8001e8:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ee:	e8 40 fe ff ff       	call   800033 <_gettoken>
  8001f3:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f8:	a1 04 50 80 00       	mov    0x805004,%eax
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	eb c2                	jmp    8001c4 <gettoken+0x31>

00800202 <runcmd>:
{
  800202:	f3 0f 1e fb          	endbr32 
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800212:	6a 00                	push   $0x0
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	e8 77 ff ff ff       	call   800193 <gettoken>
  80021c:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  80021f:	8d 7d a4             	lea    -0x5c(%ebp),%edi
	argc = 0;
  800222:	be 00 00 00 00       	mov    $0x0,%esi
		switch ((c = gettoken(0, &t))) {
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	57                   	push   %edi
  80022b:	6a 00                	push   $0x0
  80022d:	e8 61 ff ff ff       	call   800193 <gettoken>
  800232:	89 c3                	mov    %eax,%ebx
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	83 f8 3e             	cmp    $0x3e,%eax
  80023a:	0f 84 8b 01 00 00    	je     8003cb <runcmd+0x1c9>
  800240:	7e 72                	jle    8002b4 <runcmd+0xb2>
  800242:	83 f8 77             	cmp    $0x77,%eax
  800245:	0f 84 3e 01 00 00    	je     800389 <runcmd+0x187>
  80024b:	83 f8 7c             	cmp    $0x7c,%eax
  80024e:	0f 85 ab 02 00 00    	jne    8004ff <runcmd+0x2fd>
			if ((r = pipe(p)) < 0) {
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  80025d:	50                   	push   %eax
  80025e:	e8 6f 2c 00 00       	call   802ed2 <pipe>
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	85 c0                	test   %eax,%eax
  800268:	0f 88 df 01 00 00    	js     80044d <runcmd+0x24b>
			if (debug)
  80026e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800275:	0f 85 ed 01 00 00    	jne    800468 <runcmd+0x266>
			if ((r = fork()) < 0) {
  80027b:	e8 7b 18 00 00       	call   801afb <fork>
  800280:	89 c3                	mov    %eax,%ebx
  800282:	85 c0                	test   %eax,%eax
  800284:	0f 88 ff 01 00 00    	js     800489 <runcmd+0x287>
			if (r == 0) {
  80028a:	0f 85 0f 02 00 00    	jne    80049f <runcmd+0x29d>
				if (p[0] != 0) {
  800290:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	0f 85 22 02 00 00    	jne    8004c0 <runcmd+0x2be>
				close(p[1]);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002a7:	e8 bc 1c 00 00       	call   801f68 <close>
				goto again;
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	e9 6e ff ff ff       	jmp    800222 <runcmd+0x20>
		switch ((c = gettoken(0, &t))) {
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	0f 85 9a 00 00 00    	jne    800356 <runcmd+0x154>
	if (argc == 0) {
  8002bc:	85 f6                	test   %esi,%esi
  8002be:	0f 84 4d 02 00 00    	je     800511 <runcmd+0x30f>
	if (argv[0][0] != '/') {
  8002c4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002c7:	80 38 2f             	cmpb   $0x2f,(%eax)
  8002ca:	0f 85 63 02 00 00    	jne    800533 <runcmd+0x331>
	argv[argc] = 0;
  8002d0:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8002d7:	00 
	if (debug) {
  8002d8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002df:	0f 85 76 02 00 00    	jne    80055b <runcmd+0x359>
	if ((r = spawn(argv[0], (const char **) argv)) < 0)
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 a8             	pushl  -0x58(%ebp)
  8002ef:	e8 ff 26 00 00       	call   8029f3 <spawn>
  8002f4:	89 c6                	mov    %eax,%esi
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	85 c0                	test   %eax,%eax
  8002fb:	0f 88 a8 02 00 00    	js     8005a9 <runcmd+0x3a7>
	close_all();
  800301:	e8 93 1c 00 00       	call   801f99 <close_all>
		if (debug)
  800306:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80030d:	0f 85 e3 02 00 00    	jne    8005f6 <runcmd+0x3f4>
		wait(r);
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	56                   	push   %esi
  800317:	e8 3b 2d 00 00       	call   803057 <wait>
		if (debug)
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800326:	0f 85 e9 02 00 00    	jne    800615 <runcmd+0x413>
	if (pipe_child) {
  80032c:	85 db                	test   %ebx,%ebx
  80032e:	74 19                	je     800349 <runcmd+0x147>
		wait(pipe_child);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	53                   	push   %ebx
  800334:	e8 1e 2d 00 00       	call   803057 <wait>
		if (debug)
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800343:	0f 85 e7 02 00 00    	jne    800630 <runcmd+0x42e>
	exit();
  800349:	e8 02 07 00 00       	call   800a50 <exit>
}
  80034e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    
		switch ((c = gettoken(0, &t))) {
  800356:	83 f8 3c             	cmp    $0x3c,%eax
  800359:	0f 85 a0 01 00 00    	jne    8004ff <runcmd+0x2fd>
			if (gettoken(0, &t) != 'w') {
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800365:	50                   	push   %eax
  800366:	6a 00                	push   $0x0
  800368:	e8 26 fe ff ff       	call   800193 <gettoken>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	83 f8 77             	cmp    $0x77,%eax
  800373:	75 3f                	jne    8003b4 <runcmd+0x1b2>
			panic("< redirection not implemented");
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	68 59 35 80 00       	push   $0x803559
  80037d:	6a 3a                	push   $0x3a
  80037f:	68 77 35 80 00       	push   $0x803577
  800384:	e8 e5 06 00 00       	call   800a6e <_panic>
			if (argc == MAXARGS) {
  800389:	83 fe 10             	cmp    $0x10,%esi
  80038c:	74 0f                	je     80039d <runcmd+0x19b>
			argv[argc++] = t;
  80038e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800391:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  800395:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  800398:	e9 8a fe ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("too many arguments\n");
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	68 45 35 80 00       	push   $0x803545
  8003a5:	e8 ab 07 00 00       	call   800b55 <cprintf>
				exit();
  8003aa:	e8 a1 06 00 00       	call   800a50 <exit>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	eb da                	jmp    80038e <runcmd+0x18c>
				cprintf("syntax error: < not followed by "
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 98 36 80 00       	push   $0x803698
  8003bc:	e8 94 07 00 00       	call   800b55 <cprintf>
				exit();
  8003c1:	e8 8a 06 00 00       	call   800a50 <exit>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	eb aa                	jmp    800375 <runcmd+0x173>
			if (gettoken(0, &t) != 'w') {
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	57                   	push   %edi
  8003cf:	6a 00                	push   $0x0
  8003d1:	e8 bd fd ff ff       	call   800193 <gettoken>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	83 f8 77             	cmp    $0x77,%eax
  8003dc:	75 24                	jne    800402 <runcmd+0x200>
			if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0) {
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	68 01 03 00 00       	push   $0x301
  8003e6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003e9:	e8 98 21 00 00       	call   802586 <open>
  8003ee:	89 c3                	mov    %eax,%ebx
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	78 22                	js     800419 <runcmd+0x217>
			if (fd != 1) {
  8003f7:	83 f8 01             	cmp    $0x1,%eax
  8003fa:	0f 84 27 fe ff ff    	je     800227 <runcmd+0x25>
  800400:	eb 30                	jmp    800432 <runcmd+0x230>
				cprintf("syntax error: > not followed by "
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	68 c0 36 80 00       	push   $0x8036c0
  80040a:	e8 46 07 00 00       	call   800b55 <cprintf>
				exit();
  80040f:	e8 3c 06 00 00       	call   800a50 <exit>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb c5                	jmp    8003de <runcmd+0x1dc>
				cprintf("open %s for write: %e", t, fd);
  800419:	83 ec 04             	sub    $0x4,%esp
  80041c:	50                   	push   %eax
  80041d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800420:	68 81 35 80 00       	push   $0x803581
  800425:	e8 2b 07 00 00       	call   800b55 <cprintf>
				exit();
  80042a:	e8 21 06 00 00       	call   800a50 <exit>
  80042f:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	6a 01                	push   $0x1
  800437:	53                   	push   %ebx
  800438:	e8 85 1b 00 00       	call   801fc2 <dup>
				close(fd);
  80043d:	89 1c 24             	mov    %ebx,(%esp)
  800440:	e8 23 1b 00 00       	call   801f68 <close>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	e9 da fd ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("pipe: %e", r);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	50                   	push   %eax
  800451:	68 97 35 80 00       	push   $0x803597
  800456:	e8 fa 06 00 00       	call   800b55 <cprintf>
				exit();
  80045b:	e8 f0 05 00 00       	call   800a50 <exit>
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	e9 06 fe ff ff       	jmp    80026e <runcmd+0x6c>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800468:	83 ec 04             	sub    $0x4,%esp
  80046b:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800471:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800477:	68 a0 35 80 00       	push   $0x8035a0
  80047c:	e8 d4 06 00 00       	call   800b55 <cprintf>
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	e9 f2 fd ff ff       	jmp    80027b <runcmd+0x79>
				cprintf("fork: %e", r);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	50                   	push   %eax
  80048d:	68 f7 3a 80 00       	push   $0x803af7
  800492:	e8 be 06 00 00       	call   800b55 <cprintf>
				exit();
  800497:	e8 b4 05 00 00       	call   800a50 <exit>
  80049c:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  80049f:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8004a5:	83 f8 01             	cmp    $0x1,%eax
  8004a8:	75 37                	jne    8004e1 <runcmd+0x2df>
				close(p[0]);
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004b3:	e8 b0 1a 00 00       	call   801f68 <close>
				goto runit;
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	e9 fc fd ff ff       	jmp    8002bc <runcmd+0xba>
					dup(p[0], 0);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	6a 00                	push   $0x0
  8004c5:	50                   	push   %eax
  8004c6:	e8 f7 1a 00 00       	call   801fc2 <dup>
					close(p[0]);
  8004cb:	83 c4 04             	add    $0x4,%esp
  8004ce:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004d4:	e8 8f 1a 00 00       	call   801f68 <close>
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	e9 bd fd ff ff       	jmp    80029e <runcmd+0x9c>
					dup(p[1], 1);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	6a 01                	push   $0x1
  8004e6:	50                   	push   %eax
  8004e7:	e8 d6 1a 00 00       	call   801fc2 <dup>
					close(p[1]);
  8004ec:	83 c4 04             	add    $0x4,%esp
  8004ef:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004f5:	e8 6e 1a 00 00       	call   801f68 <close>
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb ab                	jmp    8004aa <runcmd+0x2a8>
			panic("bad return %d from gettoken", c);
  8004ff:	53                   	push   %ebx
  800500:	68 ad 35 80 00       	push   $0x8035ad
  800505:	6a 71                	push   $0x71
  800507:	68 77 35 80 00       	push   $0x803577
  80050c:	e8 5d 05 00 00       	call   800a6e <_panic>
		if (debug)
  800511:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800518:	0f 84 30 fe ff ff    	je     80034e <runcmd+0x14c>
			cprintf("EMPTY COMMAND\n");
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	68 c9 35 80 00       	push   $0x8035c9
  800526:	e8 2a 06 00 00       	call   800b55 <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	e9 1b fe ff ff       	jmp    80034e <runcmd+0x14c>
		argv0buf[0] = '/';
  800533:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	50                   	push   %eax
  80053e:	8d bd a4 fb ff ff    	lea    -0x45c(%ebp),%edi
  800544:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  80054a:	50                   	push   %eax
  80054b:	e8 63 0c 00 00       	call   8011b3 <strcpy>
		argv[0] = argv0buf;
  800550:	89 7d a8             	mov    %edi,-0x58(%ebp)
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	e9 75 fd ff ff       	jmp    8002d0 <runcmd+0xce>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  80055b:	a1 24 54 80 00       	mov    0x805424,%eax
  800560:	8b 40 48             	mov    0x48(%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	68 d8 35 80 00       	push   $0x8035d8
  80056c:	e8 e4 05 00 00       	call   800b55 <cprintf>
  800571:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  800574:	83 c4 10             	add    $0x10,%esp
  800577:	83 c6 04             	add    $0x4,%esi
  80057a:	8b 46 fc             	mov    -0x4(%esi),%eax
  80057d:	85 c0                	test   %eax,%eax
  80057f:	74 13                	je     800594 <runcmd+0x392>
			cprintf(" %s", argv[i]);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	50                   	push   %eax
  800585:	68 60 36 80 00       	push   $0x803660
  80058a:	e8 c6 05 00 00       	call   800b55 <cprintf>
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	eb e3                	jmp    800577 <runcmd+0x375>
		cprintf("\n");
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	68 20 35 80 00       	push   $0x803520
  80059c:	e8 b4 05 00 00       	call   800b55 <cprintf>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	e9 3c fd ff ff       	jmp    8002e5 <runcmd+0xe3>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005a9:	83 ec 04             	sub    $0x4,%esp
  8005ac:	50                   	push   %eax
  8005ad:	ff 75 a8             	pushl  -0x58(%ebp)
  8005b0:	68 e6 35 80 00       	push   $0x8035e6
  8005b5:	e8 9b 05 00 00       	call   800b55 <cprintf>
	close_all();
  8005ba:	e8 da 19 00 00       	call   801f99 <close_all>
  8005bf:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005c2:	85 db                	test   %ebx,%ebx
  8005c4:	0f 84 7f fd ff ff    	je     800349 <runcmd+0x147>
		if (debug)
  8005ca:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005d1:	0f 84 59 fd ff ff    	je     800330 <runcmd+0x12e>
			        thisenv->env_id,
  8005d7:	a1 24 54 80 00       	mov    0x805424,%eax
			cprintf("[%08x] WAIT pipe_child %08x\n",
  8005dc:	8b 40 48             	mov    0x48(%eax),%eax
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	50                   	push   %eax
  8005e4:	68 1f 36 80 00       	push   $0x80361f
  8005e9:	e8 67 05 00 00       	call   800b55 <cprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	e9 3a fd ff ff       	jmp    800330 <runcmd+0x12e>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005f6:	a1 24 54 80 00       	mov    0x805424,%eax
  8005fb:	8b 40 48             	mov    0x48(%eax),%eax
  8005fe:	56                   	push   %esi
  8005ff:	ff 75 a8             	pushl  -0x58(%ebp)
  800602:	50                   	push   %eax
  800603:	68 f4 35 80 00       	push   $0x8035f4
  800608:	e8 48 05 00 00       	call   800b55 <cprintf>
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	e9 fe fc ff ff       	jmp    800313 <runcmd+0x111>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800615:	a1 24 54 80 00       	mov    0x805424,%eax
  80061a:	8b 40 48             	mov    0x48(%eax),%eax
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	50                   	push   %eax
  800621:	68 09 36 80 00       	push   $0x803609
  800626:	e8 2a 05 00 00       	call   800b55 <cprintf>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	eb 92                	jmp    8005c2 <runcmd+0x3c0>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800630:	a1 24 54 80 00       	mov    0x805424,%eax
  800635:	8b 40 48             	mov    0x48(%eax),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	50                   	push   %eax
  80063c:	68 09 36 80 00       	push   $0x803609
  800641:	e8 0f 05 00 00       	call   800b55 <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	e9 fb fc ff ff       	jmp    800349 <runcmd+0x147>

0080064e <usage>:


void
usage(void)
{
  80064e:	f3 0f 1e fb          	endbr32 
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800658:	68 e8 36 80 00       	push   $0x8036e8
  80065d:	e8 f3 04 00 00       	call   800b55 <cprintf>
	exit();
  800662:	e8 e9 03 00 00       	call   800a50 <exit>
}
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <umain>:

void
umain(int argc, char **argv)
{
  80066c:	f3 0f 1e fb          	endbr32 
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800679:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	8d 45 08             	lea    0x8(%ebp),%eax
  800683:	50                   	push   %eax
  800684:	e8 be 15 00 00       	call   801c47 <argstart>
	while ((r = argnext(&args)) >= 0)
  800689:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  80068c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  800693:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  800698:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  80069b:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006a0:	eb 10                	jmp    8006b2 <umain+0x46>
			debug++;
  8006a2:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006a9:	eb 07                	jmp    8006b2 <umain+0x46>
			interactive = 1;
  8006ab:	89 f7                	mov    %esi,%edi
  8006ad:	eb 03                	jmp    8006b2 <umain+0x46>
		switch (r) {
  8006af:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006b2:	83 ec 0c             	sub    $0xc,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	e8 c0 15 00 00       	call   801c7b <argnext>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	78 16                	js     8006d8 <umain+0x6c>
		switch (r) {
  8006c2:	83 f8 69             	cmp    $0x69,%eax
  8006c5:	74 e4                	je     8006ab <umain+0x3f>
  8006c7:	83 f8 78             	cmp    $0x78,%eax
  8006ca:	74 e3                	je     8006af <umain+0x43>
  8006cc:	83 f8 64             	cmp    $0x64,%eax
  8006cf:	74 d1                	je     8006a2 <umain+0x36>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006d1:	e8 78 ff ff ff       	call   80064e <usage>
  8006d6:	eb da                	jmp    8006b2 <umain+0x46>
		}

	if (argc > 2)
  8006d8:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006dc:	7f 1f                	jg     8006fd <umain+0x91>
		usage();
	if (argc == 2) {
  8006de:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006e2:	74 20                	je     800704 <umain+0x98>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  8006e4:	83 ff 3f             	cmp    $0x3f,%edi
  8006e7:	74 75                	je     80075e <umain+0xf2>
  8006e9:	85 ff                	test   %edi,%edi
  8006eb:	bf 64 36 80 00       	mov    $0x803664,%edi
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 44 f8             	cmove  %eax,%edi
  8006f8:	e9 06 01 00 00       	jmp    800803 <umain+0x197>
		usage();
  8006fd:	e8 4c ff ff ff       	call   80064e <usage>
  800702:	eb da                	jmp    8006de <umain+0x72>
		close(0);
  800704:	83 ec 0c             	sub    $0xc,%esp
  800707:	6a 00                	push   $0x0
  800709:	e8 5a 18 00 00       	call   801f68 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80070e:	83 c4 08             	add    $0x8,%esp
  800711:	6a 00                	push   $0x0
  800713:	8b 45 0c             	mov    0xc(%ebp),%eax
  800716:	ff 70 04             	pushl  0x4(%eax)
  800719:	e8 68 1e 00 00       	call   802586 <open>
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	85 c0                	test   %eax,%eax
  800723:	78 1b                	js     800740 <umain+0xd4>
		assert(r == 0);
  800725:	74 bd                	je     8006e4 <umain+0x78>
  800727:	68 48 36 80 00       	push   $0x803648
  80072c:	68 4f 36 80 00       	push   $0x80364f
  800731:	68 23 01 00 00       	push   $0x123
  800736:	68 77 35 80 00       	push   $0x803577
  80073b:	e8 2e 03 00 00       	call   800a6e <_panic>
			panic("open %s: %e", argv[1], r);
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	ff 70 04             	pushl  0x4(%eax)
  80074a:	68 3c 36 80 00       	push   $0x80363c
  80074f:	68 22 01 00 00       	push   $0x122
  800754:	68 77 35 80 00       	push   $0x803577
  800759:	e8 10 03 00 00       	call   800a6e <_panic>
		interactive = iscons(0);
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	6a 00                	push   $0x0
  800763:	e8 14 02 00 00       	call   80097c <iscons>
  800768:	89 c7                	mov    %eax,%edi
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	e9 77 ff ff ff       	jmp    8006e9 <umain+0x7d>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  800772:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800779:	75 0a                	jne    800785 <umain+0x119>
				cprintf("EXITING\n");
			exit();  // end of file
  80077b:	e8 d0 02 00 00       	call   800a50 <exit>
  800780:	e9 94 00 00 00       	jmp    800819 <umain+0x1ad>
				cprintf("EXITING\n");
  800785:	83 ec 0c             	sub    $0xc,%esp
  800788:	68 67 36 80 00       	push   $0x803667
  80078d:	e8 c3 03 00 00       	call   800b55 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	eb e4                	jmp    80077b <umain+0x10f>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	68 70 36 80 00       	push   $0x803670
  8007a0:	e8 b0 03 00 00       	call   800b55 <cprintf>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	eb 7c                	jmp    800826 <umain+0x1ba>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	68 7a 36 80 00       	push   $0x80367a
  8007b3:	e8 85 1f 00 00       	call   80273d <printf>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	eb 78                	jmp    800835 <umain+0x1c9>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	68 80 36 80 00       	push   $0x803680
  8007c5:	e8 8b 03 00 00       	call   800b55 <cprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	eb 73                	jmp    800842 <umain+0x1d6>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007cf:	50                   	push   %eax
  8007d0:	68 f7 3a 80 00       	push   $0x803af7
  8007d5:	68 3a 01 00 00       	push   $0x13a
  8007da:	68 77 35 80 00       	push   $0x803577
  8007df:	e8 8a 02 00 00       	call   800a6e <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	50                   	push   %eax
  8007e8:	68 8d 36 80 00       	push   $0x80368d
  8007ed:	e8 63 03 00 00       	call   800b55 <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb 5f                	jmp    800856 <umain+0x1ea>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	56                   	push   %esi
  8007fb:	e8 57 28 00 00       	call   803057 <wait>
  800800:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	57                   	push   %edi
  800807:	e8 70 08 00 00       	call   80107c <readline>
  80080c:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	85 c0                	test   %eax,%eax
  800813:	0f 84 59 ff ff ff    	je     800772 <umain+0x106>
		if (debug)
  800819:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800820:	0f 85 71 ff ff ff    	jne    800797 <umain+0x12b>
		if (buf[0] == '#')
  800826:	80 3b 23             	cmpb   $0x23,(%ebx)
  800829:	74 d8                	je     800803 <umain+0x197>
		if (echocmds)
  80082b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80082f:	0f 85 75 ff ff ff    	jne    8007aa <umain+0x13e>
		if (debug)
  800835:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80083c:	0f 85 7b ff ff ff    	jne    8007bd <umain+0x151>
		if ((r = fork()) < 0)
  800842:	e8 b4 12 00 00       	call   801afb <fork>
  800847:	89 c6                	mov    %eax,%esi
  800849:	85 c0                	test   %eax,%eax
  80084b:	78 82                	js     8007cf <umain+0x163>
		if (debug)
  80084d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800854:	75 8e                	jne    8007e4 <umain+0x178>
		if (r == 0) {
  800856:	85 f6                	test   %esi,%esi
  800858:	75 9d                	jne    8007f7 <umain+0x18b>
			runcmd(buf);
  80085a:	83 ec 0c             	sub    $0xc,%esp
  80085d:	53                   	push   %ebx
  80085e:	e8 9f f9 ff ff       	call   800202 <runcmd>
			exit();
  800863:	e8 e8 01 00 00       	call   800a50 <exit>
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	eb 96                	jmp    800803 <umain+0x197>

0080086d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80086d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	c3                   	ret    

00800877 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800877:	f3 0f 1e fb          	endbr32 
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800881:	68 09 37 80 00       	push   $0x803709
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	e8 25 09 00 00       	call   8011b3 <strcpy>
	return 0;
}
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <devcons_write>:
{
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	57                   	push   %edi
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008a5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008aa:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008b3:	73 31                	jae    8008e6 <devcons_write+0x51>
		m = n - tot;
  8008b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008b8:	29 f3                	sub    %esi,%ebx
  8008ba:	83 fb 7f             	cmp    $0x7f,%ebx
  8008bd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008c2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	89 f0                	mov    %esi,%eax
  8008cb:	03 45 0c             	add    0xc(%ebp),%eax
  8008ce:	50                   	push   %eax
  8008cf:	57                   	push   %edi
  8008d0:	e8 96 0a 00 00       	call   80136b <memmove>
		sys_cputs(buf, m);
  8008d5:	83 c4 08             	add    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	57                   	push   %edi
  8008da:	e8 91 0c 00 00       	call   801570 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008df:	01 de                	add    %ebx,%esi
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	eb ca                	jmp    8008b0 <devcons_write+0x1b>
}
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5f                   	pop    %edi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <devcons_read>:
{
  8008f0:	f3 0f 1e fb          	endbr32 
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8008ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800903:	74 21                	je     800926 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800905:	e8 90 0c 00 00       	call   80159a <sys_cgetc>
  80090a:	85 c0                	test   %eax,%eax
  80090c:	75 07                	jne    800915 <devcons_read+0x25>
		sys_yield();
  80090e:	e8 fd 0c 00 00       	call   801610 <sys_yield>
  800913:	eb f0                	jmp    800905 <devcons_read+0x15>
	if (c < 0)
  800915:	78 0f                	js     800926 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800917:	83 f8 04             	cmp    $0x4,%eax
  80091a:	74 0c                	je     800928 <devcons_read+0x38>
	*(char*)vbuf = c;
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	88 02                	mov    %al,(%edx)
	return 1;
  800921:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800926:	c9                   	leave  
  800927:	c3                   	ret    
		return 0;
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
  80092d:	eb f7                	jmp    800926 <devcons_read+0x36>

0080092f <cputchar>:
{
  80092f:	f3 0f 1e fb          	endbr32 
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80093f:	6a 01                	push   $0x1
  800941:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	e8 26 0c 00 00       	call   801570 <sys_cputs>
}
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <getchar>:
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800959:	6a 01                	push   $0x1
  80095b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	6a 00                	push   $0x0
  800961:	e8 4c 17 00 00       	call   8020b2 <read>
	if (r < 0)
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	85 c0                	test   %eax,%eax
  80096b:	78 06                	js     800973 <getchar+0x24>
	if (r < 1)
  80096d:	74 06                	je     800975 <getchar+0x26>
	return c;
  80096f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    
		return -E_EOF;
  800975:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80097a:	eb f7                	jmp    800973 <getchar+0x24>

0080097c <iscons>:
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800986:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800989:	50                   	push   %eax
  80098a:	ff 75 08             	pushl  0x8(%ebp)
  80098d:	e8 9d 14 00 00       	call   801e2f <fd_lookup>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	85 c0                	test   %eax,%eax
  800997:	78 11                	js     8009aa <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099c:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009a2:	39 10                	cmp    %edx,(%eax)
  8009a4:	0f 94 c0             	sete   %al
  8009a7:	0f b6 c0             	movzbl %al,%eax
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <opencons>:
{
  8009ac:	f3 0f 1e fb          	endbr32 
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	e8 1a 14 00 00       	call   801dd9 <fd_alloc>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	78 3a                	js     800a00 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009c6:	83 ec 04             	sub    $0x4,%esp
  8009c9:	68 07 04 00 00       	push   $0x407
  8009ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d1:	6a 00                	push   $0x0
  8009d3:	e8 63 0c 00 00       	call   80163b <sys_page_alloc>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	85 c0                	test   %eax,%eax
  8009dd:	78 21                	js     800a00 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8009df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e2:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009e8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 a9 13 00 00       	call   801da6 <fd2num>
  8009fd:	83 c4 10             	add    $0x10,%esp
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a02:	f3 0f 1e fb          	endbr32 
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a0e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800a11:	e8 d2 0b 00 00       	call   8015e8 <sys_getenvid>
	if (id >= 0)
  800a16:	85 c0                	test   %eax,%eax
  800a18:	78 12                	js     800a2c <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800a1a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a27:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2c:	85 db                	test   %ebx,%ebx
  800a2e:	7e 07                	jle    800a37 <libmain+0x35>
		binaryname = argv[0];
  800a30:	8b 06                	mov    (%esi),%eax
  800a32:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	e8 2b fc ff ff       	call   80066c <umain>

	// exit gracefully
	exit();
  800a41:	e8 0a 00 00 00       	call   800a50 <exit>
}
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4c:	5b                   	pop    %ebx
  800a4d:	5e                   	pop    %esi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a50:	f3 0f 1e fb          	endbr32 
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a5a:	e8 3a 15 00 00       	call   801f99 <close_all>
	sys_env_destroy(0);
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	6a 00                	push   $0x0
  800a64:	e8 59 0b 00 00       	call   8015c2 <sys_env_destroy>
}
  800a69:	83 c4 10             	add    $0x10,%esp
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a6e:	f3 0f 1e fb          	endbr32 
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a77:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a7a:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a80:	e8 63 0b 00 00       	call   8015e8 <sys_getenvid>
  800a85:	83 ec 0c             	sub    $0xc,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	56                   	push   %esi
  800a8f:	50                   	push   %eax
  800a90:	68 20 37 80 00       	push   $0x803720
  800a95:	e8 bb 00 00 00       	call   800b55 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a9a:	83 c4 18             	add    $0x18,%esp
  800a9d:	53                   	push   %ebx
  800a9e:	ff 75 10             	pushl  0x10(%ebp)
  800aa1:	e8 5a 00 00 00       	call   800b00 <vcprintf>
	cprintf("\n");
  800aa6:	c7 04 24 20 35 80 00 	movl   $0x803520,(%esp)
  800aad:	e8 a3 00 00 00       	call   800b55 <cprintf>
  800ab2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ab5:	cc                   	int3   
  800ab6:	eb fd                	jmp    800ab5 <_panic+0x47>

00800ab8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	53                   	push   %ebx
  800ac0:	83 ec 04             	sub    $0x4,%esp
  800ac3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ac6:	8b 13                	mov    (%ebx),%edx
  800ac8:	8d 42 01             	lea    0x1(%edx),%eax
  800acb:	89 03                	mov    %eax,(%ebx)
  800acd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ad4:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ad9:	74 09                	je     800ae4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800adb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800adf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	68 ff 00 00 00       	push   $0xff
  800aec:	8d 43 08             	lea    0x8(%ebx),%eax
  800aef:	50                   	push   %eax
  800af0:	e8 7b 0a 00 00       	call   801570 <sys_cputs>
		b->idx = 0;
  800af5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	eb db                	jmp    800adb <putch+0x23>

00800b00 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b00:	f3 0f 1e fb          	endbr32 
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b0d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b14:	00 00 00 
	b.cnt = 0;
  800b17:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b1e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b2d:	50                   	push   %eax
  800b2e:	68 b8 0a 80 00       	push   $0x800ab8
  800b33:	e8 80 01 00 00       	call   800cb8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b38:	83 c4 08             	add    $0x8,%esp
  800b3b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b41:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b47:	50                   	push   %eax
  800b48:	e8 23 0a 00 00       	call   801570 <sys_cputs>

	return b.cnt;
}
  800b4d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b55:	f3 0f 1e fb          	endbr32 
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b5f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b62:	50                   	push   %eax
  800b63:	ff 75 08             	pushl  0x8(%ebp)
  800b66:	e8 95 ff ff ff       	call   800b00 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	83 ec 1c             	sub    $0x1c,%esp
  800b76:	89 c7                	mov    %eax,%edi
  800b78:	89 d6                	mov    %edx,%esi
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b87:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800b9a:	39 c2                	cmp    %eax,%edx
  800b9c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800b9f:	72 3e                	jb     800bdf <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ba1:	83 ec 0c             	sub    $0xc,%esp
  800ba4:	ff 75 18             	pushl  0x18(%ebp)
  800ba7:	83 eb 01             	sub    $0x1,%ebx
  800baa:	53                   	push   %ebx
  800bab:	50                   	push   %eax
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb2:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb5:	ff 75 dc             	pushl  -0x24(%ebp)
  800bb8:	ff 75 d8             	pushl  -0x28(%ebp)
  800bbb:	e8 d0 26 00 00       	call   803290 <__udivdi3>
  800bc0:	83 c4 18             	add    $0x18,%esp
  800bc3:	52                   	push   %edx
  800bc4:	50                   	push   %eax
  800bc5:	89 f2                	mov    %esi,%edx
  800bc7:	89 f8                	mov    %edi,%eax
  800bc9:	e8 9f ff ff ff       	call   800b6d <printnum>
  800bce:	83 c4 20             	add    $0x20,%esp
  800bd1:	eb 13                	jmp    800be6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	56                   	push   %esi
  800bd7:	ff 75 18             	pushl  0x18(%ebp)
  800bda:	ff d7                	call   *%edi
  800bdc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800bdf:	83 eb 01             	sub    $0x1,%ebx
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	7f ed                	jg     800bd3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	56                   	push   %esi
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf3:	ff 75 dc             	pushl  -0x24(%ebp)
  800bf6:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf9:	e8 a2 27 00 00       	call   8033a0 <__umoddi3>
  800bfe:	83 c4 14             	add    $0x14,%esp
  800c01:	0f be 80 43 37 80 00 	movsbl 0x803743(%eax),%eax
  800c08:	50                   	push   %eax
  800c09:	ff d7                	call   *%edi
}
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800c16:	83 fa 01             	cmp    $0x1,%edx
  800c19:	7f 13                	jg     800c2e <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800c1b:	85 d2                	test   %edx,%edx
  800c1d:	74 1c                	je     800c3b <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800c1f:	8b 10                	mov    (%eax),%edx
  800c21:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c24:	89 08                	mov    %ecx,(%eax)
  800c26:	8b 02                	mov    (%edx),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800c2e:	8b 10                	mov    (%eax),%edx
  800c30:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c33:	89 08                	mov    %ecx,(%eax)
  800c35:	8b 02                	mov    (%edx),%eax
  800c37:	8b 52 04             	mov    0x4(%edx),%edx
  800c3a:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800c3b:	8b 10                	mov    (%eax),%edx
  800c3d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c40:	89 08                	mov    %ecx,(%eax)
  800c42:	8b 02                	mov    (%edx),%eax
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c49:	c3                   	ret    

00800c4a <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800c4a:	83 fa 01             	cmp    $0x1,%edx
  800c4d:	7f 0f                	jg     800c5e <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800c4f:	85 d2                	test   %edx,%edx
  800c51:	74 18                	je     800c6b <getint+0x21>
		return va_arg(*ap, long);
  800c53:	8b 10                	mov    (%eax),%edx
  800c55:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c58:	89 08                	mov    %ecx,(%eax)
  800c5a:	8b 02                	mov    (%edx),%eax
  800c5c:	99                   	cltd   
  800c5d:	c3                   	ret    
		return va_arg(*ap, long long);
  800c5e:	8b 10                	mov    (%eax),%edx
  800c60:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c63:	89 08                	mov    %ecx,(%eax)
  800c65:	8b 02                	mov    (%edx),%eax
  800c67:	8b 52 04             	mov    0x4(%edx),%edx
  800c6a:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800c6b:	8b 10                	mov    (%eax),%edx
  800c6d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c70:	89 08                	mov    %ecx,(%eax)
  800c72:	8b 02                	mov    (%edx),%eax
  800c74:	99                   	cltd   
}
  800c75:	c3                   	ret    

00800c76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c80:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 10                	mov    (%eax),%edx
  800c86:	3b 50 04             	cmp    0x4(%eax),%edx
  800c89:	73 0a                	jae    800c95 <sprintputch+0x1f>
		*b->buf++ = ch;
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 08                	mov    %ecx,(%eax)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	88 02                	mov    %al,(%edx)
}
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <printfmt>:
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800ca1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800ca4:	50                   	push   %eax
  800ca5:	ff 75 10             	pushl  0x10(%ebp)
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	ff 75 08             	pushl  0x8(%ebp)
  800cae:	e8 05 00 00 00       	call   800cb8 <vprintfmt>
}
  800cb3:	83 c4 10             	add    $0x10,%esp
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <vprintfmt>:
{
  800cb8:	f3 0f 1e fb          	endbr32 
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	83 ec 2c             	sub    $0x2c,%esp
  800cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ccb:	8b 7d 10             	mov    0x10(%ebp),%edi
  800cce:	e9 86 02 00 00       	jmp    800f59 <vprintfmt+0x2a1>
		padc = ' ';
  800cd3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800cd7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800cde:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800ce5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cec:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cf1:	8d 47 01             	lea    0x1(%edi),%eax
  800cf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cf7:	0f b6 17             	movzbl (%edi),%edx
  800cfa:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cfd:	3c 55                	cmp    $0x55,%al
  800cff:	0f 87 df 02 00 00    	ja     800fe4 <vprintfmt+0x32c>
  800d05:	0f b6 c0             	movzbl %al,%eax
  800d08:	3e ff 24 85 80 38 80 	notrack jmp *0x803880(,%eax,4)
  800d0f:	00 
  800d10:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800d13:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800d17:	eb d8                	jmp    800cf1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800d19:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d1c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800d20:	eb cf                	jmp    800cf1 <vprintfmt+0x39>
  800d22:	0f b6 d2             	movzbl %dl,%edx
  800d25:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800d30:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d33:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d37:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d3a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d3d:	83 f9 09             	cmp    $0x9,%ecx
  800d40:	77 52                	ja     800d94 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800d42:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d45:	eb e9                	jmp    800d30 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	8d 50 04             	lea    0x4(%eax),%edx
  800d4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d55:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5c:	79 93                	jns    800cf1 <vprintfmt+0x39>
				width = precision, precision = -1;
  800d5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d64:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d6b:	eb 84                	jmp    800cf1 <vprintfmt+0x39>
  800d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d70:	85 c0                	test   %eax,%eax
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	0f 49 d0             	cmovns %eax,%edx
  800d7a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d7d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d80:	e9 6c ff ff ff       	jmp    800cf1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800d85:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d88:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d8f:	e9 5d ff ff ff       	jmp    800cf1 <vprintfmt+0x39>
  800d94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d97:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d9a:	eb bc                	jmp    800d58 <vprintfmt+0xa0>
			lflag++;
  800d9c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d9f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800da2:	e9 4a ff ff ff       	jmp    800cf1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800da7:	8b 45 14             	mov    0x14(%ebp),%eax
  800daa:	8d 50 04             	lea    0x4(%eax),%edx
  800dad:	89 55 14             	mov    %edx,0x14(%ebp)
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	56                   	push   %esi
  800db4:	ff 30                	pushl  (%eax)
  800db6:	ff d3                	call   *%ebx
			break;
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	e9 96 01 00 00       	jmp    800f56 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc3:	8d 50 04             	lea    0x4(%eax),%edx
  800dc6:	89 55 14             	mov    %edx,0x14(%ebp)
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	99                   	cltd   
  800dcc:	31 d0                	xor    %edx,%eax
  800dce:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dd0:	83 f8 0f             	cmp    $0xf,%eax
  800dd3:	7f 20                	jg     800df5 <vprintfmt+0x13d>
  800dd5:	8b 14 85 e0 39 80 00 	mov    0x8039e0(,%eax,4),%edx
  800ddc:	85 d2                	test   %edx,%edx
  800dde:	74 15                	je     800df5 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  800de0:	52                   	push   %edx
  800de1:	68 61 36 80 00       	push   $0x803661
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	e8 aa fe ff ff       	call   800c97 <printfmt>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	e9 61 01 00 00       	jmp    800f56 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  800df5:	50                   	push   %eax
  800df6:	68 5b 37 80 00       	push   $0x80375b
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	e8 95 fe ff ff       	call   800c97 <printfmt>
  800e02:	83 c4 10             	add    $0x10,%esp
  800e05:	e9 4c 01 00 00       	jmp    800f56 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  800e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0d:	8d 50 04             	lea    0x4(%eax),%edx
  800e10:	89 55 14             	mov    %edx,0x14(%ebp)
  800e13:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800e15:	85 c9                	test   %ecx,%ecx
  800e17:	b8 54 37 80 00       	mov    $0x803754,%eax
  800e1c:	0f 45 c1             	cmovne %ecx,%eax
  800e1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800e22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e26:	7e 06                	jle    800e2e <vprintfmt+0x176>
  800e28:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800e2c:	75 0d                	jne    800e3b <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e31:	89 c7                	mov    %eax,%edi
  800e33:	03 45 e0             	add    -0x20(%ebp),%eax
  800e36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e39:	eb 57                	jmp    800e92 <vprintfmt+0x1da>
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 d8             	pushl  -0x28(%ebp)
  800e41:	ff 75 cc             	pushl  -0x34(%ebp)
  800e44:	e8 43 03 00 00       	call   80118c <strnlen>
  800e49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e4c:	29 c2                	sub    %eax,%edx
  800e4e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e51:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800e54:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800e58:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800e5b:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5d:	85 db                	test   %ebx,%ebx
  800e5f:	7e 10                	jle    800e71 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	56                   	push   %esi
  800e65:	57                   	push   %edi
  800e66:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e69:	83 eb 01             	sub    $0x1,%ebx
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	eb ec                	jmp    800e5d <vprintfmt+0x1a5>
  800e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e77:	85 d2                	test   %edx,%edx
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7e:	0f 49 c2             	cmovns %edx,%eax
  800e81:	29 c2                	sub    %eax,%edx
  800e83:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e86:	eb a6                	jmp    800e2e <vprintfmt+0x176>
					putch(ch, putdat);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	56                   	push   %esi
  800e8c:	52                   	push   %edx
  800e8d:	ff d3                	call   *%ebx
  800e8f:	83 c4 10             	add    $0x10,%esp
  800e92:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e95:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e97:	83 c7 01             	add    $0x1,%edi
  800e9a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e9e:	0f be d0             	movsbl %al,%edx
  800ea1:	85 d2                	test   %edx,%edx
  800ea3:	74 42                	je     800ee7 <vprintfmt+0x22f>
  800ea5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ea9:	78 06                	js     800eb1 <vprintfmt+0x1f9>
  800eab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800eaf:	78 1e                	js     800ecf <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800eb5:	74 d1                	je     800e88 <vprintfmt+0x1d0>
  800eb7:	0f be c0             	movsbl %al,%eax
  800eba:	83 e8 20             	sub    $0x20,%eax
  800ebd:	83 f8 5e             	cmp    $0x5e,%eax
  800ec0:	76 c6                	jbe    800e88 <vprintfmt+0x1d0>
					putch('?', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	56                   	push   %esi
  800ec6:	6a 3f                	push   $0x3f
  800ec8:	ff d3                	call   *%ebx
  800eca:	83 c4 10             	add    $0x10,%esp
  800ecd:	eb c3                	jmp    800e92 <vprintfmt+0x1da>
  800ecf:	89 cf                	mov    %ecx,%edi
  800ed1:	eb 0e                	jmp    800ee1 <vprintfmt+0x229>
				putch(' ', putdat);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	56                   	push   %esi
  800ed7:	6a 20                	push   $0x20
  800ed9:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800edb:	83 ef 01             	sub    $0x1,%edi
  800ede:	83 c4 10             	add    $0x10,%esp
  800ee1:	85 ff                	test   %edi,%edi
  800ee3:	7f ee                	jg     800ed3 <vprintfmt+0x21b>
  800ee5:	eb 6f                	jmp    800f56 <vprintfmt+0x29e>
  800ee7:	89 cf                	mov    %ecx,%edi
  800ee9:	eb f6                	jmp    800ee1 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800eeb:	89 ca                	mov    %ecx,%edx
  800eed:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef0:	e8 55 fd ff ff       	call   800c4a <getint>
  800ef5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ef8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800efb:	85 d2                	test   %edx,%edx
  800efd:	78 0b                	js     800f0a <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 c2                	mov    %eax,%edx
			base = 10;
  800f03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f08:	eb 32                	jmp    800f3c <vprintfmt+0x284>
				putch('-', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	56                   	push   %esi
  800f0e:	6a 2d                	push   $0x2d
  800f10:	ff d3                	call   *%ebx
				num = -(long long) num;
  800f12:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f15:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f18:	f7 da                	neg    %edx
  800f1a:	83 d1 00             	adc    $0x0,%ecx
  800f1d:	f7 d9                	neg    %ecx
  800f1f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f22:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f27:	eb 13                	jmp    800f3c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800f29:	89 ca                	mov    %ecx,%edx
  800f2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2e:	e8 e3 fc ff ff       	call   800c16 <getuint>
  800f33:	89 d1                	mov    %edx,%ecx
  800f35:	89 c2                	mov    %eax,%edx
			base = 10;
  800f37:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800f43:	57                   	push   %edi
  800f44:	ff 75 e0             	pushl  -0x20(%ebp)
  800f47:	50                   	push   %eax
  800f48:	51                   	push   %ecx
  800f49:	52                   	push   %edx
  800f4a:	89 f2                	mov    %esi,%edx
  800f4c:	89 d8                	mov    %ebx,%eax
  800f4e:	e8 1a fc ff ff       	call   800b6d <printnum>
			break;
  800f53:	83 c4 20             	add    $0x20,%esp
{
  800f56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f59:	83 c7 01             	add    $0x1,%edi
  800f5c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800f60:	83 f8 25             	cmp    $0x25,%eax
  800f63:	0f 84 6a fd ff ff    	je     800cd3 <vprintfmt+0x1b>
			if (ch == '\0')
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	0f 84 93 00 00 00    	je     801004 <vprintfmt+0x34c>
			putch(ch, putdat);
  800f71:	83 ec 08             	sub    $0x8,%esp
  800f74:	56                   	push   %esi
  800f75:	50                   	push   %eax
  800f76:	ff d3                	call   *%ebx
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	eb dc                	jmp    800f59 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800f7d:	89 ca                	mov    %ecx,%edx
  800f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f82:	e8 8f fc ff ff       	call   800c16 <getuint>
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 c2                	mov    %eax,%edx
			base = 8;
  800f8b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800f90:	eb aa                	jmp    800f3c <vprintfmt+0x284>
			putch('0', putdat);
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	56                   	push   %esi
  800f96:	6a 30                	push   $0x30
  800f98:	ff d3                	call   *%ebx
			putch('x', putdat);
  800f9a:	83 c4 08             	add    $0x8,%esp
  800f9d:	56                   	push   %esi
  800f9e:	6a 78                	push   $0x78
  800fa0:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa5:	8d 50 04             	lea    0x4(%eax),%edx
  800fa8:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800fab:	8b 10                	mov    (%eax),%edx
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800fb2:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800fb5:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800fba:	eb 80                	jmp    800f3c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800fbc:	89 ca                	mov    %ecx,%edx
  800fbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc1:	e8 50 fc ff ff       	call   800c16 <getuint>
  800fc6:	89 d1                	mov    %edx,%ecx
  800fc8:	89 c2                	mov    %eax,%edx
			base = 16;
  800fca:	b8 10 00 00 00       	mov    $0x10,%eax
  800fcf:	e9 68 ff ff ff       	jmp    800f3c <vprintfmt+0x284>
			putch(ch, putdat);
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	56                   	push   %esi
  800fd8:	6a 25                	push   $0x25
  800fda:	ff d3                	call   *%ebx
			break;
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	e9 72 ff ff ff       	jmp    800f56 <vprintfmt+0x29e>
			putch('%', putdat);
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	56                   	push   %esi
  800fe8:	6a 25                	push   $0x25
  800fea:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fec:	83 c4 10             	add    $0x10,%esp
  800fef:	89 f8                	mov    %edi,%eax
  800ff1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ff5:	74 05                	je     800ffc <vprintfmt+0x344>
  800ff7:	83 e8 01             	sub    $0x1,%eax
  800ffa:	eb f5                	jmp    800ff1 <vprintfmt+0x339>
  800ffc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fff:	e9 52 ff ff ff       	jmp    800f56 <vprintfmt+0x29e>
}
  801004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100c:	f3 0f 1e fb          	endbr32 
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 18             	sub    $0x18,%esp
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80101c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80101f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801023:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801026:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102d:	85 c0                	test   %eax,%eax
  80102f:	74 26                	je     801057 <vsnprintf+0x4b>
  801031:	85 d2                	test   %edx,%edx
  801033:	7e 22                	jle    801057 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801035:	ff 75 14             	pushl  0x14(%ebp)
  801038:	ff 75 10             	pushl  0x10(%ebp)
  80103b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80103e:	50                   	push   %eax
  80103f:	68 76 0c 80 00       	push   $0x800c76
  801044:	e8 6f fc ff ff       	call   800cb8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	83 c4 10             	add    $0x10,%esp
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    
		return -E_INVAL;
  801057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105c:	eb f7                	jmp    801055 <vsnprintf+0x49>

0080105e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105e:	f3 0f 1e fb          	endbr32 
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801068:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80106b:	50                   	push   %eax
  80106c:	ff 75 10             	pushl  0x10(%ebp)
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	ff 75 08             	pushl  0x8(%ebp)
  801075:	e8 92 ff ff ff       	call   80100c <vsnprintf>
	va_end(ap);

	return rc;
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80107c:	f3 0f 1e fb          	endbr32 
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	57                   	push   %edi
  801084:	56                   	push   %esi
  801085:	53                   	push   %ebx
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	74 13                	je     8010a3 <readline+0x27>
		fprintf(1, "%s", prompt);
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	50                   	push   %eax
  801094:	68 61 36 80 00       	push   $0x803661
  801099:	6a 01                	push   $0x1
  80109b:	e8 82 16 00 00       	call   802722 <fprintf>
  8010a0:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	6a 00                	push   $0x0
  8010a8:	e8 cf f8 ff ff       	call   80097c <iscons>
  8010ad:	89 c7                	mov    %eax,%edi
  8010af:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8010b2:	be 00 00 00 00       	mov    $0x0,%esi
  8010b7:	eb 57                	jmp    801110 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8010b9:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8010be:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8010c1:	75 08                	jne    8010cb <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8010c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	53                   	push   %ebx
  8010cf:	68 3f 3a 80 00       	push   $0x803a3f
  8010d4:	e8 7c fa ff ff       	call   800b55 <cprintf>
  8010d9:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8010dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e1:	eb e0                	jmp    8010c3 <readline+0x47>
			if (echoing)
  8010e3:	85 ff                	test   %edi,%edi
  8010e5:	75 05                	jne    8010ec <readline+0x70>
			i--;
  8010e7:	83 ee 01             	sub    $0x1,%esi
  8010ea:	eb 24                	jmp    801110 <readline+0x94>
				cputchar('\b');
  8010ec:	83 ec 0c             	sub    $0xc,%esp
  8010ef:	6a 08                	push   $0x8
  8010f1:	e8 39 f8 ff ff       	call   80092f <cputchar>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	eb ec                	jmp    8010e7 <readline+0x6b>
				cputchar(c);
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	53                   	push   %ebx
  8010ff:	e8 2b f8 ff ff       	call   80092f <cputchar>
  801104:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801107:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  80110d:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  801110:	e8 3a f8 ff ff       	call   80094f <getchar>
  801115:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801117:	85 c0                	test   %eax,%eax
  801119:	78 9e                	js     8010b9 <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80111b:	83 f8 08             	cmp    $0x8,%eax
  80111e:	0f 94 c2             	sete   %dl
  801121:	83 f8 7f             	cmp    $0x7f,%eax
  801124:	0f 94 c0             	sete   %al
  801127:	08 c2                	or     %al,%dl
  801129:	74 04                	je     80112f <readline+0xb3>
  80112b:	85 f6                	test   %esi,%esi
  80112d:	7f b4                	jg     8010e3 <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112f:	83 fb 1f             	cmp    $0x1f,%ebx
  801132:	7e 0e                	jle    801142 <readline+0xc6>
  801134:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80113a:	7f 06                	jg     801142 <readline+0xc6>
			if (echoing)
  80113c:	85 ff                	test   %edi,%edi
  80113e:	74 c7                	je     801107 <readline+0x8b>
  801140:	eb b9                	jmp    8010fb <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  801142:	83 fb 0a             	cmp    $0xa,%ebx
  801145:	74 05                	je     80114c <readline+0xd0>
  801147:	83 fb 0d             	cmp    $0xd,%ebx
  80114a:	75 c4                	jne    801110 <readline+0x94>
			if (echoing)
  80114c:	85 ff                	test   %edi,%edi
  80114e:	75 11                	jne    801161 <readline+0xe5>
			buf[i] = 0;
  801150:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  801157:	b8 20 50 80 00       	mov    $0x805020,%eax
  80115c:	e9 62 ff ff ff       	jmp    8010c3 <readline+0x47>
				cputchar('\n');
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	6a 0a                	push   $0xa
  801166:	e8 c4 f7 ff ff       	call   80092f <cputchar>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	eb e0                	jmp    801150 <readline+0xd4>

00801170 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801183:	74 05                	je     80118a <strlen+0x1a>
		n++;
  801185:	83 c0 01             	add    $0x1,%eax
  801188:	eb f5                	jmp    80117f <strlen+0xf>
	return n;
}
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118c:	f3 0f 1e fb          	endbr32 
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801196:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
  80119e:	39 d0                	cmp    %edx,%eax
  8011a0:	74 0d                	je     8011af <strnlen+0x23>
  8011a2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8011a6:	74 05                	je     8011ad <strnlen+0x21>
		n++;
  8011a8:	83 c0 01             	add    $0x1,%eax
  8011ab:	eb f1                	jmp    80119e <strnlen+0x12>
  8011ad:	89 c2                	mov    %eax,%edx
	return n;
}
  8011af:	89 d0                	mov    %edx,%eax
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011b3:	f3 0f 1e fb          	endbr32 
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	53                   	push   %ebx
  8011bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8011ca:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8011cd:	83 c0 01             	add    $0x1,%eax
  8011d0:	84 d2                	test   %dl,%dl
  8011d2:	75 f2                	jne    8011c6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8011d4:	89 c8                	mov    %ecx,%eax
  8011d6:	5b                   	pop    %ebx
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011d9:	f3 0f 1e fb          	endbr32 
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 10             	sub    $0x10,%esp
  8011e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8011e7:	53                   	push   %ebx
  8011e8:	e8 83 ff ff ff       	call   801170 <strlen>
  8011ed:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	01 d8                	add    %ebx,%eax
  8011f5:	50                   	push   %eax
  8011f6:	e8 b8 ff ff ff       	call   8011b3 <strcpy>
	return dst;
}
  8011fb:	89 d8                	mov    %ebx,%eax
  8011fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801202:	f3 0f 1e fb          	endbr32 
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	8b 75 08             	mov    0x8(%ebp),%esi
  80120e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801211:	89 f3                	mov    %esi,%ebx
  801213:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801216:	89 f0                	mov    %esi,%eax
  801218:	39 d8                	cmp    %ebx,%eax
  80121a:	74 11                	je     80122d <strncpy+0x2b>
		*dst++ = *src;
  80121c:	83 c0 01             	add    $0x1,%eax
  80121f:	0f b6 0a             	movzbl (%edx),%ecx
  801222:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801225:	80 f9 01             	cmp    $0x1,%cl
  801228:	83 da ff             	sbb    $0xffffffff,%edx
  80122b:	eb eb                	jmp    801218 <strncpy+0x16>
	}
	return ret;
}
  80122d:	89 f0                	mov    %esi,%eax
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801233:	f3 0f 1e fb          	endbr32 
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	8b 75 08             	mov    0x8(%ebp),%esi
  80123f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801242:	8b 55 10             	mov    0x10(%ebp),%edx
  801245:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801247:	85 d2                	test   %edx,%edx
  801249:	74 21                	je     80126c <strlcpy+0x39>
  80124b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80124f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801251:	39 c2                	cmp    %eax,%edx
  801253:	74 14                	je     801269 <strlcpy+0x36>
  801255:	0f b6 19             	movzbl (%ecx),%ebx
  801258:	84 db                	test   %bl,%bl
  80125a:	74 0b                	je     801267 <strlcpy+0x34>
			*dst++ = *src++;
  80125c:	83 c1 01             	add    $0x1,%ecx
  80125f:	83 c2 01             	add    $0x1,%edx
  801262:	88 5a ff             	mov    %bl,-0x1(%edx)
  801265:	eb ea                	jmp    801251 <strlcpy+0x1e>
  801267:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801269:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80126c:	29 f0                	sub    %esi,%eax
}
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801272:	f3 0f 1e fb          	endbr32 
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80127f:	0f b6 01             	movzbl (%ecx),%eax
  801282:	84 c0                	test   %al,%al
  801284:	74 0c                	je     801292 <strcmp+0x20>
  801286:	3a 02                	cmp    (%edx),%al
  801288:	75 08                	jne    801292 <strcmp+0x20>
		p++, q++;
  80128a:	83 c1 01             	add    $0x1,%ecx
  80128d:	83 c2 01             	add    $0x1,%edx
  801290:	eb ed                	jmp    80127f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801292:	0f b6 c0             	movzbl %al,%eax
  801295:	0f b6 12             	movzbl (%edx),%edx
  801298:	29 d0                	sub    %edx,%eax
}
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80129c:	f3 0f 1e fb          	endbr32 
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	53                   	push   %ebx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	89 c3                	mov    %eax,%ebx
  8012ac:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8012af:	eb 06                	jmp    8012b7 <strncmp+0x1b>
		n--, p++, q++;
  8012b1:	83 c0 01             	add    $0x1,%eax
  8012b4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8012b7:	39 d8                	cmp    %ebx,%eax
  8012b9:	74 16                	je     8012d1 <strncmp+0x35>
  8012bb:	0f b6 08             	movzbl (%eax),%ecx
  8012be:	84 c9                	test   %cl,%cl
  8012c0:	74 04                	je     8012c6 <strncmp+0x2a>
  8012c2:	3a 0a                	cmp    (%edx),%cl
  8012c4:	74 eb                	je     8012b1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c6:	0f b6 00             	movzbl (%eax),%eax
  8012c9:	0f b6 12             	movzbl (%edx),%edx
  8012cc:	29 d0                	sub    %edx,%eax
}
  8012ce:	5b                   	pop    %ebx
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
		return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb f6                	jmp    8012ce <strncmp+0x32>

008012d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d8:	f3 0f 1e fb          	endbr32 
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8012e6:	0f b6 10             	movzbl (%eax),%edx
  8012e9:	84 d2                	test   %dl,%dl
  8012eb:	74 09                	je     8012f6 <strchr+0x1e>
		if (*s == c)
  8012ed:	38 ca                	cmp    %cl,%dl
  8012ef:	74 0a                	je     8012fb <strchr+0x23>
	for (; *s; s++)
  8012f1:	83 c0 01             	add    $0x1,%eax
  8012f4:	eb f0                	jmp    8012e6 <strchr+0xe>
			return (char *) s;
	return 0;
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012fd:	f3 0f 1e fb          	endbr32 
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80130b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80130e:	38 ca                	cmp    %cl,%dl
  801310:	74 09                	je     80131b <strfind+0x1e>
  801312:	84 d2                	test   %dl,%dl
  801314:	74 05                	je     80131b <strfind+0x1e>
	for (; *s; s++)
  801316:	83 c0 01             	add    $0x1,%eax
  801319:	eb f0                	jmp    80130b <strfind+0xe>
			break;
	return (char *) s;
}
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80131d:	f3 0f 1e fb          	endbr32 
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	57                   	push   %edi
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	8b 55 08             	mov    0x8(%ebp),%edx
  80132a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80132d:	85 c9                	test   %ecx,%ecx
  80132f:	74 33                	je     801364 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801331:	89 d0                	mov    %edx,%eax
  801333:	09 c8                	or     %ecx,%eax
  801335:	a8 03                	test   $0x3,%al
  801337:	75 23                	jne    80135c <memset+0x3f>
		c &= 0xFF;
  801339:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133d:	89 d8                	mov    %ebx,%eax
  80133f:	c1 e0 08             	shl    $0x8,%eax
  801342:	89 df                	mov    %ebx,%edi
  801344:	c1 e7 18             	shl    $0x18,%edi
  801347:	89 de                	mov    %ebx,%esi
  801349:	c1 e6 10             	shl    $0x10,%esi
  80134c:	09 f7                	or     %esi,%edi
  80134e:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801350:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801353:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801355:	89 d7                	mov    %edx,%edi
  801357:	fc                   	cld    
  801358:	f3 ab                	rep stos %eax,%es:(%edi)
  80135a:	eb 08                	jmp    801364 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80135c:	89 d7                	mov    %edx,%edi
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	fc                   	cld    
  801362:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801364:	89 d0                	mov    %edx,%eax
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5f                   	pop    %edi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80136b:	f3 0f 1e fb          	endbr32 
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	57                   	push   %edi
  801373:	56                   	push   %esi
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8b 75 0c             	mov    0xc(%ebp),%esi
  80137a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	39 c6                	cmp    %eax,%esi
  80137f:	73 32                	jae    8013b3 <memmove+0x48>
  801381:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801384:	39 c2                	cmp    %eax,%edx
  801386:	76 2b                	jbe    8013b3 <memmove+0x48>
		s += n;
		d += n;
  801388:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80138b:	89 fe                	mov    %edi,%esi
  80138d:	09 ce                	or     %ecx,%esi
  80138f:	09 d6                	or     %edx,%esi
  801391:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801397:	75 0e                	jne    8013a7 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801399:	83 ef 04             	sub    $0x4,%edi
  80139c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80139f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8013a2:	fd                   	std    
  8013a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013a5:	eb 09                	jmp    8013b0 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013a7:	83 ef 01             	sub    $0x1,%edi
  8013aa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8013ad:	fd                   	std    
  8013ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013b0:	fc                   	cld    
  8013b1:	eb 1a                	jmp    8013cd <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	09 ca                	or     %ecx,%edx
  8013b7:	09 f2                	or     %esi,%edx
  8013b9:	f6 c2 03             	test   $0x3,%dl
  8013bc:	75 0a                	jne    8013c8 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013be:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8013c1:	89 c7                	mov    %eax,%edi
  8013c3:	fc                   	cld    
  8013c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013c6:	eb 05                	jmp    8013cd <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8013c8:	89 c7                	mov    %eax,%edi
  8013ca:	fc                   	cld    
  8013cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8013cd:	5e                   	pop    %esi
  8013ce:	5f                   	pop    %edi
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    

008013d1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013d1:	f3 0f 1e fb          	endbr32 
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8013db:	ff 75 10             	pushl  0x10(%ebp)
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	ff 75 08             	pushl  0x8(%ebp)
  8013e4:	e8 82 ff ff ff       	call   80136b <memmove>
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013eb:	f3 0f 1e fb          	endbr32 
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	56                   	push   %esi
  8013f3:	53                   	push   %ebx
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fa:	89 c6                	mov    %eax,%esi
  8013fc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013ff:	39 f0                	cmp    %esi,%eax
  801401:	74 1c                	je     80141f <memcmp+0x34>
		if (*s1 != *s2)
  801403:	0f b6 08             	movzbl (%eax),%ecx
  801406:	0f b6 1a             	movzbl (%edx),%ebx
  801409:	38 d9                	cmp    %bl,%cl
  80140b:	75 08                	jne    801415 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80140d:	83 c0 01             	add    $0x1,%eax
  801410:	83 c2 01             	add    $0x1,%edx
  801413:	eb ea                	jmp    8013ff <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801415:	0f b6 c1             	movzbl %cl,%eax
  801418:	0f b6 db             	movzbl %bl,%ebx
  80141b:	29 d8                	sub    %ebx,%eax
  80141d:	eb 05                	jmp    801424 <memcmp+0x39>
	}

	return 0;
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801428:	f3 0f 1e fb          	endbr32 
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801435:	89 c2                	mov    %eax,%edx
  801437:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80143a:	39 d0                	cmp    %edx,%eax
  80143c:	73 09                	jae    801447 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80143e:	38 08                	cmp    %cl,(%eax)
  801440:	74 05                	je     801447 <memfind+0x1f>
	for (; s < ends; s++)
  801442:	83 c0 01             	add    $0x1,%eax
  801445:	eb f3                	jmp    80143a <memfind+0x12>
			break;
	return (void *) s;
}
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    

00801449 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801449:	f3 0f 1e fb          	endbr32 
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	57                   	push   %edi
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
  801453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801456:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801459:	eb 03                	jmp    80145e <strtol+0x15>
		s++;
  80145b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80145e:	0f b6 01             	movzbl (%ecx),%eax
  801461:	3c 20                	cmp    $0x20,%al
  801463:	74 f6                	je     80145b <strtol+0x12>
  801465:	3c 09                	cmp    $0x9,%al
  801467:	74 f2                	je     80145b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801469:	3c 2b                	cmp    $0x2b,%al
  80146b:	74 2a                	je     801497 <strtol+0x4e>
	int neg = 0;
  80146d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801472:	3c 2d                	cmp    $0x2d,%al
  801474:	74 2b                	je     8014a1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801476:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80147c:	75 0f                	jne    80148d <strtol+0x44>
  80147e:	80 39 30             	cmpb   $0x30,(%ecx)
  801481:	74 28                	je     8014ab <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801483:	85 db                	test   %ebx,%ebx
  801485:	b8 0a 00 00 00       	mov    $0xa,%eax
  80148a:	0f 44 d8             	cmove  %eax,%ebx
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801495:	eb 46                	jmp    8014dd <strtol+0x94>
		s++;
  801497:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80149a:	bf 00 00 00 00       	mov    $0x0,%edi
  80149f:	eb d5                	jmp    801476 <strtol+0x2d>
		s++, neg = 1;
  8014a1:	83 c1 01             	add    $0x1,%ecx
  8014a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8014a9:	eb cb                	jmp    801476 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ab:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014af:	74 0e                	je     8014bf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8014b1:	85 db                	test   %ebx,%ebx
  8014b3:	75 d8                	jne    80148d <strtol+0x44>
		s++, base = 8;
  8014b5:	83 c1 01             	add    $0x1,%ecx
  8014b8:	bb 08 00 00 00       	mov    $0x8,%ebx
  8014bd:	eb ce                	jmp    80148d <strtol+0x44>
		s += 2, base = 16;
  8014bf:	83 c1 02             	add    $0x2,%ecx
  8014c2:	bb 10 00 00 00       	mov    $0x10,%ebx
  8014c7:	eb c4                	jmp    80148d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8014c9:	0f be d2             	movsbl %dl,%edx
  8014cc:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8014cf:	3b 55 10             	cmp    0x10(%ebp),%edx
  8014d2:	7d 3a                	jge    80150e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8014d4:	83 c1 01             	add    $0x1,%ecx
  8014d7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8014dd:	0f b6 11             	movzbl (%ecx),%edx
  8014e0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8014e3:	89 f3                	mov    %esi,%ebx
  8014e5:	80 fb 09             	cmp    $0x9,%bl
  8014e8:	76 df                	jbe    8014c9 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8014ea:	8d 72 9f             	lea    -0x61(%edx),%esi
  8014ed:	89 f3                	mov    %esi,%ebx
  8014ef:	80 fb 19             	cmp    $0x19,%bl
  8014f2:	77 08                	ja     8014fc <strtol+0xb3>
			dig = *s - 'a' + 10;
  8014f4:	0f be d2             	movsbl %dl,%edx
  8014f7:	83 ea 57             	sub    $0x57,%edx
  8014fa:	eb d3                	jmp    8014cf <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8014fc:	8d 72 bf             	lea    -0x41(%edx),%esi
  8014ff:	89 f3                	mov    %esi,%ebx
  801501:	80 fb 19             	cmp    $0x19,%bl
  801504:	77 08                	ja     80150e <strtol+0xc5>
			dig = *s - 'A' + 10;
  801506:	0f be d2             	movsbl %dl,%edx
  801509:	83 ea 37             	sub    $0x37,%edx
  80150c:	eb c1                	jmp    8014cf <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80150e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801512:	74 05                	je     801519 <strtol+0xd0>
		*endptr = (char *) s;
  801514:	8b 75 0c             	mov    0xc(%ebp),%esi
  801517:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801519:	89 c2                	mov    %eax,%edx
  80151b:	f7 da                	neg    %edx
  80151d:	85 ff                	test   %edi,%edi
  80151f:	0f 45 c2             	cmovne %edx,%eax
}
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5f                   	pop    %edi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	57                   	push   %edi
  80152b:	56                   	push   %esi
  80152c:	53                   	push   %ebx
  80152d:	83 ec 1c             	sub    $0x1c,%esp
  801530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801533:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801536:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801538:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80153e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801541:	8b 75 14             	mov    0x14(%ebp),%esi
  801544:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801546:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80154a:	74 04                	je     801550 <syscall+0x29>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	7f 08                	jg     801558 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  801550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5f                   	pop    %edi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801558:	83 ec 0c             	sub    $0xc,%esp
  80155b:	50                   	push   %eax
  80155c:	ff 75 e0             	pushl  -0x20(%ebp)
  80155f:	68 4f 3a 80 00       	push   $0x803a4f
  801564:	6a 23                	push   $0x23
  801566:	68 6c 3a 80 00       	push   $0x803a6c
  80156b:	e8 fe f4 ff ff       	call   800a6e <_panic>

00801570 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801570:	f3 0f 1e fb          	endbr32 
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801586:	ba 00 00 00 00       	mov    $0x0,%edx
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
  801590:	e8 92 ff ff ff       	call   801527 <syscall>
}
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_cgetc>:

int
sys_cgetc(void)
{
  80159a:	f3 0f 1e fb          	endbr32 
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015bb:	e8 67 ff ff ff       	call   801527 <syscall>
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015c2:	f3 0f 1e fb          	endbr32 
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8015dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8015e1:	e8 41 ff ff ff       	call   801527 <syscall>
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8015e8:	f3 0f 1e fb          	endbr32 
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801604:	b8 02 00 00 00       	mov    $0x2,%eax
  801609:	e8 19 ff ff ff       	call   801527 <syscall>
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_yield>:

void
sys_yield(void)
{
  801610:	f3 0f 1e fb          	endbr32 
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	b9 00 00 00 00       	mov    $0x0,%ecx
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 0b 00 00 00       	mov    $0xb,%eax
  801631:	e8 f1 fe ff ff       	call   801527 <syscall>
}
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80163b:	f3 0f 1e fb          	endbr32 
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 10             	pushl  0x10(%ebp)
  80164c:	ff 75 0c             	pushl  0xc(%ebp)
  80164f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801652:	ba 01 00 00 00       	mov    $0x1,%edx
  801657:	b8 04 00 00 00       	mov    $0x4,%eax
  80165c:	e8 c6 fe ff ff       	call   801527 <syscall>
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801663:	f3 0f 1e fb          	endbr32 
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80166d:	ff 75 18             	pushl  0x18(%ebp)
  801670:	ff 75 14             	pushl  0x14(%ebp)
  801673:	ff 75 10             	pushl  0x10(%ebp)
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80167c:	ba 01 00 00 00       	mov    $0x1,%edx
  801681:	b8 05 00 00 00       	mov    $0x5,%eax
  801686:	e8 9c fe ff ff       	call   801527 <syscall>
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80168d:	f3 0f 1e fb          	endbr32 
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a3:	ba 01 00 00 00       	mov    $0x1,%edx
  8016a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ad:	e8 75 fe ff ff       	call   801527 <syscall>
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8016b4:	f3 0f 1e fb          	endbr32 
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ca:	ba 01 00 00 00       	mov    $0x1,%edx
  8016cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8016d4:	e8 4e fe ff ff       	call   801527 <syscall>
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8016db:	f3 0f 1e fb          	endbr32 
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f1:	ba 01 00 00 00       	mov    $0x1,%edx
  8016f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8016fb:	e8 27 fe ff ff       	call   801527 <syscall>
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801702:	f3 0f 1e fb          	endbr32 
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801718:	ba 01 00 00 00       	mov    $0x1,%edx
  80171d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801722:	e8 00 fe ff ff       	call   801527 <syscall>
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801729:	f3 0f 1e fb          	endbr32 
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801733:	6a 00                	push   $0x0
  801735:	ff 75 14             	pushl  0x14(%ebp)
  801738:	ff 75 10             	pushl  0x10(%ebp)
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	b8 0c 00 00 00       	mov    $0xc,%eax
  80174b:	e8 d7 fd ff ff       	call   801527 <syscall>
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801752:	f3 0f 1e fb          	endbr32 
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801767:	ba 01 00 00 00       	mov    $0x1,%edx
  80176c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801771:	e8 b1 fd ff ff       	call   801527 <syscall>
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	53                   	push   %ebx
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	89 d3                	mov    %edx,%ebx
	int r;

	// LAB 4: Your code here.
	pte_t pte = uvpt[pn];
  801781:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	void *va = (void *) (pn << PTXSHIFT);
  801788:	c1 e3 0c             	shl    $0xc,%ebx

	if (pte & PTE_SHARE) {
  80178b:	f6 c6 04             	test   $0x4,%dh
  80178e:	75 51                	jne    8017e1 <duppage+0x69>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
		if (r)
			panic("[duppage] sys_page_map: %e", r);
	} else if ((pte & PTE_W) || (pte & PTE_COW)) {
  801790:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801796:	0f 84 84 00 00 00    	je     801820 <duppage+0xa8>
		r = sys_page_map(0, va, envid, va, PTE_COW | PTE_U | PTE_P);
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	68 05 08 00 00       	push   $0x805
  8017a4:	53                   	push   %ebx
  8017a5:	50                   	push   %eax
  8017a6:	53                   	push   %ebx
  8017a7:	6a 00                	push   $0x0
  8017a9:	e8 b5 fe ff ff       	call   801663 <sys_page_map>
		if (r)
  8017ae:	83 c4 20             	add    $0x20,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 59                	jne    80180e <duppage+0x96>
			panic("[duppage] sys_page_map: %e", r);

		r = sys_page_map(0, va, 0, va, PTE_COW | PTE_U | PTE_P);
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	68 05 08 00 00       	push   $0x805
  8017bd:	53                   	push   %ebx
  8017be:	6a 00                	push   $0x0
  8017c0:	53                   	push   %ebx
  8017c1:	6a 00                	push   $0x0
  8017c3:	e8 9b fe ff ff       	call   801663 <sys_page_map>
		if (r)
  8017c8:	83 c4 20             	add    $0x20,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	74 67                	je     801836 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  8017cf:	50                   	push   %eax
  8017d0:	68 7a 3a 80 00       	push   $0x803a7a
  8017d5:	6a 5f                	push   $0x5f
  8017d7:	68 95 3a 80 00       	push   $0x803a95
  8017dc:	e8 8d f2 ff ff       	call   800a6e <_panic>
		r = sys_page_map(0, va, envid, va, pte & PTE_SYSCALL);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017ea:	52                   	push   %edx
  8017eb:	53                   	push   %ebx
  8017ec:	50                   	push   %eax
  8017ed:	53                   	push   %ebx
  8017ee:	6a 00                	push   $0x0
  8017f0:	e8 6e fe ff ff       	call   801663 <sys_page_map>
		if (r)
  8017f5:	83 c4 20             	add    $0x20,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	74 3a                	je     801836 <duppage+0xbe>
			panic("[duppage] sys_page_map: %e", r);
  8017fc:	50                   	push   %eax
  8017fd:	68 7a 3a 80 00       	push   $0x803a7a
  801802:	6a 57                	push   $0x57
  801804:	68 95 3a 80 00       	push   $0x803a95
  801809:	e8 60 f2 ff ff       	call   800a6e <_panic>
			panic("[duppage] sys_page_map: %e", r);
  80180e:	50                   	push   %eax
  80180f:	68 7a 3a 80 00       	push   $0x803a7a
  801814:	6a 5b                	push   $0x5b
  801816:	68 95 3a 80 00       	push   $0x803a95
  80181b:	e8 4e f2 ff ff       	call   800a6e <_panic>
	} else {
		r = sys_page_map(0, va, envid, va, PTE_U | PTE_P);
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	6a 05                	push   $0x5
  801825:	53                   	push   %ebx
  801826:	50                   	push   %eax
  801827:	53                   	push   %ebx
  801828:	6a 00                	push   $0x0
  80182a:	e8 34 fe ff ff       	call   801663 <sys_page_map>
		if (r)
  80182f:	83 c4 20             	add    $0x20,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	75 0a                	jne    801840 <duppage+0xc8>
			panic("[duppage] sys_page_map: %e", r);
	}
	return 0;
}
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    
			panic("[duppage] sys_page_map: %e", r);
  801840:	50                   	push   %eax
  801841:	68 7a 3a 80 00       	push   $0x803a7a
  801846:	6a 63                	push   $0x63
  801848:	68 95 3a 80 00       	push   $0x803a95
  80184d:	e8 1c f2 ff ff       	call   800a6e <_panic>

00801852 <dup_or_share>:

// Dup or Share
static void
dup_or_share(envid_t dstenv, void *va, int perm)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	57                   	push   %edi
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 0c             	sub    $0xc,%esp
  80185b:	89 c7                	mov    %eax,%edi
  80185d:	89 d6                	mov    %edx,%esi
  80185f:	89 cb                	mov    %ecx,%ebx
	int r;
	if (!(perm & PTE_W)) {
  801861:	f6 c1 02             	test   $0x2,%cl
  801864:	75 2f                	jne    801895 <dup_or_share+0x43>
		if ((r = sys_page_map(0, va, dstenv, va, perm)) < 0)
  801866:	83 ec 0c             	sub    $0xc,%esp
  801869:	51                   	push   %ecx
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	52                   	push   %edx
  80186d:	6a 00                	push   $0x0
  80186f:	e8 ef fd ff ff       	call   801663 <sys_page_map>
  801874:	83 c4 20             	add    $0x20,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 08                	js     801883 <dup_or_share+0x31>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, va, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}
  80187b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5f                   	pop    %edi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    
			panic("sys_page_map: %e", r);
  801883:	50                   	push   %eax
  801884:	68 84 3a 80 00       	push   $0x803a84
  801889:	6a 6f                	push   $0x6f
  80188b:	68 95 3a 80 00       	push   $0x803a95
  801890:	e8 d9 f1 ff ff       	call   800a6e <_panic>
	if ((r = sys_page_alloc(dstenv, va, perm)) < 0)
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	51                   	push   %ecx
  801899:	52                   	push   %edx
  80189a:	50                   	push   %eax
  80189b:	e8 9b fd ff ff       	call   80163b <sys_page_alloc>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 54                	js     8018fb <dup_or_share+0xa9>
	if ((r = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0)
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	53                   	push   %ebx
  8018ab:	68 00 00 40 00       	push   $0x400000
  8018b0:	6a 00                	push   $0x0
  8018b2:	56                   	push   %esi
  8018b3:	57                   	push   %edi
  8018b4:	e8 aa fd ff ff       	call   801663 <sys_page_map>
  8018b9:	83 c4 20             	add    $0x20,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 4d                	js     80190d <dup_or_share+0xbb>
	memmove(UTEMP, va, PGSIZE);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 00 10 00 00       	push   $0x1000
  8018c8:	56                   	push   %esi
  8018c9:	68 00 00 40 00       	push   $0x400000
  8018ce:	e8 98 fa ff ff       	call   80136b <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8018d3:	83 c4 08             	add    $0x8,%esp
  8018d6:	68 00 00 40 00       	push   $0x400000
  8018db:	6a 00                	push   $0x0
  8018dd:	e8 ab fd ff ff       	call   80168d <sys_page_unmap>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	79 92                	jns    80187b <dup_or_share+0x29>
		panic("sys_page_unmap: %e", r);
  8018e9:	50                   	push   %eax
  8018ea:	68 b3 3a 80 00       	push   $0x803ab3
  8018ef:	6a 78                	push   $0x78
  8018f1:	68 95 3a 80 00       	push   $0x803a95
  8018f6:	e8 73 f1 ff ff       	call   800a6e <_panic>
		panic("sys_page_alloc: %e", r);
  8018fb:	50                   	push   %eax
  8018fc:	68 a0 3a 80 00       	push   $0x803aa0
  801901:	6a 73                	push   $0x73
  801903:	68 95 3a 80 00       	push   $0x803a95
  801908:	e8 61 f1 ff ff       	call   800a6e <_panic>
		panic("sys_page_map: %e", r);
  80190d:	50                   	push   %eax
  80190e:	68 84 3a 80 00       	push   $0x803a84
  801913:	6a 75                	push   $0x75
  801915:	68 95 3a 80 00       	push   $0x803a95
  80191a:	e8 4f f1 ff ff       	call   800a6e <_panic>

0080191f <pgfault>:
{
  80191f:	f3 0f 1e fb          	endbr32 
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	53                   	push   %ebx
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80192d:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80192f:	8b 40 04             	mov    0x4(%eax),%eax
	pte_t pte = uvpt[PGNUM(addr)];
  801932:	89 da                	mov    %ebx,%edx
  801934:	c1 ea 0c             	shr    $0xc,%edx
  801937:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if ((err & FEC_PR) == 0)
  80193e:	a8 01                	test   $0x1,%al
  801940:	74 7e                	je     8019c0 <pgfault+0xa1>
	if ((err & FEC_WR) == 0)
  801942:	a8 02                	test   $0x2,%al
  801944:	0f 84 8a 00 00 00    	je     8019d4 <pgfault+0xb5>
	if ((pte & PTE_COW) == 0)
  80194a:	f6 c6 08             	test   $0x8,%dh
  80194d:	0f 84 95 00 00 00    	je     8019e8 <pgfault+0xc9>
	r = sys_page_alloc(0, PFTEMP, PTE_W | PTE_U | PTE_P);
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	6a 07                	push   $0x7
  801958:	68 00 f0 7f 00       	push   $0x7ff000
  80195d:	6a 00                	push   $0x0
  80195f:	e8 d7 fc ff ff       	call   80163b <sys_page_alloc>
	if (r)
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	0f 85 8d 00 00 00    	jne    8019fc <pgfault+0xdd>
	memcpy(PFTEMP, (void *) ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80196f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	68 00 10 00 00       	push   $0x1000
  80197d:	53                   	push   %ebx
  80197e:	68 00 f0 7f 00       	push   $0x7ff000
  801983:	e8 49 fa ff ff       	call   8013d1 <memcpy>
	r = sys_page_map(
  801988:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80198f:	53                   	push   %ebx
  801990:	6a 00                	push   $0x0
  801992:	68 00 f0 7f 00       	push   $0x7ff000
  801997:	6a 00                	push   $0x0
  801999:	e8 c5 fc ff ff       	call   801663 <sys_page_map>
	if (r)
  80199e:	83 c4 20             	add    $0x20,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	75 69                	jne    801a0e <pgfault+0xef>
	r = sys_page_unmap(0, PFTEMP);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	68 00 f0 7f 00       	push   $0x7ff000
  8019ad:	6a 00                	push   $0x0
  8019af:	e8 d9 fc ff ff       	call   80168d <sys_page_unmap>
	if (r)
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	75 65                	jne    801a20 <pgfault+0x101>
}
  8019bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    
		panic("[pgfault] pgfault por página no mapeada");
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	68 34 3b 80 00       	push   $0x803b34
  8019c8:	6a 20                	push   $0x20
  8019ca:	68 95 3a 80 00       	push   $0x803a95
  8019cf:	e8 9a f0 ff ff       	call   800a6e <_panic>
		panic("[pgfault] pgfault por lectura");
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	68 c6 3a 80 00       	push   $0x803ac6
  8019dc:	6a 23                	push   $0x23
  8019de:	68 95 3a 80 00       	push   $0x803a95
  8019e3:	e8 86 f0 ff ff       	call   800a6e <_panic>
		panic("[pgfault] pgfault COW no configurado");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 60 3b 80 00       	push   $0x803b60
  8019f0:	6a 27                	push   $0x27
  8019f2:	68 95 3a 80 00       	push   $0x803a95
  8019f7:	e8 72 f0 ff ff       	call   800a6e <_panic>
		panic("pgfault: %e", r);
  8019fc:	50                   	push   %eax
  8019fd:	68 e4 3a 80 00       	push   $0x803ae4
  801a02:	6a 32                	push   $0x32
  801a04:	68 95 3a 80 00       	push   $0x803a95
  801a09:	e8 60 f0 ff ff       	call   800a6e <_panic>
		panic("pgfault: %e", r);
  801a0e:	50                   	push   %eax
  801a0f:	68 e4 3a 80 00       	push   $0x803ae4
  801a14:	6a 39                	push   $0x39
  801a16:	68 95 3a 80 00       	push   $0x803a95
  801a1b:	e8 4e f0 ff ff       	call   800a6e <_panic>
		panic("pgfault: %e", r);
  801a20:	50                   	push   %eax
  801a21:	68 e4 3a 80 00       	push   $0x803ae4
  801a26:	6a 3d                	push   $0x3d
  801a28:	68 95 3a 80 00       	push   $0x803a95
  801a2d:	e8 3c f0 ff ff       	call   800a6e <_panic>

00801a32 <fork_v0>:
// devolviendo en el padre el id de proceso creado, y 0 en el hijo.
// En caso de ocurrir cualquier error, se puede invocar a panic().

envid_t
fork_v0(void)
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a3f:	b8 07 00 00 00       	mov    $0x7,%eax
  801a44:	cd 30                	int    $0x30
  801a46:	89 c7                	mov    %eax,%edi
	envid_t envid;
	uintptr_t addr;
	int r;

	envid = sys_exofork();
	if (envid < 0)
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 22                	js     801a6e <fork_v0+0x3c>
  801a4c:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801a4e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  801a53:	75 52                	jne    801aa7 <fork_v0+0x75>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a55:	e8 8e fb ff ff       	call   8015e8 <sys_getenvid>
  801a5a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a5f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a62:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a67:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801a6c:	eb 6e                	jmp    801adc <fork_v0+0xaa>
		panic("[fork_v0] sys_exofork failed: %e", envid);
  801a6e:	50                   	push   %eax
  801a6f:	68 88 3b 80 00       	push   $0x803b88
  801a74:	68 8a 00 00 00       	push   $0x8a
  801a79:	68 95 3a 80 00       	push   $0x803a95
  801a7e:	e8 eb ef ff ff       	call   800a6e <_panic>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			dup_or_share(envid,
			             (void *) addr,
			             uvpt[PGNUM(addr)] & PTE_SYSCALL);
  801a83:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
			dup_or_share(envid,
  801a8a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801a90:	89 da                	mov    %ebx,%edx
  801a92:	89 f0                	mov    %esi,%eax
  801a94:	e8 b9 fd ff ff       	call   801852 <dup_or_share>
	for (addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801a99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a9f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801aa5:	74 23                	je     801aca <fork_v0+0x98>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801aa7:	89 d8                	mov    %ebx,%eax
  801aa9:	c1 e8 16             	shr    $0x16,%eax
  801aac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ab3:	a8 01                	test   $0x1,%al
  801ab5:	74 e2                	je     801a99 <fork_v0+0x67>
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	c1 e8 0c             	shr    $0xc,%eax
  801abc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ac3:	f6 c2 01             	test   $0x1,%dl
  801ac6:	74 d1                	je     801a99 <fork_v0+0x67>
  801ac8:	eb b9                	jmp    801a83 <fork_v0+0x51>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	6a 02                	push   $0x2
  801acf:	57                   	push   %edi
  801ad0:	e8 df fb ff ff       	call   8016b4 <sys_env_set_status>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 0a                	js     801ae6 <fork_v0+0xb4>
		panic("[fork_v0] sys_env_set_status: %e", r);

	return envid;
}
  801adc:	89 f8                	mov    %edi,%eax
  801ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5f                   	pop    %edi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    
		panic("[fork_v0] sys_env_set_status: %e", r);
  801ae6:	50                   	push   %eax
  801ae7:	68 ac 3b 80 00       	push   $0x803bac
  801aec:	68 98 00 00 00       	push   $0x98
  801af1:	68 95 3a 80 00       	push   $0x803a95
  801af6:	e8 73 ef ff ff       	call   800a6e <_panic>

00801afb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801afb:	f3 0f 1e fb          	endbr32 
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	57                   	push   %edi
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	envid_t envid;
	extern void _pgfault_upcall(void);
	int r;
	set_pgfault_handler(pgfault);
  801b08:	68 1f 19 80 00       	push   $0x80191f
  801b0d:	e8 98 15 00 00       	call   8030aa <set_pgfault_handler>
  801b12:	b8 07 00 00 00       	mov    $0x7,%eax
  801b17:	cd 30                	int    $0x30
  801b19:	89 c6                	mov    %eax,%esi

	envid = sys_exofork();
	if (envid < 0)
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 37                	js     801b59 <fork+0x5e>
  801b22:	89 c7                	mov    %eax,%edi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  801b24:	74 48                	je     801b6e <fork+0x73>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	if ((r = sys_page_alloc(envid,
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	6a 07                	push   $0x7
  801b2b:	68 00 f0 bf ee       	push   $0xeebff000
  801b30:	50                   	push   %eax
  801b31:	e8 05 fb ff ff       	call   80163b <sys_page_alloc>
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 4d                	js     801b8a <fork+0x8f>
	                        (void *) (UXSTACKTOP - PGSIZE),
	                        PTE_P | PTE_W | PTE_U)) < 0)
		panic("sys_page_alloc has failed: %d", r);

	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	68 27 31 80 00       	push   $0x803127
  801b45:	56                   	push   %esi
  801b46:	e8 b7 fb ff ff       	call   801702 <sys_env_set_pgfault_upcall>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 4d                	js     801b9f <fork+0xa4>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);

	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801b52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b57:	eb 70                	jmp    801bc9 <fork+0xce>
		panic("sys_exofork: %e", envid);
  801b59:	50                   	push   %eax
  801b5a:	68 f0 3a 80 00       	push   $0x803af0
  801b5f:	68 b7 00 00 00       	push   $0xb7
  801b64:	68 95 3a 80 00       	push   $0x803a95
  801b69:	e8 00 ef ff ff       	call   800a6e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b6e:	e8 75 fa ff ff       	call   8015e8 <sys_getenvid>
  801b73:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b78:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b80:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801b85:	e9 80 00 00 00       	jmp    801c0a <fork+0x10f>
		panic("sys_page_alloc has failed: %d", r);
  801b8a:	50                   	push   %eax
  801b8b:	68 00 3b 80 00       	push   $0x803b00
  801b90:	68 c0 00 00 00       	push   $0xc0
  801b95:	68 95 3a 80 00       	push   $0x803a95
  801b9a:	e8 cf ee ff ff       	call   800a6e <_panic>
		panic("sys_env_set_pgfault_upcall has failed: %d", r);
  801b9f:	50                   	push   %eax
  801ba0:	68 d0 3b 80 00       	push   $0x803bd0
  801ba5:	68 c3 00 00 00       	push   $0xc3
  801baa:	68 95 3a 80 00       	push   $0x803a95
  801baf:	e8 ba ee ff ff       	call   800a6e <_panic>
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
		    ((int) addr < UXSTACKTOP))
			continue;
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
			duppage(envid, PGNUM(addr));
  801bb4:	89 f8                	mov    %edi,%eax
  801bb6:	e8 bd fb ff ff       	call   801778 <duppage>
	for (uint8_t *addr = 0; (int) addr < UTOP; addr += PGSIZE) {
  801bbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bc1:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801bc7:	74 2f                	je     801bf8 <fork+0xfd>
  801bc9:	89 da                	mov    %ebx,%edx
		if (((int) addr >= UXSTACKTOP - PGSIZE) &&
  801bcb:	8d 83 00 10 40 11    	lea    0x11401000(%ebx),%eax
  801bd1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  801bd6:	76 e3                	jbe    801bbb <fork+0xc0>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	c1 e8 16             	shr    $0x16,%eax
  801bdd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801be4:	a8 01                	test   $0x1,%al
  801be6:	74 d3                	je     801bbb <fork+0xc0>
  801be8:	c1 ea 0c             	shr    $0xc,%edx
  801beb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bf2:	a8 01                	test   $0x1,%al
  801bf4:	74 c5                	je     801bbb <fork+0xc0>
  801bf6:	eb bc                	jmp    801bb4 <fork+0xb9>
	}

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	6a 02                	push   $0x2
  801bfd:	56                   	push   %esi
  801bfe:	e8 b1 fa ff ff       	call   8016b4 <sys_env_set_status>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 0a                	js     801c14 <fork+0x119>
		panic("sys_env_set_status has failed: %d", r);

	return envid;
}
  801c0a:	89 f0                	mov    %esi,%eax
  801c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
		panic("sys_env_set_status has failed: %d", r);
  801c14:	50                   	push   %eax
  801c15:	68 fc 3b 80 00       	push   $0x803bfc
  801c1a:	68 ce 00 00 00       	push   $0xce
  801c1f:	68 95 3a 80 00       	push   $0x803a95
  801c24:	e8 45 ee ff ff       	call   800a6e <_panic>

00801c29 <sfork>:

// Challenge!
int
sfork(void)
{
  801c29:	f3 0f 1e fb          	endbr32 
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801c33:	68 1e 3b 80 00       	push   $0x803b1e
  801c38:	68 d7 00 00 00       	push   $0xd7
  801c3d:	68 95 3a 80 00       	push   $0x803a95
  801c42:	e8 27 ee ff ff       	call   800a6e <_panic>

00801c47 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c47:	f3 0f 1e fb          	endbr32 
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c54:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801c57:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801c59:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c5c:	83 3a 01             	cmpl   $0x1,(%edx)
  801c5f:	7e 09                	jle    801c6a <argstart+0x23>
  801c61:	ba 21 35 80 00       	mov    $0x803521,%edx
  801c66:	85 c9                	test   %ecx,%ecx
  801c68:	75 05                	jne    801c6f <argstart+0x28>
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801c72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <argnext>:

int
argnext(struct Argstate *args)
{
  801c7b:	f3 0f 1e fb          	endbr32 
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801c89:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c90:	8b 43 08             	mov    0x8(%ebx),%eax
  801c93:	85 c0                	test   %eax,%eax
  801c95:	74 74                	je     801d0b <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801c97:	80 38 00             	cmpb   $0x0,(%eax)
  801c9a:	75 48                	jne    801ce4 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c9c:	8b 0b                	mov    (%ebx),%ecx
  801c9e:	83 39 01             	cmpl   $0x1,(%ecx)
  801ca1:	74 5a                	je     801cfd <argnext+0x82>
		    || args->argv[1][0] != '-'
  801ca3:	8b 53 04             	mov    0x4(%ebx),%edx
  801ca6:	8b 42 04             	mov    0x4(%edx),%eax
  801ca9:	80 38 2d             	cmpb   $0x2d,(%eax)
  801cac:	75 4f                	jne    801cfd <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801cae:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801cb2:	74 49                	je     801cfd <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801cb4:	83 c0 01             	add    $0x1,%eax
  801cb7:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	8b 01                	mov    (%ecx),%eax
  801cbf:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801cc6:	50                   	push   %eax
  801cc7:	8d 42 08             	lea    0x8(%edx),%eax
  801cca:	50                   	push   %eax
  801ccb:	83 c2 04             	add    $0x4,%edx
  801cce:	52                   	push   %edx
  801ccf:	e8 97 f6 ff ff       	call   80136b <memmove>
		(*args->argc)--;
  801cd4:	8b 03                	mov    (%ebx),%eax
  801cd6:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cd9:	8b 43 08             	mov    0x8(%ebx),%eax
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ce2:	74 13                	je     801cf7 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801ce4:	8b 43 08             	mov    0x8(%ebx),%eax
  801ce7:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801cea:	83 c0 01             	add    $0x1,%eax
  801ced:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801cf0:	89 d0                	mov    %edx,%eax
  801cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cf7:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801cfb:	75 e7                	jne    801ce4 <argnext+0x69>
	args->curarg = 0;
  801cfd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801d04:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d09:	eb e5                	jmp    801cf0 <argnext+0x75>
		return -1;
  801d0b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d10:	eb de                	jmp    801cf0 <argnext+0x75>

00801d12 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801d12:	f3 0f 1e fb          	endbr32 
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	53                   	push   %ebx
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801d20:	8b 43 08             	mov    0x8(%ebx),%eax
  801d23:	85 c0                	test   %eax,%eax
  801d25:	74 12                	je     801d39 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801d27:	80 38 00             	cmpb   $0x0,(%eax)
  801d2a:	74 12                	je     801d3e <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801d2c:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801d2f:	c7 43 08 21 35 80 00 	movl   $0x803521,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801d36:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801d39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    
	} else if (*args->argc > 1) {
  801d3e:	8b 13                	mov    (%ebx),%edx
  801d40:	83 3a 01             	cmpl   $0x1,(%edx)
  801d43:	7f 10                	jg     801d55 <argnextvalue+0x43>
		args->argvalue = 0;
  801d45:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801d4c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801d53:	eb e1                	jmp    801d36 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801d55:	8b 43 04             	mov    0x4(%ebx),%eax
  801d58:	8b 48 04             	mov    0x4(%eax),%ecx
  801d5b:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	8b 12                	mov    (%edx),%edx
  801d63:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801d6a:	52                   	push   %edx
  801d6b:	8d 50 08             	lea    0x8(%eax),%edx
  801d6e:	52                   	push   %edx
  801d6f:	83 c0 04             	add    $0x4,%eax
  801d72:	50                   	push   %eax
  801d73:	e8 f3 f5 ff ff       	call   80136b <memmove>
		(*args->argc)--;
  801d78:	8b 03                	mov    (%ebx),%eax
  801d7a:	83 28 01             	subl   $0x1,(%eax)
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	eb b4                	jmp    801d36 <argnextvalue+0x24>

00801d82 <argvalue>:
{
  801d82:	f3 0f 1e fb          	endbr32 
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d8f:	8b 42 0c             	mov    0xc(%edx),%eax
  801d92:	85 c0                	test   %eax,%eax
  801d94:	74 02                	je     801d98 <argvalue+0x16>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	52                   	push   %edx
  801d9c:	e8 71 ff ff ff       	call   801d12 <argnextvalue>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	eb f0                	jmp    801d96 <argvalue+0x14>

00801da6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801da6:	f3 0f 1e fb          	endbr32 
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	05 00 00 00 30       	add    $0x30000000,%eax
  801db5:	c1 e8 0c             	shr    $0xc,%eax
}
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dba:	f3 0f 1e fb          	endbr32 
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	e8 da ff ff ff       	call   801da6 <fd2num>
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	c1 e0 0c             	shl    $0xc,%eax
  801dd2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dd9:	f3 0f 1e fb          	endbr32 
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801de5:	89 c2                	mov    %eax,%edx
  801de7:	c1 ea 16             	shr    $0x16,%edx
  801dea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801df1:	f6 c2 01             	test   $0x1,%dl
  801df4:	74 2d                	je     801e23 <fd_alloc+0x4a>
  801df6:	89 c2                	mov    %eax,%edx
  801df8:	c1 ea 0c             	shr    $0xc,%edx
  801dfb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e02:	f6 c2 01             	test   $0x1,%dl
  801e05:	74 1c                	je     801e23 <fd_alloc+0x4a>
  801e07:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e0c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e11:	75 d2                	jne    801de5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e1c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e21:	eb 0a                	jmp    801e2d <fd_alloc+0x54>
			*fd_store = fd;
  801e23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e26:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    

00801e2f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e2f:	f3 0f 1e fb          	endbr32 
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e39:	83 f8 1f             	cmp    $0x1f,%eax
  801e3c:	77 30                	ja     801e6e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e3e:	c1 e0 0c             	shl    $0xc,%eax
  801e41:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e46:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801e4c:	f6 c2 01             	test   $0x1,%dl
  801e4f:	74 24                	je     801e75 <fd_lookup+0x46>
  801e51:	89 c2                	mov    %eax,%edx
  801e53:	c1 ea 0c             	shr    $0xc,%edx
  801e56:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e5d:	f6 c2 01             	test   $0x1,%dl
  801e60:	74 1a                	je     801e7c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	89 02                	mov    %eax,(%edx)
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    
		return -E_INVAL;
  801e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e73:	eb f7                	jmp    801e6c <fd_lookup+0x3d>
		return -E_INVAL;
  801e75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e7a:	eb f0                	jmp    801e6c <fd_lookup+0x3d>
  801e7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e81:	eb e9                	jmp    801e6c <fd_lookup+0x3d>

00801e83 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e83:	f3 0f 1e fb          	endbr32 
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e90:	ba 9c 3c 80 00       	mov    $0x803c9c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801e95:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e9a:	39 08                	cmp    %ecx,(%eax)
  801e9c:	74 33                	je     801ed1 <dev_lookup+0x4e>
  801e9e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801ea1:	8b 02                	mov    (%edx),%eax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	75 f3                	jne    801e9a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ea7:	a1 24 54 80 00       	mov    0x805424,%eax
  801eac:	8b 40 48             	mov    0x48(%eax),%eax
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	51                   	push   %ecx
  801eb3:	50                   	push   %eax
  801eb4:	68 20 3c 80 00       	push   $0x803c20
  801eb9:	e8 97 ec ff ff       	call   800b55 <cprintf>
	*dev = 0;
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    
			*dev = devtab[i];
  801ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed4:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	eb f2                	jmp    801ecf <dev_lookup+0x4c>

00801edd <fd_close>:
{
  801edd:	f3 0f 1e fb          	endbr32 
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	57                   	push   %edi
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	83 ec 28             	sub    $0x28,%esp
  801eea:	8b 75 08             	mov    0x8(%ebp),%esi
  801eed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ef0:	56                   	push   %esi
  801ef1:	e8 b0 fe ff ff       	call   801da6 <fd2num>
  801ef6:	83 c4 08             	add    $0x8,%esp
  801ef9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	e8 2c ff ff ff       	call   801e2f <fd_lookup>
  801f03:	89 c3                	mov    %eax,%ebx
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 05                	js     801f11 <fd_close+0x34>
	    || fd != fd2)
  801f0c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f0f:	74 16                	je     801f27 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801f11:	89 f8                	mov    %edi,%eax
  801f13:	84 c0                	test   %al,%al
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1a:	0f 44 d8             	cmove  %eax,%ebx
}
  801f1d:	89 d8                	mov    %ebx,%eax
  801f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5e                   	pop    %esi
  801f24:	5f                   	pop    %edi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f2d:	50                   	push   %eax
  801f2e:	ff 36                	pushl  (%esi)
  801f30:	e8 4e ff ff ff       	call   801e83 <dev_lookup>
  801f35:	89 c3                	mov    %eax,%ebx
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	78 1a                	js     801f58 <fd_close+0x7b>
		if (dev->dev_close)
  801f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f41:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801f44:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	74 0b                	je     801f58 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	56                   	push   %esi
  801f51:	ff d0                	call   *%eax
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	56                   	push   %esi
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 2a f7 ff ff       	call   80168d <sys_page_unmap>
	return r;
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	eb b5                	jmp    801f1d <fd_close+0x40>

00801f68 <close>:

int
close(int fdnum)
{
  801f68:	f3 0f 1e fb          	endbr32 
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	e8 b1 fe ff ff       	call   801e2f <fd_lookup>
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	79 02                	jns    801f87 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    
		return fd_close(fd, 1);
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	6a 01                	push   $0x1
  801f8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8f:	e8 49 ff ff ff       	call   801edd <fd_close>
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	eb ec                	jmp    801f85 <close+0x1d>

00801f99 <close_all>:

void
close_all(void)
{
  801f99:	f3 0f 1e fb          	endbr32 
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	53                   	push   %ebx
  801fa1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fa4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fa9:	83 ec 0c             	sub    $0xc,%esp
  801fac:	53                   	push   %ebx
  801fad:	e8 b6 ff ff ff       	call   801f68 <close>
	for (i = 0; i < MAXFD; i++)
  801fb2:	83 c3 01             	add    $0x1,%ebx
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	83 fb 20             	cmp    $0x20,%ebx
  801fbb:	75 ec                	jne    801fa9 <close_all+0x10>
}
  801fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fc2:	f3 0f 1e fb          	endbr32 
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fcf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fd2:	50                   	push   %eax
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	e8 54 fe ff ff       	call   801e2f <fd_lookup>
  801fdb:	89 c3                	mov    %eax,%ebx
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	0f 88 81 00 00 00    	js     802069 <dup+0xa7>
		return r;
	close(newfdnum);
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	e8 75 ff ff ff       	call   801f68 <close>

	newfd = INDEX2FD(newfdnum);
  801ff3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ff6:	c1 e6 0c             	shl    $0xc,%esi
  801ff9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801fff:	83 c4 04             	add    $0x4,%esp
  802002:	ff 75 e4             	pushl  -0x1c(%ebp)
  802005:	e8 b0 fd ff ff       	call   801dba <fd2data>
  80200a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80200c:	89 34 24             	mov    %esi,(%esp)
  80200f:	e8 a6 fd ff ff       	call   801dba <fd2data>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802019:	89 d8                	mov    %ebx,%eax
  80201b:	c1 e8 16             	shr    $0x16,%eax
  80201e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802025:	a8 01                	test   $0x1,%al
  802027:	74 11                	je     80203a <dup+0x78>
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	c1 e8 0c             	shr    $0xc,%eax
  80202e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802035:	f6 c2 01             	test   $0x1,%dl
  802038:	75 39                	jne    802073 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80203a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	c1 e8 0c             	shr    $0xc,%eax
  802042:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	25 07 0e 00 00       	and    $0xe07,%eax
  802051:	50                   	push   %eax
  802052:	56                   	push   %esi
  802053:	6a 00                	push   $0x0
  802055:	52                   	push   %edx
  802056:	6a 00                	push   $0x0
  802058:	e8 06 f6 ff ff       	call   801663 <sys_page_map>
  80205d:	89 c3                	mov    %eax,%ebx
  80205f:	83 c4 20             	add    $0x20,%esp
  802062:	85 c0                	test   %eax,%eax
  802064:	78 31                	js     802097 <dup+0xd5>
		goto err;

	return newfdnum;
  802066:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206e:	5b                   	pop    %ebx
  80206f:	5e                   	pop    %esi
  802070:	5f                   	pop    %edi
  802071:	5d                   	pop    %ebp
  802072:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802073:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	25 07 0e 00 00       	and    $0xe07,%eax
  802082:	50                   	push   %eax
  802083:	57                   	push   %edi
  802084:	6a 00                	push   $0x0
  802086:	53                   	push   %ebx
  802087:	6a 00                	push   $0x0
  802089:	e8 d5 f5 ff ff       	call   801663 <sys_page_map>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	83 c4 20             	add    $0x20,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	79 a3                	jns    80203a <dup+0x78>
	sys_page_unmap(0, newfd);
  802097:	83 ec 08             	sub    $0x8,%esp
  80209a:	56                   	push   %esi
  80209b:	6a 00                	push   $0x0
  80209d:	e8 eb f5 ff ff       	call   80168d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020a2:	83 c4 08             	add    $0x8,%esp
  8020a5:	57                   	push   %edi
  8020a6:	6a 00                	push   $0x0
  8020a8:	e8 e0 f5 ff ff       	call   80168d <sys_page_unmap>
	return r;
  8020ad:	83 c4 10             	add    $0x10,%esp
  8020b0:	eb b7                	jmp    802069 <dup+0xa7>

008020b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020b2:	f3 0f 1e fb          	endbr32 
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	53                   	push   %ebx
  8020ba:	83 ec 1c             	sub    $0x1c,%esp
  8020bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c3:	50                   	push   %eax
  8020c4:	53                   	push   %ebx
  8020c5:	e8 65 fd ff ff       	call   801e2f <fd_lookup>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 3f                	js     802110 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020d1:	83 ec 08             	sub    $0x8,%esp
  8020d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d7:	50                   	push   %eax
  8020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020db:	ff 30                	pushl  (%eax)
  8020dd:	e8 a1 fd ff ff       	call   801e83 <dev_lookup>
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 27                	js     802110 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ec:	8b 42 08             	mov    0x8(%edx),%eax
  8020ef:	83 e0 03             	and    $0x3,%eax
  8020f2:	83 f8 01             	cmp    $0x1,%eax
  8020f5:	74 1e                	je     802115 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 40 08             	mov    0x8(%eax),%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	74 35                	je     802136 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	ff 75 10             	pushl  0x10(%ebp)
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	52                   	push   %edx
  80210b:	ff d0                	call   *%eax
  80210d:	83 c4 10             	add    $0x10,%esp
}
  802110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802113:	c9                   	leave  
  802114:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802115:	a1 24 54 80 00       	mov    0x805424,%eax
  80211a:	8b 40 48             	mov    0x48(%eax),%eax
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	53                   	push   %ebx
  802121:	50                   	push   %eax
  802122:	68 61 3c 80 00       	push   $0x803c61
  802127:	e8 29 ea ff ff       	call   800b55 <cprintf>
		return -E_INVAL;
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802134:	eb da                	jmp    802110 <read+0x5e>
		return -E_NOT_SUPP;
  802136:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80213b:	eb d3                	jmp    802110 <read+0x5e>

0080213d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80213d:	f3 0f 1e fb          	endbr32 
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	57                   	push   %edi
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80214d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802150:	bb 00 00 00 00       	mov    $0x0,%ebx
  802155:	eb 02                	jmp    802159 <readn+0x1c>
  802157:	01 c3                	add    %eax,%ebx
  802159:	39 f3                	cmp    %esi,%ebx
  80215b:	73 21                	jae    80217e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	89 f0                	mov    %esi,%eax
  802162:	29 d8                	sub    %ebx,%eax
  802164:	50                   	push   %eax
  802165:	89 d8                	mov    %ebx,%eax
  802167:	03 45 0c             	add    0xc(%ebp),%eax
  80216a:	50                   	push   %eax
  80216b:	57                   	push   %edi
  80216c:	e8 41 ff ff ff       	call   8020b2 <read>
		if (m < 0)
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	78 04                	js     80217c <readn+0x3f>
			return m;
		if (m == 0)
  802178:	75 dd                	jne    802157 <readn+0x1a>
  80217a:	eb 02                	jmp    80217e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80217c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80217e:	89 d8                	mov    %ebx,%eax
  802180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    

00802188 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802188:	f3 0f 1e fb          	endbr32 
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	53                   	push   %ebx
  802190:	83 ec 1c             	sub    $0x1c,%esp
  802193:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802196:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802199:	50                   	push   %eax
  80219a:	53                   	push   %ebx
  80219b:	e8 8f fc ff ff       	call   801e2f <fd_lookup>
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	78 3a                	js     8021e1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021a7:	83 ec 08             	sub    $0x8,%esp
  8021aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ad:	50                   	push   %eax
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	ff 30                	pushl  (%eax)
  8021b3:	e8 cb fc ff ff       	call   801e83 <dev_lookup>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 22                	js     8021e1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021c6:	74 1e                	je     8021e6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8021ce:	85 d2                	test   %edx,%edx
  8021d0:	74 35                	je     802207 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8021d2:	83 ec 04             	sub    $0x4,%esp
  8021d5:	ff 75 10             	pushl  0x10(%ebp)
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	50                   	push   %eax
  8021dc:	ff d2                	call   *%edx
  8021de:	83 c4 10             	add    $0x10,%esp
}
  8021e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021e6:	a1 24 54 80 00       	mov    0x805424,%eax
  8021eb:	8b 40 48             	mov    0x48(%eax),%eax
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	53                   	push   %ebx
  8021f2:	50                   	push   %eax
  8021f3:	68 7d 3c 80 00       	push   $0x803c7d
  8021f8:	e8 58 e9 ff ff       	call   800b55 <cprintf>
		return -E_INVAL;
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802205:	eb da                	jmp    8021e1 <write+0x59>
		return -E_NOT_SUPP;
  802207:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80220c:	eb d3                	jmp    8021e1 <write+0x59>

0080220e <seek>:

int
seek(int fdnum, off_t offset)
{
  80220e:	f3 0f 1e fb          	endbr32 
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 0b fc ff ff       	call   801e2f <fd_lookup>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	85 c0                	test   %eax,%eax
  802229:	78 0e                	js     802239 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80223b:	f3 0f 1e fb          	endbr32 
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	53                   	push   %ebx
  802243:	83 ec 1c             	sub    $0x1c,%esp
  802246:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802249:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80224c:	50                   	push   %eax
  80224d:	53                   	push   %ebx
  80224e:	e8 dc fb ff ff       	call   801e2f <fd_lookup>
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	78 37                	js     802291 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80225a:	83 ec 08             	sub    $0x8,%esp
  80225d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802260:	50                   	push   %eax
  802261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802264:	ff 30                	pushl  (%eax)
  802266:	e8 18 fc ff ff       	call   801e83 <dev_lookup>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 1f                	js     802291 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802275:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802279:	74 1b                	je     802296 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227e:	8b 52 18             	mov    0x18(%edx),%edx
  802281:	85 d2                	test   %edx,%edx
  802283:	74 32                	je     8022b7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	ff 75 0c             	pushl  0xc(%ebp)
  80228b:	50                   	push   %eax
  80228c:	ff d2                	call   *%edx
  80228e:	83 c4 10             	add    $0x10,%esp
}
  802291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802294:	c9                   	leave  
  802295:	c3                   	ret    
			thisenv->env_id, fdnum);
  802296:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80229b:	8b 40 48             	mov    0x48(%eax),%eax
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	53                   	push   %ebx
  8022a2:	50                   	push   %eax
  8022a3:	68 40 3c 80 00       	push   $0x803c40
  8022a8:	e8 a8 e8 ff ff       	call   800b55 <cprintf>
		return -E_INVAL;
  8022ad:	83 c4 10             	add    $0x10,%esp
  8022b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b5:	eb da                	jmp    802291 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8022b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022bc:	eb d3                	jmp    802291 <ftruncate+0x56>

008022be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022be:	f3 0f 1e fb          	endbr32 
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	53                   	push   %ebx
  8022c6:	83 ec 1c             	sub    $0x1c,%esp
  8022c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022cf:	50                   	push   %eax
  8022d0:	ff 75 08             	pushl  0x8(%ebp)
  8022d3:	e8 57 fb ff ff       	call   801e2f <fd_lookup>
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	78 4b                	js     80232a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022df:	83 ec 08             	sub    $0x8,%esp
  8022e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e5:	50                   	push   %eax
  8022e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e9:	ff 30                	pushl  (%eax)
  8022eb:	e8 93 fb ff ff       	call   801e83 <dev_lookup>
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	78 33                	js     80232a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8022fe:	74 2f                	je     80232f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802300:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802303:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80230a:	00 00 00 
	stat->st_isdir = 0;
  80230d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802314:	00 00 00 
	stat->st_dev = dev;
  802317:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80231d:	83 ec 08             	sub    $0x8,%esp
  802320:	53                   	push   %ebx
  802321:	ff 75 f0             	pushl  -0x10(%ebp)
  802324:	ff 50 14             	call   *0x14(%eax)
  802327:	83 c4 10             	add    $0x10,%esp
}
  80232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    
		return -E_NOT_SUPP;
  80232f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802334:	eb f4                	jmp    80232a <fstat+0x6c>

00802336 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802336:	f3 0f 1e fb          	endbr32 
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	56                   	push   %esi
  80233e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	6a 00                	push   $0x0
  802344:	ff 75 08             	pushl  0x8(%ebp)
  802347:	e8 3a 02 00 00       	call   802586 <open>
  80234c:	89 c3                	mov    %eax,%ebx
  80234e:	83 c4 10             	add    $0x10,%esp
  802351:	85 c0                	test   %eax,%eax
  802353:	78 1b                	js     802370 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  802355:	83 ec 08             	sub    $0x8,%esp
  802358:	ff 75 0c             	pushl  0xc(%ebp)
  80235b:	50                   	push   %eax
  80235c:	e8 5d ff ff ff       	call   8022be <fstat>
  802361:	89 c6                	mov    %eax,%esi
	close(fd);
  802363:	89 1c 24             	mov    %ebx,(%esp)
  802366:	e8 fd fb ff ff       	call   801f68 <close>
	return r;
  80236b:	83 c4 10             	add    $0x10,%esp
  80236e:	89 f3                	mov    %esi,%ebx
}
  802370:	89 d8                	mov    %ebx,%eax
  802372:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5d                   	pop    %ebp
  802378:	c3                   	ret    

00802379 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	56                   	push   %esi
  80237d:	53                   	push   %ebx
  80237e:	89 c6                	mov    %eax,%esi
  802380:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802382:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802389:	74 27                	je     8023b2 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80238b:	6a 07                	push   $0x7
  80238d:	68 00 60 80 00       	push   $0x806000
  802392:	56                   	push   %esi
  802393:	ff 35 20 54 80 00    	pushl  0x805420
  802399:	e8 1c 0e 00 00       	call   8031ba <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80239e:	83 c4 0c             	add    $0xc,%esp
  8023a1:	6a 00                	push   $0x0
  8023a3:	53                   	push   %ebx
  8023a4:	6a 00                	push   $0x0
  8023a6:	e8 a2 0d 00 00       	call   80314d <ipc_recv>
}
  8023ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ae:	5b                   	pop    %ebx
  8023af:	5e                   	pop    %esi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	6a 01                	push   $0x1
  8023b7:	e8 56 0e 00 00       	call   803212 <ipc_find_env>
  8023bc:	a3 20 54 80 00       	mov    %eax,0x805420
  8023c1:	83 c4 10             	add    $0x10,%esp
  8023c4:	eb c5                	jmp    80238b <fsipc+0x12>

008023c6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023c6:	f3 0f 1e fb          	endbr32 
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8023db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023de:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8023e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8023ed:	e8 87 ff ff ff       	call   802379 <fsipc>
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <devfile_flush>:
{
  8023f4:	f3 0f 1e fb          	endbr32 
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	8b 40 0c             	mov    0xc(%eax),%eax
  802404:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802409:	ba 00 00 00 00       	mov    $0x0,%edx
  80240e:	b8 06 00 00 00       	mov    $0x6,%eax
  802413:	e8 61 ff ff ff       	call   802379 <fsipc>
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <devfile_stat>:
{
  80241a:	f3 0f 1e fb          	endbr32 
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	53                   	push   %ebx
  802422:	83 ec 04             	sub    $0x4,%esp
  802425:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	8b 40 0c             	mov    0xc(%eax),%eax
  80242e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802433:	ba 00 00 00 00       	mov    $0x0,%edx
  802438:	b8 05 00 00 00       	mov    $0x5,%eax
  80243d:	e8 37 ff ff ff       	call   802379 <fsipc>
  802442:	85 c0                	test   %eax,%eax
  802444:	78 2c                	js     802472 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802446:	83 ec 08             	sub    $0x8,%esp
  802449:	68 00 60 80 00       	push   $0x806000
  80244e:	53                   	push   %ebx
  80244f:	e8 5f ed ff ff       	call   8011b3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802454:	a1 80 60 80 00       	mov    0x806080,%eax
  802459:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80245f:	a1 84 60 80 00       	mov    0x806084,%eax
  802464:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <devfile_write>:
{
  802477:	f3 0f 1e fb          	endbr32 
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	53                   	push   %ebx
  80247f:	83 ec 04             	sub    $0x4,%esp
  802482:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8b 40 0c             	mov    0xc(%eax),%eax
  80248b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  802490:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802496:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80249c:	77 30                	ja     8024ce <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	53                   	push   %ebx
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	68 08 60 80 00       	push   $0x806008
  8024aa:	e8 bc ee ff ff       	call   80136b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8024af:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8024b9:	e8 bb fe ff ff       	call   802379 <fsipc>
  8024be:	83 c4 10             	add    $0x10,%esp
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	78 04                	js     8024c9 <devfile_write+0x52>
	assert(r <= n);
  8024c5:	39 d8                	cmp    %ebx,%eax
  8024c7:	77 1e                	ja     8024e7 <devfile_write+0x70>
}
  8024c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8024ce:	68 ac 3c 80 00       	push   $0x803cac
  8024d3:	68 4f 36 80 00       	push   $0x80364f
  8024d8:	68 94 00 00 00       	push   $0x94
  8024dd:	68 d9 3c 80 00       	push   $0x803cd9
  8024e2:	e8 87 e5 ff ff       	call   800a6e <_panic>
	assert(r <= n);
  8024e7:	68 e4 3c 80 00       	push   $0x803ce4
  8024ec:	68 4f 36 80 00       	push   $0x80364f
  8024f1:	68 98 00 00 00       	push   $0x98
  8024f6:	68 d9 3c 80 00       	push   $0x803cd9
  8024fb:	e8 6e e5 ff ff       	call   800a6e <_panic>

00802500 <devfile_read>:
{
  802500:	f3 0f 1e fb          	endbr32 
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	56                   	push   %esi
  802508:	53                   	push   %ebx
  802509:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	8b 40 0c             	mov    0xc(%eax),%eax
  802512:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802517:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80251d:	ba 00 00 00 00       	mov    $0x0,%edx
  802522:	b8 03 00 00 00       	mov    $0x3,%eax
  802527:	e8 4d fe ff ff       	call   802379 <fsipc>
  80252c:	89 c3                	mov    %eax,%ebx
  80252e:	85 c0                	test   %eax,%eax
  802530:	78 1f                	js     802551 <devfile_read+0x51>
	assert(r <= n);
  802532:	39 f0                	cmp    %esi,%eax
  802534:	77 24                	ja     80255a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  802536:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80253b:	7f 33                	jg     802570 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	50                   	push   %eax
  802541:	68 00 60 80 00       	push   $0x806000
  802546:	ff 75 0c             	pushl  0xc(%ebp)
  802549:	e8 1d ee ff ff       	call   80136b <memmove>
	return r;
  80254e:	83 c4 10             	add    $0x10,%esp
}
  802551:	89 d8                	mov    %ebx,%eax
  802553:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802556:	5b                   	pop    %ebx
  802557:	5e                   	pop    %esi
  802558:	5d                   	pop    %ebp
  802559:	c3                   	ret    
	assert(r <= n);
  80255a:	68 e4 3c 80 00       	push   $0x803ce4
  80255f:	68 4f 36 80 00       	push   $0x80364f
  802564:	6a 7c                	push   $0x7c
  802566:	68 d9 3c 80 00       	push   $0x803cd9
  80256b:	e8 fe e4 ff ff       	call   800a6e <_panic>
	assert(r <= PGSIZE);
  802570:	68 eb 3c 80 00       	push   $0x803ceb
  802575:	68 4f 36 80 00       	push   $0x80364f
  80257a:	6a 7d                	push   $0x7d
  80257c:	68 d9 3c 80 00       	push   $0x803cd9
  802581:	e8 e8 e4 ff ff       	call   800a6e <_panic>

00802586 <open>:
{
  802586:	f3 0f 1e fb          	endbr32 
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	56                   	push   %esi
  80258e:	53                   	push   %ebx
  80258f:	83 ec 1c             	sub    $0x1c,%esp
  802592:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802595:	56                   	push   %esi
  802596:	e8 d5 eb ff ff       	call   801170 <strlen>
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025a3:	7f 6c                	jg     802611 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ab:	50                   	push   %eax
  8025ac:	e8 28 f8 ff ff       	call   801dd9 <fd_alloc>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	78 3c                	js     8025f6 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8025ba:	83 ec 08             	sub    $0x8,%esp
  8025bd:	56                   	push   %esi
  8025be:	68 00 60 80 00       	push   $0x806000
  8025c3:	e8 eb eb ff ff       	call   8011b3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d8:	e8 9c fd ff ff       	call   802379 <fsipc>
  8025dd:	89 c3                	mov    %eax,%ebx
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	78 19                	js     8025ff <open+0x79>
	return fd2num(fd);
  8025e6:	83 ec 0c             	sub    $0xc,%esp
  8025e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ec:	e8 b5 f7 ff ff       	call   801da6 <fd2num>
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	83 c4 10             	add    $0x10,%esp
}
  8025f6:	89 d8                	mov    %ebx,%eax
  8025f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025fb:	5b                   	pop    %ebx
  8025fc:	5e                   	pop    %esi
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    
		fd_close(fd, 0);
  8025ff:	83 ec 08             	sub    $0x8,%esp
  802602:	6a 00                	push   $0x0
  802604:	ff 75 f4             	pushl  -0xc(%ebp)
  802607:	e8 d1 f8 ff ff       	call   801edd <fd_close>
		return r;
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	eb e5                	jmp    8025f6 <open+0x70>
		return -E_BAD_PATH;
  802611:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802616:	eb de                	jmp    8025f6 <open+0x70>

00802618 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802618:	f3 0f 1e fb          	endbr32 
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802622:	ba 00 00 00 00       	mov    $0x0,%edx
  802627:	b8 08 00 00 00       	mov    $0x8,%eax
  80262c:	e8 48 fd ff ff       	call   802379 <fsipc>
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802633:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802637:	7f 01                	jg     80263a <writebuf+0x7>
  802639:	c3                   	ret    
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	53                   	push   %ebx
  80263e:	83 ec 08             	sub    $0x8,%esp
  802641:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802643:	ff 70 04             	pushl  0x4(%eax)
  802646:	8d 40 10             	lea    0x10(%eax),%eax
  802649:	50                   	push   %eax
  80264a:	ff 33                	pushl  (%ebx)
  80264c:	e8 37 fb ff ff       	call   802188 <write>
		if (result > 0)
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	85 c0                	test   %eax,%eax
  802656:	7e 03                	jle    80265b <writebuf+0x28>
			b->result += result;
  802658:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80265b:	39 43 04             	cmp    %eax,0x4(%ebx)
  80265e:	74 0d                	je     80266d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  802660:	85 c0                	test   %eax,%eax
  802662:	ba 00 00 00 00       	mov    $0x0,%edx
  802667:	0f 4f c2             	cmovg  %edx,%eax
  80266a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80266d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <putch>:

static void
putch(int ch, void *thunk)
{
  802672:	f3 0f 1e fb          	endbr32 
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	53                   	push   %ebx
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802680:	8b 53 04             	mov    0x4(%ebx),%edx
  802683:	8d 42 01             	lea    0x1(%edx),%eax
  802686:	89 43 04             	mov    %eax,0x4(%ebx)
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802690:	3d 00 01 00 00       	cmp    $0x100,%eax
  802695:	74 06                	je     80269d <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  802697:	83 c4 04             	add    $0x4,%esp
  80269a:	5b                   	pop    %ebx
  80269b:	5d                   	pop    %ebp
  80269c:	c3                   	ret    
		writebuf(b);
  80269d:	89 d8                	mov    %ebx,%eax
  80269f:	e8 8f ff ff ff       	call   802633 <writebuf>
		b->idx = 0;
  8026a4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8026ab:	eb ea                	jmp    802697 <putch+0x25>

008026ad <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8026ad:	f3 0f 1e fb          	endbr32 
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8026c3:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8026ca:	00 00 00 
	b.result = 0;
  8026cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8026d4:	00 00 00 
	b.error = 1;
  8026d7:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8026de:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8026e1:	ff 75 10             	pushl  0x10(%ebp)
  8026e4:	ff 75 0c             	pushl  0xc(%ebp)
  8026e7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026ed:	50                   	push   %eax
  8026ee:	68 72 26 80 00       	push   $0x802672
  8026f3:	e8 c0 e5 ff ff       	call   800cb8 <vprintfmt>
	if (b.idx > 0)
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802702:	7f 11                	jg     802715 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802704:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    
		writebuf(&b);
  802715:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80271b:	e8 13 ff ff ff       	call   802633 <writebuf>
  802720:	eb e2                	jmp    802704 <vfprintf+0x57>

00802722 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802722:	f3 0f 1e fb          	endbr32 
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80272c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80272f:	50                   	push   %eax
  802730:	ff 75 0c             	pushl  0xc(%ebp)
  802733:	ff 75 08             	pushl  0x8(%ebp)
  802736:	e8 72 ff ff ff       	call   8026ad <vfprintf>
	va_end(ap);

	return cnt;
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <printf>:

int
printf(const char *fmt, ...)
{
  80273d:	f3 0f 1e fb          	endbr32 
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802747:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80274a:	50                   	push   %eax
  80274b:	ff 75 08             	pushl  0x8(%ebp)
  80274e:	6a 01                	push   $0x1
  802750:	e8 58 ff ff ff       	call   8026ad <vfprintf>
	va_end(ap);

	return cnt;
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <copy_shared_pages>:
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	return 0;
}
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
  80275c:	c3                   	ret    

0080275d <init_stack>:
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	57                   	push   %edi
  802761:	56                   	push   %esi
  802762:	53                   	push   %ebx
  802763:	83 ec 2c             	sub    $0x2c,%esp
  802766:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802769:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80276c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	for (argc = 0; argv[argc] != 0; argc++)
  80276f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802774:	be 00 00 00 00       	mov    $0x0,%esi
  802779:	89 d7                	mov    %edx,%edi
  80277b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  802782:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 15                	je     80279e <init_stack+0x41>
		string_size += strlen(argv[argc]) + 1;
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	50                   	push   %eax
  80278d:	e8 de e9 ff ff       	call   801170 <strlen>
  802792:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802796:	83 c3 01             	add    $0x1,%ebx
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	eb dd                	jmp    80277b <init_stack+0x1e>
  80279e:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8027a1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	string_store = (char *) UTEMP + PGSIZE - string_size;
  8027a4:	bf 00 10 40 00       	mov    $0x401000,%edi
  8027a9:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	83 e2 fc             	and    $0xfffffffc,%edx
  8027b0:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8027b7:	29 c2                	sub    %eax,%edx
  8027b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  8027bc:	8d 42 f8             	lea    -0x8(%edx),%eax
  8027bf:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8027c4:	0f 86 06 01 00 00    	jbe    8028d0 <init_stack+0x173>
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	6a 07                	push   $0x7
  8027cf:	68 00 00 40 00       	push   $0x400000
  8027d4:	6a 00                	push   $0x0
  8027d6:	e8 60 ee ff ff       	call   80163b <sys_page_alloc>
  8027db:	89 c6                	mov    %eax,%esi
  8027dd:	83 c4 10             	add    $0x10,%esp
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	0f 88 de 00 00 00    	js     8028c6 <init_stack+0x169>
	for (i = 0; i < argc; i++) {
  8027e8:	be 00 00 00 00       	mov    $0x0,%esi
  8027ed:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8027f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8027f3:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  8027f6:	7e 2f                	jle    802827 <init_stack+0xca>
		argv_store[i] = UTEMP2USTACK(string_store);
  8027f8:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8027fe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802801:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802804:	83 ec 08             	sub    $0x8,%esp
  802807:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80280a:	57                   	push   %edi
  80280b:	e8 a3 e9 ff ff       	call   8011b3 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802810:	83 c4 04             	add    $0x4,%esp
  802813:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802816:	e8 55 e9 ff ff       	call   801170 <strlen>
  80281b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80281f:	83 c6 01             	add    $0x1,%esi
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	eb cc                	jmp    8027f3 <init_stack+0x96>
	argv_store[argc] = 0;
  802827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  80282d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  802834:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80283a:	75 5f                	jne    80289b <init_stack+0x13e>
	argv_store[-1] = UTEMP2USTACK(argv_store);
  80283c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283f:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802845:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802848:	89 d0                	mov    %edx,%eax
  80284a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80284d:	89 4a f8             	mov    %ecx,-0x8(%edx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802850:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802855:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  802858:	89 01                	mov    %eax,(%ecx)
	if ((r = sys_page_map(0,
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	6a 07                	push   $0x7
  80285f:	68 00 d0 bf ee       	push   $0xeebfd000
  802864:	ff 75 d4             	pushl  -0x2c(%ebp)
  802867:	68 00 00 40 00       	push   $0x400000
  80286c:	6a 00                	push   $0x0
  80286e:	e8 f0 ed ff ff       	call   801663 <sys_page_map>
  802873:	89 c6                	mov    %eax,%esi
  802875:	83 c4 20             	add    $0x20,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 38                	js     8028b4 <init_stack+0x157>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80287c:	83 ec 08             	sub    $0x8,%esp
  80287f:	68 00 00 40 00       	push   $0x400000
  802884:	6a 00                	push   $0x0
  802886:	e8 02 ee ff ff       	call   80168d <sys_page_unmap>
  80288b:	89 c6                	mov    %eax,%esi
  80288d:	83 c4 10             	add    $0x10,%esp
  802890:	85 c0                	test   %eax,%eax
  802892:	78 20                	js     8028b4 <init_stack+0x157>
	return 0;
  802894:	be 00 00 00 00       	mov    $0x0,%esi
  802899:	eb 2b                	jmp    8028c6 <init_stack+0x169>
	assert(string_store == (char *) UTEMP + PGSIZE);
  80289b:	68 f8 3c 80 00       	push   $0x803cf8
  8028a0:	68 4f 36 80 00       	push   $0x80364f
  8028a5:	68 fc 00 00 00       	push   $0xfc
  8028aa:	68 20 3d 80 00       	push   $0x803d20
  8028af:	e8 ba e1 ff ff       	call   800a6e <_panic>
	sys_page_unmap(0, UTEMP);
  8028b4:	83 ec 08             	sub    $0x8,%esp
  8028b7:	68 00 00 40 00       	push   $0x400000
  8028bc:	6a 00                	push   $0x0
  8028be:	e8 ca ed ff ff       	call   80168d <sys_page_unmap>
	return r;
  8028c3:	83 c4 10             	add    $0x10,%esp
}
  8028c6:	89 f0                	mov    %esi,%eax
  8028c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028cb:	5b                   	pop    %ebx
  8028cc:	5e                   	pop    %esi
  8028cd:	5f                   	pop    %edi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    
		return -E_NO_MEM;
  8028d0:	be fc ff ff ff       	mov    $0xfffffffc,%esi
  8028d5:	eb ef                	jmp    8028c6 <init_stack+0x169>

008028d7 <map_segment>:
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	57                   	push   %edi
  8028db:	56                   	push   %esi
  8028dc:	53                   	push   %ebx
  8028dd:	83 ec 1c             	sub    $0x1c,%esp
  8028e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028e3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8028e6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  8028e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((i = PGOFF(va))) {
  8028ec:	89 d0                	mov    %edx,%eax
  8028ee:	25 ff 0f 00 00       	and    $0xfff,%eax
  8028f3:	74 0f                	je     802904 <map_segment+0x2d>
		va -= i;
  8028f5:	29 c2                	sub    %eax,%edx
  8028f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		memsz += i;
  8028fa:	01 c1                	add    %eax,%ecx
  8028fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  8028ff:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  802901:	29 45 10             	sub    %eax,0x10(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802904:	bb 00 00 00 00       	mov    $0x0,%ebx
  802909:	e9 99 00 00 00       	jmp    8029a7 <map_segment+0xd0>
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	6a 07                	push   $0x7
  802913:	68 00 00 40 00       	push   $0x400000
  802918:	6a 00                	push   $0x0
  80291a:	e8 1c ed ff ff       	call   80163b <sys_page_alloc>
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	85 c0                	test   %eax,%eax
  802924:	0f 88 c1 00 00 00    	js     8029eb <map_segment+0x114>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80292a:	83 ec 08             	sub    $0x8,%esp
  80292d:	89 f0                	mov    %esi,%eax
  80292f:	03 45 10             	add    0x10(%ebp),%eax
  802932:	50                   	push   %eax
  802933:	ff 75 08             	pushl  0x8(%ebp)
  802936:	e8 d3 f8 ff ff       	call   80220e <seek>
  80293b:	83 c4 10             	add    $0x10,%esp
  80293e:	85 c0                	test   %eax,%eax
  802940:	0f 88 a5 00 00 00    	js     8029eb <map_segment+0x114>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	89 f8                	mov    %edi,%eax
  80294b:	29 f0                	sub    %esi,%eax
  80294d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802952:	ba 00 10 00 00       	mov    $0x1000,%edx
  802957:	0f 47 c2             	cmova  %edx,%eax
  80295a:	50                   	push   %eax
  80295b:	68 00 00 40 00       	push   $0x400000
  802960:	ff 75 08             	pushl  0x8(%ebp)
  802963:	e8 d5 f7 ff ff       	call   80213d <readn>
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	85 c0                	test   %eax,%eax
  80296d:	78 7c                	js     8029eb <map_segment+0x114>
			if ((r = sys_page_map(
  80296f:	83 ec 0c             	sub    $0xc,%esp
  802972:	ff 75 14             	pushl  0x14(%ebp)
  802975:	03 75 e0             	add    -0x20(%ebp),%esi
  802978:	56                   	push   %esi
  802979:	ff 75 dc             	pushl  -0x24(%ebp)
  80297c:	68 00 00 40 00       	push   $0x400000
  802981:	6a 00                	push   $0x0
  802983:	e8 db ec ff ff       	call   801663 <sys_page_map>
  802988:	83 c4 20             	add    $0x20,%esp
  80298b:	85 c0                	test   %eax,%eax
  80298d:	78 42                	js     8029d1 <map_segment+0xfa>
			sys_page_unmap(0, UTEMP);
  80298f:	83 ec 08             	sub    $0x8,%esp
  802992:	68 00 00 40 00       	push   $0x400000
  802997:	6a 00                	push   $0x0
  802999:	e8 ef ec ff ff       	call   80168d <sys_page_unmap>
  80299e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8029a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8029a7:	89 de                	mov    %ebx,%esi
  8029a9:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  8029ac:	76 38                	jbe    8029e6 <map_segment+0x10f>
		if (i >= filesz) {
  8029ae:	39 df                	cmp    %ebx,%edi
  8029b0:	0f 87 58 ff ff ff    	ja     80290e <map_segment+0x37>
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	ff 75 14             	pushl  0x14(%ebp)
  8029bc:	03 75 e0             	add    -0x20(%ebp),%esi
  8029bf:	56                   	push   %esi
  8029c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8029c3:	e8 73 ec ff ff       	call   80163b <sys_page_alloc>
  8029c8:	83 c4 10             	add    $0x10,%esp
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	79 d2                	jns    8029a1 <map_segment+0xca>
  8029cf:	eb 1a                	jmp    8029eb <map_segment+0x114>
				panic("spawn: sys_page_map data: %e", r);
  8029d1:	50                   	push   %eax
  8029d2:	68 2c 3d 80 00       	push   $0x803d2c
  8029d7:	68 3a 01 00 00       	push   $0x13a
  8029dc:	68 20 3d 80 00       	push   $0x803d20
  8029e1:	e8 88 e0 ff ff       	call   800a6e <_panic>
	return 0;
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ee:	5b                   	pop    %ebx
  8029ef:	5e                   	pop    %esi
  8029f0:	5f                   	pop    %edi
  8029f1:	5d                   	pop    %ebp
  8029f2:	c3                   	ret    

008029f3 <spawn>:
{
  8029f3:	f3 0f 1e fb          	endbr32 
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	57                   	push   %edi
  8029fb:	56                   	push   %esi
  8029fc:	53                   	push   %ebx
  8029fd:	81 ec 74 02 00 00    	sub    $0x274,%esp
	if ((r = open(prog, O_RDONLY)) < 0)
  802a03:	6a 00                	push   $0x0
  802a05:	ff 75 08             	pushl  0x8(%ebp)
  802a08:	e8 79 fb ff ff       	call   802586 <open>
  802a0d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802a13:	83 c4 10             	add    $0x10,%esp
  802a16:	85 c0                	test   %eax,%eax
  802a18:	0f 88 0b 02 00 00    	js     802c29 <spawn+0x236>
  802a1e:	89 c7                	mov    %eax,%edi
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	68 00 02 00 00       	push   $0x200
  802a28:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802a2e:	50                   	push   %eax
  802a2f:	57                   	push   %edi
  802a30:	e8 08 f7 ff ff       	call   80213d <readn>
  802a35:	83 c4 10             	add    $0x10,%esp
  802a38:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a3d:	0f 85 85 00 00 00    	jne    802ac8 <spawn+0xd5>
  802a43:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802a4a:	45 4c 46 
  802a4d:	75 79                	jne    802ac8 <spawn+0xd5>
  802a4f:	b8 07 00 00 00       	mov    $0x7,%eax
  802a54:	cd 30                	int    $0x30
  802a56:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802a5c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	if ((r = sys_exofork()) < 0)
  802a62:	89 c3                	mov    %eax,%ebx
  802a64:	85 c0                	test   %eax,%eax
  802a66:	0f 88 b1 01 00 00    	js     802c1d <spawn+0x22a>
	child_tf = envs[ENVX(child)].env_tf;
  802a6c:	89 c6                	mov    %eax,%esi
  802a6e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802a74:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802a77:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802a7d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802a83:	b9 11 00 00 00       	mov    $0x11,%ecx
  802a88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802a8a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802a90:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  802a96:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  802a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9f:	89 d8                	mov    %ebx,%eax
  802aa1:	e8 b7 fc ff ff       	call   80275d <init_stack>
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	0f 88 89 01 00 00    	js     802c37 <spawn+0x244>
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  802aae:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802ab4:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802abb:	be 00 00 00 00       	mov    $0x0,%esi
  802ac0:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802ac6:	eb 3e                	jmp    802b06 <spawn+0x113>
		close(fd);
  802ac8:	83 ec 0c             	sub    $0xc,%esp
  802acb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ad1:	e8 92 f4 ff ff       	call   801f68 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802ad6:	83 c4 0c             	add    $0xc,%esp
  802ad9:	68 7f 45 4c 46       	push   $0x464c457f
  802ade:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802ae4:	68 49 3d 80 00       	push   $0x803d49
  802ae9:	e8 67 e0 ff ff       	call   800b55 <cprintf>
		return -E_NOT_EXEC;
  802aee:	83 c4 10             	add    $0x10,%esp
  802af1:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  802af8:	ff ff ff 
  802afb:	e9 29 01 00 00       	jmp    802c29 <spawn+0x236>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b00:	83 c6 01             	add    $0x1,%esi
  802b03:	83 c3 20             	add    $0x20,%ebx
  802b06:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802b0d:	39 f0                	cmp    %esi,%eax
  802b0f:	7e 62                	jle    802b73 <spawn+0x180>
		if (ph->p_type != ELF_PROG_LOAD)
  802b11:	83 3b 01             	cmpl   $0x1,(%ebx)
  802b14:	75 ea                	jne    802b00 <spawn+0x10d>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b16:	8b 43 18             	mov    0x18(%ebx),%eax
  802b19:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802b1c:	83 f8 01             	cmp    $0x1,%eax
  802b1f:	19 c0                	sbb    %eax,%eax
  802b21:	83 e0 fe             	and    $0xfffffffe,%eax
  802b24:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  802b27:	8b 4b 14             	mov    0x14(%ebx),%ecx
  802b2a:	8b 53 08             	mov    0x8(%ebx),%edx
  802b2d:	50                   	push   %eax
  802b2e:	ff 73 04             	pushl  0x4(%ebx)
  802b31:	ff 73 10             	pushl  0x10(%ebx)
  802b34:	57                   	push   %edi
  802b35:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802b3b:	e8 97 fd ff ff       	call   8028d7 <map_segment>
  802b40:	83 c4 10             	add    $0x10,%esp
  802b43:	85 c0                	test   %eax,%eax
  802b45:	79 b9                	jns    802b00 <spawn+0x10d>
  802b47:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802b49:	83 ec 0c             	sub    $0xc,%esp
  802b4c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802b52:	e8 6b ea ff ff       	call   8015c2 <sys_env_destroy>
	close(fd);
  802b57:	83 c4 04             	add    $0x4,%esp
  802b5a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b60:	e8 03 f4 ff ff       	call   801f68 <close>
	return r;
  802b65:	83 c4 10             	add    $0x10,%esp
		if ((r = map_segment(child,
  802b68:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
	return r;
  802b6e:	e9 b6 00 00 00       	jmp    802c29 <spawn+0x236>
	close(fd);
  802b73:	83 ec 0c             	sub    $0xc,%esp
  802b76:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b7c:	e8 e7 f3 ff ff       	call   801f68 <close>
	if ((r = copy_shared_pages(child)) < 0)
  802b81:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802b87:	e8 cb fb ff ff       	call   802757 <copy_shared_pages>
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	78 4b                	js     802bde <spawn+0x1eb>
	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  802b93:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802b9a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b9d:	83 ec 08             	sub    $0x8,%esp
  802ba0:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802ba6:	50                   	push   %eax
  802ba7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802bad:	e8 29 eb ff ff       	call   8016db <sys_env_set_trapframe>
  802bb2:	83 c4 10             	add    $0x10,%esp
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	78 3a                	js     802bf3 <spawn+0x200>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802bb9:	83 ec 08             	sub    $0x8,%esp
  802bbc:	6a 02                	push   $0x2
  802bbe:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802bc4:	e8 eb ea ff ff       	call   8016b4 <sys_env_set_status>
  802bc9:	83 c4 10             	add    $0x10,%esp
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	78 38                	js     802c08 <spawn+0x215>
	return child;
  802bd0:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802bd6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802bdc:	eb 4b                	jmp    802c29 <spawn+0x236>
		panic("copy_shared_pages: %e", r);
  802bde:	50                   	push   %eax
  802bdf:	68 63 3d 80 00       	push   $0x803d63
  802be4:	68 8c 00 00 00       	push   $0x8c
  802be9:	68 20 3d 80 00       	push   $0x803d20
  802bee:	e8 7b de ff ff       	call   800a6e <_panic>
		panic("sys_env_set_trapframe: %e", r);
  802bf3:	50                   	push   %eax
  802bf4:	68 79 3d 80 00       	push   $0x803d79
  802bf9:	68 90 00 00 00       	push   $0x90
  802bfe:	68 20 3d 80 00       	push   $0x803d20
  802c03:	e8 66 de ff ff       	call   800a6e <_panic>
		panic("sys_env_set_status: %e", r);
  802c08:	50                   	push   %eax
  802c09:	68 93 3d 80 00       	push   $0x803d93
  802c0e:	68 93 00 00 00       	push   $0x93
  802c13:	68 20 3d 80 00       	push   $0x803d20
  802c18:	e8 51 de ff ff       	call   800a6e <_panic>
		return r;
  802c1d:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802c23:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802c29:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c32:	5b                   	pop    %ebx
  802c33:	5e                   	pop    %esi
  802c34:	5f                   	pop    %edi
  802c35:	5d                   	pop    %ebp
  802c36:	c3                   	ret    
		return r;
  802c37:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c3d:	eb ea                	jmp    802c29 <spawn+0x236>

00802c3f <spawnl>:
{
  802c3f:	f3 0f 1e fb          	endbr32 
  802c43:	55                   	push   %ebp
  802c44:	89 e5                	mov    %esp,%ebp
  802c46:	57                   	push   %edi
  802c47:	56                   	push   %esi
  802c48:	53                   	push   %ebx
  802c49:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c4c:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  802c4f:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  802c54:	8d 4a 04             	lea    0x4(%edx),%ecx
  802c57:	83 3a 00             	cmpl   $0x0,(%edx)
  802c5a:	74 07                	je     802c63 <spawnl+0x24>
		argc++;
  802c5c:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  802c5f:	89 ca                	mov    %ecx,%edx
  802c61:	eb f1                	jmp    802c54 <spawnl+0x15>
	const char *argv[argc + 2];
  802c63:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802c6a:	89 d1                	mov    %edx,%ecx
  802c6c:	83 e1 f0             	and    $0xfffffff0,%ecx
  802c6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802c75:	89 e6                	mov    %esp,%esi
  802c77:	29 d6                	sub    %edx,%esi
  802c79:	89 f2                	mov    %esi,%edx
  802c7b:	39 d4                	cmp    %edx,%esp
  802c7d:	74 10                	je     802c8f <spawnl+0x50>
  802c7f:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802c85:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802c8c:	00 
  802c8d:	eb ec                	jmp    802c7b <spawnl+0x3c>
  802c8f:	89 ca                	mov    %ecx,%edx
  802c91:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802c97:	29 d4                	sub    %edx,%esp
  802c99:	85 d2                	test   %edx,%edx
  802c9b:	74 05                	je     802ca2 <spawnl+0x63>
  802c9d:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802ca2:	8d 74 24 03          	lea    0x3(%esp),%esi
  802ca6:	89 f2                	mov    %esi,%edx
  802ca8:	c1 ea 02             	shr    $0x2,%edx
  802cab:	83 e6 fc             	and    $0xfffffffc,%esi
  802cae:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cb3:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  802cba:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802cc1:	00 
	va_start(vl, arg0);
  802cc2:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802cc5:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	eb 0b                	jmp    802cd9 <spawnl+0x9a>
		argv[i + 1] = va_arg(vl, const char *);
  802cce:	83 c0 01             	add    $0x1,%eax
  802cd1:	8b 39                	mov    (%ecx),%edi
  802cd3:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802cd6:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  802cd9:	39 d0                	cmp    %edx,%eax
  802cdb:	75 f1                	jne    802cce <spawnl+0x8f>
	return spawn(prog, argv);
  802cdd:	83 ec 08             	sub    $0x8,%esp
  802ce0:	56                   	push   %esi
  802ce1:	ff 75 08             	pushl  0x8(%ebp)
  802ce4:	e8 0a fd ff ff       	call   8029f3 <spawn>
}
  802ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cec:	5b                   	pop    %ebx
  802ced:	5e                   	pop    %esi
  802cee:	5f                   	pop    %edi
  802cef:	5d                   	pop    %ebp
  802cf0:	c3                   	ret    

00802cf1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802cf1:	f3 0f 1e fb          	endbr32 
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
  802cf8:	56                   	push   %esi
  802cf9:	53                   	push   %ebx
  802cfa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802cfd:	83 ec 0c             	sub    $0xc,%esp
  802d00:	ff 75 08             	pushl  0x8(%ebp)
  802d03:	e8 b2 f0 ff ff       	call   801dba <fd2data>
  802d08:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802d0a:	83 c4 08             	add    $0x8,%esp
  802d0d:	68 aa 3d 80 00       	push   $0x803daa
  802d12:	53                   	push   %ebx
  802d13:	e8 9b e4 ff ff       	call   8011b3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d18:	8b 46 04             	mov    0x4(%esi),%eax
  802d1b:	2b 06                	sub    (%esi),%eax
  802d1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802d2a:	00 00 00 
	stat->st_dev = &devpipe;
  802d2d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802d34:	40 80 00 
	return 0;
}
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d3f:	5b                   	pop    %ebx
  802d40:	5e                   	pop    %esi
  802d41:	5d                   	pop    %ebp
  802d42:	c3                   	ret    

00802d43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d43:	f3 0f 1e fb          	endbr32 
  802d47:	55                   	push   %ebp
  802d48:	89 e5                	mov    %esp,%ebp
  802d4a:	53                   	push   %ebx
  802d4b:	83 ec 0c             	sub    $0xc,%esp
  802d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d51:	53                   	push   %ebx
  802d52:	6a 00                	push   $0x0
  802d54:	e8 34 e9 ff ff       	call   80168d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d59:	89 1c 24             	mov    %ebx,(%esp)
  802d5c:	e8 59 f0 ff ff       	call   801dba <fd2data>
  802d61:	83 c4 08             	add    $0x8,%esp
  802d64:	50                   	push   %eax
  802d65:	6a 00                	push   $0x0
  802d67:	e8 21 e9 ff ff       	call   80168d <sys_page_unmap>
}
  802d6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <_pipeisclosed>:
{
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
  802d74:	57                   	push   %edi
  802d75:	56                   	push   %esi
  802d76:	53                   	push   %ebx
  802d77:	83 ec 1c             	sub    $0x1c,%esp
  802d7a:	89 c7                	mov    %eax,%edi
  802d7c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d7e:	a1 24 54 80 00       	mov    0x805424,%eax
  802d83:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	57                   	push   %edi
  802d8a:	e8 c0 04 00 00       	call   80324f <pageref>
  802d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d92:	89 34 24             	mov    %esi,(%esp)
  802d95:	e8 b5 04 00 00       	call   80324f <pageref>
		nn = thisenv->env_runs;
  802d9a:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802da0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802da3:	83 c4 10             	add    $0x10,%esp
  802da6:	39 cb                	cmp    %ecx,%ebx
  802da8:	74 1b                	je     802dc5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802daa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802dad:	75 cf                	jne    802d7e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802daf:	8b 42 58             	mov    0x58(%edx),%eax
  802db2:	6a 01                	push   $0x1
  802db4:	50                   	push   %eax
  802db5:	53                   	push   %ebx
  802db6:	68 b1 3d 80 00       	push   $0x803db1
  802dbb:	e8 95 dd ff ff       	call   800b55 <cprintf>
  802dc0:	83 c4 10             	add    $0x10,%esp
  802dc3:	eb b9                	jmp    802d7e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802dc5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802dc8:	0f 94 c0             	sete   %al
  802dcb:	0f b6 c0             	movzbl %al,%eax
}
  802dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dd1:	5b                   	pop    %ebx
  802dd2:	5e                   	pop    %esi
  802dd3:	5f                   	pop    %edi
  802dd4:	5d                   	pop    %ebp
  802dd5:	c3                   	ret    

00802dd6 <devpipe_write>:
{
  802dd6:	f3 0f 1e fb          	endbr32 
  802dda:	55                   	push   %ebp
  802ddb:	89 e5                	mov    %esp,%ebp
  802ddd:	57                   	push   %edi
  802dde:	56                   	push   %esi
  802ddf:	53                   	push   %ebx
  802de0:	83 ec 28             	sub    $0x28,%esp
  802de3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802de6:	56                   	push   %esi
  802de7:	e8 ce ef ff ff       	call   801dba <fd2data>
  802dec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dee:	83 c4 10             	add    $0x10,%esp
  802df1:	bf 00 00 00 00       	mov    $0x0,%edi
  802df6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802df9:	74 4f                	je     802e4a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802dfb:	8b 43 04             	mov    0x4(%ebx),%eax
  802dfe:	8b 0b                	mov    (%ebx),%ecx
  802e00:	8d 51 20             	lea    0x20(%ecx),%edx
  802e03:	39 d0                	cmp    %edx,%eax
  802e05:	72 14                	jb     802e1b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802e07:	89 da                	mov    %ebx,%edx
  802e09:	89 f0                	mov    %esi,%eax
  802e0b:	e8 61 ff ff ff       	call   802d71 <_pipeisclosed>
  802e10:	85 c0                	test   %eax,%eax
  802e12:	75 3b                	jne    802e4f <devpipe_write+0x79>
			sys_yield();
  802e14:	e8 f7 e7 ff ff       	call   801610 <sys_yield>
  802e19:	eb e0                	jmp    802dfb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e1e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e22:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802e25:	89 c2                	mov    %eax,%edx
  802e27:	c1 fa 1f             	sar    $0x1f,%edx
  802e2a:	89 d1                	mov    %edx,%ecx
  802e2c:	c1 e9 1b             	shr    $0x1b,%ecx
  802e2f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802e32:	83 e2 1f             	and    $0x1f,%edx
  802e35:	29 ca                	sub    %ecx,%edx
  802e37:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802e3b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802e3f:	83 c0 01             	add    $0x1,%eax
  802e42:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802e45:	83 c7 01             	add    $0x1,%edi
  802e48:	eb ac                	jmp    802df6 <devpipe_write+0x20>
	return i;
  802e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  802e4d:	eb 05                	jmp    802e54 <devpipe_write+0x7e>
				return 0;
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e57:	5b                   	pop    %ebx
  802e58:	5e                   	pop    %esi
  802e59:	5f                   	pop    %edi
  802e5a:	5d                   	pop    %ebp
  802e5b:	c3                   	ret    

00802e5c <devpipe_read>:
{
  802e5c:	f3 0f 1e fb          	endbr32 
  802e60:	55                   	push   %ebp
  802e61:	89 e5                	mov    %esp,%ebp
  802e63:	57                   	push   %edi
  802e64:	56                   	push   %esi
  802e65:	53                   	push   %ebx
  802e66:	83 ec 18             	sub    $0x18,%esp
  802e69:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e6c:	57                   	push   %edi
  802e6d:	e8 48 ef ff ff       	call   801dba <fd2data>
  802e72:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e74:	83 c4 10             	add    $0x10,%esp
  802e77:	be 00 00 00 00       	mov    $0x0,%esi
  802e7c:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e7f:	75 14                	jne    802e95 <devpipe_read+0x39>
	return i;
  802e81:	8b 45 10             	mov    0x10(%ebp),%eax
  802e84:	eb 02                	jmp    802e88 <devpipe_read+0x2c>
				return i;
  802e86:	89 f0                	mov    %esi,%eax
}
  802e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e8b:	5b                   	pop    %ebx
  802e8c:	5e                   	pop    %esi
  802e8d:	5f                   	pop    %edi
  802e8e:	5d                   	pop    %ebp
  802e8f:	c3                   	ret    
			sys_yield();
  802e90:	e8 7b e7 ff ff       	call   801610 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802e95:	8b 03                	mov    (%ebx),%eax
  802e97:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e9a:	75 18                	jne    802eb4 <devpipe_read+0x58>
			if (i > 0)
  802e9c:	85 f6                	test   %esi,%esi
  802e9e:	75 e6                	jne    802e86 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802ea0:	89 da                	mov    %ebx,%edx
  802ea2:	89 f8                	mov    %edi,%eax
  802ea4:	e8 c8 fe ff ff       	call   802d71 <_pipeisclosed>
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 e3                	je     802e90 <devpipe_read+0x34>
				return 0;
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	eb d4                	jmp    802e88 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802eb4:	99                   	cltd   
  802eb5:	c1 ea 1b             	shr    $0x1b,%edx
  802eb8:	01 d0                	add    %edx,%eax
  802eba:	83 e0 1f             	and    $0x1f,%eax
  802ebd:	29 d0                	sub    %edx,%eax
  802ebf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ec7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802eca:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ecd:	83 c6 01             	add    $0x1,%esi
  802ed0:	eb aa                	jmp    802e7c <devpipe_read+0x20>

00802ed2 <pipe>:
{
  802ed2:	f3 0f 1e fb          	endbr32 
  802ed6:	55                   	push   %ebp
  802ed7:	89 e5                	mov    %esp,%ebp
  802ed9:	56                   	push   %esi
  802eda:	53                   	push   %ebx
  802edb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ede:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ee1:	50                   	push   %eax
  802ee2:	e8 f2 ee ff ff       	call   801dd9 <fd_alloc>
  802ee7:	89 c3                	mov    %eax,%ebx
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	85 c0                	test   %eax,%eax
  802eee:	0f 88 23 01 00 00    	js     803017 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 07 04 00 00       	push   $0x407
  802efc:	ff 75 f4             	pushl  -0xc(%ebp)
  802eff:	6a 00                	push   $0x0
  802f01:	e8 35 e7 ff ff       	call   80163b <sys_page_alloc>
  802f06:	89 c3                	mov    %eax,%ebx
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	0f 88 04 01 00 00    	js     803017 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802f13:	83 ec 0c             	sub    $0xc,%esp
  802f16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f19:	50                   	push   %eax
  802f1a:	e8 ba ee ff ff       	call   801dd9 <fd_alloc>
  802f1f:	89 c3                	mov    %eax,%ebx
  802f21:	83 c4 10             	add    $0x10,%esp
  802f24:	85 c0                	test   %eax,%eax
  802f26:	0f 88 db 00 00 00    	js     803007 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 07 04 00 00       	push   $0x407
  802f34:	ff 75 f0             	pushl  -0x10(%ebp)
  802f37:	6a 00                	push   $0x0
  802f39:	e8 fd e6 ff ff       	call   80163b <sys_page_alloc>
  802f3e:	89 c3                	mov    %eax,%ebx
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	85 c0                	test   %eax,%eax
  802f45:	0f 88 bc 00 00 00    	js     803007 <pipe+0x135>
	va = fd2data(fd0);
  802f4b:	83 ec 0c             	sub    $0xc,%esp
  802f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f51:	e8 64 ee ff ff       	call   801dba <fd2data>
  802f56:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f58:	83 c4 0c             	add    $0xc,%esp
  802f5b:	68 07 04 00 00       	push   $0x407
  802f60:	50                   	push   %eax
  802f61:	6a 00                	push   $0x0
  802f63:	e8 d3 e6 ff ff       	call   80163b <sys_page_alloc>
  802f68:	89 c3                	mov    %eax,%ebx
  802f6a:	83 c4 10             	add    $0x10,%esp
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	0f 88 82 00 00 00    	js     802ff7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f75:	83 ec 0c             	sub    $0xc,%esp
  802f78:	ff 75 f0             	pushl  -0x10(%ebp)
  802f7b:	e8 3a ee ff ff       	call   801dba <fd2data>
  802f80:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f87:	50                   	push   %eax
  802f88:	6a 00                	push   $0x0
  802f8a:	56                   	push   %esi
  802f8b:	6a 00                	push   $0x0
  802f8d:	e8 d1 e6 ff ff       	call   801663 <sys_page_map>
  802f92:	89 c3                	mov    %eax,%ebx
  802f94:	83 c4 20             	add    $0x20,%esp
  802f97:	85 c0                	test   %eax,%eax
  802f99:	78 4e                	js     802fe9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802f9b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802faf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802fbe:	83 ec 0c             	sub    $0xc,%esp
  802fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc4:	e8 dd ed ff ff       	call   801da6 <fd2num>
  802fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802fce:	83 c4 04             	add    $0x4,%esp
  802fd1:	ff 75 f0             	pushl  -0x10(%ebp)
  802fd4:	e8 cd ed ff ff       	call   801da6 <fd2num>
  802fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fdc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802fdf:	83 c4 10             	add    $0x10,%esp
  802fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fe7:	eb 2e                	jmp    803017 <pipe+0x145>
	sys_page_unmap(0, va);
  802fe9:	83 ec 08             	sub    $0x8,%esp
  802fec:	56                   	push   %esi
  802fed:	6a 00                	push   $0x0
  802fef:	e8 99 e6 ff ff       	call   80168d <sys_page_unmap>
  802ff4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802ff7:	83 ec 08             	sub    $0x8,%esp
  802ffa:	ff 75 f0             	pushl  -0x10(%ebp)
  802ffd:	6a 00                	push   $0x0
  802fff:	e8 89 e6 ff ff       	call   80168d <sys_page_unmap>
  803004:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803007:	83 ec 08             	sub    $0x8,%esp
  80300a:	ff 75 f4             	pushl  -0xc(%ebp)
  80300d:	6a 00                	push   $0x0
  80300f:	e8 79 e6 ff ff       	call   80168d <sys_page_unmap>
  803014:	83 c4 10             	add    $0x10,%esp
}
  803017:	89 d8                	mov    %ebx,%eax
  803019:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80301c:	5b                   	pop    %ebx
  80301d:	5e                   	pop    %esi
  80301e:	5d                   	pop    %ebp
  80301f:	c3                   	ret    

00803020 <pipeisclosed>:
{
  803020:	f3 0f 1e fb          	endbr32 
  803024:	55                   	push   %ebp
  803025:	89 e5                	mov    %esp,%ebp
  803027:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80302a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80302d:	50                   	push   %eax
  80302e:	ff 75 08             	pushl  0x8(%ebp)
  803031:	e8 f9 ed ff ff       	call   801e2f <fd_lookup>
  803036:	83 c4 10             	add    $0x10,%esp
  803039:	85 c0                	test   %eax,%eax
  80303b:	78 18                	js     803055 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	ff 75 f4             	pushl  -0xc(%ebp)
  803043:	e8 72 ed ff ff       	call   801dba <fd2data>
  803048:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	e8 1f fd ff ff       	call   802d71 <_pipeisclosed>
  803052:	83 c4 10             	add    $0x10,%esp
}
  803055:	c9                   	leave  
  803056:	c3                   	ret    

00803057 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803057:	f3 0f 1e fb          	endbr32 
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
  80305e:	56                   	push   %esi
  80305f:	53                   	push   %ebx
  803060:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803063:	85 f6                	test   %esi,%esi
  803065:	74 13                	je     80307a <wait+0x23>
	e = &envs[ENVX(envid)];
  803067:	89 f3                	mov    %esi,%ebx
  803069:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80306f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803078:	eb 1b                	jmp    803095 <wait+0x3e>
	assert(envid != 0);
  80307a:	68 c9 3d 80 00       	push   $0x803dc9
  80307f:	68 4f 36 80 00       	push   $0x80364f
  803084:	6a 09                	push   $0x9
  803086:	68 d4 3d 80 00       	push   $0x803dd4
  80308b:	e8 de d9 ff ff       	call   800a6e <_panic>
		sys_yield();
  803090:	e8 7b e5 ff ff       	call   801610 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803095:	8b 43 48             	mov    0x48(%ebx),%eax
  803098:	39 f0                	cmp    %esi,%eax
  80309a:	75 07                	jne    8030a3 <wait+0x4c>
  80309c:	8b 43 54             	mov    0x54(%ebx),%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	75 ed                	jne    803090 <wait+0x39>
}
  8030a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a6:	5b                   	pop    %ebx
  8030a7:	5e                   	pop    %esi
  8030a8:	5d                   	pop    %ebp
  8030a9:	c3                   	ret    

008030aa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030aa:	f3 0f 1e fb          	endbr32 
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
  8030b1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030b4:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8030bb:	74 0a                	je     8030c7 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  8030c7:	a1 24 54 80 00       	mov    0x805424,%eax
  8030cc:	8b 40 48             	mov    0x48(%eax),%eax
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	6a 07                	push   $0x7
  8030d4:	68 00 f0 bf ee       	push   $0xeebff000
  8030d9:	50                   	push   %eax
  8030da:	e8 5c e5 ff ff       	call   80163b <sys_page_alloc>
		if (r!= 0)
  8030df:	83 c4 10             	add    $0x10,%esp
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	75 2f                	jne    803115 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8030e6:	a1 24 54 80 00       	mov    0x805424,%eax
  8030eb:	8b 40 48             	mov    0x48(%eax),%eax
  8030ee:	83 ec 08             	sub    $0x8,%esp
  8030f1:	68 27 31 80 00       	push   $0x803127
  8030f6:	50                   	push   %eax
  8030f7:	e8 06 e6 ff ff       	call   801702 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  8030fc:	83 c4 10             	add    $0x10,%esp
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 ba                	je     8030bd <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  803103:	50                   	push   %eax
  803104:	68 df 3d 80 00       	push   $0x803ddf
  803109:	6a 26                	push   $0x26
  80310b:	68 f7 3d 80 00       	push   $0x803df7
  803110:	e8 59 d9 ff ff       	call   800a6e <_panic>
			panic("set_pgfault_handler: %e", r);
  803115:	50                   	push   %eax
  803116:	68 df 3d 80 00       	push   $0x803ddf
  80311b:	6a 22                	push   $0x22
  80311d:	68 f7 3d 80 00       	push   $0x803df7
  803122:	e8 47 d9 ff ff       	call   800a6e <_panic>

00803127 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803127:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803128:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80312d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80312f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  803132:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  803136:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  803139:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  80313d:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  803141:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  803143:	83 c4 08             	add    $0x8,%esp
	popal
  803146:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  803147:	83 c4 04             	add    $0x4,%esp
	popfl
  80314a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80314b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80314c:	c3                   	ret    

0080314d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80314d:	f3 0f 1e fb          	endbr32 
  803151:	55                   	push   %ebp
  803152:	89 e5                	mov    %esp,%ebp
  803154:	56                   	push   %esi
  803155:	53                   	push   %ebx
  803156:	8b 75 08             	mov    0x8(%ebp),%esi
  803159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  80315f:	85 c0                	test   %eax,%eax
  803161:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803166:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  803169:	83 ec 0c             	sub    $0xc,%esp
  80316c:	50                   	push   %eax
  80316d:	e8 e0 e5 ff ff       	call   801752 <sys_ipc_recv>
	if (r < 0) {
  803172:	83 c4 10             	add    $0x10,%esp
  803175:	85 c0                	test   %eax,%eax
  803177:	78 2b                	js     8031a4 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  803179:	85 f6                	test   %esi,%esi
  80317b:	74 0a                	je     803187 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  80317d:	a1 24 54 80 00       	mov    0x805424,%eax
  803182:	8b 40 74             	mov    0x74(%eax),%eax
  803185:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  803187:	85 db                	test   %ebx,%ebx
  803189:	74 0a                	je     803195 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  80318b:	a1 24 54 80 00       	mov    0x805424,%eax
  803190:	8b 40 78             	mov    0x78(%eax),%eax
  803193:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  803195:	a1 24 54 80 00       	mov    0x805424,%eax
  80319a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80319d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031a0:	5b                   	pop    %ebx
  8031a1:	5e                   	pop    %esi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
		if (from_env_store) {
  8031a4:	85 f6                	test   %esi,%esi
  8031a6:	74 06                	je     8031ae <ipc_recv+0x61>
			*from_env_store = 0;
  8031a8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8031ae:	85 db                	test   %ebx,%ebx
  8031b0:	74 eb                	je     80319d <ipc_recv+0x50>
			*perm_store = 0;
  8031b2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8031b8:	eb e3                	jmp    80319d <ipc_recv+0x50>

008031ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8031ba:	f3 0f 1e fb          	endbr32 
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	57                   	push   %edi
  8031c2:	56                   	push   %esi
  8031c3:	53                   	push   %ebx
  8031c4:	83 ec 0c             	sub    $0xc,%esp
  8031c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8031ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8031cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  8031d0:	85 db                	test   %ebx,%ebx
  8031d2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8031d7:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8031da:	ff 75 14             	pushl  0x14(%ebp)
  8031dd:	53                   	push   %ebx
  8031de:	56                   	push   %esi
  8031df:	57                   	push   %edi
  8031e0:	e8 44 e5 ff ff       	call   801729 <sys_ipc_try_send>
  8031e5:	83 c4 10             	add    $0x10,%esp
  8031e8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031eb:	75 07                	jne    8031f4 <ipc_send+0x3a>
		sys_yield();
  8031ed:	e8 1e e4 ff ff       	call   801610 <sys_yield>
  8031f2:	eb e6                	jmp    8031da <ipc_send+0x20>
	}

	if (ret < 0) {
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	78 08                	js     803200 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  8031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5e                   	pop    %esi
  8031fd:	5f                   	pop    %edi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  803200:	50                   	push   %eax
  803201:	68 05 3e 80 00       	push   $0x803e05
  803206:	6a 48                	push   $0x48
  803208:	68 22 3e 80 00       	push   $0x803e22
  80320d:	e8 5c d8 ff ff       	call   800a6e <_panic>

00803212 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803212:	f3 0f 1e fb          	endbr32 
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803221:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803224:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80322a:	8b 52 50             	mov    0x50(%edx),%edx
  80322d:	39 ca                	cmp    %ecx,%edx
  80322f:	74 11                	je     803242 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  803231:	83 c0 01             	add    $0x1,%eax
  803234:	3d 00 04 00 00       	cmp    $0x400,%eax
  803239:	75 e6                	jne    803221 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80323b:	b8 00 00 00 00       	mov    $0x0,%eax
  803240:	eb 0b                	jmp    80324d <ipc_find_env+0x3b>
			return envs[i].env_id;
  803242:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803245:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80324a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80324d:	5d                   	pop    %ebp
  80324e:	c3                   	ret    

0080324f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80324f:	f3 0f 1e fb          	endbr32 
  803253:	55                   	push   %ebp
  803254:	89 e5                	mov    %esp,%ebp
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803259:	89 c2                	mov    %eax,%edx
  80325b:	c1 ea 16             	shr    $0x16,%edx
  80325e:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803265:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80326a:	f6 c1 01             	test   $0x1,%cl
  80326d:	74 1c                	je     80328b <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80326f:	c1 e8 0c             	shr    $0xc,%eax
  803272:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803279:	a8 01                	test   $0x1,%al
  80327b:	74 0e                	je     80328b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80327d:	c1 e8 0c             	shr    $0xc,%eax
  803280:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803287:	ef 
  803288:	0f b7 d2             	movzwl %dx,%edx
}
  80328b:	89 d0                	mov    %edx,%eax
  80328d:	5d                   	pop    %ebp
  80328e:	c3                   	ret    
  80328f:	90                   	nop

00803290 <__udivdi3>:
  803290:	f3 0f 1e fb          	endbr32 
  803294:	55                   	push   %ebp
  803295:	57                   	push   %edi
  803296:	56                   	push   %esi
  803297:	53                   	push   %ebx
  803298:	83 ec 1c             	sub    $0x1c,%esp
  80329b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80329f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8032a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8032ab:	85 d2                	test   %edx,%edx
  8032ad:	75 19                	jne    8032c8 <__udivdi3+0x38>
  8032af:	39 f3                	cmp    %esi,%ebx
  8032b1:	76 4d                	jbe    803300 <__udivdi3+0x70>
  8032b3:	31 ff                	xor    %edi,%edi
  8032b5:	89 e8                	mov    %ebp,%eax
  8032b7:	89 f2                	mov    %esi,%edx
  8032b9:	f7 f3                	div    %ebx
  8032bb:	89 fa                	mov    %edi,%edx
  8032bd:	83 c4 1c             	add    $0x1c,%esp
  8032c0:	5b                   	pop    %ebx
  8032c1:	5e                   	pop    %esi
  8032c2:	5f                   	pop    %edi
  8032c3:	5d                   	pop    %ebp
  8032c4:	c3                   	ret    
  8032c5:	8d 76 00             	lea    0x0(%esi),%esi
  8032c8:	39 f2                	cmp    %esi,%edx
  8032ca:	76 14                	jbe    8032e0 <__udivdi3+0x50>
  8032cc:	31 ff                	xor    %edi,%edi
  8032ce:	31 c0                	xor    %eax,%eax
  8032d0:	89 fa                	mov    %edi,%edx
  8032d2:	83 c4 1c             	add    $0x1c,%esp
  8032d5:	5b                   	pop    %ebx
  8032d6:	5e                   	pop    %esi
  8032d7:	5f                   	pop    %edi
  8032d8:	5d                   	pop    %ebp
  8032d9:	c3                   	ret    
  8032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032e0:	0f bd fa             	bsr    %edx,%edi
  8032e3:	83 f7 1f             	xor    $0x1f,%edi
  8032e6:	75 48                	jne    803330 <__udivdi3+0xa0>
  8032e8:	39 f2                	cmp    %esi,%edx
  8032ea:	72 06                	jb     8032f2 <__udivdi3+0x62>
  8032ec:	31 c0                	xor    %eax,%eax
  8032ee:	39 eb                	cmp    %ebp,%ebx
  8032f0:	77 de                	ja     8032d0 <__udivdi3+0x40>
  8032f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f7:	eb d7                	jmp    8032d0 <__udivdi3+0x40>
  8032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803300:	89 d9                	mov    %ebx,%ecx
  803302:	85 db                	test   %ebx,%ebx
  803304:	75 0b                	jne    803311 <__udivdi3+0x81>
  803306:	b8 01 00 00 00       	mov    $0x1,%eax
  80330b:	31 d2                	xor    %edx,%edx
  80330d:	f7 f3                	div    %ebx
  80330f:	89 c1                	mov    %eax,%ecx
  803311:	31 d2                	xor    %edx,%edx
  803313:	89 f0                	mov    %esi,%eax
  803315:	f7 f1                	div    %ecx
  803317:	89 c6                	mov    %eax,%esi
  803319:	89 e8                	mov    %ebp,%eax
  80331b:	89 f7                	mov    %esi,%edi
  80331d:	f7 f1                	div    %ecx
  80331f:	89 fa                	mov    %edi,%edx
  803321:	83 c4 1c             	add    $0x1c,%esp
  803324:	5b                   	pop    %ebx
  803325:	5e                   	pop    %esi
  803326:	5f                   	pop    %edi
  803327:	5d                   	pop    %ebp
  803328:	c3                   	ret    
  803329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803330:	89 f9                	mov    %edi,%ecx
  803332:	b8 20 00 00 00       	mov    $0x20,%eax
  803337:	29 f8                	sub    %edi,%eax
  803339:	d3 e2                	shl    %cl,%edx
  80333b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80333f:	89 c1                	mov    %eax,%ecx
  803341:	89 da                	mov    %ebx,%edx
  803343:	d3 ea                	shr    %cl,%edx
  803345:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803349:	09 d1                	or     %edx,%ecx
  80334b:	89 f2                	mov    %esi,%edx
  80334d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803351:	89 f9                	mov    %edi,%ecx
  803353:	d3 e3                	shl    %cl,%ebx
  803355:	89 c1                	mov    %eax,%ecx
  803357:	d3 ea                	shr    %cl,%edx
  803359:	89 f9                	mov    %edi,%ecx
  80335b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80335f:	89 eb                	mov    %ebp,%ebx
  803361:	d3 e6                	shl    %cl,%esi
  803363:	89 c1                	mov    %eax,%ecx
  803365:	d3 eb                	shr    %cl,%ebx
  803367:	09 de                	or     %ebx,%esi
  803369:	89 f0                	mov    %esi,%eax
  80336b:	f7 74 24 08          	divl   0x8(%esp)
  80336f:	89 d6                	mov    %edx,%esi
  803371:	89 c3                	mov    %eax,%ebx
  803373:	f7 64 24 0c          	mull   0xc(%esp)
  803377:	39 d6                	cmp    %edx,%esi
  803379:	72 15                	jb     803390 <__udivdi3+0x100>
  80337b:	89 f9                	mov    %edi,%ecx
  80337d:	d3 e5                	shl    %cl,%ebp
  80337f:	39 c5                	cmp    %eax,%ebp
  803381:	73 04                	jae    803387 <__udivdi3+0xf7>
  803383:	39 d6                	cmp    %edx,%esi
  803385:	74 09                	je     803390 <__udivdi3+0x100>
  803387:	89 d8                	mov    %ebx,%eax
  803389:	31 ff                	xor    %edi,%edi
  80338b:	e9 40 ff ff ff       	jmp    8032d0 <__udivdi3+0x40>
  803390:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 36 ff ff ff       	jmp    8032d0 <__udivdi3+0x40>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	66 90                	xchg   %ax,%ax
  80339e:	66 90                	xchg   %ax,%ax

008033a0 <__umoddi3>:
  8033a0:	f3 0f 1e fb          	endbr32 
  8033a4:	55                   	push   %ebp
  8033a5:	57                   	push   %edi
  8033a6:	56                   	push   %esi
  8033a7:	53                   	push   %ebx
  8033a8:	83 ec 1c             	sub    $0x1c,%esp
  8033ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8033b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8033b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	75 19                	jne    8033d8 <__umoddi3+0x38>
  8033bf:	39 df                	cmp    %ebx,%edi
  8033c1:	76 5d                	jbe    803420 <__umoddi3+0x80>
  8033c3:	89 f0                	mov    %esi,%eax
  8033c5:	89 da                	mov    %ebx,%edx
  8033c7:	f7 f7                	div    %edi
  8033c9:	89 d0                	mov    %edx,%eax
  8033cb:	31 d2                	xor    %edx,%edx
  8033cd:	83 c4 1c             	add    $0x1c,%esp
  8033d0:	5b                   	pop    %ebx
  8033d1:	5e                   	pop    %esi
  8033d2:	5f                   	pop    %edi
  8033d3:	5d                   	pop    %ebp
  8033d4:	c3                   	ret    
  8033d5:	8d 76 00             	lea    0x0(%esi),%esi
  8033d8:	89 f2                	mov    %esi,%edx
  8033da:	39 d8                	cmp    %ebx,%eax
  8033dc:	76 12                	jbe    8033f0 <__umoddi3+0x50>
  8033de:	89 f0                	mov    %esi,%eax
  8033e0:	89 da                	mov    %ebx,%edx
  8033e2:	83 c4 1c             	add    $0x1c,%esp
  8033e5:	5b                   	pop    %ebx
  8033e6:	5e                   	pop    %esi
  8033e7:	5f                   	pop    %edi
  8033e8:	5d                   	pop    %ebp
  8033e9:	c3                   	ret    
  8033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	75 50                	jne    803448 <__umoddi3+0xa8>
  8033f8:	39 d8                	cmp    %ebx,%eax
  8033fa:	0f 82 e0 00 00 00    	jb     8034e0 <__umoddi3+0x140>
  803400:	89 d9                	mov    %ebx,%ecx
  803402:	39 f7                	cmp    %esi,%edi
  803404:	0f 86 d6 00 00 00    	jbe    8034e0 <__umoddi3+0x140>
  80340a:	89 d0                	mov    %edx,%eax
  80340c:	89 ca                	mov    %ecx,%edx
  80340e:	83 c4 1c             	add    $0x1c,%esp
  803411:	5b                   	pop    %ebx
  803412:	5e                   	pop    %esi
  803413:	5f                   	pop    %edi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
  803416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80341d:	8d 76 00             	lea    0x0(%esi),%esi
  803420:	89 fd                	mov    %edi,%ebp
  803422:	85 ff                	test   %edi,%edi
  803424:	75 0b                	jne    803431 <__umoddi3+0x91>
  803426:	b8 01 00 00 00       	mov    $0x1,%eax
  80342b:	31 d2                	xor    %edx,%edx
  80342d:	f7 f7                	div    %edi
  80342f:	89 c5                	mov    %eax,%ebp
  803431:	89 d8                	mov    %ebx,%eax
  803433:	31 d2                	xor    %edx,%edx
  803435:	f7 f5                	div    %ebp
  803437:	89 f0                	mov    %esi,%eax
  803439:	f7 f5                	div    %ebp
  80343b:	89 d0                	mov    %edx,%eax
  80343d:	31 d2                	xor    %edx,%edx
  80343f:	eb 8c                	jmp    8033cd <__umoddi3+0x2d>
  803441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803448:	89 e9                	mov    %ebp,%ecx
  80344a:	ba 20 00 00 00       	mov    $0x20,%edx
  80344f:	29 ea                	sub    %ebp,%edx
  803451:	d3 e0                	shl    %cl,%eax
  803453:	89 44 24 08          	mov    %eax,0x8(%esp)
  803457:	89 d1                	mov    %edx,%ecx
  803459:	89 f8                	mov    %edi,%eax
  80345b:	d3 e8                	shr    %cl,%eax
  80345d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803461:	89 54 24 04          	mov    %edx,0x4(%esp)
  803465:	8b 54 24 04          	mov    0x4(%esp),%edx
  803469:	09 c1                	or     %eax,%ecx
  80346b:	89 d8                	mov    %ebx,%eax
  80346d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803471:	89 e9                	mov    %ebp,%ecx
  803473:	d3 e7                	shl    %cl,%edi
  803475:	89 d1                	mov    %edx,%ecx
  803477:	d3 e8                	shr    %cl,%eax
  803479:	89 e9                	mov    %ebp,%ecx
  80347b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80347f:	d3 e3                	shl    %cl,%ebx
  803481:	89 c7                	mov    %eax,%edi
  803483:	89 d1                	mov    %edx,%ecx
  803485:	89 f0                	mov    %esi,%eax
  803487:	d3 e8                	shr    %cl,%eax
  803489:	89 e9                	mov    %ebp,%ecx
  80348b:	89 fa                	mov    %edi,%edx
  80348d:	d3 e6                	shl    %cl,%esi
  80348f:	09 d8                	or     %ebx,%eax
  803491:	f7 74 24 08          	divl   0x8(%esp)
  803495:	89 d1                	mov    %edx,%ecx
  803497:	89 f3                	mov    %esi,%ebx
  803499:	f7 64 24 0c          	mull   0xc(%esp)
  80349d:	89 c6                	mov    %eax,%esi
  80349f:	89 d7                	mov    %edx,%edi
  8034a1:	39 d1                	cmp    %edx,%ecx
  8034a3:	72 06                	jb     8034ab <__umoddi3+0x10b>
  8034a5:	75 10                	jne    8034b7 <__umoddi3+0x117>
  8034a7:	39 c3                	cmp    %eax,%ebx
  8034a9:	73 0c                	jae    8034b7 <__umoddi3+0x117>
  8034ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8034af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8034b3:	89 d7                	mov    %edx,%edi
  8034b5:	89 c6                	mov    %eax,%esi
  8034b7:	89 ca                	mov    %ecx,%edx
  8034b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8034be:	29 f3                	sub    %esi,%ebx
  8034c0:	19 fa                	sbb    %edi,%edx
  8034c2:	89 d0                	mov    %edx,%eax
  8034c4:	d3 e0                	shl    %cl,%eax
  8034c6:	89 e9                	mov    %ebp,%ecx
  8034c8:	d3 eb                	shr    %cl,%ebx
  8034ca:	d3 ea                	shr    %cl,%edx
  8034cc:	09 d8                	or     %ebx,%eax
  8034ce:	83 c4 1c             	add    $0x1c,%esp
  8034d1:	5b                   	pop    %ebx
  8034d2:	5e                   	pop    %esi
  8034d3:	5f                   	pop    %edi
  8034d4:	5d                   	pop    %ebp
  8034d5:	c3                   	ret    
  8034d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034dd:	8d 76 00             	lea    0x0(%esi),%esi
  8034e0:	29 fe                	sub    %edi,%esi
  8034e2:	19 c3                	sbb    %eax,%ebx
  8034e4:	89 f2                	mov    %esi,%edx
  8034e6:	89 d9                	mov    %ebx,%ecx
  8034e8:	e9 1d ff ff ff       	jmp    80340a <__umoddi3+0x6a>
