
obj/user/ls.debug:     formato del fichero elf32-i386


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
  80002c:	e8 a9 02 00 00       	call   8002da <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  800042:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800049:	74 20                	je     80006b <ls1+0x38>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  80004b:	89 f0                	mov    %esi,%eax
  80004d:	3c 01                	cmp    $0x1,%al
  80004f:	19 c0                	sbb    %eax,%eax
  800051:	83 e0 c9             	and    $0xffffffc9,%eax
  800054:	83 c0 64             	add    $0x64,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	ff 75 10             	pushl  0x10(%ebp)
  80005e:	68 22 23 80 00       	push   $0x802322
  800063:	e8 ea 19 00 00       	call   801a52 <printf>
  800068:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  80006b:	85 db                	test   %ebx,%ebx
  80006d:	74 1c                	je     80008b <ls1+0x58>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006f:	b8 3f 28 80 00       	mov    $0x80283f,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800074:	80 3b 00             	cmpb   $0x0,(%ebx)
  800077:	75 4b                	jne    8000c4 <ls1+0x91>
		printf("%s%s", prefix, sep);
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 2b 23 80 00       	push   $0x80232b
  800083:	e8 ca 19 00 00       	call   801a52 <printf>
  800088:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	ff 75 14             	pushl  0x14(%ebp)
  800091:	68 d7 27 80 00       	push   $0x8027d7
  800096:	e8 b7 19 00 00       	call   801a52 <printf>
	if(flag['F'] && isdir)
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a5:	74 06                	je     8000ad <ls1+0x7a>
  8000a7:	89 f0                	mov    %esi,%eax
  8000a9:	84 c0                	test   %al,%al
  8000ab:	75 37                	jne    8000e4 <ls1+0xb1>
		printf("/");
	printf("\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 3e 28 80 00       	push   $0x80283e
  8000b5:	e8 98 19 00 00       	call   801a52 <printf>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	53                   	push   %ebx
  8000c8:	e8 87 08 00 00       	call   800954 <strlen>
  8000cd:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000d0:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d5:	b8 20 23 80 00       	mov    $0x802320,%eax
  8000da:	ba 3f 28 80 00       	mov    $0x80283f,%edx
  8000df:	0f 44 c2             	cmove  %edx,%eax
  8000e2:	eb 95                	jmp    800079 <ls1+0x46>
		printf("/");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 20 23 80 00       	push   $0x802320
  8000ec:	e8 61 19 00 00       	call   801a52 <printf>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	eb b7                	jmp    8000ad <ls1+0x7a>

008000f6 <lsdir>:
{
  8000f6:	f3 0f 1e fb          	endbr32 
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800106:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800109:	6a 00                	push   $0x0
  80010b:	57                   	push   %edi
  80010c:	e8 8a 17 00 00       	call   80189b <open>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	85 c0                	test   %eax,%eax
  800118:	78 4a                	js     800164 <lsdir+0x6e>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	68 00 01 00 00       	push   $0x100
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 23 13 00 00       	call   801452 <readn>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	3d 00 01 00 00       	cmp    $0x100,%eax
  800137:	75 41                	jne    80017a <lsdir+0x84>
		if (f.f_name[0])
  800139:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800140:	74 de                	je     800120 <lsdir+0x2a>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800142:	56                   	push   %esi
  800143:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800149:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800150:	0f 94 c0             	sete   %al
  800153:	0f b6 c0             	movzbl %al,%eax
  800156:	50                   	push   %eax
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	e8 d4 fe ff ff       	call   800033 <ls1>
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb bc                	jmp    800120 <lsdir+0x2a>
		panic("open %s: %e", path, fd);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	57                   	push   %edi
  800169:	68 30 23 80 00       	push   $0x802330
  80016e:	6a 1d                	push   $0x1d
  800170:	68 3c 23 80 00       	push   $0x80233c
  800175:	e8 cc 01 00 00       	call   800346 <_panic>
	if (n > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 0a                	jg     800188 <lsdir+0x92>
	if (n < 0)
  80017e:	78 1a                	js     80019a <lsdir+0xa4>
}
  800180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    
		panic("short read in directory %s", path);
  800188:	57                   	push   %edi
  800189:	68 46 23 80 00       	push   $0x802346
  80018e:	6a 22                	push   $0x22
  800190:	68 3c 23 80 00       	push   $0x80233c
  800195:	e8 ac 01 00 00       	call   800346 <_panic>
		panic("error reading directory %s: %e", path, n);
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	57                   	push   %edi
  80019f:	68 8c 23 80 00       	push   $0x80238c
  8001a4:	6a 24                	push   $0x24
  8001a6:	68 3c 23 80 00       	push   $0x80233c
  8001ab:	e8 96 01 00 00       	call   800346 <_panic>

008001b0 <ls>:
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001c1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001c7:	50                   	push   %eax
  8001c8:	53                   	push   %ebx
  8001c9:	e8 7d 14 00 00       	call   80164b <stat>
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 2c                	js     800201 <ls+0x51>
	if (st.st_isdir && !flag['d'])
  8001d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001d8:	85 c0                	test   %eax,%eax
  8001da:	74 09                	je     8001e5 <ls+0x35>
  8001dc:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001e3:	74 32                	je     800217 <ls+0x67>
		ls1(0, st.st_isdir, st.st_size, path);
  8001e5:	53                   	push   %ebx
  8001e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	0f 95 c0             	setne  %al
  8001ee:	0f b6 c0             	movzbl %al,%eax
  8001f1:	50                   	push   %eax
  8001f2:	6a 00                	push   $0x0
  8001f4:	e8 3a fe ff ff       	call   800033 <ls1>
  8001f9:	83 c4 10             	add    $0x10,%esp
}
  8001fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    
		panic("stat %s: %e", path, r);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	53                   	push   %ebx
  800206:	68 61 23 80 00       	push   $0x802361
  80020b:	6a 0f                	push   $0xf
  80020d:	68 3c 23 80 00       	push   $0x80233c
  800212:	e8 2f 01 00 00       	call   800346 <_panic>
		lsdir(path, prefix);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	ff 75 0c             	pushl  0xc(%ebp)
  80021d:	53                   	push   %ebx
  80021e:	e8 d3 fe ff ff       	call   8000f6 <lsdir>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb d4                	jmp    8001fc <ls+0x4c>

00800228 <usage>:

void
usage(void)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800232:	68 6d 23 80 00       	push   $0x80236d
  800237:	e8 16 18 00 00       	call   801a52 <printf>
	exit();
  80023c:	e8 e7 00 00 00       	call   800328 <exit>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <umain>:

void
umain(int argc, char **argv)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 14             	sub    $0x14,%esp
  800252:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800255:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	56                   	push   %esi
  80025a:	8d 45 08             	lea    0x8(%ebp),%eax
  80025d:	50                   	push   %eax
  80025e:	e8 f9 0c 00 00       	call   800f5c <argstart>
	while ((i = argnext(&args)) >= 0)
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800269:	eb 08                	jmp    800273 <umain+0x2d>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80026b:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800272:	01 
	while ((i = argnext(&args)) >= 0)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	53                   	push   %ebx
  800277:	e8 14 0d 00 00       	call   800f90 <argnext>
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	85 c0                	test   %eax,%eax
  800281:	78 16                	js     800299 <umain+0x53>
		switch (i) {
  800283:	89 c2                	mov    %eax,%edx
  800285:	83 e2 f7             	and    $0xfffffff7,%edx
  800288:	83 fa 64             	cmp    $0x64,%edx
  80028b:	74 de                	je     80026b <umain+0x25>
  80028d:	83 f8 46             	cmp    $0x46,%eax
  800290:	74 d9                	je     80026b <umain+0x25>
			break;
		default:
			usage();
  800292:	e8 91 ff ff ff       	call   800228 <usage>
  800297:	eb da                	jmp    800273 <umain+0x2d>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800299:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80029e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002a2:	75 2a                	jne    8002ce <umain+0x88>
		ls("/", "");
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	68 3f 28 80 00       	push   $0x80283f
  8002ac:	68 20 23 80 00       	push   $0x802320
  8002b1:	e8 fa fe ff ff       	call   8001b0 <ls>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	eb 18                	jmp    8002d3 <umain+0x8d>
			ls(argv[i], argv[i]);
  8002bb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	50                   	push   %eax
  8002c3:	e8 e8 fe ff ff       	call   8001b0 <ls>
		for (i = 1; i < argc; i++)
  8002c8:	83 c3 01             	add    $0x1,%ebx
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002d1:	7f e8                	jg     8002bb <umain+0x75>
	}
}
  8002d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002d6:	5b                   	pop    %ebx
  8002d7:	5e                   	pop    %esi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002da:	f3 0f 1e fb          	endbr32 
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8002e9:	e8 de 0a 00 00       	call   800dcc <sys_getenvid>
	if (id >= 0)
  8002ee:	85 c0                	test   %eax,%eax
  8002f0:	78 12                	js     800304 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  8002f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ff:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800304:	85 db                	test   %ebx,%ebx
  800306:	7e 07                	jle    80030f <libmain+0x35>
		binaryname = argv[0];
  800308:	8b 06                	mov    (%esi),%eax
  80030a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	e8 2d ff ff ff       	call   800246 <umain>

	// exit gracefully
	exit();
  800319:	e8 0a 00 00 00       	call   800328 <exit>
}
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800324:	5b                   	pop    %ebx
  800325:	5e                   	pop    %esi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    

00800328 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800328:	f3 0f 1e fb          	endbr32 
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800332:	e8 77 0f 00 00       	call   8012ae <close_all>
	sys_env_destroy(0);
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	6a 00                	push   $0x0
  80033c:	e8 65 0a 00 00       	call   800da6 <sys_env_destroy>
}
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800352:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800358:	e8 6f 0a 00 00       	call   800dcc <sys_getenvid>
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 08             	pushl  0x8(%ebp)
  800366:	56                   	push   %esi
  800367:	50                   	push   %eax
  800368:	68 b8 23 80 00       	push   $0x8023b8
  80036d:	e8 bb 00 00 00       	call   80042d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800372:	83 c4 18             	add    $0x18,%esp
  800375:	53                   	push   %ebx
  800376:	ff 75 10             	pushl  0x10(%ebp)
  800379:	e8 5a 00 00 00       	call   8003d8 <vcprintf>
	cprintf("\n");
  80037e:	c7 04 24 3e 28 80 00 	movl   $0x80283e,(%esp)
  800385:	e8 a3 00 00 00       	call   80042d <cprintf>
  80038a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038d:	cc                   	int3   
  80038e:	eb fd                	jmp    80038d <_panic+0x47>

00800390 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800390:	f3 0f 1e fb          	endbr32 
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	53                   	push   %ebx
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039e:	8b 13                	mov    (%ebx),%edx
  8003a0:	8d 42 01             	lea    0x1(%edx),%eax
  8003a3:	89 03                	mov    %eax,(%ebx)
  8003a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b1:	74 09                	je     8003bc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	68 ff 00 00 00       	push   $0xff
  8003c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 87 09 00 00       	call   800d54 <sys_cputs>
		b->idx = 0;
  8003cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	eb db                	jmp    8003b3 <putch+0x23>

008003d8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d8:	f3 0f 1e fb          	endbr32 
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ec:	00 00 00 
	b.cnt = 0;
  8003ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	68 90 03 80 00       	push   $0x800390
  80040b:	e8 80 01 00 00       	call   800590 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800410:	83 c4 08             	add    $0x8,%esp
  800413:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800419:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041f:	50                   	push   %eax
  800420:	e8 2f 09 00 00       	call   800d54 <sys_cputs>

	return b.cnt;
}
  800425:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042d:	f3 0f 1e fb          	endbr32 
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800437:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043a:	50                   	push   %eax
  80043b:	ff 75 08             	pushl  0x8(%ebp)
  80043e:	e8 95 ff ff ff       	call   8003d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	57                   	push   %edi
  800449:	56                   	push   %esi
  80044a:	53                   	push   %ebx
  80044b:	83 ec 1c             	sub    $0x1c,%esp
  80044e:	89 c7                	mov    %eax,%edi
  800450:	89 d6                	mov    %edx,%esi
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 55 0c             	mov    0xc(%ebp),%edx
  800458:	89 d1                	mov    %edx,%ecx
  80045a:	89 c2                	mov    %eax,%edx
  80045c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800462:	8b 45 10             	mov    0x10(%ebp),%eax
  800465:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800472:	39 c2                	cmp    %eax,%edx
  800474:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800477:	72 3e                	jb     8004b7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	ff 75 18             	pushl  0x18(%ebp)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	53                   	push   %ebx
  800483:	50                   	push   %eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048a:	ff 75 e0             	pushl  -0x20(%ebp)
  80048d:	ff 75 dc             	pushl  -0x24(%ebp)
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 18 1c 00 00       	call   8020b0 <__udivdi3>
  800498:	83 c4 18             	add    $0x18,%esp
  80049b:	52                   	push   %edx
  80049c:	50                   	push   %eax
  80049d:	89 f2                	mov    %esi,%edx
  80049f:	89 f8                	mov    %edi,%eax
  8004a1:	e8 9f ff ff ff       	call   800445 <printnum>
  8004a6:	83 c4 20             	add    $0x20,%esp
  8004a9:	eb 13                	jmp    8004be <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	56                   	push   %esi
  8004af:	ff 75 18             	pushl  0x18(%ebp)
  8004b2:	ff d7                	call   *%edi
  8004b4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b7:	83 eb 01             	sub    $0x1,%ebx
  8004ba:	85 db                	test   %ebx,%ebx
  8004bc:	7f ed                	jg     8004ab <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	56                   	push   %esi
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d1:	e8 ea 1c 00 00       	call   8021c0 <__umoddi3>
  8004d6:	83 c4 14             	add    $0x14,%esp
  8004d9:	0f be 80 db 23 80 00 	movsbl 0x8023db(%eax),%eax
  8004e0:	50                   	push   %eax
  8004e1:	ff d7                	call   *%edi
}
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e9:	5b                   	pop    %ebx
  8004ea:	5e                   	pop    %esi
  8004eb:	5f                   	pop    %edi
  8004ec:	5d                   	pop    %ebp
  8004ed:	c3                   	ret    

008004ee <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8004ee:	83 fa 01             	cmp    $0x1,%edx
  8004f1:	7f 13                	jg     800506 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8004f3:	85 d2                	test   %edx,%edx
  8004f5:	74 1c                	je     800513 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  8004f7:	8b 10                	mov    (%eax),%edx
  8004f9:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004fc:	89 08                	mov    %ecx,(%eax)
  8004fe:	8b 02                	mov    (%edx),%eax
  800500:	ba 00 00 00 00       	mov    $0x0,%edx
  800505:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800506:	8b 10                	mov    (%eax),%edx
  800508:	8d 4a 08             	lea    0x8(%edx),%ecx
  80050b:	89 08                	mov    %ecx,(%eax)
  80050d:	8b 02                	mov    (%edx),%eax
  80050f:	8b 52 04             	mov    0x4(%edx),%edx
  800512:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800513:	8b 10                	mov    (%eax),%edx
  800515:	8d 4a 04             	lea    0x4(%edx),%ecx
  800518:	89 08                	mov    %ecx,(%eax)
  80051a:	8b 02                	mov    (%edx),%eax
  80051c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800521:	c3                   	ret    

00800522 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800522:	83 fa 01             	cmp    $0x1,%edx
  800525:	7f 0f                	jg     800536 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800527:	85 d2                	test   %edx,%edx
  800529:	74 18                	je     800543 <getint+0x21>
		return va_arg(*ap, long);
  80052b:	8b 10                	mov    (%eax),%edx
  80052d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800530:	89 08                	mov    %ecx,(%eax)
  800532:	8b 02                	mov    (%edx),%eax
  800534:	99                   	cltd   
  800535:	c3                   	ret    
		return va_arg(*ap, long long);
  800536:	8b 10                	mov    (%eax),%edx
  800538:	8d 4a 08             	lea    0x8(%edx),%ecx
  80053b:	89 08                	mov    %ecx,(%eax)
  80053d:	8b 02                	mov    (%edx),%eax
  80053f:	8b 52 04             	mov    0x4(%edx),%edx
  800542:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800543:	8b 10                	mov    (%eax),%edx
  800545:	8d 4a 04             	lea    0x4(%edx),%ecx
  800548:	89 08                	mov    %ecx,(%eax)
  80054a:	8b 02                	mov    (%edx),%eax
  80054c:	99                   	cltd   
}
  80054d:	c3                   	ret    

0080054e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80054e:	f3 0f 1e fb          	endbr32 
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800558:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80055c:	8b 10                	mov    (%eax),%edx
  80055e:	3b 50 04             	cmp    0x4(%eax),%edx
  800561:	73 0a                	jae    80056d <sprintputch+0x1f>
		*b->buf++ = ch;
  800563:	8d 4a 01             	lea    0x1(%edx),%ecx
  800566:	89 08                	mov    %ecx,(%eax)
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	88 02                	mov    %al,(%edx)
}
  80056d:	5d                   	pop    %ebp
  80056e:	c3                   	ret    

0080056f <printfmt>:
{
  80056f:	f3 0f 1e fb          	endbr32 
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800579:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80057c:	50                   	push   %eax
  80057d:	ff 75 10             	pushl  0x10(%ebp)
  800580:	ff 75 0c             	pushl  0xc(%ebp)
  800583:	ff 75 08             	pushl  0x8(%ebp)
  800586:	e8 05 00 00 00       	call   800590 <vprintfmt>
}
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <vprintfmt>:
{
  800590:	f3 0f 1e fb          	endbr32 
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 2c             	sub    $0x2c,%esp
  80059d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005a6:	e9 86 02 00 00       	jmp    800831 <vprintfmt+0x2a1>
		padc = ' ';
  8005ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005c9:	8d 47 01             	lea    0x1(%edi),%eax
  8005cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cf:	0f b6 17             	movzbl (%edi),%edx
  8005d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005d5:	3c 55                	cmp    $0x55,%al
  8005d7:	0f 87 df 02 00 00    	ja     8008bc <vprintfmt+0x32c>
  8005dd:	0f b6 c0             	movzbl %al,%eax
  8005e0:	3e ff 24 85 20 25 80 	notrack jmp *0x802520(,%eax,4)
  8005e7:	00 
  8005e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8005ef:	eb d8                	jmp    8005c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8005f8:	eb cf                	jmp    8005c9 <vprintfmt+0x39>
  8005fa:	0f b6 d2             	movzbl %dl,%edx
  8005fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800600:	b8 00 00 00 00       	mov    $0x0,%eax
  800605:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800608:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80060b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80060f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800612:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800615:	83 f9 09             	cmp    $0x9,%ecx
  800618:	77 52                	ja     80066c <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80061a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80061d:	eb e9                	jmp    800608 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 50 04             	lea    0x4(%eax),%edx
  800625:	89 55 14             	mov    %edx,0x14(%ebp)
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80062d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800630:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800634:	79 93                	jns    8005c9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800636:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800639:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800643:	eb 84                	jmp    8005c9 <vprintfmt+0x39>
  800645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800648:	85 c0                	test   %eax,%eax
  80064a:	ba 00 00 00 00       	mov    $0x0,%edx
  80064f:	0f 49 d0             	cmovns %eax,%edx
  800652:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800658:	e9 6c ff ff ff       	jmp    8005c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80065d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800660:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800667:	e9 5d ff ff ff       	jmp    8005c9 <vprintfmt+0x39>
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800672:	eb bc                	jmp    800630 <vprintfmt+0xa0>
			lflag++;
  800674:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800677:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80067a:	e9 4a ff ff ff       	jmp    8005c9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	56                   	push   %esi
  80068c:	ff 30                	pushl  (%eax)
  80068e:	ff d3                	call   *%ebx
			break;
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	e9 96 01 00 00       	jmp    80082e <vprintfmt+0x29e>
			err = va_arg(ap, int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 50 04             	lea    0x4(%eax),%edx
  80069e:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	99                   	cltd   
  8006a4:	31 d0                	xor    %edx,%eax
  8006a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006a8:	83 f8 0f             	cmp    $0xf,%eax
  8006ab:	7f 20                	jg     8006cd <vprintfmt+0x13d>
  8006ad:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  8006b4:	85 d2                	test   %edx,%edx
  8006b6:	74 15                	je     8006cd <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8006b8:	52                   	push   %edx
  8006b9:	68 d7 27 80 00       	push   $0x8027d7
  8006be:	56                   	push   %esi
  8006bf:	53                   	push   %ebx
  8006c0:	e8 aa fe ff ff       	call   80056f <printfmt>
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	e9 61 01 00 00       	jmp    80082e <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8006cd:	50                   	push   %eax
  8006ce:	68 f3 23 80 00       	push   $0x8023f3
  8006d3:	56                   	push   %esi
  8006d4:	53                   	push   %ebx
  8006d5:	e8 95 fe ff ff       	call   80056f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	e9 4c 01 00 00       	jmp    80082e <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006eb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006ed:	85 c9                	test   %ecx,%ecx
  8006ef:	b8 ec 23 80 00       	mov    $0x8023ec,%eax
  8006f4:	0f 45 c1             	cmovne %ecx,%eax
  8006f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8006fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fe:	7e 06                	jle    800706 <vprintfmt+0x176>
  800700:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800704:	75 0d                	jne    800713 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800706:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800709:	89 c7                	mov    %eax,%edi
  80070b:	03 45 e0             	add    -0x20(%ebp),%eax
  80070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800711:	eb 57                	jmp    80076a <vprintfmt+0x1da>
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 d8             	pushl  -0x28(%ebp)
  800719:	ff 75 cc             	pushl  -0x34(%ebp)
  80071c:	e8 4f 02 00 00       	call   800970 <strnlen>
  800721:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800724:	29 c2                	sub    %eax,%edx
  800726:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800729:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80072c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800730:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800733:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800735:	85 db                	test   %ebx,%ebx
  800737:	7e 10                	jle    800749 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	56                   	push   %esi
  80073d:	57                   	push   %edi
  80073e:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800741:	83 eb 01             	sub    $0x1,%ebx
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	eb ec                	jmp    800735 <vprintfmt+0x1a5>
  800749:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80074c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80074f:	85 d2                	test   %edx,%edx
  800751:	b8 00 00 00 00       	mov    $0x0,%eax
  800756:	0f 49 c2             	cmovns %edx,%eax
  800759:	29 c2                	sub    %eax,%edx
  80075b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80075e:	eb a6                	jmp    800706 <vprintfmt+0x176>
					putch(ch, putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	56                   	push   %esi
  800764:	52                   	push   %edx
  800765:	ff d3                	call   *%ebx
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80076d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076f:	83 c7 01             	add    $0x1,%edi
  800772:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800776:	0f be d0             	movsbl %al,%edx
  800779:	85 d2                	test   %edx,%edx
  80077b:	74 42                	je     8007bf <vprintfmt+0x22f>
  80077d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800781:	78 06                	js     800789 <vprintfmt+0x1f9>
  800783:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800787:	78 1e                	js     8007a7 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800789:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078d:	74 d1                	je     800760 <vprintfmt+0x1d0>
  80078f:	0f be c0             	movsbl %al,%eax
  800792:	83 e8 20             	sub    $0x20,%eax
  800795:	83 f8 5e             	cmp    $0x5e,%eax
  800798:	76 c6                	jbe    800760 <vprintfmt+0x1d0>
					putch('?', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	56                   	push   %esi
  80079e:	6a 3f                	push   $0x3f
  8007a0:	ff d3                	call   *%ebx
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	eb c3                	jmp    80076a <vprintfmt+0x1da>
  8007a7:	89 cf                	mov    %ecx,%edi
  8007a9:	eb 0e                	jmp    8007b9 <vprintfmt+0x229>
				putch(' ', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	56                   	push   %esi
  8007af:	6a 20                	push   $0x20
  8007b1:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8007b3:	83 ef 01             	sub    $0x1,%edi
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	85 ff                	test   %edi,%edi
  8007bb:	7f ee                	jg     8007ab <vprintfmt+0x21b>
  8007bd:	eb 6f                	jmp    80082e <vprintfmt+0x29e>
  8007bf:	89 cf                	mov    %ecx,%edi
  8007c1:	eb f6                	jmp    8007b9 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8007c3:	89 ca                	mov    %ecx,%edx
  8007c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c8:	e8 55 fd ff ff       	call   800522 <getint>
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	78 0b                	js     8007e2 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  8007d7:	89 d1                	mov    %edx,%ecx
  8007d9:	89 c2                	mov    %eax,%edx
			base = 10;
  8007db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e0:	eb 32                	jmp    800814 <vprintfmt+0x284>
				putch('-', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	56                   	push   %esi
  8007e6:	6a 2d                	push   $0x2d
  8007e8:	ff d3                	call   *%ebx
				num = -(long long) num;
  8007ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ed:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007f0:	f7 da                	neg    %edx
  8007f2:	83 d1 00             	adc    $0x0,%ecx
  8007f5:	f7 d9                	neg    %ecx
  8007f7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ff:	eb 13                	jmp    800814 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800801:	89 ca                	mov    %ecx,%edx
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	e8 e3 fc ff ff       	call   8004ee <getuint>
  80080b:	89 d1                	mov    %edx,%ecx
  80080d:	89 c2                	mov    %eax,%edx
			base = 10;
  80080f:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800814:	83 ec 0c             	sub    $0xc,%esp
  800817:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80081b:	57                   	push   %edi
  80081c:	ff 75 e0             	pushl  -0x20(%ebp)
  80081f:	50                   	push   %eax
  800820:	51                   	push   %ecx
  800821:	52                   	push   %edx
  800822:	89 f2                	mov    %esi,%edx
  800824:	89 d8                	mov    %ebx,%eax
  800826:	e8 1a fc ff ff       	call   800445 <printnum>
			break;
  80082b:	83 c4 20             	add    $0x20,%esp
{
  80082e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800831:	83 c7 01             	add    $0x1,%edi
  800834:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800838:	83 f8 25             	cmp    $0x25,%eax
  80083b:	0f 84 6a fd ff ff    	je     8005ab <vprintfmt+0x1b>
			if (ch == '\0')
  800841:	85 c0                	test   %eax,%eax
  800843:	0f 84 93 00 00 00    	je     8008dc <vprintfmt+0x34c>
			putch(ch, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	56                   	push   %esi
  80084d:	50                   	push   %eax
  80084e:	ff d3                	call   *%ebx
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	eb dc                	jmp    800831 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800855:	89 ca                	mov    %ecx,%edx
  800857:	8d 45 14             	lea    0x14(%ebp),%eax
  80085a:	e8 8f fc ff ff       	call   8004ee <getuint>
  80085f:	89 d1                	mov    %edx,%ecx
  800861:	89 c2                	mov    %eax,%edx
			base = 8;
  800863:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800868:	eb aa                	jmp    800814 <vprintfmt+0x284>
			putch('0', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	56                   	push   %esi
  80086e:	6a 30                	push   $0x30
  800870:	ff d3                	call   *%ebx
			putch('x', putdat);
  800872:	83 c4 08             	add    $0x8,%esp
  800875:	56                   	push   %esi
  800876:	6a 78                	push   $0x78
  800878:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 50 04             	lea    0x4(%eax),%edx
  800880:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800883:	8b 10                	mov    (%eax),%edx
  800885:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80088a:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80088d:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800892:	eb 80                	jmp    800814 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800894:	89 ca                	mov    %ecx,%edx
  800896:	8d 45 14             	lea    0x14(%ebp),%eax
  800899:	e8 50 fc ff ff       	call   8004ee <getuint>
  80089e:	89 d1                	mov    %edx,%ecx
  8008a0:	89 c2                	mov    %eax,%edx
			base = 16;
  8008a2:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a7:	e9 68 ff ff ff       	jmp    800814 <vprintfmt+0x284>
			putch(ch, putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	56                   	push   %esi
  8008b0:	6a 25                	push   $0x25
  8008b2:	ff d3                	call   *%ebx
			break;
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	e9 72 ff ff ff       	jmp    80082e <vprintfmt+0x29e>
			putch('%', putdat);
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	56                   	push   %esi
  8008c0:	6a 25                	push   $0x25
  8008c2:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	89 f8                	mov    %edi,%eax
  8008c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008cd:	74 05                	je     8008d4 <vprintfmt+0x344>
  8008cf:	83 e8 01             	sub    $0x1,%eax
  8008d2:	eb f5                	jmp    8008c9 <vprintfmt+0x339>
  8008d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d7:	e9 52 ff ff ff       	jmp    80082e <vprintfmt+0x29e>
}
  8008dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5e                   	pop    %esi
  8008e1:	5f                   	pop    %edi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 18             	sub    $0x18,%esp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800905:	85 c0                	test   %eax,%eax
  800907:	74 26                	je     80092f <vsnprintf+0x4b>
  800909:	85 d2                	test   %edx,%edx
  80090b:	7e 22                	jle    80092f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090d:	ff 75 14             	pushl  0x14(%ebp)
  800910:	ff 75 10             	pushl  0x10(%ebp)
  800913:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800916:	50                   	push   %eax
  800917:	68 4e 05 80 00       	push   $0x80054e
  80091c:	e8 6f fc ff ff       	call   800590 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800924:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	83 c4 10             	add    $0x10,%esp
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    
		return -E_INVAL;
  80092f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800934:	eb f7                	jmp    80092d <vsnprintf+0x49>

00800936 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800936:	f3 0f 1e fb          	endbr32 
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800943:	50                   	push   %eax
  800944:	ff 75 10             	pushl  0x10(%ebp)
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	e8 92 ff ff ff       	call   8008e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800954:	f3 0f 1e fb          	endbr32 
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800967:	74 05                	je     80096e <strlen+0x1a>
		n++;
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	eb f5                	jmp    800963 <strlen+0xf>
	return n;
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800970:	f3 0f 1e fb          	endbr32 
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	39 d0                	cmp    %edx,%eax
  800984:	74 0d                	je     800993 <strnlen+0x23>
  800986:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80098a:	74 05                	je     800991 <strnlen+0x21>
		n++;
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	eb f1                	jmp    800982 <strnlen+0x12>
  800991:	89 c2                	mov    %eax,%edx
	return n;
}
  800993:	89 d0                	mov    %edx,%eax
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800997:	f3 0f 1e fb          	endbr32 
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009b1:	83 c0 01             	add    $0x1,%eax
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	75 f2                	jne    8009aa <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8009b8:	89 c8                	mov    %ecx,%eax
  8009ba:	5b                   	pop    %ebx
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bd:	f3 0f 1e fb          	endbr32 
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	53                   	push   %ebx
  8009c5:	83 ec 10             	sub    $0x10,%esp
  8009c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009cb:	53                   	push   %ebx
  8009cc:	e8 83 ff ff ff       	call   800954 <strlen>
  8009d1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	01 d8                	add    %ebx,%eax
  8009d9:	50                   	push   %eax
  8009da:	e8 b8 ff ff ff       	call   800997 <strcpy>
	return dst;
}
  8009df:	89 d8                	mov    %ebx,%eax
  8009e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	56                   	push   %esi
  8009ee:	53                   	push   %ebx
  8009ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f5:	89 f3                	mov    %esi,%ebx
  8009f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fa:	89 f0                	mov    %esi,%eax
  8009fc:	39 d8                	cmp    %ebx,%eax
  8009fe:	74 11                	je     800a11 <strncpy+0x2b>
		*dst++ = *src;
  800a00:	83 c0 01             	add    $0x1,%eax
  800a03:	0f b6 0a             	movzbl (%edx),%ecx
  800a06:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a09:	80 f9 01             	cmp    $0x1,%cl
  800a0c:	83 da ff             	sbb    $0xffffffff,%edx
  800a0f:	eb eb                	jmp    8009fc <strncpy+0x16>
	}
	return ret;
}
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a17:	f3 0f 1e fb          	endbr32 
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 75 08             	mov    0x8(%ebp),%esi
  800a23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a26:	8b 55 10             	mov    0x10(%ebp),%edx
  800a29:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2b:	85 d2                	test   %edx,%edx
  800a2d:	74 21                	je     800a50 <strlcpy+0x39>
  800a2f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a33:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	74 14                	je     800a4d <strlcpy+0x36>
  800a39:	0f b6 19             	movzbl (%ecx),%ebx
  800a3c:	84 db                	test   %bl,%bl
  800a3e:	74 0b                	je     800a4b <strlcpy+0x34>
			*dst++ = *src++;
  800a40:	83 c1 01             	add    $0x1,%ecx
  800a43:	83 c2 01             	add    $0x1,%edx
  800a46:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a49:	eb ea                	jmp    800a35 <strlcpy+0x1e>
  800a4b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a50:	29 f0                	sub    %esi,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a56:	f3 0f 1e fb          	endbr32 
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a63:	0f b6 01             	movzbl (%ecx),%eax
  800a66:	84 c0                	test   %al,%al
  800a68:	74 0c                	je     800a76 <strcmp+0x20>
  800a6a:	3a 02                	cmp    (%edx),%al
  800a6c:	75 08                	jne    800a76 <strcmp+0x20>
		p++, q++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ed                	jmp    800a63 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a76:	0f b6 c0             	movzbl %al,%eax
  800a79:	0f b6 12             	movzbl (%edx),%edx
  800a7c:	29 d0                	sub    %edx,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	53                   	push   %ebx
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 c3                	mov    %eax,%ebx
  800a90:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a93:	eb 06                	jmp    800a9b <strncmp+0x1b>
		n--, p++, q++;
  800a95:	83 c0 01             	add    $0x1,%eax
  800a98:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a9b:	39 d8                	cmp    %ebx,%eax
  800a9d:	74 16                	je     800ab5 <strncmp+0x35>
  800a9f:	0f b6 08             	movzbl (%eax),%ecx
  800aa2:	84 c9                	test   %cl,%cl
  800aa4:	74 04                	je     800aaa <strncmp+0x2a>
  800aa6:	3a 0a                	cmp    (%edx),%cl
  800aa8:	74 eb                	je     800a95 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aaa:	0f b6 00             	movzbl (%eax),%eax
  800aad:	0f b6 12             	movzbl (%edx),%edx
  800ab0:	29 d0                	sub    %edx,%eax
}
  800ab2:	5b                   	pop    %ebx
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    
		return 0;
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	eb f6                	jmp    800ab2 <strncmp+0x32>

00800abc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800abc:	f3 0f 1e fb          	endbr32 
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aca:	0f b6 10             	movzbl (%eax),%edx
  800acd:	84 d2                	test   %dl,%dl
  800acf:	74 09                	je     800ada <strchr+0x1e>
		if (*s == c)
  800ad1:	38 ca                	cmp    %cl,%dl
  800ad3:	74 0a                	je     800adf <strchr+0x23>
	for (; *s; s++)
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	eb f0                	jmp    800aca <strchr+0xe>
			return (char *) s;
	return 0;
  800ada:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae1:	f3 0f 1e fb          	endbr32 
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af2:	38 ca                	cmp    %cl,%dl
  800af4:	74 09                	je     800aff <strfind+0x1e>
  800af6:	84 d2                	test   %dl,%dl
  800af8:	74 05                	je     800aff <strfind+0x1e>
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	eb f0                	jmp    800aef <strfind+0xe>
			break;
	return (char *) s;
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800b11:	85 c9                	test   %ecx,%ecx
  800b13:	74 33                	je     800b48 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	09 c8                	or     %ecx,%eax
  800b19:	a8 03                	test   $0x3,%al
  800b1b:	75 23                	jne    800b40 <memset+0x3f>
		c &= 0xFF;
  800b1d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b21:	89 d8                	mov    %ebx,%eax
  800b23:	c1 e0 08             	shl    $0x8,%eax
  800b26:	89 df                	mov    %ebx,%edi
  800b28:	c1 e7 18             	shl    $0x18,%edi
  800b2b:	89 de                	mov    %ebx,%esi
  800b2d:	c1 e6 10             	shl    $0x10,%esi
  800b30:	09 f7                	or     %esi,%edi
  800b32:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800b34:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b37:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800b39:	89 d7                	mov    %edx,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 ab                	rep stos %eax,%es:(%edi)
  800b3e:	eb 08                	jmp    800b48 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b40:	89 d7                	mov    %edx,%edi
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	fc                   	cld    
  800b46:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800b48:	89 d0                	mov    %edx,%eax
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4f:	f3 0f 1e fb          	endbr32 
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b61:	39 c6                	cmp    %eax,%esi
  800b63:	73 32                	jae    800b97 <memmove+0x48>
  800b65:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b68:	39 c2                	cmp    %eax,%edx
  800b6a:	76 2b                	jbe    800b97 <memmove+0x48>
		s += n;
		d += n;
  800b6c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	89 fe                	mov    %edi,%esi
  800b71:	09 ce                	or     %ecx,%esi
  800b73:	09 d6                	or     %edx,%esi
  800b75:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7b:	75 0e                	jne    800b8b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b7d:	83 ef 04             	sub    $0x4,%edi
  800b80:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b86:	fd                   	std    
  800b87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b89:	eb 09                	jmp    800b94 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b8b:	83 ef 01             	sub    $0x1,%edi
  800b8e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b91:	fd                   	std    
  800b92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b94:	fc                   	cld    
  800b95:	eb 1a                	jmp    800bb1 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	09 ca                	or     %ecx,%edx
  800b9b:	09 f2                	or     %esi,%edx
  800b9d:	f6 c2 03             	test   $0x3,%dl
  800ba0:	75 0a                	jne    800bac <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800baa:	eb 05                	jmp    800bb1 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800bac:	89 c7                	mov    %eax,%edi
  800bae:	fc                   	cld    
  800baf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbf:	ff 75 10             	pushl  0x10(%ebp)
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	ff 75 08             	pushl  0x8(%ebp)
  800bc8:	e8 82 ff ff ff       	call   800b4f <memmove>
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcf:	f3 0f 1e fb          	endbr32 
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bde:	89 c6                	mov    %eax,%esi
  800be0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be3:	39 f0                	cmp    %esi,%eax
  800be5:	74 1c                	je     800c03 <memcmp+0x34>
		if (*s1 != *s2)
  800be7:	0f b6 08             	movzbl (%eax),%ecx
  800bea:	0f b6 1a             	movzbl (%edx),%ebx
  800bed:	38 d9                	cmp    %bl,%cl
  800bef:	75 08                	jne    800bf9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bf1:	83 c0 01             	add    $0x1,%eax
  800bf4:	83 c2 01             	add    $0x1,%edx
  800bf7:	eb ea                	jmp    800be3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bf9:	0f b6 c1             	movzbl %cl,%eax
  800bfc:	0f b6 db             	movzbl %bl,%ebx
  800bff:	29 d8                	sub    %ebx,%eax
  800c01:	eb 05                	jmp    800c08 <memcmp+0x39>
	}

	return 0;
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c0c:	f3 0f 1e fb          	endbr32 
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c19:	89 c2                	mov    %eax,%edx
  800c1b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c1e:	39 d0                	cmp    %edx,%eax
  800c20:	73 09                	jae    800c2b <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c22:	38 08                	cmp    %cl,(%eax)
  800c24:	74 05                	je     800c2b <memfind+0x1f>
	for (; s < ends; s++)
  800c26:	83 c0 01             	add    $0x1,%eax
  800c29:	eb f3                	jmp    800c1e <memfind+0x12>
			break;
	return (void *) s;
}
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3d:	eb 03                	jmp    800c42 <strtol+0x15>
		s++;
  800c3f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c42:	0f b6 01             	movzbl (%ecx),%eax
  800c45:	3c 20                	cmp    $0x20,%al
  800c47:	74 f6                	je     800c3f <strtol+0x12>
  800c49:	3c 09                	cmp    $0x9,%al
  800c4b:	74 f2                	je     800c3f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c4d:	3c 2b                	cmp    $0x2b,%al
  800c4f:	74 2a                	je     800c7b <strtol+0x4e>
	int neg = 0;
  800c51:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c56:	3c 2d                	cmp    $0x2d,%al
  800c58:	74 2b                	je     800c85 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c60:	75 0f                	jne    800c71 <strtol+0x44>
  800c62:	80 39 30             	cmpb   $0x30,(%ecx)
  800c65:	74 28                	je     800c8f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c67:	85 db                	test   %ebx,%ebx
  800c69:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6e:	0f 44 d8             	cmove  %eax,%ebx
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c79:	eb 46                	jmp    800cc1 <strtol+0x94>
		s++;
  800c7b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c83:	eb d5                	jmp    800c5a <strtol+0x2d>
		s++, neg = 1;
  800c85:	83 c1 01             	add    $0x1,%ecx
  800c88:	bf 01 00 00 00       	mov    $0x1,%edi
  800c8d:	eb cb                	jmp    800c5a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c93:	74 0e                	je     800ca3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c95:	85 db                	test   %ebx,%ebx
  800c97:	75 d8                	jne    800c71 <strtol+0x44>
		s++, base = 8;
  800c99:	83 c1 01             	add    $0x1,%ecx
  800c9c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca1:	eb ce                	jmp    800c71 <strtol+0x44>
		s += 2, base = 16;
  800ca3:	83 c1 02             	add    $0x2,%ecx
  800ca6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cab:	eb c4                	jmp    800c71 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800cad:	0f be d2             	movsbl %dl,%edx
  800cb0:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cb3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cb6:	7d 3a                	jge    800cf2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cb8:	83 c1 01             	add    $0x1,%ecx
  800cbb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cbf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cc1:	0f b6 11             	movzbl (%ecx),%edx
  800cc4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc7:	89 f3                	mov    %esi,%ebx
  800cc9:	80 fb 09             	cmp    $0x9,%bl
  800ccc:	76 df                	jbe    800cad <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800cce:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cd1:	89 f3                	mov    %esi,%ebx
  800cd3:	80 fb 19             	cmp    $0x19,%bl
  800cd6:	77 08                	ja     800ce0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd8:	0f be d2             	movsbl %dl,%edx
  800cdb:	83 ea 57             	sub    $0x57,%edx
  800cde:	eb d3                	jmp    800cb3 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ce0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce3:	89 f3                	mov    %esi,%ebx
  800ce5:	80 fb 19             	cmp    $0x19,%bl
  800ce8:	77 08                	ja     800cf2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cea:	0f be d2             	movsbl %dl,%edx
  800ced:	83 ea 37             	sub    $0x37,%edx
  800cf0:	eb c1                	jmp    800cb3 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf6:	74 05                	je     800cfd <strtol+0xd0>
		*endptr = (char *) s;
  800cf8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cfd:	89 c2                	mov    %eax,%edx
  800cff:	f7 da                	neg    %edx
  800d01:	85 ff                	test   %edi,%edi
  800d03:	0f 45 c2             	cmovne %edx,%eax
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 1c             	sub    $0x1c,%esp
  800d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d1a:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d22:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d25:	8b 75 14             	mov    0x14(%ebp),%esi
  800d28:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2e:	74 04                	je     800d34 <syscall+0x29>
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	50                   	push   %eax
  800d40:	ff 75 e0             	pushl  -0x20(%ebp)
  800d43:	68 df 26 80 00       	push   $0x8026df
  800d48:	6a 23                	push   $0x23
  800d4a:	68 fc 26 80 00       	push   $0x8026fc
  800d4f:	e8 f2 f5 ff ff       	call   800346 <_panic>

00800d54 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800d54:	f3 0f 1e fb          	endbr32 
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800d5e:	6a 00                	push   $0x0
  800d60:	6a 00                	push   $0x0
  800d62:	6a 00                	push   $0x0
  800d64:	ff 75 0c             	pushl  0xc(%ebp)
  800d67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	e8 92 ff ff ff       	call   800d0b <syscall>
}
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800d88:	6a 00                	push   $0x0
  800d8a:	6a 00                	push   $0x0
  800d8c:	6a 00                	push   $0x0
  800d8e:	6a 00                	push   $0x0
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9f:	e8 67 ff ff ff       	call   800d0b <syscall>
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da6:	f3 0f 1e fb          	endbr32 
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800db0:	6a 00                	push   $0x0
  800db2:	6a 00                	push   $0x0
  800db4:	6a 00                	push   $0x0
  800db6:	6a 00                	push   $0x0
  800db8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbb:	ba 01 00 00 00       	mov    $0x1,%edx
  800dc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc5:	e8 41 ff ff ff       	call   800d0b <syscall>
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dcc:	f3 0f 1e fb          	endbr32 
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800dd6:	6a 00                	push   $0x0
  800dd8:	6a 00                	push   $0x0
  800dda:	6a 00                	push   $0x0
  800ddc:	6a 00                	push   $0x0
  800dde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	b8 02 00 00 00       	mov    $0x2,%eax
  800ded:	e8 19 ff ff ff       	call   800d0b <syscall>
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <sys_yield>:

void
sys_yield(void)
{
  800df4:	f3 0f 1e fb          	endbr32 
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 00                	push   $0x0
  800e02:	6a 00                	push   $0x0
  800e04:	6a 00                	push   $0x0
  800e06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e10:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e15:	e8 f1 fe ff ff       	call   800d0b <syscall>
}
  800e1a:	83 c4 10             	add    $0x10,%esp
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e1f:	f3 0f 1e fb          	endbr32 
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800e29:	6a 00                	push   $0x0
  800e2b:	6a 00                	push   $0x0
  800e2d:	ff 75 10             	pushl  0x10(%ebp)
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e36:	ba 01 00 00 00       	mov    $0x1,%edx
  800e3b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e40:	e8 c6 fe ff ff       	call   800d0b <syscall>
}
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e47:	f3 0f 1e fb          	endbr32 
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800e51:	ff 75 18             	pushl  0x18(%ebp)
  800e54:	ff 75 14             	pushl  0x14(%ebp)
  800e57:	ff 75 10             	pushl  0x10(%ebp)
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e60:	ba 01 00 00 00       	mov    $0x1,%edx
  800e65:	b8 05 00 00 00       	mov    $0x5,%eax
  800e6a:	e8 9c fe ff ff       	call   800d0b <syscall>
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e71:	f3 0f 1e fb          	endbr32 
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800e7b:	6a 00                	push   $0x0
  800e7d:	6a 00                	push   $0x0
  800e7f:	6a 00                	push   $0x0
  800e81:	ff 75 0c             	pushl  0xc(%ebp)
  800e84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e87:	ba 01 00 00 00       	mov    $0x1,%edx
  800e8c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e91:	e8 75 fe ff ff       	call   800d0b <syscall>
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e98:	f3 0f 1e fb          	endbr32 
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ea2:	6a 00                	push   $0x0
  800ea4:	6a 00                	push   $0x0
  800ea6:	6a 00                	push   $0x0
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eae:	ba 01 00 00 00       	mov    $0x1,%edx
  800eb3:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb8:	e8 4e fe ff ff       	call   800d0b <syscall>
}
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    

00800ebf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ebf:	f3 0f 1e fb          	endbr32 
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ec9:	6a 00                	push   $0x0
  800ecb:	6a 00                	push   $0x0
  800ecd:	6a 00                	push   $0x0
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed5:	ba 01 00 00 00       	mov    $0x1,%edx
  800eda:	b8 09 00 00 00       	mov    $0x9,%eax
  800edf:	e8 27 fe ff ff       	call   800d0b <syscall>
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee6:	f3 0f 1e fb          	endbr32 
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ef0:	6a 00                	push   $0x0
  800ef2:	6a 00                	push   $0x0
  800ef4:	6a 00                	push   $0x0
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efc:	ba 01 00 00 00       	mov    $0x1,%edx
  800f01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f06:	e8 00 fe ff ff       	call   800d0b <syscall>
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0d:	f3 0f 1e fb          	endbr32 
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800f17:	6a 00                	push   $0x0
  800f19:	ff 75 14             	pushl  0x14(%ebp)
  800f1c:	ff 75 10             	pushl  0x10(%ebp)
  800f1f:	ff 75 0c             	pushl  0xc(%ebp)
  800f22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f25:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2f:	e8 d7 fd ff ff       	call   800d0b <syscall>
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f36:	f3 0f 1e fb          	endbr32 
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800f40:	6a 00                	push   $0x0
  800f42:	6a 00                	push   $0x0
  800f44:	6a 00                	push   $0x0
  800f46:	6a 00                	push   $0x0
  800f48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4b:	ba 01 00 00 00       	mov    $0x1,%edx
  800f50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f55:	e8 b1 fd ff ff       	call   800d0b <syscall>
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800f5c:	f3 0f 1e fb          	endbr32 
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800f6c:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800f6e:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800f71:	83 3a 01             	cmpl   $0x1,(%edx)
  800f74:	7e 09                	jle    800f7f <argstart+0x23>
  800f76:	ba 3f 28 80 00       	mov    $0x80283f,%edx
  800f7b:	85 c9                	test   %ecx,%ecx
  800f7d:	75 05                	jne    800f84 <argstart+0x28>
  800f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f84:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800f87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <argnext>:

int
argnext(struct Argstate *args)
{
  800f90:	f3 0f 1e fb          	endbr32 
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	53                   	push   %ebx
  800f98:	83 ec 04             	sub    $0x4,%esp
  800f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800f9e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800fa5:	8b 43 08             	mov    0x8(%ebx),%eax
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	74 74                	je     801020 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  800fac:	80 38 00             	cmpb   $0x0,(%eax)
  800faf:	75 48                	jne    800ff9 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800fb1:	8b 0b                	mov    (%ebx),%ecx
  800fb3:	83 39 01             	cmpl   $0x1,(%ecx)
  800fb6:	74 5a                	je     801012 <argnext+0x82>
		    || args->argv[1][0] != '-'
  800fb8:	8b 53 04             	mov    0x4(%ebx),%edx
  800fbb:	8b 42 04             	mov    0x4(%edx),%eax
  800fbe:	80 38 2d             	cmpb   $0x2d,(%eax)
  800fc1:	75 4f                	jne    801012 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  800fc3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800fc7:	74 49                	je     801012 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800fc9:	83 c0 01             	add    $0x1,%eax
  800fcc:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	8b 01                	mov    (%ecx),%eax
  800fd4:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800fdb:	50                   	push   %eax
  800fdc:	8d 42 08             	lea    0x8(%edx),%eax
  800fdf:	50                   	push   %eax
  800fe0:	83 c2 04             	add    $0x4,%edx
  800fe3:	52                   	push   %edx
  800fe4:	e8 66 fb ff ff       	call   800b4f <memmove>
		(*args->argc)--;
  800fe9:	8b 03                	mov    (%ebx),%eax
  800feb:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800fee:	8b 43 08             	mov    0x8(%ebx),%eax
  800ff1:	83 c4 10             	add    $0x10,%esp
  800ff4:	80 38 2d             	cmpb   $0x2d,(%eax)
  800ff7:	74 13                	je     80100c <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800ff9:	8b 43 08             	mov    0x8(%ebx),%eax
  800ffc:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800fff:	83 c0 01             	add    $0x1,%eax
  801002:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801005:	89 d0                	mov    %edx,%eax
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80100c:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801010:	75 e7                	jne    800ff9 <argnext+0x69>
	args->curarg = 0;
  801012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801019:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80101e:	eb e5                	jmp    801005 <argnext+0x75>
		return -1;
  801020:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801025:	eb de                	jmp    801005 <argnext+0x75>

00801027 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801027:	f3 0f 1e fb          	endbr32 
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	53                   	push   %ebx
  80102f:	83 ec 04             	sub    $0x4,%esp
  801032:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801035:	8b 43 08             	mov    0x8(%ebx),%eax
  801038:	85 c0                	test   %eax,%eax
  80103a:	74 12                	je     80104e <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  80103c:	80 38 00             	cmpb   $0x0,(%eax)
  80103f:	74 12                	je     801053 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801041:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801044:	c7 43 08 3f 28 80 00 	movl   $0x80283f,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  80104b:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80104e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801051:	c9                   	leave  
  801052:	c3                   	ret    
	} else if (*args->argc > 1) {
  801053:	8b 13                	mov    (%ebx),%edx
  801055:	83 3a 01             	cmpl   $0x1,(%edx)
  801058:	7f 10                	jg     80106a <argnextvalue+0x43>
		args->argvalue = 0;
  80105a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801061:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801068:	eb e1                	jmp    80104b <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  80106a:	8b 43 04             	mov    0x4(%ebx),%eax
  80106d:	8b 48 04             	mov    0x4(%eax),%ecx
  801070:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801073:	83 ec 04             	sub    $0x4,%esp
  801076:	8b 12                	mov    (%edx),%edx
  801078:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  80107f:	52                   	push   %edx
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	52                   	push   %edx
  801084:	83 c0 04             	add    $0x4,%eax
  801087:	50                   	push   %eax
  801088:	e8 c2 fa ff ff       	call   800b4f <memmove>
		(*args->argc)--;
  80108d:	8b 03                	mov    (%ebx),%eax
  80108f:	83 28 01             	subl   $0x1,(%eax)
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	eb b4                	jmp    80104b <argnextvalue+0x24>

00801097 <argvalue>:
{
  801097:	f3 0f 1e fb          	endbr32 
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010a4:	8b 42 0c             	mov    0xc(%edx),%eax
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	74 02                	je     8010ad <argvalue+0x16>
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	52                   	push   %edx
  8010b1:	e8 71 ff ff ff       	call   801027 <argnextvalue>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	eb f0                	jmp    8010ab <argvalue+0x14>

008010bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010bb:	f3 0f 1e fb          	endbr32 
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ca:	c1 e8 0c             	shr    $0xc,%eax
}
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010cf:	f3 0f 1e fb          	endbr32 
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8010d9:	ff 75 08             	pushl  0x8(%ebp)
  8010dc:	e8 da ff ff ff       	call   8010bb <fd2num>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	c1 e0 0c             	shl    $0xc,%eax
  8010e7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ee:	f3 0f 1e fb          	endbr32 
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	c1 ea 16             	shr    $0x16,%edx
  8010ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801106:	f6 c2 01             	test   $0x1,%dl
  801109:	74 2d                	je     801138 <fd_alloc+0x4a>
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	c1 ea 0c             	shr    $0xc,%edx
  801110:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801117:	f6 c2 01             	test   $0x1,%dl
  80111a:	74 1c                	je     801138 <fd_alloc+0x4a>
  80111c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801121:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801126:	75 d2                	jne    8010fa <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801131:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801136:	eb 0a                	jmp    801142 <fd_alloc+0x54>
			*fd_store = fd;
  801138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    

00801144 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801144:	f3 0f 1e fb          	endbr32 
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114e:	83 f8 1f             	cmp    $0x1f,%eax
  801151:	77 30                	ja     801183 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801153:	c1 e0 0c             	shl    $0xc,%eax
  801156:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801161:	f6 c2 01             	test   $0x1,%dl
  801164:	74 24                	je     80118a <fd_lookup+0x46>
  801166:	89 c2                	mov    %eax,%edx
  801168:	c1 ea 0c             	shr    $0xc,%edx
  80116b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801172:	f6 c2 01             	test   $0x1,%dl
  801175:	74 1a                	je     801191 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117a:	89 02                	mov    %eax,(%edx)
	return 0;
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    
		return -E_INVAL;
  801183:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801188:	eb f7                	jmp    801181 <fd_lookup+0x3d>
		return -E_INVAL;
  80118a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118f:	eb f0                	jmp    801181 <fd_lookup+0x3d>
  801191:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801196:	eb e9                	jmp    801181 <fd_lookup+0x3d>

00801198 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801198:	f3 0f 1e fb          	endbr32 
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a5:	ba 88 27 80 00       	mov    $0x802788,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011aa:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011af:	39 08                	cmp    %ecx,(%eax)
  8011b1:	74 33                	je     8011e6 <dev_lookup+0x4e>
  8011b3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011b6:	8b 02                	mov    (%edx),%eax
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	75 f3                	jne    8011af <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011bc:	a1 20 44 80 00       	mov    0x804420,%eax
  8011c1:	8b 40 48             	mov    0x48(%eax),%eax
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	51                   	push   %ecx
  8011c8:	50                   	push   %eax
  8011c9:	68 0c 27 80 00       	push   $0x80270c
  8011ce:	e8 5a f2 ff ff       	call   80042d <cprintf>
	*dev = 0;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
			*dev = devtab[i];
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f0:	eb f2                	jmp    8011e4 <dev_lookup+0x4c>

008011f2 <fd_close>:
{
  8011f2:	f3 0f 1e fb          	endbr32 
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 28             	sub    $0x28,%esp
  8011ff:	8b 75 08             	mov    0x8(%ebp),%esi
  801202:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801205:	56                   	push   %esi
  801206:	e8 b0 fe ff ff       	call   8010bb <fd2num>
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801211:	52                   	push   %edx
  801212:	50                   	push   %eax
  801213:	e8 2c ff ff ff       	call   801144 <fd_lookup>
  801218:	89 c3                	mov    %eax,%ebx
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 05                	js     801226 <fd_close+0x34>
	    || fd != fd2)
  801221:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801224:	74 16                	je     80123c <fd_close+0x4a>
		return (must_exist ? r : 0);
  801226:	89 f8                	mov    %edi,%eax
  801228:	84 c0                	test   %al,%al
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	0f 44 d8             	cmove  %eax,%ebx
}
  801232:	89 d8                	mov    %ebx,%eax
  801234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	ff 36                	pushl  (%esi)
  801245:	e8 4e ff ff ff       	call   801198 <dev_lookup>
  80124a:	89 c3                	mov    %eax,%ebx
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 1a                	js     80126d <fd_close+0x7b>
		if (dev->dev_close)
  801253:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801256:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801259:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 0b                	je     80126d <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801262:	83 ec 0c             	sub    $0xc,%esp
  801265:	56                   	push   %esi
  801266:	ff d0                	call   *%eax
  801268:	89 c3                	mov    %eax,%ebx
  80126a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	56                   	push   %esi
  801271:	6a 00                	push   $0x0
  801273:	e8 f9 fb ff ff       	call   800e71 <sys_page_unmap>
	return r;
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	eb b5                	jmp    801232 <fd_close+0x40>

0080127d <close>:

int
close(int fdnum)
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801287:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128a:	50                   	push   %eax
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	e8 b1 fe ff ff       	call   801144 <fd_lookup>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	79 02                	jns    80129c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    
		return fd_close(fd, 1);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	6a 01                	push   $0x1
  8012a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a4:	e8 49 ff ff ff       	call   8011f2 <fd_close>
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	eb ec                	jmp    80129a <close+0x1d>

008012ae <close_all>:

void
close_all(void)
{
  8012ae:	f3 0f 1e fb          	endbr32 
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	53                   	push   %ebx
  8012c2:	e8 b6 ff ff ff       	call   80127d <close>
	for (i = 0; i < MAXFD; i++)
  8012c7:	83 c3 01             	add    $0x1,%ebx
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	83 fb 20             	cmp    $0x20,%ebx
  8012d0:	75 ec                	jne    8012be <close_all+0x10>
}
  8012d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012d7:	f3 0f 1e fb          	endbr32 
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	e8 54 fe ff ff       	call   801144 <fd_lookup>
  8012f0:	89 c3                	mov    %eax,%ebx
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	0f 88 81 00 00 00    	js     80137e <dup+0xa7>
		return r;
	close(newfdnum);
  8012fd:	83 ec 0c             	sub    $0xc,%esp
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	e8 75 ff ff ff       	call   80127d <close>

	newfd = INDEX2FD(newfdnum);
  801308:	8b 75 0c             	mov    0xc(%ebp),%esi
  80130b:	c1 e6 0c             	shl    $0xc,%esi
  80130e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801314:	83 c4 04             	add    $0x4,%esp
  801317:	ff 75 e4             	pushl  -0x1c(%ebp)
  80131a:	e8 b0 fd ff ff       	call   8010cf <fd2data>
  80131f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801321:	89 34 24             	mov    %esi,(%esp)
  801324:	e8 a6 fd ff ff       	call   8010cf <fd2data>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	c1 e8 16             	shr    $0x16,%eax
  801333:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80133a:	a8 01                	test   $0x1,%al
  80133c:	74 11                	je     80134f <dup+0x78>
  80133e:	89 d8                	mov    %ebx,%eax
  801340:	c1 e8 0c             	shr    $0xc,%eax
  801343:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80134a:	f6 c2 01             	test   $0x1,%dl
  80134d:	75 39                	jne    801388 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801352:	89 d0                	mov    %edx,%eax
  801354:	c1 e8 0c             	shr    $0xc,%eax
  801357:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	25 07 0e 00 00       	and    $0xe07,%eax
  801366:	50                   	push   %eax
  801367:	56                   	push   %esi
  801368:	6a 00                	push   $0x0
  80136a:	52                   	push   %edx
  80136b:	6a 00                	push   $0x0
  80136d:	e8 d5 fa ff ff       	call   800e47 <sys_page_map>
  801372:	89 c3                	mov    %eax,%ebx
  801374:	83 c4 20             	add    $0x20,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	78 31                	js     8013ac <dup+0xd5>
		goto err;

	return newfdnum;
  80137b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80137e:	89 d8                	mov    %ebx,%eax
  801380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801383:	5b                   	pop    %ebx
  801384:	5e                   	pop    %esi
  801385:	5f                   	pop    %edi
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801388:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138f:	83 ec 0c             	sub    $0xc,%esp
  801392:	25 07 0e 00 00       	and    $0xe07,%eax
  801397:	50                   	push   %eax
  801398:	57                   	push   %edi
  801399:	6a 00                	push   $0x0
  80139b:	53                   	push   %ebx
  80139c:	6a 00                	push   $0x0
  80139e:	e8 a4 fa ff ff       	call   800e47 <sys_page_map>
  8013a3:	89 c3                	mov    %eax,%ebx
  8013a5:	83 c4 20             	add    $0x20,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	79 a3                	jns    80134f <dup+0x78>
	sys_page_unmap(0, newfd);
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	56                   	push   %esi
  8013b0:	6a 00                	push   $0x0
  8013b2:	e8 ba fa ff ff       	call   800e71 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b7:	83 c4 08             	add    $0x8,%esp
  8013ba:	57                   	push   %edi
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 af fa ff ff       	call   800e71 <sys_page_unmap>
	return r;
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	eb b7                	jmp    80137e <dup+0xa7>

008013c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013c7:	f3 0f 1e fb          	endbr32 
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 1c             	sub    $0x1c,%esp
  8013d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	53                   	push   %ebx
  8013da:	e8 65 fd ff ff       	call   801144 <fd_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 3f                	js     801425 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	ff 30                	pushl  (%eax)
  8013f2:	e8 a1 fd ff ff       	call   801198 <dev_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 27                	js     801425 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801401:	8b 42 08             	mov    0x8(%edx),%eax
  801404:	83 e0 03             	and    $0x3,%eax
  801407:	83 f8 01             	cmp    $0x1,%eax
  80140a:	74 1e                	je     80142a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80140c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140f:	8b 40 08             	mov    0x8(%eax),%eax
  801412:	85 c0                	test   %eax,%eax
  801414:	74 35                	je     80144b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	ff 75 10             	pushl  0x10(%ebp)
  80141c:	ff 75 0c             	pushl  0xc(%ebp)
  80141f:	52                   	push   %edx
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
}
  801425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801428:	c9                   	leave  
  801429:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80142a:	a1 20 44 80 00       	mov    0x804420,%eax
  80142f:	8b 40 48             	mov    0x48(%eax),%eax
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	53                   	push   %ebx
  801436:	50                   	push   %eax
  801437:	68 4d 27 80 00       	push   $0x80274d
  80143c:	e8 ec ef ff ff       	call   80042d <cprintf>
		return -E_INVAL;
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801449:	eb da                	jmp    801425 <read+0x5e>
		return -E_NOT_SUPP;
  80144b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801450:	eb d3                	jmp    801425 <read+0x5e>

00801452 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801452:	f3 0f 1e fb          	endbr32 
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	57                   	push   %edi
  80145a:	56                   	push   %esi
  80145b:	53                   	push   %ebx
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801462:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801465:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146a:	eb 02                	jmp    80146e <readn+0x1c>
  80146c:	01 c3                	add    %eax,%ebx
  80146e:	39 f3                	cmp    %esi,%ebx
  801470:	73 21                	jae    801493 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	89 f0                	mov    %esi,%eax
  801477:	29 d8                	sub    %ebx,%eax
  801479:	50                   	push   %eax
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	03 45 0c             	add    0xc(%ebp),%eax
  80147f:	50                   	push   %eax
  801480:	57                   	push   %edi
  801481:	e8 41 ff ff ff       	call   8013c7 <read>
		if (m < 0)
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 04                	js     801491 <readn+0x3f>
			return m;
		if (m == 0)
  80148d:	75 dd                	jne    80146c <readn+0x1a>
  80148f:	eb 02                	jmp    801493 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801491:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801493:	89 d8                	mov    %ebx,%eax
  801495:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801498:	5b                   	pop    %ebx
  801499:	5e                   	pop    %esi
  80149a:	5f                   	pop    %edi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80149d:	f3 0f 1e fb          	endbr32 
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 1c             	sub    $0x1c,%esp
  8014a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ae:	50                   	push   %eax
  8014af:	53                   	push   %ebx
  8014b0:	e8 8f fc ff ff       	call   801144 <fd_lookup>
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 3a                	js     8014f6 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c6:	ff 30                	pushl  (%eax)
  8014c8:	e8 cb fc ff ff       	call   801198 <dev_lookup>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 22                	js     8014f6 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014db:	74 1e                	je     8014fb <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014e3:	85 d2                	test   %edx,%edx
  8014e5:	74 35                	je     80151c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	ff 75 10             	pushl  0x10(%ebp)
  8014ed:	ff 75 0c             	pushl  0xc(%ebp)
  8014f0:	50                   	push   %eax
  8014f1:	ff d2                	call   *%edx
  8014f3:	83 c4 10             	add    $0x10,%esp
}
  8014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014fb:	a1 20 44 80 00       	mov    0x804420,%eax
  801500:	8b 40 48             	mov    0x48(%eax),%eax
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	53                   	push   %ebx
  801507:	50                   	push   %eax
  801508:	68 69 27 80 00       	push   $0x802769
  80150d:	e8 1b ef ff ff       	call   80042d <cprintf>
		return -E_INVAL;
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151a:	eb da                	jmp    8014f6 <write+0x59>
		return -E_NOT_SUPP;
  80151c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801521:	eb d3                	jmp    8014f6 <write+0x59>

00801523 <seek>:

int
seek(int fdnum, off_t offset)
{
  801523:	f3 0f 1e fb          	endbr32 
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 0b fc ff ff       	call   801144 <fd_lookup>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 0e                	js     80154e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801540:	8b 55 0c             	mov    0xc(%ebp),%edx
  801543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801546:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801550:	f3 0f 1e fb          	endbr32 
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	53                   	push   %ebx
  801558:	83 ec 1c             	sub    $0x1c,%esp
  80155b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801561:	50                   	push   %eax
  801562:	53                   	push   %ebx
  801563:	e8 dc fb ff ff       	call   801144 <fd_lookup>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 37                	js     8015a6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	ff 30                	pushl  (%eax)
  80157b:	e8 18 fc ff ff       	call   801198 <dev_lookup>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 1f                	js     8015a6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158e:	74 1b                	je     8015ab <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	8b 52 18             	mov    0x18(%edx),%edx
  801596:	85 d2                	test   %edx,%edx
  801598:	74 32                	je     8015cc <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	50                   	push   %eax
  8015a1:	ff d2                	call   *%edx
  8015a3:	83 c4 10             	add    $0x10,%esp
}
  8015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ab:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b0:	8b 40 48             	mov    0x48(%eax),%eax
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	53                   	push   %ebx
  8015b7:	50                   	push   %eax
  8015b8:	68 2c 27 80 00       	push   $0x80272c
  8015bd:	e8 6b ee ff ff       	call   80042d <cprintf>
		return -E_INVAL;
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ca:	eb da                	jmp    8015a6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8015cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d1:	eb d3                	jmp    8015a6 <ftruncate+0x56>

008015d3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015d3:	f3 0f 1e fb          	endbr32 
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	53                   	push   %ebx
  8015db:	83 ec 1c             	sub    $0x1c,%esp
  8015de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e4:	50                   	push   %eax
  8015e5:	ff 75 08             	pushl  0x8(%ebp)
  8015e8:	e8 57 fb ff ff       	call   801144 <fd_lookup>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 4b                	js     80163f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fa:	50                   	push   %eax
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	ff 30                	pushl  (%eax)
  801600:	e8 93 fb ff ff       	call   801198 <dev_lookup>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 33                	js     80163f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801613:	74 2f                	je     801644 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801615:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801618:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80161f:	00 00 00 
	stat->st_isdir = 0;
  801622:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801629:	00 00 00 
	stat->st_dev = dev;
  80162c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	53                   	push   %ebx
  801636:	ff 75 f0             	pushl  -0x10(%ebp)
  801639:	ff 50 14             	call   *0x14(%eax)
  80163c:	83 c4 10             	add    $0x10,%esp
}
  80163f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801642:	c9                   	leave  
  801643:	c3                   	ret    
		return -E_NOT_SUPP;
  801644:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801649:	eb f4                	jmp    80163f <fstat+0x6c>

0080164b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80164b:	f3 0f 1e fb          	endbr32 
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	56                   	push   %esi
  801653:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	6a 00                	push   $0x0
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 3a 02 00 00       	call   80189b <open>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 1b                	js     801685 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	50                   	push   %eax
  801671:	e8 5d ff ff ff       	call   8015d3 <fstat>
  801676:	89 c6                	mov    %eax,%esi
	close(fd);
  801678:	89 1c 24             	mov    %ebx,(%esp)
  80167b:	e8 fd fb ff ff       	call   80127d <close>
	return r;
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	89 f3                	mov    %esi,%ebx
}
  801685:	89 d8                	mov    %ebx,%eax
  801687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
  801693:	89 c6                	mov    %eax,%esi
  801695:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801697:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80169e:	74 27                	je     8016c7 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a0:	6a 07                	push   $0x7
  8016a2:	68 00 50 80 00       	push   $0x805000
  8016a7:	56                   	push   %esi
  8016a8:	ff 35 00 40 80 00    	pushl  0x804000
  8016ae:	e8 21 09 00 00       	call   801fd4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016b3:	83 c4 0c             	add    $0xc,%esp
  8016b6:	6a 00                	push   $0x0
  8016b8:	53                   	push   %ebx
  8016b9:	6a 00                	push   $0x0
  8016bb:	e8 a7 08 00 00       	call   801f67 <ipc_recv>
}
  8016c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016c7:	83 ec 0c             	sub    $0xc,%esp
  8016ca:	6a 01                	push   $0x1
  8016cc:	e8 5b 09 00 00       	call   80202c <ipc_find_env>
  8016d1:	a3 00 40 80 00       	mov    %eax,0x804000
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	eb c5                	jmp    8016a0 <fsipc+0x12>

008016db <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016db:	f3 0f 1e fb          	endbr32 
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801702:	e8 87 ff ff ff       	call   80168e <fsipc>
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <devfile_flush>:
{
  801709:	f3 0f 1e fb          	endbr32 
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8b 40 0c             	mov    0xc(%eax),%eax
  801719:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	b8 06 00 00 00       	mov    $0x6,%eax
  801728:	e8 61 ff ff ff       	call   80168e <fsipc>
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <devfile_stat>:
{
  80172f:	f3 0f 1e fb          	endbr32 
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	b8 05 00 00 00       	mov    $0x5,%eax
  801752:	e8 37 ff ff ff       	call   80168e <fsipc>
  801757:	85 c0                	test   %eax,%eax
  801759:	78 2c                	js     801787 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	68 00 50 80 00       	push   $0x805000
  801763:	53                   	push   %ebx
  801764:	e8 2e f2 ff ff       	call   800997 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801769:	a1 80 50 80 00       	mov    0x805080,%eax
  80176e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801774:	a1 84 50 80 00       	mov    0x805084,%eax
  801779:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <devfile_write>:
{
  80178c:	f3 0f 1e fb          	endbr32 
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017a5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8017ab:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8017b1:	77 30                	ja     8017e3 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	53                   	push   %ebx
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	68 08 50 80 00       	push   $0x805008
  8017bf:	e8 8b f3 ff ff       	call   800b4f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ce:	e8 bb fe ff ff       	call   80168e <fsipc>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 04                	js     8017de <devfile_write+0x52>
	assert(r <= n);
  8017da:	39 d8                	cmp    %ebx,%eax
  8017dc:	77 1e                	ja     8017fc <devfile_write+0x70>
}
  8017de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8017e3:	68 98 27 80 00       	push   $0x802798
  8017e8:	68 c5 27 80 00       	push   $0x8027c5
  8017ed:	68 94 00 00 00       	push   $0x94
  8017f2:	68 da 27 80 00       	push   $0x8027da
  8017f7:	e8 4a eb ff ff       	call   800346 <_panic>
	assert(r <= n);
  8017fc:	68 e5 27 80 00       	push   $0x8027e5
  801801:	68 c5 27 80 00       	push   $0x8027c5
  801806:	68 98 00 00 00       	push   $0x98
  80180b:	68 da 27 80 00       	push   $0x8027da
  801810:	e8 31 eb ff ff       	call   800346 <_panic>

00801815 <devfile_read>:
{
  801815:	f3 0f 1e fb          	endbr32 
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8b 40 0c             	mov    0xc(%eax),%eax
  801827:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80182c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 03 00 00 00       	mov    $0x3,%eax
  80183c:	e8 4d fe ff ff       	call   80168e <fsipc>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	85 c0                	test   %eax,%eax
  801845:	78 1f                	js     801866 <devfile_read+0x51>
	assert(r <= n);
  801847:	39 f0                	cmp    %esi,%eax
  801849:	77 24                	ja     80186f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80184b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801850:	7f 33                	jg     801885 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	50                   	push   %eax
  801856:	68 00 50 80 00       	push   $0x805000
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	e8 ec f2 ff ff       	call   800b4f <memmove>
	return r;
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	89 d8                	mov    %ebx,%eax
  801868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    
	assert(r <= n);
  80186f:	68 e5 27 80 00       	push   $0x8027e5
  801874:	68 c5 27 80 00       	push   $0x8027c5
  801879:	6a 7c                	push   $0x7c
  80187b:	68 da 27 80 00       	push   $0x8027da
  801880:	e8 c1 ea ff ff       	call   800346 <_panic>
	assert(r <= PGSIZE);
  801885:	68 ec 27 80 00       	push   $0x8027ec
  80188a:	68 c5 27 80 00       	push   $0x8027c5
  80188f:	6a 7d                	push   $0x7d
  801891:	68 da 27 80 00       	push   $0x8027da
  801896:	e8 ab ea ff ff       	call   800346 <_panic>

0080189b <open>:
{
  80189b:	f3 0f 1e fb          	endbr32 
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018aa:	56                   	push   %esi
  8018ab:	e8 a4 f0 ff ff       	call   800954 <strlen>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018b8:	7f 6c                	jg     801926 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c0:	50                   	push   %eax
  8018c1:	e8 28 f8 ff ff       	call   8010ee <fd_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 3c                	js     80190b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	56                   	push   %esi
  8018d3:	68 00 50 80 00       	push   $0x805000
  8018d8:	e8 ba f0 ff ff       	call   800997 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ed:	e8 9c fd ff ff       	call   80168e <fsipc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 19                	js     801914 <open+0x79>
	return fd2num(fd);
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801901:	e8 b5 f7 ff ff       	call   8010bb <fd2num>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
}
  80190b:	89 d8                	mov    %ebx,%eax
  80190d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
		fd_close(fd, 0);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	6a 00                	push   $0x0
  801919:	ff 75 f4             	pushl  -0xc(%ebp)
  80191c:	e8 d1 f8 ff ff       	call   8011f2 <fd_close>
		return r;
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	eb e5                	jmp    80190b <open+0x70>
		return -E_BAD_PATH;
  801926:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80192b:	eb de                	jmp    80190b <open+0x70>

0080192d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80192d:	f3 0f 1e fb          	endbr32 
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	b8 08 00 00 00       	mov    $0x8,%eax
  801941:	e8 48 fd ff ff       	call   80168e <fsipc>
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801948:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80194c:	7f 01                	jg     80194f <writebuf+0x7>
  80194e:	c3                   	ret    
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	53                   	push   %ebx
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801958:	ff 70 04             	pushl  0x4(%eax)
  80195b:	8d 40 10             	lea    0x10(%eax),%eax
  80195e:	50                   	push   %eax
  80195f:	ff 33                	pushl  (%ebx)
  801961:	e8 37 fb ff ff       	call   80149d <write>
		if (result > 0)
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	7e 03                	jle    801970 <writebuf+0x28>
			b->result += result;
  80196d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801970:	39 43 04             	cmp    %eax,0x4(%ebx)
  801973:	74 0d                	je     801982 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801975:	85 c0                	test   %eax,%eax
  801977:	ba 00 00 00 00       	mov    $0x0,%edx
  80197c:	0f 4f c2             	cmovg  %edx,%eax
  80197f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <putch>:

static void
putch(int ch, void *thunk)
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801995:	8b 53 04             	mov    0x4(%ebx),%edx
  801998:	8d 42 01             	lea    0x1(%edx),%eax
  80199b:	89 43 04             	mov    %eax,0x4(%ebx)
  80199e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a1:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019a5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019aa:	74 06                	je     8019b2 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8019ac:	83 c4 04             	add    $0x4,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    
		writebuf(b);
  8019b2:	89 d8                	mov    %ebx,%eax
  8019b4:	e8 8f ff ff ff       	call   801948 <writebuf>
		b->idx = 0;
  8019b9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019c0:	eb ea                	jmp    8019ac <putch+0x25>

008019c2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019c2:	f3 0f 1e fb          	endbr32 
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019d8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019df:	00 00 00 
	b.result = 0;
  8019e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019e9:	00 00 00 
	b.error = 1;
  8019ec:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019f3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019f6:	ff 75 10             	pushl  0x10(%ebp)
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a02:	50                   	push   %eax
  801a03:	68 87 19 80 00       	push   $0x801987
  801a08:	e8 83 eb ff ff       	call   800590 <vprintfmt>
	if (b.idx > 0)
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a17:	7f 11                	jg     801a2a <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a19:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    
		writebuf(&b);
  801a2a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a30:	e8 13 ff ff ff       	call   801948 <writebuf>
  801a35:	eb e2                	jmp    801a19 <vfprintf+0x57>

00801a37 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a37:	f3 0f 1e fb          	endbr32 
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a41:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a44:	50                   	push   %eax
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	e8 72 ff ff ff       	call   8019c2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <printf>:

int
printf(const char *fmt, ...)
{
  801a52:	f3 0f 1e fb          	endbr32 
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a5f:	50                   	push   %eax
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 01                	push   $0x1
  801a65:	e8 58 ff ff ff       	call   8019c2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a6c:	f3 0f 1e fb          	endbr32 
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	56                   	push   %esi
  801a74:	53                   	push   %ebx
  801a75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 4c f6 ff ff       	call   8010cf <fd2data>
  801a83:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a85:	83 c4 08             	add    $0x8,%esp
  801a88:	68 f8 27 80 00       	push   $0x8027f8
  801a8d:	53                   	push   %ebx
  801a8e:	e8 04 ef ff ff       	call   800997 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a93:	8b 46 04             	mov    0x4(%esi),%eax
  801a96:	2b 06                	sub    (%esi),%eax
  801a98:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a9e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aa5:	00 00 00 
	stat->st_dev = &devpipe;
  801aa8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aaf:	30 80 00 
	return 0;
}
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    

00801abe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801abe:	f3 0f 1e fb          	endbr32 
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801acc:	53                   	push   %ebx
  801acd:	6a 00                	push   $0x0
  801acf:	e8 9d f3 ff ff       	call   800e71 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ad4:	89 1c 24             	mov    %ebx,(%esp)
  801ad7:	e8 f3 f5 ff ff       	call   8010cf <fd2data>
  801adc:	83 c4 08             	add    $0x8,%esp
  801adf:	50                   	push   %eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	e8 8a f3 ff ff       	call   800e71 <sys_page_unmap>
}
  801ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <_pipeisclosed>:
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 1c             	sub    $0x1c,%esp
  801af5:	89 c7                	mov    %eax,%edi
  801af7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801af9:	a1 20 44 80 00       	mov    0x804420,%eax
  801afe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b01:	83 ec 0c             	sub    $0xc,%esp
  801b04:	57                   	push   %edi
  801b05:	e8 5f 05 00 00       	call   802069 <pageref>
  801b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b0d:	89 34 24             	mov    %esi,(%esp)
  801b10:	e8 54 05 00 00       	call   802069 <pageref>
		nn = thisenv->env_runs;
  801b15:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b1b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	39 cb                	cmp    %ecx,%ebx
  801b23:	74 1b                	je     801b40 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b25:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b28:	75 cf                	jne    801af9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b2a:	8b 42 58             	mov    0x58(%edx),%eax
  801b2d:	6a 01                	push   $0x1
  801b2f:	50                   	push   %eax
  801b30:	53                   	push   %ebx
  801b31:	68 ff 27 80 00       	push   $0x8027ff
  801b36:	e8 f2 e8 ff ff       	call   80042d <cprintf>
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	eb b9                	jmp    801af9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b40:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b43:	0f 94 c0             	sete   %al
  801b46:	0f b6 c0             	movzbl %al,%eax
}
  801b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5f                   	pop    %edi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <devpipe_write>:
{
  801b51:	f3 0f 1e fb          	endbr32 
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	57                   	push   %edi
  801b59:	56                   	push   %esi
  801b5a:	53                   	push   %ebx
  801b5b:	83 ec 28             	sub    $0x28,%esp
  801b5e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b61:	56                   	push   %esi
  801b62:	e8 68 f5 ff ff       	call   8010cf <fd2data>
  801b67:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b71:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b74:	74 4f                	je     801bc5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b76:	8b 43 04             	mov    0x4(%ebx),%eax
  801b79:	8b 0b                	mov    (%ebx),%ecx
  801b7b:	8d 51 20             	lea    0x20(%ecx),%edx
  801b7e:	39 d0                	cmp    %edx,%eax
  801b80:	72 14                	jb     801b96 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801b82:	89 da                	mov    %ebx,%edx
  801b84:	89 f0                	mov    %esi,%eax
  801b86:	e8 61 ff ff ff       	call   801aec <_pipeisclosed>
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	75 3b                	jne    801bca <devpipe_write+0x79>
			sys_yield();
  801b8f:	e8 60 f2 ff ff       	call   800df4 <sys_yield>
  801b94:	eb e0                	jmp    801b76 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b99:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b9d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba0:	89 c2                	mov    %eax,%edx
  801ba2:	c1 fa 1f             	sar    $0x1f,%edx
  801ba5:	89 d1                	mov    %edx,%ecx
  801ba7:	c1 e9 1b             	shr    $0x1b,%ecx
  801baa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bad:	83 e2 1f             	and    $0x1f,%edx
  801bb0:	29 ca                	sub    %ecx,%edx
  801bb2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bb6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bba:	83 c0 01             	add    $0x1,%eax
  801bbd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc0:	83 c7 01             	add    $0x1,%edi
  801bc3:	eb ac                	jmp    801b71 <devpipe_write+0x20>
	return i;
  801bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc8:	eb 05                	jmp    801bcf <devpipe_write+0x7e>
				return 0;
  801bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5f                   	pop    %edi
  801bd5:	5d                   	pop    %ebp
  801bd6:	c3                   	ret    

00801bd7 <devpipe_read>:
{
  801bd7:	f3 0f 1e fb          	endbr32 
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	57                   	push   %edi
  801bdf:	56                   	push   %esi
  801be0:	53                   	push   %ebx
  801be1:	83 ec 18             	sub    $0x18,%esp
  801be4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801be7:	57                   	push   %edi
  801be8:	e8 e2 f4 ff ff       	call   8010cf <fd2data>
  801bed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	be 00 00 00 00       	mov    $0x0,%esi
  801bf7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfa:	75 14                	jne    801c10 <devpipe_read+0x39>
	return i;
  801bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bff:	eb 02                	jmp    801c03 <devpipe_read+0x2c>
				return i;
  801c01:	89 f0                	mov    %esi,%eax
}
  801c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5f                   	pop    %edi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    
			sys_yield();
  801c0b:	e8 e4 f1 ff ff       	call   800df4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c10:	8b 03                	mov    (%ebx),%eax
  801c12:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c15:	75 18                	jne    801c2f <devpipe_read+0x58>
			if (i > 0)
  801c17:	85 f6                	test   %esi,%esi
  801c19:	75 e6                	jne    801c01 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c1b:	89 da                	mov    %ebx,%edx
  801c1d:	89 f8                	mov    %edi,%eax
  801c1f:	e8 c8 fe ff ff       	call   801aec <_pipeisclosed>
  801c24:	85 c0                	test   %eax,%eax
  801c26:	74 e3                	je     801c0b <devpipe_read+0x34>
				return 0;
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2d:	eb d4                	jmp    801c03 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c2f:	99                   	cltd   
  801c30:	c1 ea 1b             	shr    $0x1b,%edx
  801c33:	01 d0                	add    %edx,%eax
  801c35:	83 e0 1f             	and    $0x1f,%eax
  801c38:	29 d0                	sub    %edx,%eax
  801c3a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c42:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c45:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c48:	83 c6 01             	add    $0x1,%esi
  801c4b:	eb aa                	jmp    801bf7 <devpipe_read+0x20>

00801c4d <pipe>:
{
  801c4d:	f3 0f 1e fb          	endbr32 
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5c:	50                   	push   %eax
  801c5d:	e8 8c f4 ff ff       	call   8010ee <fd_alloc>
  801c62:	89 c3                	mov    %eax,%ebx
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	0f 88 23 01 00 00    	js     801d92 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	68 07 04 00 00       	push   $0x407
  801c77:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 9e f1 ff ff       	call   800e1f <sys_page_alloc>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	85 c0                	test   %eax,%eax
  801c88:	0f 88 04 01 00 00    	js     801d92 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801c8e:	83 ec 0c             	sub    $0xc,%esp
  801c91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	e8 54 f4 ff ff       	call   8010ee <fd_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	0f 88 db 00 00 00    	js     801d82 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	68 07 04 00 00       	push   $0x407
  801caf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb2:	6a 00                	push   $0x0
  801cb4:	e8 66 f1 ff ff       	call   800e1f <sys_page_alloc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	0f 88 bc 00 00 00    	js     801d82 <pipe+0x135>
	va = fd2data(fd0);
  801cc6:	83 ec 0c             	sub    $0xc,%esp
  801cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccc:	e8 fe f3 ff ff       	call   8010cf <fd2data>
  801cd1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd3:	83 c4 0c             	add    $0xc,%esp
  801cd6:	68 07 04 00 00       	push   $0x407
  801cdb:	50                   	push   %eax
  801cdc:	6a 00                	push   $0x0
  801cde:	e8 3c f1 ff ff       	call   800e1f <sys_page_alloc>
  801ce3:	89 c3                	mov    %eax,%ebx
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	0f 88 82 00 00 00    	js     801d72 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf6:	e8 d4 f3 ff ff       	call   8010cf <fd2data>
  801cfb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d02:	50                   	push   %eax
  801d03:	6a 00                	push   $0x0
  801d05:	56                   	push   %esi
  801d06:	6a 00                	push   $0x0
  801d08:	e8 3a f1 ff ff       	call   800e47 <sys_page_map>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	83 c4 20             	add    $0x20,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 4e                	js     801d64 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d16:	a1 20 30 80 00       	mov    0x803020,%eax
  801d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d23:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d2d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d32:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3f:	e8 77 f3 ff ff       	call   8010bb <fd2num>
  801d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d47:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d49:	83 c4 04             	add    $0x4,%esp
  801d4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4f:	e8 67 f3 ff ff       	call   8010bb <fd2num>
  801d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d57:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d62:	eb 2e                	jmp    801d92 <pipe+0x145>
	sys_page_unmap(0, va);
  801d64:	83 ec 08             	sub    $0x8,%esp
  801d67:	56                   	push   %esi
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 02 f1 ff ff       	call   800e71 <sys_page_unmap>
  801d6f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d72:	83 ec 08             	sub    $0x8,%esp
  801d75:	ff 75 f0             	pushl  -0x10(%ebp)
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 f2 f0 ff ff       	call   800e71 <sys_page_unmap>
  801d7f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 75 f4             	pushl  -0xc(%ebp)
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 e2 f0 ff ff       	call   800e71 <sys_page_unmap>
  801d8f:	83 c4 10             	add    $0x10,%esp
}
  801d92:	89 d8                	mov    %ebx,%eax
  801d94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <pipeisclosed>:
{
  801d9b:	f3 0f 1e fb          	endbr32 
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da8:	50                   	push   %eax
  801da9:	ff 75 08             	pushl  0x8(%ebp)
  801dac:	e8 93 f3 ff ff       	call   801144 <fd_lookup>
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 18                	js     801dd0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbe:	e8 0c f3 ff ff       	call   8010cf <fd2data>
  801dc3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	e8 1f fd ff ff       	call   801aec <_pipeisclosed>
  801dcd:	83 c4 10             	add    $0x10,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dd2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddb:	c3                   	ret    

00801ddc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ddc:	f3 0f 1e fb          	endbr32 
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801de6:	68 17 28 80 00       	push   $0x802817
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	e8 a4 eb ff ff       	call   800997 <strcpy>
	return 0;
}
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <devcons_write>:
{
  801dfa:	f3 0f 1e fb          	endbr32 
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	57                   	push   %edi
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e0a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e0f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e15:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e18:	73 31                	jae    801e4b <devcons_write+0x51>
		m = n - tot;
  801e1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e1d:	29 f3                	sub    %esi,%ebx
  801e1f:	83 fb 7f             	cmp    $0x7f,%ebx
  801e22:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e27:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	53                   	push   %ebx
  801e2e:	89 f0                	mov    %esi,%eax
  801e30:	03 45 0c             	add    0xc(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	57                   	push   %edi
  801e35:	e8 15 ed ff ff       	call   800b4f <memmove>
		sys_cputs(buf, m);
  801e3a:	83 c4 08             	add    $0x8,%esp
  801e3d:	53                   	push   %ebx
  801e3e:	57                   	push   %edi
  801e3f:	e8 10 ef ff ff       	call   800d54 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e44:	01 de                	add    %ebx,%esi
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	eb ca                	jmp    801e15 <devcons_write+0x1b>
}
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5f                   	pop    %edi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    

00801e55 <devcons_read>:
{
  801e55:	f3 0f 1e fb          	endbr32 
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e68:	74 21                	je     801e8b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801e6a:	e8 0f ef ff ff       	call   800d7e <sys_cgetc>
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	75 07                	jne    801e7a <devcons_read+0x25>
		sys_yield();
  801e73:	e8 7c ef ff ff       	call   800df4 <sys_yield>
  801e78:	eb f0                	jmp    801e6a <devcons_read+0x15>
	if (c < 0)
  801e7a:	78 0f                	js     801e8b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801e7c:	83 f8 04             	cmp    $0x4,%eax
  801e7f:	74 0c                	je     801e8d <devcons_read+0x38>
	*(char*)vbuf = c;
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	88 02                	mov    %al,(%edx)
	return 1;
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    
		return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	eb f7                	jmp    801e8b <devcons_read+0x36>

00801e94 <cputchar>:
{
  801e94:	f3 0f 1e fb          	endbr32 
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ea4:	6a 01                	push   $0x1
  801ea6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea9:	50                   	push   %eax
  801eaa:	e8 a5 ee ff ff       	call   800d54 <sys_cputs>
}
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <getchar>:
{
  801eb4:	f3 0f 1e fb          	endbr32 
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ebe:	6a 01                	push   $0x1
  801ec0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec3:	50                   	push   %eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	e8 fc f4 ff ff       	call   8013c7 <read>
	if (r < 0)
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 06                	js     801ed8 <getchar+0x24>
	if (r < 1)
  801ed2:	74 06                	je     801eda <getchar+0x26>
	return c;
  801ed4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    
		return -E_EOF;
  801eda:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801edf:	eb f7                	jmp    801ed8 <getchar+0x24>

00801ee1 <iscons>:
{
  801ee1:	f3 0f 1e fb          	endbr32 
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eee:	50                   	push   %eax
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	e8 4d f2 ff ff       	call   801144 <fd_lookup>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 11                	js     801f0f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f07:	39 10                	cmp    %edx,(%eax)
  801f09:	0f 94 c0             	sete   %al
  801f0c:	0f b6 c0             	movzbl %al,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <opencons>:
{
  801f11:	f3 0f 1e fb          	endbr32 
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	e8 ca f1 ff ff       	call   8010ee <fd_alloc>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 3a                	js     801f65 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	68 07 04 00 00       	push   $0x407
  801f33:	ff 75 f4             	pushl  -0xc(%ebp)
  801f36:	6a 00                	push   $0x0
  801f38:	e8 e2 ee ff ff       	call   800e1f <sys_page_alloc>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 21                	js     801f65 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f47:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f4d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	50                   	push   %eax
  801f5d:	e8 59 f1 ff ff       	call   8010bb <fd2num>
  801f62:	83 c4 10             	add    $0x10,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f67:	f3 0f 1e fb          	endbr32 
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	8b 75 08             	mov    0x8(%ebp),%esi
  801f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f80:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	50                   	push   %eax
  801f87:	e8 aa ef ff ff       	call   800f36 <sys_ipc_recv>
	if (r < 0) {
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 2b                	js     801fbe <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801f93:	85 f6                	test   %esi,%esi
  801f95:	74 0a                	je     801fa1 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801f97:	a1 20 44 80 00       	mov    0x804420,%eax
  801f9c:	8b 40 74             	mov    0x74(%eax),%eax
  801f9f:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801fa1:	85 db                	test   %ebx,%ebx
  801fa3:	74 0a                	je     801faf <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801fa5:	a1 20 44 80 00       	mov    0x804420,%eax
  801faa:	8b 40 78             	mov    0x78(%eax),%eax
  801fad:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801faf:	a1 20 44 80 00       	mov    0x804420,%eax
  801fb4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5e                   	pop    %esi
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    
		if (from_env_store) {
  801fbe:	85 f6                	test   %esi,%esi
  801fc0:	74 06                	je     801fc8 <ipc_recv+0x61>
			*from_env_store = 0;
  801fc2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801fc8:	85 db                	test   %ebx,%ebx
  801fca:	74 eb                	je     801fb7 <ipc_recv+0x50>
			*perm_store = 0;
  801fcc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fd2:	eb e3                	jmp    801fb7 <ipc_recv+0x50>

00801fd4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fd4:	f3 0f 1e fb          	endbr32 
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	57                   	push   %edi
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fe4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fe7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801fea:	85 db                	test   %ebx,%ebx
  801fec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ff1:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ff4:	ff 75 14             	pushl  0x14(%ebp)
  801ff7:	53                   	push   %ebx
  801ff8:	56                   	push   %esi
  801ff9:	57                   	push   %edi
  801ffa:	e8 0e ef ff ff       	call   800f0d <sys_ipc_try_send>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802005:	75 07                	jne    80200e <ipc_send+0x3a>
		sys_yield();
  802007:	e8 e8 ed ff ff       	call   800df4 <sys_yield>
  80200c:	eb e6                	jmp    801ff4 <ipc_send+0x20>
	}

	if (ret < 0) {
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 08                	js     80201a <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802012:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5f                   	pop    %edi
  802018:	5d                   	pop    %ebp
  802019:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  80201a:	50                   	push   %eax
  80201b:	68 23 28 80 00       	push   $0x802823
  802020:	6a 48                	push   $0x48
  802022:	68 40 28 80 00       	push   $0x802840
  802027:	e8 1a e3 ff ff       	call   800346 <_panic>

0080202c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80202c:	f3 0f 1e fb          	endbr32 
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80203b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80203e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802044:	8b 52 50             	mov    0x50(%edx),%edx
  802047:	39 ca                	cmp    %ecx,%edx
  802049:	74 11                	je     80205c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80204b:	83 c0 01             	add    $0x1,%eax
  80204e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802053:	75 e6                	jne    80203b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	eb 0b                	jmp    802067 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80205c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80205f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802064:	8b 40 48             	mov    0x48(%eax),%eax
}
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802069:	f3 0f 1e fb          	endbr32 
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802073:	89 c2                	mov    %eax,%edx
  802075:	c1 ea 16             	shr    $0x16,%edx
  802078:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80207f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802084:	f6 c1 01             	test   $0x1,%cl
  802087:	74 1c                	je     8020a5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802089:	c1 e8 0c             	shr    $0xc,%eax
  80208c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802093:	a8 01                	test   $0x1,%al
  802095:	74 0e                	je     8020a5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802097:	c1 e8 0c             	shr    $0xc,%eax
  80209a:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020a1:	ef 
  8020a2:	0f b7 d2             	movzwl %dx,%edx
}
  8020a5:	89 d0                	mov    %edx,%eax
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
  8020a9:	66 90                	xchg   %ax,%ax
  8020ab:	66 90                	xchg   %ax,%ax
  8020ad:	66 90                	xchg   %ax,%ax
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020cb:	85 d2                	test   %edx,%edx
  8020cd:	75 19                	jne    8020e8 <__udivdi3+0x38>
  8020cf:	39 f3                	cmp    %esi,%ebx
  8020d1:	76 4d                	jbe    802120 <__udivdi3+0x70>
  8020d3:	31 ff                	xor    %edi,%edi
  8020d5:	89 e8                	mov    %ebp,%eax
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	f7 f3                	div    %ebx
  8020db:	89 fa                	mov    %edi,%edx
  8020dd:	83 c4 1c             	add    $0x1c,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	8d 76 00             	lea    0x0(%esi),%esi
  8020e8:	39 f2                	cmp    %esi,%edx
  8020ea:	76 14                	jbe    802100 <__udivdi3+0x50>
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	31 c0                	xor    %eax,%eax
  8020f0:	89 fa                	mov    %edi,%edx
  8020f2:	83 c4 1c             	add    $0x1c,%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5f                   	pop    %edi
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    
  8020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802100:	0f bd fa             	bsr    %edx,%edi
  802103:	83 f7 1f             	xor    $0x1f,%edi
  802106:	75 48                	jne    802150 <__udivdi3+0xa0>
  802108:	39 f2                	cmp    %esi,%edx
  80210a:	72 06                	jb     802112 <__udivdi3+0x62>
  80210c:	31 c0                	xor    %eax,%eax
  80210e:	39 eb                	cmp    %ebp,%ebx
  802110:	77 de                	ja     8020f0 <__udivdi3+0x40>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	eb d7                	jmp    8020f0 <__udivdi3+0x40>
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	89 d9                	mov    %ebx,%ecx
  802122:	85 db                	test   %ebx,%ebx
  802124:	75 0b                	jne    802131 <__udivdi3+0x81>
  802126:	b8 01 00 00 00       	mov    $0x1,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	f7 f3                	div    %ebx
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	31 d2                	xor    %edx,%edx
  802133:	89 f0                	mov    %esi,%eax
  802135:	f7 f1                	div    %ecx
  802137:	89 c6                	mov    %eax,%esi
  802139:	89 e8                	mov    %ebp,%eax
  80213b:	89 f7                	mov    %esi,%edi
  80213d:	f7 f1                	div    %ecx
  80213f:	89 fa                	mov    %edi,%edx
  802141:	83 c4 1c             	add    $0x1c,%esp
  802144:	5b                   	pop    %ebx
  802145:	5e                   	pop    %esi
  802146:	5f                   	pop    %edi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	89 eb                	mov    %ebp,%ebx
  802181:	d3 e6                	shl    %cl,%esi
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 15                	jb     8021b0 <__udivdi3+0x100>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 04                	jae    8021a7 <__udivdi3+0xf7>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	74 09                	je     8021b0 <__udivdi3+0x100>
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	31 ff                	xor    %edi,%edi
  8021ab:	e9 40 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	e9 36 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 19                	jne    8021f8 <__umoddi3+0x38>
  8021df:	39 df                	cmp    %ebx,%edi
  8021e1:	76 5d                	jbe    802240 <__umoddi3+0x80>
  8021e3:	89 f0                	mov    %esi,%eax
  8021e5:	89 da                	mov    %ebx,%edx
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	89 f2                	mov    %esi,%edx
  8021fa:	39 d8                	cmp    %ebx,%eax
  8021fc:	76 12                	jbe    802210 <__umoddi3+0x50>
  8021fe:	89 f0                	mov    %esi,%eax
  802200:	89 da                	mov    %ebx,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd e8             	bsr    %eax,%ebp
  802213:	83 f5 1f             	xor    $0x1f,%ebp
  802216:	75 50                	jne    802268 <__umoddi3+0xa8>
  802218:	39 d8                	cmp    %ebx,%eax
  80221a:	0f 82 e0 00 00 00    	jb     802300 <__umoddi3+0x140>
  802220:	89 d9                	mov    %ebx,%ecx
  802222:	39 f7                	cmp    %esi,%edi
  802224:	0f 86 d6 00 00 00    	jbe    802300 <__umoddi3+0x140>
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	89 ca                	mov    %ecx,%edx
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	89 fd                	mov    %edi,%ebp
  802242:	85 ff                	test   %edi,%edi
  802244:	75 0b                	jne    802251 <__umoddi3+0x91>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f7                	div    %edi
  80224f:	89 c5                	mov    %eax,%ebp
  802251:	89 d8                	mov    %ebx,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f5                	div    %ebp
  802257:	89 f0                	mov    %esi,%eax
  802259:	f7 f5                	div    %ebp
  80225b:	89 d0                	mov    %edx,%eax
  80225d:	31 d2                	xor    %edx,%edx
  80225f:	eb 8c                	jmp    8021ed <__umoddi3+0x2d>
  802261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	ba 20 00 00 00       	mov    $0x20,%edx
  80226f:	29 ea                	sub    %ebp,%edx
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 44 24 08          	mov    %eax,0x8(%esp)
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802281:	89 54 24 04          	mov    %edx,0x4(%esp)
  802285:	8b 54 24 04          	mov    0x4(%esp),%edx
  802289:	09 c1                	or     %eax,%ecx
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e7                	shl    %cl,%edi
  802295:	89 d1                	mov    %edx,%ecx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	d3 e6                	shl    %cl,%esi
  8022af:	09 d8                	or     %ebx,%eax
  8022b1:	f7 74 24 08          	divl   0x8(%esp)
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	89 f3                	mov    %esi,%ebx
  8022b9:	f7 64 24 0c          	mull   0xc(%esp)
  8022bd:	89 c6                	mov    %eax,%esi
  8022bf:	89 d7                	mov    %edx,%edi
  8022c1:	39 d1                	cmp    %edx,%ecx
  8022c3:	72 06                	jb     8022cb <__umoddi3+0x10b>
  8022c5:	75 10                	jne    8022d7 <__umoddi3+0x117>
  8022c7:	39 c3                	cmp    %eax,%ebx
  8022c9:	73 0c                	jae    8022d7 <__umoddi3+0x117>
  8022cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d3:	89 d7                	mov    %edx,%edi
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 ca                	mov    %ecx,%edx
  8022d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	19 fa                	sbb    %edi,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	d3 e0                	shl    %cl,%eax
  8022e6:	89 e9                	mov    %ebp,%ecx
  8022e8:	d3 eb                	shr    %cl,%ebx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d8                	or     %ebx,%eax
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	29 fe                	sub    %edi,%esi
  802302:	19 c3                	sbb    %eax,%ebx
  802304:	89 f2                	mov    %esi,%edx
  802306:	89 d9                	mov    %ebx,%ecx
  802308:	e9 1d ff ff ff       	jmp    80222a <__umoddi3+0x6a>
