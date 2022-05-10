
obj/user/echo.debug:     formato del fichero elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 7d 08             	mov    0x8(%ebp),%edi
  800043:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800046:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004d:	83 ff 01             	cmp    $0x1,%edi
  800050:	7f 07                	jg     800059 <umain+0x26>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800052:	bb 01 00 00 00       	mov    $0x1,%ebx
  800057:	eb 60                	jmp    8000b9 <umain+0x86>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	68 a0 1e 80 00       	push   $0x801ea0
  800061:	ff 76 04             	pushl  0x4(%esi)
  800064:	e8 ed 01 00 00       	call   800256 <strcmp>
  800069:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  80006c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800073:	85 c0                	test   %eax,%eax
  800075:	75 db                	jne    800052 <umain+0x1f>
		argc--;
  800077:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80007a:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  80007d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800084:	eb cc                	jmp    800052 <umain+0x1f>
		if (i > 1)
			write(1, " ", 1);
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	68 a3 1e 80 00       	push   $0x801ea3
  800090:	6a 01                	push   $0x1
  800092:	e8 a7 0a 00 00       	call   800b3e <write>
  800097:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a0:	e8 af 00 00 00       	call   800154 <strlen>
  8000a5:	83 c4 0c             	add    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000ac:	6a 01                	push   $0x1
  8000ae:	e8 8b 0a 00 00       	call   800b3e <write>
	for (i = 1; i < argc; i++) {
  8000b3:	83 c3 01             	add    $0x1,%ebx
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	39 df                	cmp    %ebx,%edi
  8000bb:	7e 07                	jle    8000c4 <umain+0x91>
		if (i > 1)
  8000bd:	83 fb 01             	cmp    $0x1,%ebx
  8000c0:	7f c4                	jg     800086 <umain+0x53>
  8000c2:	eb d6                	jmp    80009a <umain+0x67>
	}
	if (!nflag)
  8000c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c8:	74 08                	je     8000d2 <umain+0x9f>
		write(1, "\n", 1);
}
  8000ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    
		write(1, "\n", 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 3a 23 80 00       	push   $0x80233a
  8000dc:	6a 01                	push   $0x1
  8000de:	e8 5b 0a 00 00       	call   800b3e <write>
  8000e3:	83 c4 10             	add    $0x10,%esp
}
  8000e6:	eb e2                	jmp    8000ca <umain+0x97>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000f7:	e8 d0 04 00 00       	call   8005cc <sys_getenvid>
	if (id >= 0)
  8000fc:	85 c0                	test   %eax,%eax
  8000fe:	78 12                	js     800112 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800100:	25 ff 03 00 00       	and    $0x3ff,%eax
  800105:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800108:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800112:	85 db                	test   %ebx,%ebx
  800114:	7e 07                	jle    80011d <libmain+0x35>
		binaryname = argv[0];
  800116:	8b 06                	mov    (%esi),%eax
  800118:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 0c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800127:	e8 0a 00 00 00       	call   800136 <exit>
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800136:	f3 0f 1e fb          	endbr32 
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800140:	e8 0a 08 00 00       	call   80094f <close_all>
	sys_env_destroy(0);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	6a 00                	push   $0x0
  80014a:	e8 57 04 00 00       	call   8005a6 <sys_env_destroy>
}
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800154:	f3 0f 1e fb          	endbr32 
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800167:	74 05                	je     80016e <strlen+0x1a>
		n++;
  800169:	83 c0 01             	add    $0x1,%eax
  80016c:	eb f5                	jmp    800163 <strlen+0xf>
	return n;
}
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800170:	f3 0f 1e fb          	endbr32 
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	39 d0                	cmp    %edx,%eax
  800184:	74 0d                	je     800193 <strnlen+0x23>
  800186:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80018a:	74 05                	je     800191 <strnlen+0x21>
		n++;
  80018c:	83 c0 01             	add    $0x1,%eax
  80018f:	eb f1                	jmp    800182 <strnlen+0x12>
  800191:	89 c2                	mov    %eax,%edx
	return n;
}
  800193:	89 d0                	mov    %edx,%eax
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    

00800197 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800197:	f3 0f 1e fb          	endbr32 
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8001ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8001b1:	83 c0 01             	add    $0x1,%eax
  8001b4:	84 d2                	test   %dl,%dl
  8001b6:	75 f2                	jne    8001aa <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8001b8:	89 c8                	mov    %ecx,%eax
  8001ba:	5b                   	pop    %ebx
  8001bb:	5d                   	pop    %ebp
  8001bc:	c3                   	ret    

008001bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001bd:	f3 0f 1e fb          	endbr32 
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 10             	sub    $0x10,%esp
  8001c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001cb:	53                   	push   %ebx
  8001cc:	e8 83 ff ff ff       	call   800154 <strlen>
  8001d1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001d4:	ff 75 0c             	pushl  0xc(%ebp)
  8001d7:	01 d8                	add    %ebx,%eax
  8001d9:	50                   	push   %eax
  8001da:	e8 b8 ff ff ff       	call   800197 <strcpy>
	return dst;
}
  8001df:	89 d8                	mov    %ebx,%eax
  8001e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e6:	f3 0f 1e fb          	endbr32 
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	89 f3                	mov    %esi,%ebx
  8001f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001fa:	89 f0                	mov    %esi,%eax
  8001fc:	39 d8                	cmp    %ebx,%eax
  8001fe:	74 11                	je     800211 <strncpy+0x2b>
		*dst++ = *src;
  800200:	83 c0 01             	add    $0x1,%eax
  800203:	0f b6 0a             	movzbl (%edx),%ecx
  800206:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800209:	80 f9 01             	cmp    $0x1,%cl
  80020c:	83 da ff             	sbb    $0xffffffff,%edx
  80020f:	eb eb                	jmp    8001fc <strncpy+0x16>
	}
	return ret;
}
  800211:	89 f0                	mov    %esi,%eax
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    

00800217 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800217:	f3 0f 1e fb          	endbr32 
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	8b 75 08             	mov    0x8(%ebp),%esi
  800223:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800226:	8b 55 10             	mov    0x10(%ebp),%edx
  800229:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80022b:	85 d2                	test   %edx,%edx
  80022d:	74 21                	je     800250 <strlcpy+0x39>
  80022f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800233:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800235:	39 c2                	cmp    %eax,%edx
  800237:	74 14                	je     80024d <strlcpy+0x36>
  800239:	0f b6 19             	movzbl (%ecx),%ebx
  80023c:	84 db                	test   %bl,%bl
  80023e:	74 0b                	je     80024b <strlcpy+0x34>
			*dst++ = *src++;
  800240:	83 c1 01             	add    $0x1,%ecx
  800243:	83 c2 01             	add    $0x1,%edx
  800246:	88 5a ff             	mov    %bl,-0x1(%edx)
  800249:	eb ea                	jmp    800235 <strlcpy+0x1e>
  80024b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80024d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800250:	29 f0                	sub    %esi,%eax
}
  800252:	5b                   	pop    %ebx
  800253:	5e                   	pop    %esi
  800254:	5d                   	pop    %ebp
  800255:	c3                   	ret    

00800256 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800256:	f3 0f 1e fb          	endbr32 
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800260:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800263:	0f b6 01             	movzbl (%ecx),%eax
  800266:	84 c0                	test   %al,%al
  800268:	74 0c                	je     800276 <strcmp+0x20>
  80026a:	3a 02                	cmp    (%edx),%al
  80026c:	75 08                	jne    800276 <strcmp+0x20>
		p++, q++;
  80026e:	83 c1 01             	add    $0x1,%ecx
  800271:	83 c2 01             	add    $0x1,%edx
  800274:	eb ed                	jmp    800263 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800276:	0f b6 c0             	movzbl %al,%eax
  800279:	0f b6 12             	movzbl (%edx),%edx
  80027c:	29 d0                	sub    %edx,%eax
}
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800280:	f3 0f 1e fb          	endbr32 
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	53                   	push   %ebx
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 c3                	mov    %eax,%ebx
  800290:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800293:	eb 06                	jmp    80029b <strncmp+0x1b>
		n--, p++, q++;
  800295:	83 c0 01             	add    $0x1,%eax
  800298:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80029b:	39 d8                	cmp    %ebx,%eax
  80029d:	74 16                	je     8002b5 <strncmp+0x35>
  80029f:	0f b6 08             	movzbl (%eax),%ecx
  8002a2:	84 c9                	test   %cl,%cl
  8002a4:	74 04                	je     8002aa <strncmp+0x2a>
  8002a6:	3a 0a                	cmp    (%edx),%cl
  8002a8:	74 eb                	je     800295 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002aa:	0f b6 00             	movzbl (%eax),%eax
  8002ad:	0f b6 12             	movzbl (%edx),%edx
  8002b0:	29 d0                	sub    %edx,%eax
}
  8002b2:	5b                   	pop    %ebx
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    
		return 0;
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	eb f6                	jmp    8002b2 <strncmp+0x32>

008002bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002bc:	f3 0f 1e fb          	endbr32 
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ca:	0f b6 10             	movzbl (%eax),%edx
  8002cd:	84 d2                	test   %dl,%dl
  8002cf:	74 09                	je     8002da <strchr+0x1e>
		if (*s == c)
  8002d1:	38 ca                	cmp    %cl,%dl
  8002d3:	74 0a                	je     8002df <strchr+0x23>
	for (; *s; s++)
  8002d5:	83 c0 01             	add    $0x1,%eax
  8002d8:	eb f0                	jmp    8002ca <strchr+0xe>
			return (char *) s;
	return 0;
  8002da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    

008002e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002e1:	f3 0f 1e fb          	endbr32 
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002f2:	38 ca                	cmp    %cl,%dl
  8002f4:	74 09                	je     8002ff <strfind+0x1e>
  8002f6:	84 d2                	test   %dl,%dl
  8002f8:	74 05                	je     8002ff <strfind+0x1e>
	for (; *s; s++)
  8002fa:	83 c0 01             	add    $0x1,%eax
  8002fd:	eb f0                	jmp    8002ef <strfind+0xe>
			break;
	return (char *) s;
}
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800301:	f3 0f 1e fb          	endbr32 
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	8b 55 08             	mov    0x8(%ebp),%edx
  80030e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800311:	85 c9                	test   %ecx,%ecx
  800313:	74 33                	je     800348 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800315:	89 d0                	mov    %edx,%eax
  800317:	09 c8                	or     %ecx,%eax
  800319:	a8 03                	test   $0x3,%al
  80031b:	75 23                	jne    800340 <memset+0x3f>
		c &= 0xFF;
  80031d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800321:	89 d8                	mov    %ebx,%eax
  800323:	c1 e0 08             	shl    $0x8,%eax
  800326:	89 df                	mov    %ebx,%edi
  800328:	c1 e7 18             	shl    $0x18,%edi
  80032b:	89 de                	mov    %ebx,%esi
  80032d:	c1 e6 10             	shl    $0x10,%esi
  800330:	09 f7                	or     %esi,%edi
  800332:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800334:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800337:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800339:	89 d7                	mov    %edx,%edi
  80033b:	fc                   	cld    
  80033c:	f3 ab                	rep stos %eax,%es:(%edi)
  80033e:	eb 08                	jmp    800348 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800340:	89 d7                	mov    %edx,%edi
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	fc                   	cld    
  800346:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800348:	89 d0                	mov    %edx,%eax
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80034f:	f3 0f 1e fb          	endbr32 
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	57                   	push   %edi
  800357:	56                   	push   %esi
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80035e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800361:	39 c6                	cmp    %eax,%esi
  800363:	73 32                	jae    800397 <memmove+0x48>
  800365:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	76 2b                	jbe    800397 <memmove+0x48>
		s += n;
		d += n;
  80036c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80036f:	89 fe                	mov    %edi,%esi
  800371:	09 ce                	or     %ecx,%esi
  800373:	09 d6                	or     %edx,%esi
  800375:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80037b:	75 0e                	jne    80038b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80037d:	83 ef 04             	sub    $0x4,%edi
  800380:	8d 72 fc             	lea    -0x4(%edx),%esi
  800383:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800386:	fd                   	std    
  800387:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800389:	eb 09                	jmp    800394 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80038b:	83 ef 01             	sub    $0x1,%edi
  80038e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800391:	fd                   	std    
  800392:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800394:	fc                   	cld    
  800395:	eb 1a                	jmp    8003b1 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800397:	89 c2                	mov    %eax,%edx
  800399:	09 ca                	or     %ecx,%edx
  80039b:	09 f2                	or     %esi,%edx
  80039d:	f6 c2 03             	test   $0x3,%dl
  8003a0:	75 0a                	jne    8003ac <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8003a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8003a5:	89 c7                	mov    %eax,%edi
  8003a7:	fc                   	cld    
  8003a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8003aa:	eb 05                	jmp    8003b1 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8003ac:	89 c7                	mov    %eax,%edi
  8003ae:	fc                   	cld    
  8003af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003b1:	5e                   	pop    %esi
  8003b2:	5f                   	pop    %edi
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    

008003b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8003b5:	f3 0f 1e fb          	endbr32 
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003bf:	ff 75 10             	pushl  0x10(%ebp)
  8003c2:	ff 75 0c             	pushl  0xc(%ebp)
  8003c5:	ff 75 08             	pushl  0x8(%ebp)
  8003c8:	e8 82 ff ff ff       	call   80034f <memmove>
}
  8003cd:	c9                   	leave  
  8003ce:	c3                   	ret    

008003cf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003cf:	f3 0f 1e fb          	endbr32 
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	56                   	push   %esi
  8003d7:	53                   	push   %ebx
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003de:	89 c6                	mov    %eax,%esi
  8003e0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003e3:	39 f0                	cmp    %esi,%eax
  8003e5:	74 1c                	je     800403 <memcmp+0x34>
		if (*s1 != *s2)
  8003e7:	0f b6 08             	movzbl (%eax),%ecx
  8003ea:	0f b6 1a             	movzbl (%edx),%ebx
  8003ed:	38 d9                	cmp    %bl,%cl
  8003ef:	75 08                	jne    8003f9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003f1:	83 c0 01             	add    $0x1,%eax
  8003f4:	83 c2 01             	add    $0x1,%edx
  8003f7:	eb ea                	jmp    8003e3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8003f9:	0f b6 c1             	movzbl %cl,%eax
  8003fc:	0f b6 db             	movzbl %bl,%ebx
  8003ff:	29 d8                	sub    %ebx,%eax
  800401:	eb 05                	jmp    800408 <memcmp+0x39>
	}

	return 0;
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800408:	5b                   	pop    %ebx
  800409:	5e                   	pop    %esi
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80040c:	f3 0f 1e fb          	endbr32 
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800419:	89 c2                	mov    %eax,%edx
  80041b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80041e:	39 d0                	cmp    %edx,%eax
  800420:	73 09                	jae    80042b <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800422:	38 08                	cmp    %cl,(%eax)
  800424:	74 05                	je     80042b <memfind+0x1f>
	for (; s < ends; s++)
  800426:	83 c0 01             	add    $0x1,%eax
  800429:	eb f3                	jmp    80041e <memfind+0x12>
			break;
	return (void *) s;
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80042d:	f3 0f 1e fb          	endbr32 
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	57                   	push   %edi
  800435:	56                   	push   %esi
  800436:	53                   	push   %ebx
  800437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80043d:	eb 03                	jmp    800442 <strtol+0x15>
		s++;
  80043f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800442:	0f b6 01             	movzbl (%ecx),%eax
  800445:	3c 20                	cmp    $0x20,%al
  800447:	74 f6                	je     80043f <strtol+0x12>
  800449:	3c 09                	cmp    $0x9,%al
  80044b:	74 f2                	je     80043f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80044d:	3c 2b                	cmp    $0x2b,%al
  80044f:	74 2a                	je     80047b <strtol+0x4e>
	int neg = 0;
  800451:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800456:	3c 2d                	cmp    $0x2d,%al
  800458:	74 2b                	je     800485 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80045a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800460:	75 0f                	jne    800471 <strtol+0x44>
  800462:	80 39 30             	cmpb   $0x30,(%ecx)
  800465:	74 28                	je     80048f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800467:	85 db                	test   %ebx,%ebx
  800469:	b8 0a 00 00 00       	mov    $0xa,%eax
  80046e:	0f 44 d8             	cmove  %eax,%ebx
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
  800476:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800479:	eb 46                	jmp    8004c1 <strtol+0x94>
		s++;
  80047b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80047e:	bf 00 00 00 00       	mov    $0x0,%edi
  800483:	eb d5                	jmp    80045a <strtol+0x2d>
		s++, neg = 1;
  800485:	83 c1 01             	add    $0x1,%ecx
  800488:	bf 01 00 00 00       	mov    $0x1,%edi
  80048d:	eb cb                	jmp    80045a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80048f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800493:	74 0e                	je     8004a3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800495:	85 db                	test   %ebx,%ebx
  800497:	75 d8                	jne    800471 <strtol+0x44>
		s++, base = 8;
  800499:	83 c1 01             	add    $0x1,%ecx
  80049c:	bb 08 00 00 00       	mov    $0x8,%ebx
  8004a1:	eb ce                	jmp    800471 <strtol+0x44>
		s += 2, base = 16;
  8004a3:	83 c1 02             	add    $0x2,%ecx
  8004a6:	bb 10 00 00 00       	mov    $0x10,%ebx
  8004ab:	eb c4                	jmp    800471 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8004ad:	0f be d2             	movsbl %dl,%edx
  8004b0:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8004b3:	3b 55 10             	cmp    0x10(%ebp),%edx
  8004b6:	7d 3a                	jge    8004f2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8004b8:	83 c1 01             	add    $0x1,%ecx
  8004bb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8004bf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8004c1:	0f b6 11             	movzbl (%ecx),%edx
  8004c4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c7:	89 f3                	mov    %esi,%ebx
  8004c9:	80 fb 09             	cmp    $0x9,%bl
  8004cc:	76 df                	jbe    8004ad <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8004ce:	8d 72 9f             	lea    -0x61(%edx),%esi
  8004d1:	89 f3                	mov    %esi,%ebx
  8004d3:	80 fb 19             	cmp    $0x19,%bl
  8004d6:	77 08                	ja     8004e0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8004d8:	0f be d2             	movsbl %dl,%edx
  8004db:	83 ea 57             	sub    $0x57,%edx
  8004de:	eb d3                	jmp    8004b3 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8004e0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8004e3:	89 f3                	mov    %esi,%ebx
  8004e5:	80 fb 19             	cmp    $0x19,%bl
  8004e8:	77 08                	ja     8004f2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8004ea:	0f be d2             	movsbl %dl,%edx
  8004ed:	83 ea 37             	sub    $0x37,%edx
  8004f0:	eb c1                	jmp    8004b3 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8004f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f6:	74 05                	je     8004fd <strtol+0xd0>
		*endptr = (char *) s;
  8004f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004fb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004fd:	89 c2                	mov    %eax,%edx
  8004ff:	f7 da                	neg    %edx
  800501:	85 ff                	test   %edi,%edi
  800503:	0f 45 c2             	cmovne %edx,%eax
}
  800506:	5b                   	pop    %ebx
  800507:	5e                   	pop    %esi
  800508:	5f                   	pop    %edi
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	57                   	push   %edi
  80050f:	56                   	push   %esi
  800510:	53                   	push   %ebx
  800511:	83 ec 1c             	sub    $0x1c,%esp
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80051a:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80051c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80051f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800522:	8b 7d 10             	mov    0x10(%ebp),%edi
  800525:	8b 75 14             	mov    0x14(%ebp),%esi
  800528:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80052a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052e:	74 04                	je     800534 <syscall+0x29>
  800530:	85 c0                	test   %eax,%eax
  800532:	7f 08                	jg     80053c <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  800534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800537:	5b                   	pop    %ebx
  800538:	5e                   	pop    %esi
  800539:	5f                   	pop    %edi
  80053a:	5d                   	pop    %ebp
  80053b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	68 af 1e 80 00       	push   $0x801eaf
  800548:	6a 23                	push   $0x23
  80054a:	68 cc 1e 80 00       	push   $0x801ecc
  80054f:	e8 90 0f 00 00       	call   8014e4 <_panic>

00800554 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800554:	f3 0f 1e fb          	endbr32 
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80055e:	6a 00                	push   $0x0
  800560:	6a 00                	push   $0x0
  800562:	6a 00                	push   $0x0
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80056a:	ba 00 00 00 00       	mov    $0x0,%edx
  80056f:	b8 00 00 00 00       	mov    $0x0,%eax
  800574:	e8 92 ff ff ff       	call   80050b <syscall>
}
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <sys_cgetc>:

int
sys_cgetc(void)
{
  80057e:	f3 0f 1e fb          	endbr32 
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800588:	6a 00                	push   $0x0
  80058a:	6a 00                	push   $0x0
  80058c:	6a 00                	push   $0x0
  80058e:	6a 00                	push   $0x0
  800590:	b9 00 00 00 00       	mov    $0x0,%ecx
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	b8 01 00 00 00       	mov    $0x1,%eax
  80059f:	e8 67 ff ff ff       	call   80050b <syscall>
}
  8005a4:	c9                   	leave  
  8005a5:	c3                   	ret    

008005a6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8005a6:	f3 0f 1e fb          	endbr32 
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8005b0:	6a 00                	push   $0x0
  8005b2:	6a 00                	push   $0x0
  8005b4:	6a 00                	push   $0x0
  8005b6:	6a 00                	push   $0x0
  8005b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8005c0:	b8 03 00 00 00       	mov    $0x3,%eax
  8005c5:	e8 41 ff ff ff       	call   80050b <syscall>
}
  8005ca:	c9                   	leave  
  8005cb:	c3                   	ret    

008005cc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8005cc:	f3 0f 1e fb          	endbr32 
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8005d6:	6a 00                	push   $0x0
  8005d8:	6a 00                	push   $0x0
  8005da:	6a 00                	push   $0x0
  8005dc:	6a 00                	push   $0x0
  8005de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8005ed:	e8 19 ff ff ff       	call   80050b <syscall>
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <sys_yield>:

void
sys_yield(void)
{
  8005f4:	f3 0f 1e fb          	endbr32 
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8005fe:	6a 00                	push   $0x0
  800600:	6a 00                	push   $0x0
  800602:	6a 00                	push   $0x0
  800604:	6a 00                	push   $0x0
  800606:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060b:	ba 00 00 00 00       	mov    $0x0,%edx
  800610:	b8 0b 00 00 00       	mov    $0xb,%eax
  800615:	e8 f1 fe ff ff       	call   80050b <syscall>
}
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80061f:	f3 0f 1e fb          	endbr32 
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800629:	6a 00                	push   $0x0
  80062b:	6a 00                	push   $0x0
  80062d:	ff 75 10             	pushl  0x10(%ebp)
  800630:	ff 75 0c             	pushl  0xc(%ebp)
  800633:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800636:	ba 01 00 00 00       	mov    $0x1,%edx
  80063b:	b8 04 00 00 00       	mov    $0x4,%eax
  800640:	e8 c6 fe ff ff       	call   80050b <syscall>
}
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800647:	f3 0f 1e fb          	endbr32 
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800651:	ff 75 18             	pushl  0x18(%ebp)
  800654:	ff 75 14             	pushl  0x14(%ebp)
  800657:	ff 75 10             	pushl  0x10(%ebp)
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800660:	ba 01 00 00 00       	mov    $0x1,%edx
  800665:	b8 05 00 00 00       	mov    $0x5,%eax
  80066a:	e8 9c fe ff ff       	call   80050b <syscall>
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800671:	f3 0f 1e fb          	endbr32 
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80067b:	6a 00                	push   $0x0
  80067d:	6a 00                	push   $0x0
  80067f:	6a 00                	push   $0x0
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800687:	ba 01 00 00 00       	mov    $0x1,%edx
  80068c:	b8 06 00 00 00       	mov    $0x6,%eax
  800691:	e8 75 fe ff ff       	call   80050b <syscall>
}
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800698:	f3 0f 1e fb          	endbr32 
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8006a2:	6a 00                	push   $0x0
  8006a4:	6a 00                	push   $0x0
  8006a6:	6a 00                	push   $0x0
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8006b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b8:	e8 4e fe ff ff       	call   80050b <syscall>
}
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8006bf:	f3 0f 1e fb          	endbr32 
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8006c9:	6a 00                	push   $0x0
  8006cb:	6a 00                	push   $0x0
  8006cd:	6a 00                	push   $0x0
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8006da:	b8 09 00 00 00       	mov    $0x9,%eax
  8006df:	e8 27 fe ff ff       	call   80050b <syscall>
}
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    

008006e6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006e6:	f3 0f 1e fb          	endbr32 
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8006f0:	6a 00                	push   $0x0
  8006f2:	6a 00                	push   $0x0
  8006f4:	6a 00                	push   $0x0
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006fc:	ba 01 00 00 00       	mov    $0x1,%edx
  800701:	b8 0a 00 00 00       	mov    $0xa,%eax
  800706:	e8 00 fe ff ff       	call   80050b <syscall>
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80070d:	f3 0f 1e fb          	endbr32 
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800717:	6a 00                	push   $0x0
  800719:	ff 75 14             	pushl  0x14(%ebp)
  80071c:	ff 75 10             	pushl  0x10(%ebp)
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
  80072a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80072f:	e8 d7 fd ff ff       	call   80050b <syscall>
}
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800736:	f3 0f 1e fb          	endbr32 
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800740:	6a 00                	push   $0x0
  800742:	6a 00                	push   $0x0
  800744:	6a 00                	push   $0x0
  800746:	6a 00                	push   $0x0
  800748:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80074b:	ba 01 00 00 00       	mov    $0x1,%edx
  800750:	b8 0d 00 00 00       	mov    $0xd,%eax
  800755:	e8 b1 fd ff ff       	call   80050b <syscall>
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80075c:	f3 0f 1e fb          	endbr32 
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	05 00 00 00 30       	add    $0x30000000,%eax
  80076b:	c1 e8 0c             	shr    $0xc,%eax
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80077a:	ff 75 08             	pushl  0x8(%ebp)
  80077d:	e8 da ff ff ff       	call   80075c <fd2num>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	c1 e0 0c             	shl    $0xc,%eax
  800788:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80078f:	f3 0f 1e fb          	endbr32 
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80079b:	89 c2                	mov    %eax,%edx
  80079d:	c1 ea 16             	shr    $0x16,%edx
  8007a0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007a7:	f6 c2 01             	test   $0x1,%dl
  8007aa:	74 2d                	je     8007d9 <fd_alloc+0x4a>
  8007ac:	89 c2                	mov    %eax,%edx
  8007ae:	c1 ea 0c             	shr    $0xc,%edx
  8007b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007b8:	f6 c2 01             	test   $0x1,%dl
  8007bb:	74 1c                	je     8007d9 <fd_alloc+0x4a>
  8007bd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007c7:	75 d2                	jne    80079b <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8007d2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8007d7:	eb 0a                	jmp    8007e3 <fd_alloc+0x54>
			*fd_store = fd;
  8007d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007e5:	f3 0f 1e fb          	endbr32 
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007ef:	83 f8 1f             	cmp    $0x1f,%eax
  8007f2:	77 30                	ja     800824 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8007f4:	c1 e0 0c             	shl    $0xc,%eax
  8007f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007fc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800802:	f6 c2 01             	test   $0x1,%dl
  800805:	74 24                	je     80082b <fd_lookup+0x46>
  800807:	89 c2                	mov    %eax,%edx
  800809:	c1 ea 0c             	shr    $0xc,%edx
  80080c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800813:	f6 c2 01             	test   $0x1,%dl
  800816:	74 1a                	je     800832 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081b:	89 02                	mov    %eax,(%edx)
	return 0;
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    
		return -E_INVAL;
  800824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800829:	eb f7                	jmp    800822 <fd_lookup+0x3d>
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb f0                	jmp    800822 <fd_lookup+0x3d>
  800832:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800837:	eb e9                	jmp    800822 <fd_lookup+0x3d>

00800839 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800839:	f3 0f 1e fb          	endbr32 
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800846:	ba 58 1f 80 00       	mov    $0x801f58,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80084b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800850:	39 08                	cmp    %ecx,(%eax)
  800852:	74 33                	je     800887 <dev_lookup+0x4e>
  800854:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800857:	8b 02                	mov    (%edx),%eax
  800859:	85 c0                	test   %eax,%eax
  80085b:	75 f3                	jne    800850 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80085d:	a1 04 40 80 00       	mov    0x804004,%eax
  800862:	8b 40 48             	mov    0x48(%eax),%eax
  800865:	83 ec 04             	sub    $0x4,%esp
  800868:	51                   	push   %ecx
  800869:	50                   	push   %eax
  80086a:	68 dc 1e 80 00       	push   $0x801edc
  80086f:	e8 57 0d 00 00       	call   8015cb <cprintf>
	*dev = 0;
  800874:	8b 45 0c             	mov    0xc(%ebp),%eax
  800877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800885:	c9                   	leave  
  800886:	c3                   	ret    
			*dev = devtab[i];
  800887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	eb f2                	jmp    800885 <dev_lookup+0x4c>

00800893 <fd_close>:
{
  800893:	f3 0f 1e fb          	endbr32 
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	57                   	push   %edi
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	83 ec 28             	sub    $0x28,%esp
  8008a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008a6:	56                   	push   %esi
  8008a7:	e8 b0 fe ff ff       	call   80075c <fd2num>
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8008b2:	52                   	push   %edx
  8008b3:	50                   	push   %eax
  8008b4:	e8 2c ff ff ff       	call   8007e5 <fd_lookup>
  8008b9:	89 c3                	mov    %eax,%ebx
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	85 c0                	test   %eax,%eax
  8008c0:	78 05                	js     8008c7 <fd_close+0x34>
	    || fd != fd2)
  8008c2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008c5:	74 16                	je     8008dd <fd_close+0x4a>
		return (must_exist ? r : 0);
  8008c7:	89 f8                	mov    %edi,%eax
  8008c9:	84 c0                	test   %al,%al
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	0f 44 d8             	cmove  %eax,%ebx
}
  8008d3:	89 d8                	mov    %ebx,%eax
  8008d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5f                   	pop    %edi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008e3:	50                   	push   %eax
  8008e4:	ff 36                	pushl  (%esi)
  8008e6:	e8 4e ff ff ff       	call   800839 <dev_lookup>
  8008eb:	89 c3                	mov    %eax,%ebx
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	78 1a                	js     80090e <fd_close+0x7b>
		if (dev->dev_close)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8008fa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	74 0b                	je     80090e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	56                   	push   %esi
  800907:	ff d0                	call   *%eax
  800909:	89 c3                	mov    %eax,%ebx
  80090b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	56                   	push   %esi
  800912:	6a 00                	push   $0x0
  800914:	e8 58 fd ff ff       	call   800671 <sys_page_unmap>
	return r;
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb b5                	jmp    8008d3 <fd_close+0x40>

0080091e <close>:

int
close(int fdnum)
{
  80091e:	f3 0f 1e fb          	endbr32 
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	ff 75 08             	pushl  0x8(%ebp)
  80092f:	e8 b1 fe ff ff       	call   8007e5 <fd_lookup>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	85 c0                	test   %eax,%eax
  800939:	79 02                	jns    80093d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    
		return fd_close(fd, 1);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	6a 01                	push   $0x1
  800942:	ff 75 f4             	pushl  -0xc(%ebp)
  800945:	e8 49 ff ff ff       	call   800893 <fd_close>
  80094a:	83 c4 10             	add    $0x10,%esp
  80094d:	eb ec                	jmp    80093b <close+0x1d>

0080094f <close_all>:

void
close_all(void)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	53                   	push   %ebx
  800957:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80095a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80095f:	83 ec 0c             	sub    $0xc,%esp
  800962:	53                   	push   %ebx
  800963:	e8 b6 ff ff ff       	call   80091e <close>
	for (i = 0; i < MAXFD; i++)
  800968:	83 c3 01             	add    $0x1,%ebx
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	83 fb 20             	cmp    $0x20,%ebx
  800971:	75 ec                	jne    80095f <close_all+0x10>
}
  800973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800978:	f3 0f 1e fb          	endbr32 
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	57                   	push   %edi
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800985:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800988:	50                   	push   %eax
  800989:	ff 75 08             	pushl  0x8(%ebp)
  80098c:	e8 54 fe ff ff       	call   8007e5 <fd_lookup>
  800991:	89 c3                	mov    %eax,%ebx
  800993:	83 c4 10             	add    $0x10,%esp
  800996:	85 c0                	test   %eax,%eax
  800998:	0f 88 81 00 00 00    	js     800a1f <dup+0xa7>
		return r;
	close(newfdnum);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	e8 75 ff ff ff       	call   80091e <close>

	newfd = INDEX2FD(newfdnum);
  8009a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ac:	c1 e6 0c             	shl    $0xc,%esi
  8009af:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8009b5:	83 c4 04             	add    $0x4,%esp
  8009b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009bb:	e8 b0 fd ff ff       	call   800770 <fd2data>
  8009c0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8009c2:	89 34 24             	mov    %esi,(%esp)
  8009c5:	e8 a6 fd ff ff       	call   800770 <fd2data>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009cf:	89 d8                	mov    %ebx,%eax
  8009d1:	c1 e8 16             	shr    $0x16,%eax
  8009d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009db:	a8 01                	test   $0x1,%al
  8009dd:	74 11                	je     8009f0 <dup+0x78>
  8009df:	89 d8                	mov    %ebx,%eax
  8009e1:	c1 e8 0c             	shr    $0xc,%eax
  8009e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009eb:	f6 c2 01             	test   $0x1,%dl
  8009ee:	75 39                	jne    800a29 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	c1 e8 0c             	shr    $0xc,%eax
  8009f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8009ff:	83 ec 0c             	sub    $0xc,%esp
  800a02:	25 07 0e 00 00       	and    $0xe07,%eax
  800a07:	50                   	push   %eax
  800a08:	56                   	push   %esi
  800a09:	6a 00                	push   $0x0
  800a0b:	52                   	push   %edx
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 34 fc ff ff       	call   800647 <sys_page_map>
  800a13:	89 c3                	mov    %eax,%ebx
  800a15:	83 c4 20             	add    $0x20,%esp
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	78 31                	js     800a4d <dup+0xd5>
		goto err;

	return newfdnum;
  800a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a1f:	89 d8                	mov    %ebx,%eax
  800a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5f                   	pop    %edi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a30:	83 ec 0c             	sub    $0xc,%esp
  800a33:	25 07 0e 00 00       	and    $0xe07,%eax
  800a38:	50                   	push   %eax
  800a39:	57                   	push   %edi
  800a3a:	6a 00                	push   $0x0
  800a3c:	53                   	push   %ebx
  800a3d:	6a 00                	push   $0x0
  800a3f:	e8 03 fc ff ff       	call   800647 <sys_page_map>
  800a44:	89 c3                	mov    %eax,%ebx
  800a46:	83 c4 20             	add    $0x20,%esp
  800a49:	85 c0                	test   %eax,%eax
  800a4b:	79 a3                	jns    8009f0 <dup+0x78>
	sys_page_unmap(0, newfd);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	56                   	push   %esi
  800a51:	6a 00                	push   $0x0
  800a53:	e8 19 fc ff ff       	call   800671 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a58:	83 c4 08             	add    $0x8,%esp
  800a5b:	57                   	push   %edi
  800a5c:	6a 00                	push   $0x0
  800a5e:	e8 0e fc ff ff       	call   800671 <sys_page_unmap>
	return r;
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	eb b7                	jmp    800a1f <dup+0xa7>

00800a68 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a68:	f3 0f 1e fb          	endbr32 
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	53                   	push   %ebx
  800a70:	83 ec 1c             	sub    $0x1c,%esp
  800a73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a79:	50                   	push   %eax
  800a7a:	53                   	push   %ebx
  800a7b:	e8 65 fd ff ff       	call   8007e5 <fd_lookup>
  800a80:	83 c4 10             	add    $0x10,%esp
  800a83:	85 c0                	test   %eax,%eax
  800a85:	78 3f                	js     800ac6 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a91:	ff 30                	pushl  (%eax)
  800a93:	e8 a1 fd ff ff       	call   800839 <dev_lookup>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	85 c0                	test   %eax,%eax
  800a9d:	78 27                	js     800ac6 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aa2:	8b 42 08             	mov    0x8(%edx),%eax
  800aa5:	83 e0 03             	and    $0x3,%eax
  800aa8:	83 f8 01             	cmp    $0x1,%eax
  800aab:	74 1e                	je     800acb <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab0:	8b 40 08             	mov    0x8(%eax),%eax
  800ab3:	85 c0                	test   %eax,%eax
  800ab5:	74 35                	je     800aec <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800ab7:	83 ec 04             	sub    $0x4,%esp
  800aba:	ff 75 10             	pushl  0x10(%ebp)
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	52                   	push   %edx
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
}
  800ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800acb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ad0:	8b 40 48             	mov    0x48(%eax),%eax
  800ad3:	83 ec 04             	sub    $0x4,%esp
  800ad6:	53                   	push   %ebx
  800ad7:	50                   	push   %eax
  800ad8:	68 1d 1f 80 00       	push   $0x801f1d
  800add:	e8 e9 0a 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aea:	eb da                	jmp    800ac6 <read+0x5e>
		return -E_NOT_SUPP;
  800aec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800af1:	eb d3                	jmp    800ac6 <read+0x5e>

00800af3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800af3:	f3 0f 1e fb          	endbr32 
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	57                   	push   %edi
  800afb:	56                   	push   %esi
  800afc:	53                   	push   %ebx
  800afd:	83 ec 0c             	sub    $0xc,%esp
  800b00:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b03:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b0b:	eb 02                	jmp    800b0f <readn+0x1c>
  800b0d:	01 c3                	add    %eax,%ebx
  800b0f:	39 f3                	cmp    %esi,%ebx
  800b11:	73 21                	jae    800b34 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	89 f0                	mov    %esi,%eax
  800b18:	29 d8                	sub    %ebx,%eax
  800b1a:	50                   	push   %eax
  800b1b:	89 d8                	mov    %ebx,%eax
  800b1d:	03 45 0c             	add    0xc(%ebp),%eax
  800b20:	50                   	push   %eax
  800b21:	57                   	push   %edi
  800b22:	e8 41 ff ff ff       	call   800a68 <read>
		if (m < 0)
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	78 04                	js     800b32 <readn+0x3f>
			return m;
		if (m == 0)
  800b2e:	75 dd                	jne    800b0d <readn+0x1a>
  800b30:	eb 02                	jmp    800b34 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b32:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b34:	89 d8                	mov    %ebx,%eax
  800b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b3e:	f3 0f 1e fb          	endbr32 
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	53                   	push   %ebx
  800b46:	83 ec 1c             	sub    $0x1c,%esp
  800b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b4f:	50                   	push   %eax
  800b50:	53                   	push   %ebx
  800b51:	e8 8f fc ff ff       	call   8007e5 <fd_lookup>
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	85 c0                	test   %eax,%eax
  800b5b:	78 3a                	js     800b97 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b63:	50                   	push   %eax
  800b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b67:	ff 30                	pushl  (%eax)
  800b69:	e8 cb fc ff ff       	call   800839 <dev_lookup>
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	85 c0                	test   %eax,%eax
  800b73:	78 22                	js     800b97 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b78:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b7c:	74 1e                	je     800b9c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b81:	8b 52 0c             	mov    0xc(%edx),%edx
  800b84:	85 d2                	test   %edx,%edx
  800b86:	74 35                	je     800bbd <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	ff 75 10             	pushl  0x10(%ebp)
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	50                   	push   %eax
  800b92:	ff d2                	call   *%edx
  800b94:	83 c4 10             	add    $0x10,%esp
}
  800b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b9c:	a1 04 40 80 00       	mov    0x804004,%eax
  800ba1:	8b 40 48             	mov    0x48(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	53                   	push   %ebx
  800ba8:	50                   	push   %eax
  800ba9:	68 39 1f 80 00       	push   $0x801f39
  800bae:	e8 18 0a 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bbb:	eb da                	jmp    800b97 <write+0x59>
		return -E_NOT_SUPP;
  800bbd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800bc2:	eb d3                	jmp    800b97 <write+0x59>

00800bc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 08             	pushl  0x8(%ebp)
  800bd5:	e8 0b fc ff ff       	call   8007e5 <fd_lookup>
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	78 0e                	js     800bef <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bf1:	f3 0f 1e fb          	endbr32 
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 1c             	sub    $0x1c,%esp
  800bfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	53                   	push   %ebx
  800c04:	e8 dc fb ff ff       	call   8007e5 <fd_lookup>
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	78 37                	js     800c47 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c16:	50                   	push   %eax
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	ff 30                	pushl  (%eax)
  800c1c:	e8 18 fc ff ff       	call   800839 <dev_lookup>
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	85 c0                	test   %eax,%eax
  800c26:	78 1f                	js     800c47 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c2f:	74 1b                	je     800c4c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c34:	8b 52 18             	mov    0x18(%edx),%edx
  800c37:	85 d2                	test   %edx,%edx
  800c39:	74 32                	je     800c6d <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	ff d2                	call   *%edx
  800c44:	83 c4 10             	add    $0x10,%esp
}
  800c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c4c:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c51:	8b 40 48             	mov    0x48(%eax),%eax
  800c54:	83 ec 04             	sub    $0x4,%esp
  800c57:	53                   	push   %ebx
  800c58:	50                   	push   %eax
  800c59:	68 fc 1e 80 00       	push   $0x801efc
  800c5e:	e8 68 09 00 00       	call   8015cb <cprintf>
		return -E_INVAL;
  800c63:	83 c4 10             	add    $0x10,%esp
  800c66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c6b:	eb da                	jmp    800c47 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800c6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c72:	eb d3                	jmp    800c47 <ftruncate+0x56>

00800c74 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c74:	f3 0f 1e fb          	endbr32 
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	53                   	push   %ebx
  800c7c:	83 ec 1c             	sub    $0x1c,%esp
  800c7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c82:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c85:	50                   	push   %eax
  800c86:	ff 75 08             	pushl  0x8(%ebp)
  800c89:	e8 57 fb ff ff       	call   8007e5 <fd_lookup>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	85 c0                	test   %eax,%eax
  800c93:	78 4b                	js     800ce0 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c9b:	50                   	push   %eax
  800c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9f:	ff 30                	pushl  (%eax)
  800ca1:	e8 93 fb ff ff       	call   800839 <dev_lookup>
  800ca6:	83 c4 10             	add    $0x10,%esp
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	78 33                	js     800ce0 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800cb4:	74 2f                	je     800ce5 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800cb6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800cb9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800cc0:	00 00 00 
	stat->st_isdir = 0;
  800cc3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cca:	00 00 00 
	stat->st_dev = dev;
  800ccd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	53                   	push   %ebx
  800cd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cda:	ff 50 14             	call   *0x14(%eax)
  800cdd:	83 c4 10             	add    $0x10,%esp
}
  800ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    
		return -E_NOT_SUPP;
  800ce5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cea:	eb f4                	jmp    800ce0 <fstat+0x6c>

00800cec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cec:	f3 0f 1e fb          	endbr32 
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	6a 00                	push   $0x0
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 3a 02 00 00       	call   800f3c <open>
  800d02:	89 c3                	mov    %eax,%ebx
  800d04:	83 c4 10             	add    $0x10,%esp
  800d07:	85 c0                	test   %eax,%eax
  800d09:	78 1b                	js     800d26 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	50                   	push   %eax
  800d12:	e8 5d ff ff ff       	call   800c74 <fstat>
  800d17:	89 c6                	mov    %eax,%esi
	close(fd);
  800d19:	89 1c 24             	mov    %ebx,(%esp)
  800d1c:	e8 fd fb ff ff       	call   80091e <close>
	return r;
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	89 f3                	mov    %esi,%ebx
}
  800d26:	89 d8                	mov    %ebx,%eax
  800d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	89 c6                	mov    %eax,%esi
  800d36:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d38:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d3f:	74 27                	je     800d68 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d41:	6a 07                	push   $0x7
  800d43:	68 00 50 80 00       	push   $0x805000
  800d48:	56                   	push   %esi
  800d49:	ff 35 00 40 80 00    	pushl  0x804000
  800d4f:	e8 0b 0e 00 00       	call   801b5f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d54:	83 c4 0c             	add    $0xc,%esp
  800d57:	6a 00                	push   $0x0
  800d59:	53                   	push   %ebx
  800d5a:	6a 00                	push   $0x0
  800d5c:	e8 91 0d 00 00       	call   801af2 <ipc_recv>
}
  800d61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d68:	83 ec 0c             	sub    $0xc,%esp
  800d6b:	6a 01                	push   $0x1
  800d6d:	e8 45 0e 00 00       	call   801bb7 <ipc_find_env>
  800d72:	a3 00 40 80 00       	mov    %eax,0x804000
  800d77:	83 c4 10             	add    $0x10,%esp
  800d7a:	eb c5                	jmp    800d41 <fsipc+0x12>

00800d7c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d7c:	f3 0f 1e fb          	endbr32 
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 40 0c             	mov    0xc(%eax),%eax
  800d8c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	b8 02 00 00 00       	mov    $0x2,%eax
  800da3:	e8 87 ff ff ff       	call   800d2f <fsipc>
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <devfile_flush>:
{
  800daa:	f3 0f 1e fb          	endbr32 
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8b 40 0c             	mov    0xc(%eax),%eax
  800dba:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc9:	e8 61 ff ff ff       	call   800d2f <fsipc>
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <devfile_stat>:
{
  800dd0:	f3 0f 1e fb          	endbr32 
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8b 40 0c             	mov    0xc(%eax),%eax
  800de4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dee:	b8 05 00 00 00       	mov    $0x5,%eax
  800df3:	e8 37 ff ff ff       	call   800d2f <fsipc>
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	78 2c                	js     800e28 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dfc:	83 ec 08             	sub    $0x8,%esp
  800dff:	68 00 50 80 00       	push   $0x805000
  800e04:	53                   	push   %ebx
  800e05:	e8 8d f3 ff ff       	call   800197 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800e0a:	a1 80 50 80 00       	mov    0x805080,%eax
  800e0f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800e15:	a1 84 50 80 00       	mov    0x805084,%eax
  800e1a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800e20:	83 c4 10             	add    $0x10,%esp
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <devfile_write>:
{
  800e2d:	f3 0f 1e fb          	endbr32 
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	53                   	push   %ebx
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  800e41:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800e46:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800e4c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800e52:	77 30                	ja     800e84 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	53                   	push   %ebx
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	68 08 50 80 00       	push   $0x805008
  800e60:	e8 ea f4 ff ff       	call   80034f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800e65:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e6f:	e8 bb fe ff ff       	call   800d2f <fsipc>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	78 04                	js     800e7f <devfile_write+0x52>
	assert(r <= n);
  800e7b:	39 d8                	cmp    %ebx,%eax
  800e7d:	77 1e                	ja     800e9d <devfile_write+0x70>
}
  800e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800e84:	68 68 1f 80 00       	push   $0x801f68
  800e89:	68 95 1f 80 00       	push   $0x801f95
  800e8e:	68 94 00 00 00       	push   $0x94
  800e93:	68 aa 1f 80 00       	push   $0x801faa
  800e98:	e8 47 06 00 00       	call   8014e4 <_panic>
	assert(r <= n);
  800e9d:	68 b5 1f 80 00       	push   $0x801fb5
  800ea2:	68 95 1f 80 00       	push   $0x801f95
  800ea7:	68 98 00 00 00       	push   $0x98
  800eac:	68 aa 1f 80 00       	push   $0x801faa
  800eb1:	e8 2e 06 00 00       	call   8014e4 <_panic>

00800eb6 <devfile_read>:
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ec8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ecd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed8:	b8 03 00 00 00       	mov    $0x3,%eax
  800edd:	e8 4d fe ff ff       	call   800d2f <fsipc>
  800ee2:	89 c3                	mov    %eax,%ebx
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	78 1f                	js     800f07 <devfile_read+0x51>
	assert(r <= n);
  800ee8:	39 f0                	cmp    %esi,%eax
  800eea:	77 24                	ja     800f10 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800eec:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ef1:	7f 33                	jg     800f26 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	50                   	push   %eax
  800ef7:	68 00 50 80 00       	push   $0x805000
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	e8 4b f4 ff ff       	call   80034f <memmove>
	return r;
  800f04:	83 c4 10             	add    $0x10,%esp
}
  800f07:	89 d8                	mov    %ebx,%eax
  800f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    
	assert(r <= n);
  800f10:	68 b5 1f 80 00       	push   $0x801fb5
  800f15:	68 95 1f 80 00       	push   $0x801f95
  800f1a:	6a 7c                	push   $0x7c
  800f1c:	68 aa 1f 80 00       	push   $0x801faa
  800f21:	e8 be 05 00 00       	call   8014e4 <_panic>
	assert(r <= PGSIZE);
  800f26:	68 bc 1f 80 00       	push   $0x801fbc
  800f2b:	68 95 1f 80 00       	push   $0x801f95
  800f30:	6a 7d                	push   $0x7d
  800f32:	68 aa 1f 80 00       	push   $0x801faa
  800f37:	e8 a8 05 00 00       	call   8014e4 <_panic>

00800f3c <open>:
{
  800f3c:	f3 0f 1e fb          	endbr32 
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 1c             	sub    $0x1c,%esp
  800f48:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f4b:	56                   	push   %esi
  800f4c:	e8 03 f2 ff ff       	call   800154 <strlen>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f59:	7f 6c                	jg     800fc7 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f61:	50                   	push   %eax
  800f62:	e8 28 f8 ff ff       	call   80078f <fd_alloc>
  800f67:	89 c3                	mov    %eax,%ebx
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 3c                	js     800fac <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	56                   	push   %esi
  800f74:	68 00 50 80 00       	push   $0x805000
  800f79:	e8 19 f2 ff ff       	call   800197 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f89:	b8 01 00 00 00       	mov    $0x1,%eax
  800f8e:	e8 9c fd ff ff       	call   800d2f <fsipc>
  800f93:	89 c3                	mov    %eax,%ebx
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	78 19                	js     800fb5 <open+0x79>
	return fd2num(fd);
  800f9c:	83 ec 0c             	sub    $0xc,%esp
  800f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa2:	e8 b5 f7 ff ff       	call   80075c <fd2num>
  800fa7:	89 c3                	mov    %eax,%ebx
  800fa9:	83 c4 10             	add    $0x10,%esp
}
  800fac:	89 d8                	mov    %ebx,%eax
  800fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    
		fd_close(fd, 0);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	6a 00                	push   $0x0
  800fba:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbd:	e8 d1 f8 ff ff       	call   800893 <fd_close>
		return r;
  800fc2:	83 c4 10             	add    $0x10,%esp
  800fc5:	eb e5                	jmp    800fac <open+0x70>
		return -E_BAD_PATH;
  800fc7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800fcc:	eb de                	jmp    800fac <open+0x70>

00800fce <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800fce:	f3 0f 1e fb          	endbr32 
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdd:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe2:	e8 48 fd ff ff       	call   800d2f <fsipc>
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fe9:	f3 0f 1e fb          	endbr32 
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	ff 75 08             	pushl  0x8(%ebp)
  800ffb:	e8 70 f7 ff ff       	call   800770 <fd2data>
  801000:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801002:	83 c4 08             	add    $0x8,%esp
  801005:	68 c8 1f 80 00       	push   $0x801fc8
  80100a:	53                   	push   %ebx
  80100b:	e8 87 f1 ff ff       	call   800197 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801010:	8b 46 04             	mov    0x4(%esi),%eax
  801013:	2b 06                	sub    (%esi),%eax
  801015:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80101b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801022:	00 00 00 
	stat->st_dev = &devpipe;
  801025:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80102c:	30 80 00 
	return 0;
}
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
  801034:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80103b:	f3 0f 1e fb          	endbr32 
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	53                   	push   %ebx
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801049:	53                   	push   %ebx
  80104a:	6a 00                	push   $0x0
  80104c:	e8 20 f6 ff ff       	call   800671 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801051:	89 1c 24             	mov    %ebx,(%esp)
  801054:	e8 17 f7 ff ff       	call   800770 <fd2data>
  801059:	83 c4 08             	add    $0x8,%esp
  80105c:	50                   	push   %eax
  80105d:	6a 00                	push   $0x0
  80105f:	e8 0d f6 ff ff       	call   800671 <sys_page_unmap>
}
  801064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <_pipeisclosed>:
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	83 ec 1c             	sub    $0x1c,%esp
  801072:	89 c7                	mov    %eax,%edi
  801074:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801076:	a1 04 40 80 00       	mov    0x804004,%eax
  80107b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	57                   	push   %edi
  801082:	e8 6d 0b 00 00       	call   801bf4 <pageref>
  801087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80108a:	89 34 24             	mov    %esi,(%esp)
  80108d:	e8 62 0b 00 00       	call   801bf4 <pageref>
		nn = thisenv->env_runs;
  801092:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801098:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	39 cb                	cmp    %ecx,%ebx
  8010a0:	74 1b                	je     8010bd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8010a2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010a5:	75 cf                	jne    801076 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8010a7:	8b 42 58             	mov    0x58(%edx),%eax
  8010aa:	6a 01                	push   $0x1
  8010ac:	50                   	push   %eax
  8010ad:	53                   	push   %ebx
  8010ae:	68 cf 1f 80 00       	push   $0x801fcf
  8010b3:	e8 13 05 00 00       	call   8015cb <cprintf>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	eb b9                	jmp    801076 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8010bd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010c0:	0f 94 c0             	sete   %al
  8010c3:	0f b6 c0             	movzbl %al,%eax
}
  8010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c9:	5b                   	pop    %ebx
  8010ca:	5e                   	pop    %esi
  8010cb:	5f                   	pop    %edi
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <devpipe_write>:
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 28             	sub    $0x28,%esp
  8010db:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010de:	56                   	push   %esi
  8010df:	e8 8c f6 ff ff       	call   800770 <fd2data>
  8010e4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010f1:	74 4f                	je     801142 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010f3:	8b 43 04             	mov    0x4(%ebx),%eax
  8010f6:	8b 0b                	mov    (%ebx),%ecx
  8010f8:	8d 51 20             	lea    0x20(%ecx),%edx
  8010fb:	39 d0                	cmp    %edx,%eax
  8010fd:	72 14                	jb     801113 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8010ff:	89 da                	mov    %ebx,%edx
  801101:	89 f0                	mov    %esi,%eax
  801103:	e8 61 ff ff ff       	call   801069 <_pipeisclosed>
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 3b                	jne    801147 <devpipe_write+0x79>
			sys_yield();
  80110c:	e8 e3 f4 ff ff       	call   8005f4 <sys_yield>
  801111:	eb e0                	jmp    8010f3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801113:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801116:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80111a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80111d:	89 c2                	mov    %eax,%edx
  80111f:	c1 fa 1f             	sar    $0x1f,%edx
  801122:	89 d1                	mov    %edx,%ecx
  801124:	c1 e9 1b             	shr    $0x1b,%ecx
  801127:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80112a:	83 e2 1f             	and    $0x1f,%edx
  80112d:	29 ca                	sub    %ecx,%edx
  80112f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801133:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801137:	83 c0 01             	add    $0x1,%eax
  80113a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80113d:	83 c7 01             	add    $0x1,%edi
  801140:	eb ac                	jmp    8010ee <devpipe_write+0x20>
	return i;
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	eb 05                	jmp    80114c <devpipe_write+0x7e>
				return 0;
  801147:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <devpipe_read>:
{
  801154:	f3 0f 1e fb          	endbr32 
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	83 ec 18             	sub    $0x18,%esp
  801161:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801164:	57                   	push   %edi
  801165:	e8 06 f6 ff ff       	call   800770 <fd2data>
  80116a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	be 00 00 00 00       	mov    $0x0,%esi
  801174:	3b 75 10             	cmp    0x10(%ebp),%esi
  801177:	75 14                	jne    80118d <devpipe_read+0x39>
	return i;
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	eb 02                	jmp    801180 <devpipe_read+0x2c>
				return i;
  80117e:	89 f0                	mov    %esi,%eax
}
  801180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    
			sys_yield();
  801188:	e8 67 f4 ff ff       	call   8005f4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80118d:	8b 03                	mov    (%ebx),%eax
  80118f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801192:	75 18                	jne    8011ac <devpipe_read+0x58>
			if (i > 0)
  801194:	85 f6                	test   %esi,%esi
  801196:	75 e6                	jne    80117e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801198:	89 da                	mov    %ebx,%edx
  80119a:	89 f8                	mov    %edi,%eax
  80119c:	e8 c8 fe ff ff       	call   801069 <_pipeisclosed>
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	74 e3                	je     801188 <devpipe_read+0x34>
				return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	eb d4                	jmp    801180 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8011ac:	99                   	cltd   
  8011ad:	c1 ea 1b             	shr    $0x1b,%edx
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	83 e0 1f             	and    $0x1f,%eax
  8011b5:	29 d0                	sub    %edx,%eax
  8011b7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8011bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bf:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8011c2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8011c5:	83 c6 01             	add    $0x1,%esi
  8011c8:	eb aa                	jmp    801174 <devpipe_read+0x20>

008011ca <pipe>:
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d9:	50                   	push   %eax
  8011da:	e8 b0 f5 ff ff       	call   80078f <fd_alloc>
  8011df:	89 c3                	mov    %eax,%ebx
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	0f 88 23 01 00 00    	js     80130f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	68 07 04 00 00       	push   $0x407
  8011f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f7:	6a 00                	push   $0x0
  8011f9:	e8 21 f4 ff ff       	call   80061f <sys_page_alloc>
  8011fe:	89 c3                	mov    %eax,%ebx
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	0f 88 04 01 00 00    	js     80130f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	e8 78 f5 ff ff       	call   80078f <fd_alloc>
  801217:	89 c3                	mov    %eax,%ebx
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	0f 88 db 00 00 00    	js     8012ff <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	68 07 04 00 00       	push   $0x407
  80122c:	ff 75 f0             	pushl  -0x10(%ebp)
  80122f:	6a 00                	push   $0x0
  801231:	e8 e9 f3 ff ff       	call   80061f <sys_page_alloc>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	0f 88 bc 00 00 00    	js     8012ff <pipe+0x135>
	va = fd2data(fd0);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	ff 75 f4             	pushl  -0xc(%ebp)
  801249:	e8 22 f5 ff ff       	call   800770 <fd2data>
  80124e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801250:	83 c4 0c             	add    $0xc,%esp
  801253:	68 07 04 00 00       	push   $0x407
  801258:	50                   	push   %eax
  801259:	6a 00                	push   $0x0
  80125b:	e8 bf f3 ff ff       	call   80061f <sys_page_alloc>
  801260:	89 c3                	mov    %eax,%ebx
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	0f 88 82 00 00 00    	js     8012ef <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80126d:	83 ec 0c             	sub    $0xc,%esp
  801270:	ff 75 f0             	pushl  -0x10(%ebp)
  801273:	e8 f8 f4 ff ff       	call   800770 <fd2data>
  801278:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80127f:	50                   	push   %eax
  801280:	6a 00                	push   $0x0
  801282:	56                   	push   %esi
  801283:	6a 00                	push   $0x0
  801285:	e8 bd f3 ff ff       	call   800647 <sys_page_map>
  80128a:	89 c3                	mov    %eax,%ebx
  80128c:	83 c4 20             	add    $0x20,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	78 4e                	js     8012e1 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801293:	a1 20 30 80 00       	mov    0x803020,%eax
  801298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80129d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8012ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012af:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8012b6:	83 ec 0c             	sub    $0xc,%esp
  8012b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012bc:	e8 9b f4 ff ff       	call   80075c <fd2num>
  8012c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012c6:	83 c4 04             	add    $0x4,%esp
  8012c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8012cc:	e8 8b f4 ff ff       	call   80075c <fd2num>
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012df:	eb 2e                	jmp    80130f <pipe+0x145>
	sys_page_unmap(0, va);
  8012e1:	83 ec 08             	sub    $0x8,%esp
  8012e4:	56                   	push   %esi
  8012e5:	6a 00                	push   $0x0
  8012e7:	e8 85 f3 ff ff       	call   800671 <sys_page_unmap>
  8012ec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 75 f3 ff ff       	call   800671 <sys_page_unmap>
  8012fc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	ff 75 f4             	pushl  -0xc(%ebp)
  801305:	6a 00                	push   $0x0
  801307:	e8 65 f3 ff ff       	call   800671 <sys_page_unmap>
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	89 d8                	mov    %ebx,%eax
  801311:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801314:	5b                   	pop    %ebx
  801315:	5e                   	pop    %esi
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    

00801318 <pipeisclosed>:
{
  801318:	f3 0f 1e fb          	endbr32 
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	e8 b7 f4 ff ff       	call   8007e5 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 18                	js     80134d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	ff 75 f4             	pushl  -0xc(%ebp)
  80133b:	e8 30 f4 ff ff       	call   800770 <fd2data>
  801340:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801345:	e8 1f fd ff ff       	call   801069 <_pipeisclosed>
  80134a:	83 c4 10             	add    $0x10,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80134f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	c3                   	ret    

00801359 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801359:	f3 0f 1e fb          	endbr32 
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801363:	68 e7 1f 80 00       	push   $0x801fe7
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 27 ee ff ff       	call   800197 <strcpy>
	return 0;
}
  801370:	b8 00 00 00 00       	mov    $0x0,%eax
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <devcons_write>:
{
  801377:	f3 0f 1e fb          	endbr32 
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	57                   	push   %edi
  80137f:	56                   	push   %esi
  801380:	53                   	push   %ebx
  801381:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801387:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80138c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801392:	3b 75 10             	cmp    0x10(%ebp),%esi
  801395:	73 31                	jae    8013c8 <devcons_write+0x51>
		m = n - tot;
  801397:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80139a:	29 f3                	sub    %esi,%ebx
  80139c:	83 fb 7f             	cmp    $0x7f,%ebx
  80139f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013a4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	53                   	push   %ebx
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	03 45 0c             	add    0xc(%ebp),%eax
  8013b0:	50                   	push   %eax
  8013b1:	57                   	push   %edi
  8013b2:	e8 98 ef ff ff       	call   80034f <memmove>
		sys_cputs(buf, m);
  8013b7:	83 c4 08             	add    $0x8,%esp
  8013ba:	53                   	push   %ebx
  8013bb:	57                   	push   %edi
  8013bc:	e8 93 f1 ff ff       	call   800554 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013c1:	01 de                	add    %ebx,%esi
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	eb ca                	jmp    801392 <devcons_write+0x1b>
}
  8013c8:	89 f0                	mov    %esi,%eax
  8013ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5e                   	pop    %esi
  8013cf:	5f                   	pop    %edi
  8013d0:	5d                   	pop    %ebp
  8013d1:	c3                   	ret    

008013d2 <devcons_read>:
{
  8013d2:	f3 0f 1e fb          	endbr32 
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e5:	74 21                	je     801408 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8013e7:	e8 92 f1 ff ff       	call   80057e <sys_cgetc>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	75 07                	jne    8013f7 <devcons_read+0x25>
		sys_yield();
  8013f0:	e8 ff f1 ff ff       	call   8005f4 <sys_yield>
  8013f5:	eb f0                	jmp    8013e7 <devcons_read+0x15>
	if (c < 0)
  8013f7:	78 0f                	js     801408 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8013f9:	83 f8 04             	cmp    $0x4,%eax
  8013fc:	74 0c                	je     80140a <devcons_read+0x38>
	*(char*)vbuf = c;
  8013fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801401:	88 02                	mov    %al,(%edx)
	return 1;
  801403:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    
		return 0;
  80140a:	b8 00 00 00 00       	mov    $0x0,%eax
  80140f:	eb f7                	jmp    801408 <devcons_read+0x36>

00801411 <cputchar>:
{
  801411:	f3 0f 1e fb          	endbr32 
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801421:	6a 01                	push   $0x1
  801423:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801426:	50                   	push   %eax
  801427:	e8 28 f1 ff ff       	call   800554 <sys_cputs>
}
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <getchar>:
{
  801431:	f3 0f 1e fb          	endbr32 
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80143b:	6a 01                	push   $0x1
  80143d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801440:	50                   	push   %eax
  801441:	6a 00                	push   $0x0
  801443:	e8 20 f6 ff ff       	call   800a68 <read>
	if (r < 0)
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 06                	js     801455 <getchar+0x24>
	if (r < 1)
  80144f:	74 06                	je     801457 <getchar+0x26>
	return c;
  801451:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    
		return -E_EOF;
  801457:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80145c:	eb f7                	jmp    801455 <getchar+0x24>

0080145e <iscons>:
{
  80145e:	f3 0f 1e fb          	endbr32 
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	50                   	push   %eax
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	e8 71 f3 ff ff       	call   8007e5 <fd_lookup>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 11                	js     80148c <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801484:	39 10                	cmp    %edx,(%eax)
  801486:	0f 94 c0             	sete   %al
  801489:	0f b6 c0             	movzbl %al,%eax
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <opencons>:
{
  80148e:	f3 0f 1e fb          	endbr32 
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	e8 ee f2 ff ff       	call   80078f <fd_alloc>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 3a                	js     8014e2 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	68 07 04 00 00       	push   $0x407
  8014b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 65 f1 ff ff       	call   80061f <sys_page_alloc>
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 21                	js     8014e2 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8014ca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	50                   	push   %eax
  8014da:	e8 7d f2 ff ff       	call   80075c <fd2num>
  8014df:	83 c4 10             	add    $0x10,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014e4:	f3 0f 1e fb          	endbr32 
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	56                   	push   %esi
  8014ec:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014ed:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014f0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014f6:	e8 d1 f0 ff ff       	call   8005cc <sys_getenvid>
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	56                   	push   %esi
  801505:	50                   	push   %eax
  801506:	68 f4 1f 80 00       	push   $0x801ff4
  80150b:	e8 bb 00 00 00       	call   8015cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801510:	83 c4 18             	add    $0x18,%esp
  801513:	53                   	push   %ebx
  801514:	ff 75 10             	pushl  0x10(%ebp)
  801517:	e8 5a 00 00 00       	call   801576 <vcprintf>
	cprintf("\n");
  80151c:	c7 04 24 3a 23 80 00 	movl   $0x80233a,(%esp)
  801523:	e8 a3 00 00 00       	call   8015cb <cprintf>
  801528:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80152b:	cc                   	int3   
  80152c:	eb fd                	jmp    80152b <_panic+0x47>

0080152e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80152e:	f3 0f 1e fb          	endbr32 
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80153c:	8b 13                	mov    (%ebx),%edx
  80153e:	8d 42 01             	lea    0x1(%edx),%eax
  801541:	89 03                	mov    %eax,(%ebx)
  801543:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801546:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80154a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80154f:	74 09                	je     80155a <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801551:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801558:	c9                   	leave  
  801559:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	68 ff 00 00 00       	push   $0xff
  801562:	8d 43 08             	lea    0x8(%ebx),%eax
  801565:	50                   	push   %eax
  801566:	e8 e9 ef ff ff       	call   800554 <sys_cputs>
		b->idx = 0;
  80156b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	eb db                	jmp    801551 <putch+0x23>

00801576 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801576:	f3 0f 1e fb          	endbr32 
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80158a:	00 00 00 
	b.cnt = 0;
  80158d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	68 2e 15 80 00       	push   $0x80152e
  8015a9:	e8 80 01 00 00       	call   80172e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015ae:	83 c4 08             	add    $0x8,%esp
  8015b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	e8 91 ef ff ff       	call   800554 <sys_cputs>

	return b.cnt;
}
  8015c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015cb:	f3 0f 1e fb          	endbr32 
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015d8:	50                   	push   %eax
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 95 ff ff ff       	call   801576 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	57                   	push   %edi
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 1c             	sub    $0x1c,%esp
  8015ec:	89 c7                	mov    %eax,%edi
  8015ee:	89 d6                	mov    %edx,%esi
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	89 d1                	mov    %edx,%ecx
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801606:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801609:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801610:	39 c2                	cmp    %eax,%edx
  801612:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801615:	72 3e                	jb     801655 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	ff 75 18             	pushl  0x18(%ebp)
  80161d:	83 eb 01             	sub    $0x1,%ebx
  801620:	53                   	push   %ebx
  801621:	50                   	push   %eax
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	ff 75 e4             	pushl  -0x1c(%ebp)
  801628:	ff 75 e0             	pushl  -0x20(%ebp)
  80162b:	ff 75 dc             	pushl  -0x24(%ebp)
  80162e:	ff 75 d8             	pushl  -0x28(%ebp)
  801631:	e8 0a 06 00 00       	call   801c40 <__udivdi3>
  801636:	83 c4 18             	add    $0x18,%esp
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	89 f2                	mov    %esi,%edx
  80163d:	89 f8                	mov    %edi,%eax
  80163f:	e8 9f ff ff ff       	call   8015e3 <printnum>
  801644:	83 c4 20             	add    $0x20,%esp
  801647:	eb 13                	jmp    80165c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	56                   	push   %esi
  80164d:	ff 75 18             	pushl  0x18(%ebp)
  801650:	ff d7                	call   *%edi
  801652:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801655:	83 eb 01             	sub    $0x1,%ebx
  801658:	85 db                	test   %ebx,%ebx
  80165a:	7f ed                	jg     801649 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	56                   	push   %esi
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	ff 75 e4             	pushl  -0x1c(%ebp)
  801666:	ff 75 e0             	pushl  -0x20(%ebp)
  801669:	ff 75 dc             	pushl  -0x24(%ebp)
  80166c:	ff 75 d8             	pushl  -0x28(%ebp)
  80166f:	e8 dc 06 00 00       	call   801d50 <__umoddi3>
  801674:	83 c4 14             	add    $0x14,%esp
  801677:	0f be 80 17 20 80 00 	movsbl 0x802017(%eax),%eax
  80167e:	50                   	push   %eax
  80167f:	ff d7                	call   *%edi
}
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5f                   	pop    %edi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80168c:	83 fa 01             	cmp    $0x1,%edx
  80168f:	7f 13                	jg     8016a4 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801691:	85 d2                	test   %edx,%edx
  801693:	74 1c                	je     8016b1 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801695:	8b 10                	mov    (%eax),%edx
  801697:	8d 4a 04             	lea    0x4(%edx),%ecx
  80169a:	89 08                	mov    %ecx,(%eax)
  80169c:	8b 02                	mov    (%edx),%eax
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  8016a4:	8b 10                	mov    (%eax),%edx
  8016a6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8016a9:	89 08                	mov    %ecx,(%eax)
  8016ab:	8b 02                	mov    (%edx),%eax
  8016ad:	8b 52 04             	mov    0x4(%edx),%edx
  8016b0:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  8016b1:	8b 10                	mov    (%eax),%edx
  8016b3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8016b6:	89 08                	mov    %ecx,(%eax)
  8016b8:	8b 02                	mov    (%edx),%eax
  8016ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016bf:	c3                   	ret    

008016c0 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8016c0:	83 fa 01             	cmp    $0x1,%edx
  8016c3:	7f 0f                	jg     8016d4 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8016c5:	85 d2                	test   %edx,%edx
  8016c7:	74 18                	je     8016e1 <getint+0x21>
		return va_arg(*ap, long);
  8016c9:	8b 10                	mov    (%eax),%edx
  8016cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8016ce:	89 08                	mov    %ecx,(%eax)
  8016d0:	8b 02                	mov    (%edx),%eax
  8016d2:	99                   	cltd   
  8016d3:	c3                   	ret    
		return va_arg(*ap, long long);
  8016d4:	8b 10                	mov    (%eax),%edx
  8016d6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8016d9:	89 08                	mov    %ecx,(%eax)
  8016db:	8b 02                	mov    (%edx),%eax
  8016dd:	8b 52 04             	mov    0x4(%edx),%edx
  8016e0:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8016e1:	8b 10                	mov    (%eax),%edx
  8016e3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8016e6:	89 08                	mov    %ecx,(%eax)
  8016e8:	8b 02                	mov    (%edx),%eax
  8016ea:	99                   	cltd   
}
  8016eb:	c3                   	ret    

008016ec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016ec:	f3 0f 1e fb          	endbr32 
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8016f6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8016fa:	8b 10                	mov    (%eax),%edx
  8016fc:	3b 50 04             	cmp    0x4(%eax),%edx
  8016ff:	73 0a                	jae    80170b <sprintputch+0x1f>
		*b->buf++ = ch;
  801701:	8d 4a 01             	lea    0x1(%edx),%ecx
  801704:	89 08                	mov    %ecx,(%eax)
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	88 02                	mov    %al,(%edx)
}
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <printfmt>:
{
  80170d:	f3 0f 1e fb          	endbr32 
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801717:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80171a:	50                   	push   %eax
  80171b:	ff 75 10             	pushl  0x10(%ebp)
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	e8 05 00 00 00       	call   80172e <vprintfmt>
}
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <vprintfmt>:
{
  80172e:	f3 0f 1e fb          	endbr32 
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 2c             	sub    $0x2c,%esp
  80173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80173e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801741:	8b 7d 10             	mov    0x10(%ebp),%edi
  801744:	e9 86 02 00 00       	jmp    8019cf <vprintfmt+0x2a1>
		padc = ' ';
  801749:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80174d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801754:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80175b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801767:	8d 47 01             	lea    0x1(%edi),%eax
  80176a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80176d:	0f b6 17             	movzbl (%edi),%edx
  801770:	8d 42 dd             	lea    -0x23(%edx),%eax
  801773:	3c 55                	cmp    $0x55,%al
  801775:	0f 87 df 02 00 00    	ja     801a5a <vprintfmt+0x32c>
  80177b:	0f b6 c0             	movzbl %al,%eax
  80177e:	3e ff 24 85 60 21 80 	notrack jmp *0x802160(,%eax,4)
  801785:	00 
  801786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801789:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80178d:	eb d8                	jmp    801767 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80178f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801792:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801796:	eb cf                	jmp    801767 <vprintfmt+0x39>
  801798:	0f b6 d2             	movzbl %dl,%edx
  80179b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8017a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8017a9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8017ad:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8017b0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8017b3:	83 f9 09             	cmp    $0x9,%ecx
  8017b6:	77 52                	ja     80180a <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  8017b8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8017bb:	eb e9                	jmp    8017a6 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8017bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c0:	8d 50 04             	lea    0x4(%eax),%edx
  8017c3:	89 55 14             	mov    %edx,0x14(%ebp)
  8017c6:	8b 00                	mov    (%eax),%eax
  8017c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8017ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d2:	79 93                	jns    801767 <vprintfmt+0x39>
				width = precision, precision = -1;
  8017d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8017e1:	eb 84                	jmp    801767 <vprintfmt+0x39>
  8017e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ed:	0f 49 d0             	cmovns %eax,%edx
  8017f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8017f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017f6:	e9 6c ff ff ff       	jmp    801767 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017fe:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801805:	e9 5d ff ff ff       	jmp    801767 <vprintfmt+0x39>
  80180a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80180d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801810:	eb bc                	jmp    8017ce <vprintfmt+0xa0>
			lflag++;
  801812:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801815:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801818:	e9 4a ff ff ff       	jmp    801767 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80181d:	8b 45 14             	mov    0x14(%ebp),%eax
  801820:	8d 50 04             	lea    0x4(%eax),%edx
  801823:	89 55 14             	mov    %edx,0x14(%ebp)
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	56                   	push   %esi
  80182a:	ff 30                	pushl  (%eax)
  80182c:	ff d3                	call   *%ebx
			break;
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	e9 96 01 00 00       	jmp    8019cc <vprintfmt+0x29e>
			err = va_arg(ap, int);
  801836:	8b 45 14             	mov    0x14(%ebp),%eax
  801839:	8d 50 04             	lea    0x4(%eax),%edx
  80183c:	89 55 14             	mov    %edx,0x14(%ebp)
  80183f:	8b 00                	mov    (%eax),%eax
  801841:	99                   	cltd   
  801842:	31 d0                	xor    %edx,%eax
  801844:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801846:	83 f8 0f             	cmp    $0xf,%eax
  801849:	7f 20                	jg     80186b <vprintfmt+0x13d>
  80184b:	8b 14 85 c0 22 80 00 	mov    0x8022c0(,%eax,4),%edx
  801852:	85 d2                	test   %edx,%edx
  801854:	74 15                	je     80186b <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801856:	52                   	push   %edx
  801857:	68 a7 1f 80 00       	push   $0x801fa7
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	e8 aa fe ff ff       	call   80170d <printfmt>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	e9 61 01 00 00       	jmp    8019cc <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80186b:	50                   	push   %eax
  80186c:	68 2f 20 80 00       	push   $0x80202f
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
  801873:	e8 95 fe ff ff       	call   80170d <printfmt>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	e9 4c 01 00 00       	jmp    8019cc <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  801880:	8b 45 14             	mov    0x14(%ebp),%eax
  801883:	8d 50 04             	lea    0x4(%eax),%edx
  801886:	89 55 14             	mov    %edx,0x14(%ebp)
  801889:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80188b:	85 c9                	test   %ecx,%ecx
  80188d:	b8 28 20 80 00       	mov    $0x802028,%eax
  801892:	0f 45 c1             	cmovne %ecx,%eax
  801895:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801898:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80189c:	7e 06                	jle    8018a4 <vprintfmt+0x176>
  80189e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8018a2:	75 0d                	jne    8018b1 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018a7:	89 c7                	mov    %eax,%edi
  8018a9:	03 45 e0             	add    -0x20(%ebp),%eax
  8018ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018af:	eb 57                	jmp    801908 <vprintfmt+0x1da>
  8018b1:	83 ec 08             	sub    $0x8,%esp
  8018b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8018b7:	ff 75 cc             	pushl  -0x34(%ebp)
  8018ba:	e8 b1 e8 ff ff       	call   800170 <strnlen>
  8018bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c2:	29 c2                	sub    %eax,%edx
  8018c4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018c7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8018ca:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8018ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8018d1:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8018d3:	85 db                	test   %ebx,%ebx
  8018d5:	7e 10                	jle    8018e7 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	56                   	push   %esi
  8018db:	57                   	push   %edi
  8018dc:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8018df:	83 eb 01             	sub    $0x1,%ebx
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	eb ec                	jmp    8018d3 <vprintfmt+0x1a5>
  8018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018ed:	85 d2                	test   %edx,%edx
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f4:	0f 49 c2             	cmovns %edx,%eax
  8018f7:	29 c2                	sub    %eax,%edx
  8018f9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018fc:	eb a6                	jmp    8018a4 <vprintfmt+0x176>
					putch(ch, putdat);
  8018fe:	83 ec 08             	sub    $0x8,%esp
  801901:	56                   	push   %esi
  801902:	52                   	push   %edx
  801903:	ff d3                	call   *%ebx
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80190b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80190d:	83 c7 01             	add    $0x1,%edi
  801910:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801914:	0f be d0             	movsbl %al,%edx
  801917:	85 d2                	test   %edx,%edx
  801919:	74 42                	je     80195d <vprintfmt+0x22f>
  80191b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80191f:	78 06                	js     801927 <vprintfmt+0x1f9>
  801921:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801925:	78 1e                	js     801945 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  801927:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80192b:	74 d1                	je     8018fe <vprintfmt+0x1d0>
  80192d:	0f be c0             	movsbl %al,%eax
  801930:	83 e8 20             	sub    $0x20,%eax
  801933:	83 f8 5e             	cmp    $0x5e,%eax
  801936:	76 c6                	jbe    8018fe <vprintfmt+0x1d0>
					putch('?', putdat);
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	56                   	push   %esi
  80193c:	6a 3f                	push   $0x3f
  80193e:	ff d3                	call   *%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb c3                	jmp    801908 <vprintfmt+0x1da>
  801945:	89 cf                	mov    %ecx,%edi
  801947:	eb 0e                	jmp    801957 <vprintfmt+0x229>
				putch(' ', putdat);
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	56                   	push   %esi
  80194d:	6a 20                	push   $0x20
  80194f:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  801951:	83 ef 01             	sub    $0x1,%edi
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 ff                	test   %edi,%edi
  801959:	7f ee                	jg     801949 <vprintfmt+0x21b>
  80195b:	eb 6f                	jmp    8019cc <vprintfmt+0x29e>
  80195d:	89 cf                	mov    %ecx,%edi
  80195f:	eb f6                	jmp    801957 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801961:	89 ca                	mov    %ecx,%edx
  801963:	8d 45 14             	lea    0x14(%ebp),%eax
  801966:	e8 55 fd ff ff       	call   8016c0 <getint>
  80196b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801971:	85 d2                	test   %edx,%edx
  801973:	78 0b                	js     801980 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801975:	89 d1                	mov    %edx,%ecx
  801977:	89 c2                	mov    %eax,%edx
			base = 10;
  801979:	b8 0a 00 00 00       	mov    $0xa,%eax
  80197e:	eb 32                	jmp    8019b2 <vprintfmt+0x284>
				putch('-', putdat);
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	56                   	push   %esi
  801984:	6a 2d                	push   $0x2d
  801986:	ff d3                	call   *%ebx
				num = -(long long) num;
  801988:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80198b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80198e:	f7 da                	neg    %edx
  801990:	83 d1 00             	adc    $0x0,%ecx
  801993:	f7 d9                	neg    %ecx
  801995:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801998:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199d:	eb 13                	jmp    8019b2 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80199f:	89 ca                	mov    %ecx,%edx
  8019a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8019a4:	e8 e3 fc ff ff       	call   80168c <getuint>
  8019a9:	89 d1                	mov    %edx,%ecx
  8019ab:	89 c2                	mov    %eax,%edx
			base = 10;
  8019ad:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  8019b2:	83 ec 0c             	sub    $0xc,%esp
  8019b5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8019b9:	57                   	push   %edi
  8019ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8019bd:	50                   	push   %eax
  8019be:	51                   	push   %ecx
  8019bf:	52                   	push   %edx
  8019c0:	89 f2                	mov    %esi,%edx
  8019c2:	89 d8                	mov    %ebx,%eax
  8019c4:	e8 1a fc ff ff       	call   8015e3 <printnum>
			break;
  8019c9:	83 c4 20             	add    $0x20,%esp
{
  8019cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019cf:	83 c7 01             	add    $0x1,%edi
  8019d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8019d6:	83 f8 25             	cmp    $0x25,%eax
  8019d9:	0f 84 6a fd ff ff    	je     801749 <vprintfmt+0x1b>
			if (ch == '\0')
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	0f 84 93 00 00 00    	je     801a7a <vprintfmt+0x34c>
			putch(ch, putdat);
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	56                   	push   %esi
  8019eb:	50                   	push   %eax
  8019ec:	ff d3                	call   *%ebx
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	eb dc                	jmp    8019cf <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8019f3:	89 ca                	mov    %ecx,%edx
  8019f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019f8:	e8 8f fc ff ff       	call   80168c <getuint>
  8019fd:	89 d1                	mov    %edx,%ecx
  8019ff:	89 c2                	mov    %eax,%edx
			base = 8;
  801a01:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  801a06:	eb aa                	jmp    8019b2 <vprintfmt+0x284>
			putch('0', putdat);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	56                   	push   %esi
  801a0c:	6a 30                	push   $0x30
  801a0e:	ff d3                	call   *%ebx
			putch('x', putdat);
  801a10:	83 c4 08             	add    $0x8,%esp
  801a13:	56                   	push   %esi
  801a14:	6a 78                	push   $0x78
  801a16:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	8d 50 04             	lea    0x4(%eax),%edx
  801a1e:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  801a21:	8b 10                	mov    (%eax),%edx
  801a23:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a28:	83 c4 10             	add    $0x10,%esp
			base = 16;
  801a2b:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  801a30:	eb 80                	jmp    8019b2 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801a32:	89 ca                	mov    %ecx,%edx
  801a34:	8d 45 14             	lea    0x14(%ebp),%eax
  801a37:	e8 50 fc ff ff       	call   80168c <getuint>
  801a3c:	89 d1                	mov    %edx,%ecx
  801a3e:	89 c2                	mov    %eax,%edx
			base = 16;
  801a40:	b8 10 00 00 00       	mov    $0x10,%eax
  801a45:	e9 68 ff ff ff       	jmp    8019b2 <vprintfmt+0x284>
			putch(ch, putdat);
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	56                   	push   %esi
  801a4e:	6a 25                	push   $0x25
  801a50:	ff d3                	call   *%ebx
			break;
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	e9 72 ff ff ff       	jmp    8019cc <vprintfmt+0x29e>
			putch('%', putdat);
  801a5a:	83 ec 08             	sub    $0x8,%esp
  801a5d:	56                   	push   %esi
  801a5e:	6a 25                	push   $0x25
  801a60:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	89 f8                	mov    %edi,%eax
  801a67:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801a6b:	74 05                	je     801a72 <vprintfmt+0x344>
  801a6d:	83 e8 01             	sub    $0x1,%eax
  801a70:	eb f5                	jmp    801a67 <vprintfmt+0x339>
  801a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a75:	e9 52 ff ff ff       	jmp    8019cc <vprintfmt+0x29e>
}
  801a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5e                   	pop    %esi
  801a7f:	5f                   	pop    %edi
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    

00801a82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a82:	f3 0f 1e fb          	endbr32 
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 18             	sub    $0x18,%esp
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a95:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801a99:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801a9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	74 26                	je     801acd <vsnprintf+0x4b>
  801aa7:	85 d2                	test   %edx,%edx
  801aa9:	7e 22                	jle    801acd <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801aab:	ff 75 14             	pushl  0x14(%ebp)
  801aae:	ff 75 10             	pushl  0x10(%ebp)
  801ab1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ab4:	50                   	push   %eax
  801ab5:	68 ec 16 80 00       	push   $0x8016ec
  801aba:	e8 6f fc ff ff       	call   80172e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	83 c4 10             	add    $0x10,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    
		return -E_INVAL;
  801acd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad2:	eb f7                	jmp    801acb <vsnprintf+0x49>

00801ad4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ad4:	f3 0f 1e fb          	endbr32 
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ade:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 10             	pushl  0x10(%ebp)
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	e8 92 ff ff ff       	call   801a82 <vsnprintf>
	va_end(ap);

	return rc;
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801af2:	f3 0f 1e fb          	endbr32 
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	56                   	push   %esi
  801afa:	53                   	push   %ebx
  801afb:	8b 75 08             	mov    0x8(%ebp),%esi
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b04:	85 c0                	test   %eax,%eax
  801b06:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b0b:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	50                   	push   %eax
  801b12:	e8 1f ec ff ff       	call   800736 <sys_ipc_recv>
	if (r < 0) {
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 2b                	js     801b49 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b1e:	85 f6                	test   %esi,%esi
  801b20:	74 0a                	je     801b2c <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b22:	a1 04 40 80 00       	mov    0x804004,%eax
  801b27:	8b 40 74             	mov    0x74(%eax),%eax
  801b2a:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801b2c:	85 db                	test   %ebx,%ebx
  801b2e:	74 0a                	je     801b3a <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801b30:	a1 04 40 80 00       	mov    0x804004,%eax
  801b35:	8b 40 78             	mov    0x78(%eax),%eax
  801b38:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801b3a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    
		if (from_env_store) {
  801b49:	85 f6                	test   %esi,%esi
  801b4b:	74 06                	je     801b53 <ipc_recv+0x61>
			*from_env_store = 0;
  801b4d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b53:	85 db                	test   %ebx,%ebx
  801b55:	74 eb                	je     801b42 <ipc_recv+0x50>
			*perm_store = 0;
  801b57:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b5d:	eb e3                	jmp    801b42 <ipc_recv+0x50>

00801b5f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b5f:	f3 0f 1e fb          	endbr32 
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	57                   	push   %edi
  801b67:	56                   	push   %esi
  801b68:	53                   	push   %ebx
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b75:	85 db                	test   %ebx,%ebx
  801b77:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b7c:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b7f:	ff 75 14             	pushl  0x14(%ebp)
  801b82:	53                   	push   %ebx
  801b83:	56                   	push   %esi
  801b84:	57                   	push   %edi
  801b85:	e8 83 eb ff ff       	call   80070d <sys_ipc_try_send>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b90:	75 07                	jne    801b99 <ipc_send+0x3a>
		sys_yield();
  801b92:	e8 5d ea ff ff       	call   8005f4 <sys_yield>
  801b97:	eb e6                	jmp    801b7f <ipc_send+0x20>
	}

	if (ret < 0) {
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 08                	js     801ba5 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801ba5:	50                   	push   %eax
  801ba6:	68 1f 23 80 00       	push   $0x80231f
  801bab:	6a 48                	push   $0x48
  801bad:	68 3c 23 80 00       	push   $0x80233c
  801bb2:	e8 2d f9 ff ff       	call   8014e4 <_panic>

00801bb7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bb7:	f3 0f 1e fb          	endbr32 
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bc6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bc9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801bcf:	8b 52 50             	mov    0x50(%edx),%edx
  801bd2:	39 ca                	cmp    %ecx,%edx
  801bd4:	74 11                	je     801be7 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801bd6:	83 c0 01             	add    $0x1,%eax
  801bd9:	3d 00 04 00 00       	cmp    $0x400,%eax
  801bde:	75 e6                	jne    801bc6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
  801be5:	eb 0b                	jmp    801bf2 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801be7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bef:	8b 40 48             	mov    0x48(%eax),%eax
}
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    

00801bf4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bf4:	f3 0f 1e fb          	endbr32 
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bfe:	89 c2                	mov    %eax,%edx
  801c00:	c1 ea 16             	shr    $0x16,%edx
  801c03:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c0f:	f6 c1 01             	test   $0x1,%cl
  801c12:	74 1c                	je     801c30 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c14:	c1 e8 0c             	shr    $0xc,%eax
  801c17:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c1e:	a8 01                	test   $0x1,%al
  801c20:	74 0e                	je     801c30 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c22:	c1 e8 0c             	shr    $0xc,%eax
  801c25:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c2c:	ef 
  801c2d:	0f b7 d2             	movzwl %dx,%edx
}
  801c30:	89 d0                	mov    %edx,%eax
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	66 90                	xchg   %ax,%ax
  801c36:	66 90                	xchg   %ax,%ax
  801c38:	66 90                	xchg   %ax,%ax
  801c3a:	66 90                	xchg   %ax,%ax
  801c3c:	66 90                	xchg   %ax,%ax
  801c3e:	66 90                	xchg   %ax,%ax

00801c40 <__udivdi3>:
  801c40:	f3 0f 1e fb          	endbr32 
  801c44:	55                   	push   %ebp
  801c45:	57                   	push   %edi
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	83 ec 1c             	sub    $0x1c,%esp
  801c4b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	75 19                	jne    801c78 <__udivdi3+0x38>
  801c5f:	39 f3                	cmp    %esi,%ebx
  801c61:	76 4d                	jbe    801cb0 <__udivdi3+0x70>
  801c63:	31 ff                	xor    %edi,%edi
  801c65:	89 e8                	mov    %ebp,%eax
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	f7 f3                	div    %ebx
  801c6b:	89 fa                	mov    %edi,%edx
  801c6d:	83 c4 1c             	add    $0x1c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
  801c75:	8d 76 00             	lea    0x0(%esi),%esi
  801c78:	39 f2                	cmp    %esi,%edx
  801c7a:	76 14                	jbe    801c90 <__udivdi3+0x50>
  801c7c:	31 ff                	xor    %edi,%edi
  801c7e:	31 c0                	xor    %eax,%eax
  801c80:	89 fa                	mov    %edi,%edx
  801c82:	83 c4 1c             	add    $0x1c,%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
  801c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c90:	0f bd fa             	bsr    %edx,%edi
  801c93:	83 f7 1f             	xor    $0x1f,%edi
  801c96:	75 48                	jne    801ce0 <__udivdi3+0xa0>
  801c98:	39 f2                	cmp    %esi,%edx
  801c9a:	72 06                	jb     801ca2 <__udivdi3+0x62>
  801c9c:	31 c0                	xor    %eax,%eax
  801c9e:	39 eb                	cmp    %ebp,%ebx
  801ca0:	77 de                	ja     801c80 <__udivdi3+0x40>
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	eb d7                	jmp    801c80 <__udivdi3+0x40>
  801ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	89 d9                	mov    %ebx,%ecx
  801cb2:	85 db                	test   %ebx,%ebx
  801cb4:	75 0b                	jne    801cc1 <__udivdi3+0x81>
  801cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f3                	div    %ebx
  801cbf:	89 c1                	mov    %eax,%ecx
  801cc1:	31 d2                	xor    %edx,%edx
  801cc3:	89 f0                	mov    %esi,%eax
  801cc5:	f7 f1                	div    %ecx
  801cc7:	89 c6                	mov    %eax,%esi
  801cc9:	89 e8                	mov    %ebp,%eax
  801ccb:	89 f7                	mov    %esi,%edi
  801ccd:	f7 f1                	div    %ecx
  801ccf:	89 fa                	mov    %edi,%edx
  801cd1:	83 c4 1c             	add    $0x1c,%esp
  801cd4:	5b                   	pop    %ebx
  801cd5:	5e                   	pop    %esi
  801cd6:	5f                   	pop    %edi
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    
  801cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ce0:	89 f9                	mov    %edi,%ecx
  801ce2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ce7:	29 f8                	sub    %edi,%eax
  801ce9:	d3 e2                	shl    %cl,%edx
  801ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cef:	89 c1                	mov    %eax,%ecx
  801cf1:	89 da                	mov    %ebx,%edx
  801cf3:	d3 ea                	shr    %cl,%edx
  801cf5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801cf9:	09 d1                	or     %edx,%ecx
  801cfb:	89 f2                	mov    %esi,%edx
  801cfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	d3 e3                	shl    %cl,%ebx
  801d05:	89 c1                	mov    %eax,%ecx
  801d07:	d3 ea                	shr    %cl,%edx
  801d09:	89 f9                	mov    %edi,%ecx
  801d0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d0f:	89 eb                	mov    %ebp,%ebx
  801d11:	d3 e6                	shl    %cl,%esi
  801d13:	89 c1                	mov    %eax,%ecx
  801d15:	d3 eb                	shr    %cl,%ebx
  801d17:	09 de                	or     %ebx,%esi
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	f7 74 24 08          	divl   0x8(%esp)
  801d1f:	89 d6                	mov    %edx,%esi
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	f7 64 24 0c          	mull   0xc(%esp)
  801d27:	39 d6                	cmp    %edx,%esi
  801d29:	72 15                	jb     801d40 <__udivdi3+0x100>
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e5                	shl    %cl,%ebp
  801d2f:	39 c5                	cmp    %eax,%ebp
  801d31:	73 04                	jae    801d37 <__udivdi3+0xf7>
  801d33:	39 d6                	cmp    %edx,%esi
  801d35:	74 09                	je     801d40 <__udivdi3+0x100>
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	31 ff                	xor    %edi,%edi
  801d3b:	e9 40 ff ff ff       	jmp    801c80 <__udivdi3+0x40>
  801d40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 36 ff ff ff       	jmp    801c80 <__udivdi3+0x40>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	66 90                	xchg   %ax,%ax
  801d4e:	66 90                	xchg   %ax,%ax

00801d50 <__umoddi3>:
  801d50:	f3 0f 1e fb          	endbr32 
  801d54:	55                   	push   %ebp
  801d55:	57                   	push   %edi
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	83 ec 1c             	sub    $0x1c,%esp
  801d5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d63:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	75 19                	jne    801d88 <__umoddi3+0x38>
  801d6f:	39 df                	cmp    %ebx,%edi
  801d71:	76 5d                	jbe    801dd0 <__umoddi3+0x80>
  801d73:	89 f0                	mov    %esi,%eax
  801d75:	89 da                	mov    %ebx,%edx
  801d77:	f7 f7                	div    %edi
  801d79:	89 d0                	mov    %edx,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	83 c4 1c             	add    $0x1c,%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    
  801d85:	8d 76 00             	lea    0x0(%esi),%esi
  801d88:	89 f2                	mov    %esi,%edx
  801d8a:	39 d8                	cmp    %ebx,%eax
  801d8c:	76 12                	jbe    801da0 <__umoddi3+0x50>
  801d8e:	89 f0                	mov    %esi,%eax
  801d90:	89 da                	mov    %ebx,%edx
  801d92:	83 c4 1c             	add    $0x1c,%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5f                   	pop    %edi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    
  801d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801da0:	0f bd e8             	bsr    %eax,%ebp
  801da3:	83 f5 1f             	xor    $0x1f,%ebp
  801da6:	75 50                	jne    801df8 <__umoddi3+0xa8>
  801da8:	39 d8                	cmp    %ebx,%eax
  801daa:	0f 82 e0 00 00 00    	jb     801e90 <__umoddi3+0x140>
  801db0:	89 d9                	mov    %ebx,%ecx
  801db2:	39 f7                	cmp    %esi,%edi
  801db4:	0f 86 d6 00 00 00    	jbe    801e90 <__umoddi3+0x140>
  801dba:	89 d0                	mov    %edx,%eax
  801dbc:	89 ca                	mov    %ecx,%edx
  801dbe:	83 c4 1c             	add    $0x1c,%esp
  801dc1:	5b                   	pop    %ebx
  801dc2:	5e                   	pop    %esi
  801dc3:	5f                   	pop    %edi
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    
  801dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dcd:	8d 76 00             	lea    0x0(%esi),%esi
  801dd0:	89 fd                	mov    %edi,%ebp
  801dd2:	85 ff                	test   %edi,%edi
  801dd4:	75 0b                	jne    801de1 <__umoddi3+0x91>
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	f7 f7                	div    %edi
  801ddf:	89 c5                	mov    %eax,%ebp
  801de1:	89 d8                	mov    %ebx,%eax
  801de3:	31 d2                	xor    %edx,%edx
  801de5:	f7 f5                	div    %ebp
  801de7:	89 f0                	mov    %esi,%eax
  801de9:	f7 f5                	div    %ebp
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	31 d2                	xor    %edx,%edx
  801def:	eb 8c                	jmp    801d7d <__umoddi3+0x2d>
  801df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801df8:	89 e9                	mov    %ebp,%ecx
  801dfa:	ba 20 00 00 00       	mov    $0x20,%edx
  801dff:	29 ea                	sub    %ebp,%edx
  801e01:	d3 e0                	shl    %cl,%eax
  801e03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e07:	89 d1                	mov    %edx,%ecx
  801e09:	89 f8                	mov    %edi,%eax
  801e0b:	d3 e8                	shr    %cl,%eax
  801e0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e11:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e15:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e19:	09 c1                	or     %eax,%ecx
  801e1b:	89 d8                	mov    %ebx,%eax
  801e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e7                	shl    %cl,%edi
  801e25:	89 d1                	mov    %edx,%ecx
  801e27:	d3 e8                	shr    %cl,%eax
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e2f:	d3 e3                	shl    %cl,%ebx
  801e31:	89 c7                	mov    %eax,%edi
  801e33:	89 d1                	mov    %edx,%ecx
  801e35:	89 f0                	mov    %esi,%eax
  801e37:	d3 e8                	shr    %cl,%eax
  801e39:	89 e9                	mov    %ebp,%ecx
  801e3b:	89 fa                	mov    %edi,%edx
  801e3d:	d3 e6                	shl    %cl,%esi
  801e3f:	09 d8                	or     %ebx,%eax
  801e41:	f7 74 24 08          	divl   0x8(%esp)
  801e45:	89 d1                	mov    %edx,%ecx
  801e47:	89 f3                	mov    %esi,%ebx
  801e49:	f7 64 24 0c          	mull   0xc(%esp)
  801e4d:	89 c6                	mov    %eax,%esi
  801e4f:	89 d7                	mov    %edx,%edi
  801e51:	39 d1                	cmp    %edx,%ecx
  801e53:	72 06                	jb     801e5b <__umoddi3+0x10b>
  801e55:	75 10                	jne    801e67 <__umoddi3+0x117>
  801e57:	39 c3                	cmp    %eax,%ebx
  801e59:	73 0c                	jae    801e67 <__umoddi3+0x117>
  801e5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e63:	89 d7                	mov    %edx,%edi
  801e65:	89 c6                	mov    %eax,%esi
  801e67:	89 ca                	mov    %ecx,%edx
  801e69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e6e:	29 f3                	sub    %esi,%ebx
  801e70:	19 fa                	sbb    %edi,%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	d3 e0                	shl    %cl,%eax
  801e76:	89 e9                	mov    %ebp,%ecx
  801e78:	d3 eb                	shr    %cl,%ebx
  801e7a:	d3 ea                	shr    %cl,%edx
  801e7c:	09 d8                	or     %ebx,%eax
  801e7e:	83 c4 1c             	add    $0x1c,%esp
  801e81:	5b                   	pop    %ebx
  801e82:	5e                   	pop    %esi
  801e83:	5f                   	pop    %edi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    
  801e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e8d:	8d 76 00             	lea    0x0(%esi),%esi
  801e90:	29 fe                	sub    %edi,%esi
  801e92:	19 c3                	sbb    %eax,%ebx
  801e94:	89 f2                	mov    %esi,%edx
  801e96:	89 d9                	mov    %ebx,%ecx
  801e98:	e9 1d ff ff ff       	jmp    801dba <__umoddi3+0x6a>
