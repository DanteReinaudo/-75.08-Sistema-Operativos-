
obj/user/buggyhello2.debug:     formato del fichero elf32-i386


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
  80002c:	e8 21 00 00 00       	call   800052 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  80003d:	68 00 00 10 00       	push   $0x100000
  800042:	ff 35 00 30 80 00    	pushl  0x803000
  800048:	e8 ba 00 00 00       	call   800107 <sys_cputs>
}
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	c9                   	leave  
  800051:	c3                   	ret    

00800052 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800052:	f3 0f 1e fb          	endbr32 
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800061:	e8 19 01 00 00       	call   80017f <sys_getenvid>
	if (id >= 0)
  800066:	85 c0                	test   %eax,%eax
  800068:	78 12                	js     80007c <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80006a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800072:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800077:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007c:	85 db                	test   %ebx,%ebx
  80007e:	7e 07                	jle    800087 <libmain+0x35>
		binaryname = argv[0];
  800080:	8b 06                	mov    (%esi),%eax
  800082:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	56                   	push   %esi
  80008b:	53                   	push   %ebx
  80008c:	e8 a2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800091:	e8 0a 00 00 00       	call   8000a0 <exit>
}
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009c:	5b                   	pop    %ebx
  80009d:	5e                   	pop    %esi
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a0:	f3 0f 1e fb          	endbr32 
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000aa:	e8 53 04 00 00       	call   800502 <close_all>
	sys_env_destroy(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 a0 00 00 00       	call   800159 <sys_env_destroy>
}
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 1c             	sub    $0x1c,%esp
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000cd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000d8:	8b 75 14             	mov    0x14(%ebp),%esi
  8000db:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e1:	74 04                	je     8000e7 <syscall+0x29>
  8000e3:	85 c0                	test   %eax,%eax
  8000e5:	7f 08                	jg     8000ef <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	50                   	push   %eax
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	68 18 1e 80 00       	push   $0x801e18
  8000fb:	6a 23                	push   $0x23
  8000fd:	68 35 1e 80 00       	push   $0x801e35
  800102:	e8 90 0f 00 00       	call   801097 <_panic>

00800107 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800111:	6a 00                	push   $0x0
  800113:	6a 00                	push   $0x0
  800115:	6a 00                	push   $0x0
  800117:	ff 75 0c             	pushl  0xc(%ebp)
  80011a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 00 00 00 00       	mov    $0x0,%eax
  800127:	e8 92 ff ff ff       	call   8000be <syscall>
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	c9                   	leave  
  800130:	c3                   	ret    

00800131 <sys_cgetc>:

int
sys_cgetc(void)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80013b:	6a 00                	push   $0x0
  80013d:	6a 00                	push   $0x0
  80013f:	6a 00                	push   $0x0
  800141:	6a 00                	push   $0x0
  800143:	b9 00 00 00 00       	mov    $0x0,%ecx
  800148:	ba 00 00 00 00       	mov    $0x0,%edx
  80014d:	b8 01 00 00 00       	mov    $0x1,%eax
  800152:	e8 67 ff ff ff       	call   8000be <syscall>
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800159:	f3 0f 1e fb          	endbr32 
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800163:	6a 00                	push   $0x0
  800165:	6a 00                	push   $0x0
  800167:	6a 00                	push   $0x0
  800169:	6a 00                	push   $0x0
  80016b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016e:	ba 01 00 00 00       	mov    $0x1,%edx
  800173:	b8 03 00 00 00       	mov    $0x3,%eax
  800178:	e8 41 ff ff ff       	call   8000be <syscall>
}
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80017f:	f3 0f 1e fb          	endbr32 
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800189:	6a 00                	push   $0x0
  80018b:	6a 00                	push   $0x0
  80018d:	6a 00                	push   $0x0
  80018f:	6a 00                	push   $0x0
  800191:	b9 00 00 00 00       	mov    $0x0,%ecx
  800196:	ba 00 00 00 00       	mov    $0x0,%edx
  80019b:	b8 02 00 00 00       	mov    $0x2,%eax
  8001a0:	e8 19 ff ff ff       	call   8000be <syscall>
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <sys_yield>:

void
sys_yield(void)
{
  8001a7:	f3 0f 1e fb          	endbr32 
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 00                	push   $0x0
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 00                	push   $0x0
  8001b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001be:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c8:	e8 f1 fe ff ff       	call   8000be <syscall>
}
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	c9                   	leave  
  8001d1:	c3                   	ret    

008001d2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d2:	f3 0f 1e fb          	endbr32 
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001dc:	6a 00                	push   $0x0
  8001de:	6a 00                	push   $0x0
  8001e0:	ff 75 10             	pushl  0x10(%ebp)
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8001f3:	e8 c6 fe ff ff       	call   8000be <syscall>
}
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    

008001fa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001fa:	f3 0f 1e fb          	endbr32 
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800204:	ff 75 18             	pushl  0x18(%ebp)
  800207:	ff 75 14             	pushl  0x14(%ebp)
  80020a:	ff 75 10             	pushl  0x10(%ebp)
  80020d:	ff 75 0c             	pushl  0xc(%ebp)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	ba 01 00 00 00       	mov    $0x1,%edx
  800218:	b8 05 00 00 00       	mov    $0x5,%eax
  80021d:	e8 9c fe ff ff       	call   8000be <syscall>
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800224:	f3 0f 1e fb          	endbr32 
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80022e:	6a 00                	push   $0x0
  800230:	6a 00                	push   $0x0
  800232:	6a 00                	push   $0x0
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023a:	ba 01 00 00 00       	mov    $0x1,%edx
  80023f:	b8 06 00 00 00       	mov    $0x6,%eax
  800244:	e8 75 fe ff ff       	call   8000be <syscall>
}
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80024b:	f3 0f 1e fb          	endbr32 
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800255:	6a 00                	push   $0x0
  800257:	6a 00                	push   $0x0
  800259:	6a 00                	push   $0x0
  80025b:	ff 75 0c             	pushl  0xc(%ebp)
  80025e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800261:	ba 01 00 00 00       	mov    $0x1,%edx
  800266:	b8 08 00 00 00       	mov    $0x8,%eax
  80026b:	e8 4e fe ff ff       	call   8000be <syscall>
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800272:	f3 0f 1e fb          	endbr32 
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80027c:	6a 00                	push   $0x0
  80027e:	6a 00                	push   $0x0
  800280:	6a 00                	push   $0x0
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800288:	ba 01 00 00 00       	mov    $0x1,%edx
  80028d:	b8 09 00 00 00       	mov    $0x9,%eax
  800292:	e8 27 fe ff ff       	call   8000be <syscall>
}
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800299:	f3 0f 1e fb          	endbr32 
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8002a3:	6a 00                	push   $0x0
  8002a5:	6a 00                	push   $0x0
  8002a7:	6a 00                	push   $0x0
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002af:	ba 01 00 00 00       	mov    $0x1,%edx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	e8 00 fe ff ff       	call   8000be <syscall>
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c0:	f3 0f 1e fb          	endbr32 
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002ca:	6a 00                	push   $0x0
  8002cc:	ff 75 14             	pushl  0x14(%ebp)
  8002cf:	ff 75 10             	pushl  0x10(%ebp)
  8002d2:	ff 75 0c             	pushl  0xc(%ebp)
  8002d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e2:	e8 d7 fd ff ff       	call   8000be <syscall>
}
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002e9:	f3 0f 1e fb          	endbr32 
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002f3:	6a 00                	push   $0x0
  8002f5:	6a 00                	push   $0x0
  8002f7:	6a 00                	push   $0x0
  8002f9:	6a 00                	push   $0x0
  8002fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fe:	ba 01 00 00 00       	mov    $0x1,%edx
  800303:	b8 0d 00 00 00       	mov    $0xd,%eax
  800308:	e8 b1 fd ff ff       	call   8000be <syscall>
}
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	05 00 00 00 30       	add    $0x30000000,%eax
  80031e:	c1 e8 0c             	shr    $0xc,%eax
}
  800321:	5d                   	pop    %ebp
  800322:	c3                   	ret    

00800323 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	e8 da ff ff ff       	call   80030f <fd2num>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	c1 e0 0c             	shl    $0xc,%eax
  80033b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80034e:	89 c2                	mov    %eax,%edx
  800350:	c1 ea 16             	shr    $0x16,%edx
  800353:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80035a:	f6 c2 01             	test   $0x1,%dl
  80035d:	74 2d                	je     80038c <fd_alloc+0x4a>
  80035f:	89 c2                	mov    %eax,%edx
  800361:	c1 ea 0c             	shr    $0xc,%edx
  800364:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80036b:	f6 c2 01             	test   $0x1,%dl
  80036e:	74 1c                	je     80038c <fd_alloc+0x4a>
  800370:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800375:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80037a:	75 d2                	jne    80034e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800385:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80038a:	eb 0a                	jmp    800396 <fd_alloc+0x54>
			*fd_store = fd;
  80038c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80038f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800391:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800396:	5d                   	pop    %ebp
  800397:	c3                   	ret    

00800398 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800398:	f3 0f 1e fb          	endbr32 
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003a2:	83 f8 1f             	cmp    $0x1f,%eax
  8003a5:	77 30                	ja     8003d7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003a7:	c1 e0 0c             	shl    $0xc,%eax
  8003aa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003af:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003b5:	f6 c2 01             	test   $0x1,%dl
  8003b8:	74 24                	je     8003de <fd_lookup+0x46>
  8003ba:	89 c2                	mov    %eax,%edx
  8003bc:	c1 ea 0c             	shr    $0xc,%edx
  8003bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c6:	f6 c2 01             	test   $0x1,%dl
  8003c9:	74 1a                	je     8003e5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8003d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    
		return -E_INVAL;
  8003d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003dc:	eb f7                	jmp    8003d5 <fd_lookup+0x3d>
		return -E_INVAL;
  8003de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003e3:	eb f0                	jmp    8003d5 <fd_lookup+0x3d>
  8003e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003ea:	eb e9                	jmp    8003d5 <fd_lookup+0x3d>

008003ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003ec:	f3 0f 1e fb          	endbr32 
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f9:	ba c0 1e 80 00       	mov    $0x801ec0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003fe:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800403:	39 08                	cmp    %ecx,(%eax)
  800405:	74 33                	je     80043a <dev_lookup+0x4e>
  800407:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80040a:	8b 02                	mov    (%edx),%eax
  80040c:	85 c0                	test   %eax,%eax
  80040e:	75 f3                	jne    800403 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800410:	a1 04 40 80 00       	mov    0x804004,%eax
  800415:	8b 40 48             	mov    0x48(%eax),%eax
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	51                   	push   %ecx
  80041c:	50                   	push   %eax
  80041d:	68 44 1e 80 00       	push   $0x801e44
  800422:	e8 57 0d 00 00       	call   80117e <cprintf>
	*dev = 0;
  800427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    
			*dev = devtab[i];
  80043a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80043f:	b8 00 00 00 00       	mov    $0x0,%eax
  800444:	eb f2                	jmp    800438 <dev_lookup+0x4c>

00800446 <fd_close>:
{
  800446:	f3 0f 1e fb          	endbr32 
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	57                   	push   %edi
  80044e:	56                   	push   %esi
  80044f:	53                   	push   %ebx
  800450:	83 ec 28             	sub    $0x28,%esp
  800453:	8b 75 08             	mov    0x8(%ebp),%esi
  800456:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800459:	56                   	push   %esi
  80045a:	e8 b0 fe ff ff       	call   80030f <fd2num>
  80045f:	83 c4 08             	add    $0x8,%esp
  800462:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800465:	52                   	push   %edx
  800466:	50                   	push   %eax
  800467:	e8 2c ff ff ff       	call   800398 <fd_lookup>
  80046c:	89 c3                	mov    %eax,%ebx
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	85 c0                	test   %eax,%eax
  800473:	78 05                	js     80047a <fd_close+0x34>
	    || fd != fd2)
  800475:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800478:	74 16                	je     800490 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80047a:	89 f8                	mov    %edi,%eax
  80047c:	84 c0                	test   %al,%al
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	0f 44 d8             	cmove  %eax,%ebx
}
  800486:	89 d8                	mov    %ebx,%eax
  800488:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048b:	5b                   	pop    %ebx
  80048c:	5e                   	pop    %esi
  80048d:	5f                   	pop    %edi
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800496:	50                   	push   %eax
  800497:	ff 36                	pushl  (%esi)
  800499:	e8 4e ff ff ff       	call   8003ec <dev_lookup>
  80049e:	89 c3                	mov    %eax,%ebx
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	78 1a                	js     8004c1 <fd_close+0x7b>
		if (dev->dev_close)
  8004a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004aa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	74 0b                	je     8004c1 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004b6:	83 ec 0c             	sub    $0xc,%esp
  8004b9:	56                   	push   %esi
  8004ba:	ff d0                	call   *%eax
  8004bc:	89 c3                	mov    %eax,%ebx
  8004be:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	56                   	push   %esi
  8004c5:	6a 00                	push   $0x0
  8004c7:	e8 58 fd ff ff       	call   800224 <sys_page_unmap>
	return r;
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	eb b5                	jmp    800486 <fd_close+0x40>

008004d1 <close>:

int
close(int fdnum)
{
  8004d1:	f3 0f 1e fb          	endbr32 
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 b1 fe ff ff       	call   800398 <fd_lookup>
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	79 02                	jns    8004f0 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    
		return fd_close(fd, 1);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	6a 01                	push   $0x1
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	e8 49 ff ff ff       	call   800446 <fd_close>
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	eb ec                	jmp    8004ee <close+0x1d>

00800502 <close_all>:

void
close_all(void)
{
  800502:	f3 0f 1e fb          	endbr32 
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	53                   	push   %ebx
  80050a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80050d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	53                   	push   %ebx
  800516:	e8 b6 ff ff ff       	call   8004d1 <close>
	for (i = 0; i < MAXFD; i++)
  80051b:	83 c3 01             	add    $0x1,%ebx
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	83 fb 20             	cmp    $0x20,%ebx
  800524:	75 ec                	jne    800512 <close_all+0x10>
}
  800526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80052b:	f3 0f 1e fb          	endbr32 
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	57                   	push   %edi
  800533:	56                   	push   %esi
  800534:	53                   	push   %ebx
  800535:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800538:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80053b:	50                   	push   %eax
  80053c:	ff 75 08             	pushl  0x8(%ebp)
  80053f:	e8 54 fe ff ff       	call   800398 <fd_lookup>
  800544:	89 c3                	mov    %eax,%ebx
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	85 c0                	test   %eax,%eax
  80054b:	0f 88 81 00 00 00    	js     8005d2 <dup+0xa7>
		return r;
	close(newfdnum);
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	ff 75 0c             	pushl  0xc(%ebp)
  800557:	e8 75 ff ff ff       	call   8004d1 <close>

	newfd = INDEX2FD(newfdnum);
  80055c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80055f:	c1 e6 0c             	shl    $0xc,%esi
  800562:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800568:	83 c4 04             	add    $0x4,%esp
  80056b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056e:	e8 b0 fd ff ff       	call   800323 <fd2data>
  800573:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800575:	89 34 24             	mov    %esi,(%esp)
  800578:	e8 a6 fd ff ff       	call   800323 <fd2data>
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800582:	89 d8                	mov    %ebx,%eax
  800584:	c1 e8 16             	shr    $0x16,%eax
  800587:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80058e:	a8 01                	test   $0x1,%al
  800590:	74 11                	je     8005a3 <dup+0x78>
  800592:	89 d8                	mov    %ebx,%eax
  800594:	c1 e8 0c             	shr    $0xc,%eax
  800597:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80059e:	f6 c2 01             	test   $0x1,%dl
  8005a1:	75 39                	jne    8005dc <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a6:	89 d0                	mov    %edx,%eax
  8005a8:	c1 e8 0c             	shr    $0xc,%eax
  8005ab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005b2:	83 ec 0c             	sub    $0xc,%esp
  8005b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8005ba:	50                   	push   %eax
  8005bb:	56                   	push   %esi
  8005bc:	6a 00                	push   $0x0
  8005be:	52                   	push   %edx
  8005bf:	6a 00                	push   $0x0
  8005c1:	e8 34 fc ff ff       	call   8001fa <sys_page_map>
  8005c6:	89 c3                	mov    %eax,%ebx
  8005c8:	83 c4 20             	add    $0x20,%esp
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	78 31                	js     800600 <dup+0xd5>
		goto err;

	return newfdnum;
  8005cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005d2:	89 d8                	mov    %ebx,%eax
  8005d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d7:	5b                   	pop    %ebx
  8005d8:	5e                   	pop    %esi
  8005d9:	5f                   	pop    %edi
  8005da:	5d                   	pop    %ebp
  8005db:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	25 07 0e 00 00       	and    $0xe07,%eax
  8005eb:	50                   	push   %eax
  8005ec:	57                   	push   %edi
  8005ed:	6a 00                	push   $0x0
  8005ef:	53                   	push   %ebx
  8005f0:	6a 00                	push   $0x0
  8005f2:	e8 03 fc ff ff       	call   8001fa <sys_page_map>
  8005f7:	89 c3                	mov    %eax,%ebx
  8005f9:	83 c4 20             	add    $0x20,%esp
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	79 a3                	jns    8005a3 <dup+0x78>
	sys_page_unmap(0, newfd);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	56                   	push   %esi
  800604:	6a 00                	push   $0x0
  800606:	e8 19 fc ff ff       	call   800224 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80060b:	83 c4 08             	add    $0x8,%esp
  80060e:	57                   	push   %edi
  80060f:	6a 00                	push   $0x0
  800611:	e8 0e fc ff ff       	call   800224 <sys_page_unmap>
	return r;
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	eb b7                	jmp    8005d2 <dup+0xa7>

0080061b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80061b:	f3 0f 1e fb          	endbr32 
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	53                   	push   %ebx
  800623:	83 ec 1c             	sub    $0x1c,%esp
  800626:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800629:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80062c:	50                   	push   %eax
  80062d:	53                   	push   %ebx
  80062e:	e8 65 fd ff ff       	call   800398 <fd_lookup>
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	85 c0                	test   %eax,%eax
  800638:	78 3f                	js     800679 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800640:	50                   	push   %eax
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800644:	ff 30                	pushl  (%eax)
  800646:	e8 a1 fd ff ff       	call   8003ec <dev_lookup>
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	85 c0                	test   %eax,%eax
  800650:	78 27                	js     800679 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800652:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800655:	8b 42 08             	mov    0x8(%edx),%eax
  800658:	83 e0 03             	and    $0x3,%eax
  80065b:	83 f8 01             	cmp    $0x1,%eax
  80065e:	74 1e                	je     80067e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800663:	8b 40 08             	mov    0x8(%eax),%eax
  800666:	85 c0                	test   %eax,%eax
  800668:	74 35                	je     80069f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	ff 75 10             	pushl  0x10(%ebp)
  800670:	ff 75 0c             	pushl  0xc(%ebp)
  800673:	52                   	push   %edx
  800674:	ff d0                	call   *%eax
  800676:	83 c4 10             	add    $0x10,%esp
}
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80067e:	a1 04 40 80 00       	mov    0x804004,%eax
  800683:	8b 40 48             	mov    0x48(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	53                   	push   %ebx
  80068a:	50                   	push   %eax
  80068b:	68 85 1e 80 00       	push   $0x801e85
  800690:	e8 e9 0a 00 00       	call   80117e <cprintf>
		return -E_INVAL;
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80069d:	eb da                	jmp    800679 <read+0x5e>
		return -E_NOT_SUPP;
  80069f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006a4:	eb d3                	jmp    800679 <read+0x5e>

008006a6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006a6:	f3 0f 1e fb          	endbr32 
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	57                   	push   %edi
  8006ae:	56                   	push   %esi
  8006af:	53                   	push   %ebx
  8006b0:	83 ec 0c             	sub    $0xc,%esp
  8006b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006b6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006be:	eb 02                	jmp    8006c2 <readn+0x1c>
  8006c0:	01 c3                	add    %eax,%ebx
  8006c2:	39 f3                	cmp    %esi,%ebx
  8006c4:	73 21                	jae    8006e7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006c6:	83 ec 04             	sub    $0x4,%esp
  8006c9:	89 f0                	mov    %esi,%eax
  8006cb:	29 d8                	sub    %ebx,%eax
  8006cd:	50                   	push   %eax
  8006ce:	89 d8                	mov    %ebx,%eax
  8006d0:	03 45 0c             	add    0xc(%ebp),%eax
  8006d3:	50                   	push   %eax
  8006d4:	57                   	push   %edi
  8006d5:	e8 41 ff ff ff       	call   80061b <read>
		if (m < 0)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	78 04                	js     8006e5 <readn+0x3f>
			return m;
		if (m == 0)
  8006e1:	75 dd                	jne    8006c0 <readn+0x1a>
  8006e3:	eb 02                	jmp    8006e7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006e5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006e7:	89 d8                	mov    %ebx,%eax
  8006e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ec:	5b                   	pop    %ebx
  8006ed:	5e                   	pop    %esi
  8006ee:	5f                   	pop    %edi
  8006ef:	5d                   	pop    %ebp
  8006f0:	c3                   	ret    

008006f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006f1:	f3 0f 1e fb          	endbr32 
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	53                   	push   %ebx
  8006f9:	83 ec 1c             	sub    $0x1c,%esp
  8006fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800702:	50                   	push   %eax
  800703:	53                   	push   %ebx
  800704:	e8 8f fc ff ff       	call   800398 <fd_lookup>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	85 c0                	test   %eax,%eax
  80070e:	78 3a                	js     80074a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	ff 30                	pushl  (%eax)
  80071c:	e8 cb fc ff ff       	call   8003ec <dev_lookup>
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	85 c0                	test   %eax,%eax
  800726:	78 22                	js     80074a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80072f:	74 1e                	je     80074f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800734:	8b 52 0c             	mov    0xc(%edx),%edx
  800737:	85 d2                	test   %edx,%edx
  800739:	74 35                	je     800770 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80073b:	83 ec 04             	sub    $0x4,%esp
  80073e:	ff 75 10             	pushl  0x10(%ebp)
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	50                   	push   %eax
  800745:	ff d2                	call   *%edx
  800747:	83 c4 10             	add    $0x10,%esp
}
  80074a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80074f:	a1 04 40 80 00       	mov    0x804004,%eax
  800754:	8b 40 48             	mov    0x48(%eax),%eax
  800757:	83 ec 04             	sub    $0x4,%esp
  80075a:	53                   	push   %ebx
  80075b:	50                   	push   %eax
  80075c:	68 a1 1e 80 00       	push   $0x801ea1
  800761:	e8 18 0a 00 00       	call   80117e <cprintf>
		return -E_INVAL;
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076e:	eb da                	jmp    80074a <write+0x59>
		return -E_NOT_SUPP;
  800770:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800775:	eb d3                	jmp    80074a <write+0x59>

00800777 <seek>:

int
seek(int fdnum, off_t offset)
{
  800777:	f3 0f 1e fb          	endbr32 
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800784:	50                   	push   %eax
  800785:	ff 75 08             	pushl  0x8(%ebp)
  800788:	e8 0b fc ff ff       	call   800398 <fd_lookup>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	85 c0                	test   %eax,%eax
  800792:	78 0e                	js     8007a2 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800794:	8b 55 0c             	mov    0xc(%ebp),%edx
  800797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80079d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	53                   	push   %ebx
  8007ac:	83 ec 1c             	sub    $0x1c,%esp
  8007af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	53                   	push   %ebx
  8007b7:	e8 dc fb ff ff       	call   800398 <fd_lookup>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 37                	js     8007fa <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cd:	ff 30                	pushl  (%eax)
  8007cf:	e8 18 fc ff ff       	call   8003ec <dev_lookup>
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	85 c0                	test   %eax,%eax
  8007d9:	78 1f                	js     8007fa <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e2:	74 1b                	je     8007ff <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e7:	8b 52 18             	mov    0x18(%edx),%edx
  8007ea:	85 d2                	test   %edx,%edx
  8007ec:	74 32                	je     800820 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	ff d2                	call   *%edx
  8007f7:	83 c4 10             	add    $0x10,%esp
}
  8007fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007ff:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800804:	8b 40 48             	mov    0x48(%eax),%eax
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	53                   	push   %ebx
  80080b:	50                   	push   %eax
  80080c:	68 64 1e 80 00       	push   $0x801e64
  800811:	e8 68 09 00 00       	call   80117e <cprintf>
		return -E_INVAL;
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081e:	eb da                	jmp    8007fa <ftruncate+0x56>
		return -E_NOT_SUPP;
  800820:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800825:	eb d3                	jmp    8007fa <ftruncate+0x56>

00800827 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800827:	f3 0f 1e fb          	endbr32 
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	83 ec 1c             	sub    $0x1c,%esp
  800832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800835:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800838:	50                   	push   %eax
  800839:	ff 75 08             	pushl  0x8(%ebp)
  80083c:	e8 57 fb ff ff       	call   800398 <fd_lookup>
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	78 4b                	js     800893 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084e:	50                   	push   %eax
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800852:	ff 30                	pushl  (%eax)
  800854:	e8 93 fb ff ff       	call   8003ec <dev_lookup>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	85 c0                	test   %eax,%eax
  80085e:	78 33                	js     800893 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800863:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800867:	74 2f                	je     800898 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800869:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80086c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800873:	00 00 00 
	stat->st_isdir = 0;
  800876:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80087d:	00 00 00 
	stat->st_dev = dev;
  800880:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	53                   	push   %ebx
  80088a:	ff 75 f0             	pushl  -0x10(%ebp)
  80088d:	ff 50 14             	call   *0x14(%eax)
  800890:	83 c4 10             	add    $0x10,%esp
}
  800893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800896:	c9                   	leave  
  800897:	c3                   	ret    
		return -E_NOT_SUPP;
  800898:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80089d:	eb f4                	jmp    800893 <fstat+0x6c>

0080089f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	56                   	push   %esi
  8008a7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	6a 00                	push   $0x0
  8008ad:	ff 75 08             	pushl  0x8(%ebp)
  8008b0:	e8 3a 02 00 00       	call   800aef <open>
  8008b5:	89 c3                	mov    %eax,%ebx
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	85 c0                	test   %eax,%eax
  8008bc:	78 1b                	js     8008d9 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	50                   	push   %eax
  8008c5:	e8 5d ff ff ff       	call   800827 <fstat>
  8008ca:	89 c6                	mov    %eax,%esi
	close(fd);
  8008cc:	89 1c 24             	mov    %ebx,(%esp)
  8008cf:	e8 fd fb ff ff       	call   8004d1 <close>
	return r;
  8008d4:	83 c4 10             	add    $0x10,%esp
  8008d7:	89 f3                	mov    %esi,%ebx
}
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	89 c6                	mov    %eax,%esi
  8008e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008eb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008f2:	74 27                	je     80091b <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008f4:	6a 07                	push   $0x7
  8008f6:	68 00 50 80 00       	push   $0x805000
  8008fb:	56                   	push   %esi
  8008fc:	ff 35 00 40 80 00    	pushl  0x804000
  800902:	e8 c2 11 00 00       	call   801ac9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800907:	83 c4 0c             	add    $0xc,%esp
  80090a:	6a 00                	push   $0x0
  80090c:	53                   	push   %ebx
  80090d:	6a 00                	push   $0x0
  80090f:	e8 48 11 00 00       	call   801a5c <ipc_recv>
}
  800914:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800917:	5b                   	pop    %ebx
  800918:	5e                   	pop    %esi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80091b:	83 ec 0c             	sub    $0xc,%esp
  80091e:	6a 01                	push   $0x1
  800920:	e8 fc 11 00 00       	call   801b21 <ipc_find_env>
  800925:	a3 00 40 80 00       	mov    %eax,0x804000
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	eb c5                	jmp    8008f4 <fsipc+0x12>

0080092f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80092f:	f3 0f 1e fb          	endbr32 
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 40 0c             	mov    0xc(%eax),%eax
  80093f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80094c:	ba 00 00 00 00       	mov    $0x0,%edx
  800951:	b8 02 00 00 00       	mov    $0x2,%eax
  800956:	e8 87 ff ff ff       	call   8008e2 <fsipc>
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <devfile_flush>:
{
  80095d:	f3 0f 1e fb          	endbr32 
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 40 0c             	mov    0xc(%eax),%eax
  80096d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	b8 06 00 00 00       	mov    $0x6,%eax
  80097c:	e8 61 ff ff ff       	call   8008e2 <fsipc>
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <devfile_stat>:
{
  800983:	f3 0f 1e fb          	endbr32 
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	83 ec 04             	sub    $0x4,%esp
  80098e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 40 0c             	mov    0xc(%eax),%eax
  800997:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80099c:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a1:	b8 05 00 00 00       	mov    $0x5,%eax
  8009a6:	e8 37 ff ff ff       	call   8008e2 <fsipc>
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	78 2c                	js     8009db <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	68 00 50 80 00       	push   $0x805000
  8009b7:	53                   	push   %ebx
  8009b8:	e8 2b 0d 00 00       	call   8016e8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009bd:	a1 80 50 80 00       	mov    0x805080,%eax
  8009c2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009c8:	a1 84 50 80 00       	mov    0x805084,%eax
  8009cd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <devfile_write>:
{
  8009e0:	f3 0f 1e fb          	endbr32 
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	53                   	push   %ebx
  8009e8:	83 ec 04             	sub    $0x4,%esp
  8009eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009f9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009ff:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a05:	77 30                	ja     800a37 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	53                   	push   %ebx
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	68 08 50 80 00       	push   $0x805008
  800a13:	e8 88 0e 00 00       	call   8018a0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	b8 04 00 00 00       	mov    $0x4,%eax
  800a22:	e8 bb fe ff ff       	call   8008e2 <fsipc>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	85 c0                	test   %eax,%eax
  800a2c:	78 04                	js     800a32 <devfile_write+0x52>
	assert(r <= n);
  800a2e:	39 d8                	cmp    %ebx,%eax
  800a30:	77 1e                	ja     800a50 <devfile_write+0x70>
}
  800a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a37:	68 d0 1e 80 00       	push   $0x801ed0
  800a3c:	68 fd 1e 80 00       	push   $0x801efd
  800a41:	68 94 00 00 00       	push   $0x94
  800a46:	68 12 1f 80 00       	push   $0x801f12
  800a4b:	e8 47 06 00 00       	call   801097 <_panic>
	assert(r <= n);
  800a50:	68 1d 1f 80 00       	push   $0x801f1d
  800a55:	68 fd 1e 80 00       	push   $0x801efd
  800a5a:	68 98 00 00 00       	push   $0x98
  800a5f:	68 12 1f 80 00       	push   $0x801f12
  800a64:	e8 2e 06 00 00       	call   801097 <_panic>

00800a69 <devfile_read>:
{
  800a69:	f3 0f 1e fb          	endbr32 
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8b 40 0c             	mov    0xc(%eax),%eax
  800a7b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a80:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a86:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a90:	e8 4d fe ff ff       	call   8008e2 <fsipc>
  800a95:	89 c3                	mov    %eax,%ebx
  800a97:	85 c0                	test   %eax,%eax
  800a99:	78 1f                	js     800aba <devfile_read+0x51>
	assert(r <= n);
  800a9b:	39 f0                	cmp    %esi,%eax
  800a9d:	77 24                	ja     800ac3 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a9f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa4:	7f 33                	jg     800ad9 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aa6:	83 ec 04             	sub    $0x4,%esp
  800aa9:	50                   	push   %eax
  800aaa:	68 00 50 80 00       	push   $0x805000
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	e8 e9 0d 00 00       	call   8018a0 <memmove>
	return r;
  800ab7:	83 c4 10             	add    $0x10,%esp
}
  800aba:	89 d8                	mov    %ebx,%eax
  800abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    
	assert(r <= n);
  800ac3:	68 1d 1f 80 00       	push   $0x801f1d
  800ac8:	68 fd 1e 80 00       	push   $0x801efd
  800acd:	6a 7c                	push   $0x7c
  800acf:	68 12 1f 80 00       	push   $0x801f12
  800ad4:	e8 be 05 00 00       	call   801097 <_panic>
	assert(r <= PGSIZE);
  800ad9:	68 24 1f 80 00       	push   $0x801f24
  800ade:	68 fd 1e 80 00       	push   $0x801efd
  800ae3:	6a 7d                	push   $0x7d
  800ae5:	68 12 1f 80 00       	push   $0x801f12
  800aea:	e8 a8 05 00 00       	call   801097 <_panic>

00800aef <open>:
{
  800aef:	f3 0f 1e fb          	endbr32 
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	83 ec 1c             	sub    $0x1c,%esp
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800afe:	56                   	push   %esi
  800aff:	e8 a1 0b 00 00       	call   8016a5 <strlen>
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b0c:	7f 6c                	jg     800b7a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b14:	50                   	push   %eax
  800b15:	e8 28 f8 ff ff       	call   800342 <fd_alloc>
  800b1a:	89 c3                	mov    %eax,%ebx
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	85 c0                	test   %eax,%eax
  800b21:	78 3c                	js     800b5f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	56                   	push   %esi
  800b27:	68 00 50 80 00       	push   $0x805000
  800b2c:	e8 b7 0b 00 00       	call   8016e8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b41:	e8 9c fd ff ff       	call   8008e2 <fsipc>
  800b46:	89 c3                	mov    %eax,%ebx
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	85 c0                	test   %eax,%eax
  800b4d:	78 19                	js     800b68 <open+0x79>
	return fd2num(fd);
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	e8 b5 f7 ff ff       	call   80030f <fd2num>
  800b5a:	89 c3                	mov    %eax,%ebx
  800b5c:	83 c4 10             	add    $0x10,%esp
}
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    
		fd_close(fd, 0);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	6a 00                	push   $0x0
  800b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b70:	e8 d1 f8 ff ff       	call   800446 <fd_close>
		return r;
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	eb e5                	jmp    800b5f <open+0x70>
		return -E_BAD_PATH;
  800b7a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b7f:	eb de                	jmp    800b5f <open+0x70>

00800b81 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b81:	f3 0f 1e fb          	endbr32 
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b90:	b8 08 00 00 00       	mov    $0x8,%eax
  800b95:	e8 48 fd ff ff       	call   8008e2 <fsipc>
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b9c:	f3 0f 1e fb          	endbr32 
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 70 f7 ff ff       	call   800323 <fd2data>
  800bb3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb5:	83 c4 08             	add    $0x8,%esp
  800bb8:	68 30 1f 80 00       	push   $0x801f30
  800bbd:	53                   	push   %ebx
  800bbe:	e8 25 0b 00 00       	call   8016e8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc3:	8b 46 04             	mov    0x4(%esi),%eax
  800bc6:	2b 06                	sub    (%esi),%eax
  800bc8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd5:	00 00 00 
	stat->st_dev = &devpipe;
  800bd8:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800bdf:	30 80 00 
	return 0;
}
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
  800be7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bee:	f3 0f 1e fb          	endbr32 
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 0c             	sub    $0xc,%esp
  800bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bfc:	53                   	push   %ebx
  800bfd:	6a 00                	push   $0x0
  800bff:	e8 20 f6 ff ff       	call   800224 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c04:	89 1c 24             	mov    %ebx,(%esp)
  800c07:	e8 17 f7 ff ff       	call   800323 <fd2data>
  800c0c:	83 c4 08             	add    $0x8,%esp
  800c0f:	50                   	push   %eax
  800c10:	6a 00                	push   $0x0
  800c12:	e8 0d f6 ff ff       	call   800224 <sys_page_unmap>
}
  800c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <_pipeisclosed>:
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 1c             	sub    $0x1c,%esp
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c29:	a1 04 40 80 00       	mov    0x804004,%eax
  800c2e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c31:	83 ec 0c             	sub    $0xc,%esp
  800c34:	57                   	push   %edi
  800c35:	e8 24 0f 00 00       	call   801b5e <pageref>
  800c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3d:	89 34 24             	mov    %esi,(%esp)
  800c40:	e8 19 0f 00 00       	call   801b5e <pageref>
		nn = thisenv->env_runs;
  800c45:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c4b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	39 cb                	cmp    %ecx,%ebx
  800c53:	74 1b                	je     800c70 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c58:	75 cf                	jne    800c29 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c5a:	8b 42 58             	mov    0x58(%edx),%eax
  800c5d:	6a 01                	push   $0x1
  800c5f:	50                   	push   %eax
  800c60:	53                   	push   %ebx
  800c61:	68 37 1f 80 00       	push   $0x801f37
  800c66:	e8 13 05 00 00       	call   80117e <cprintf>
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	eb b9                	jmp    800c29 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c70:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c73:	0f 94 c0             	sete   %al
  800c76:	0f b6 c0             	movzbl %al,%eax
}
  800c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <devpipe_write>:
{
  800c81:	f3 0f 1e fb          	endbr32 
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 28             	sub    $0x28,%esp
  800c8e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c91:	56                   	push   %esi
  800c92:	e8 8c f6 ff ff       	call   800323 <fd2data>
  800c97:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ca4:	74 4f                	je     800cf5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca6:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca9:	8b 0b                	mov    (%ebx),%ecx
  800cab:	8d 51 20             	lea    0x20(%ecx),%edx
  800cae:	39 d0                	cmp    %edx,%eax
  800cb0:	72 14                	jb     800cc6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cb2:	89 da                	mov    %ebx,%edx
  800cb4:	89 f0                	mov    %esi,%eax
  800cb6:	e8 61 ff ff ff       	call   800c1c <_pipeisclosed>
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	75 3b                	jne    800cfa <devpipe_write+0x79>
			sys_yield();
  800cbf:	e8 e3 f4 ff ff       	call   8001a7 <sys_yield>
  800cc4:	eb e0                	jmp    800ca6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800ccd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cd0:	89 c2                	mov    %eax,%edx
  800cd2:	c1 fa 1f             	sar    $0x1f,%edx
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	c1 e9 1b             	shr    $0x1b,%ecx
  800cda:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cdd:	83 e2 1f             	and    $0x1f,%edx
  800ce0:	29 ca                	sub    %ecx,%edx
  800ce2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cea:	83 c0 01             	add    $0x1,%eax
  800ced:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cf0:	83 c7 01             	add    $0x1,%edi
  800cf3:	eb ac                	jmp    800ca1 <devpipe_write+0x20>
	return i;
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	eb 05                	jmp    800cff <devpipe_write+0x7e>
				return 0;
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <devpipe_read>:
{
  800d07:	f3 0f 1e fb          	endbr32 
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 18             	sub    $0x18,%esp
  800d14:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d17:	57                   	push   %edi
  800d18:	e8 06 f6 ff ff       	call   800323 <fd2data>
  800d1d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	be 00 00 00 00       	mov    $0x0,%esi
  800d27:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d2a:	75 14                	jne    800d40 <devpipe_read+0x39>
	return i;
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	eb 02                	jmp    800d33 <devpipe_read+0x2c>
				return i;
  800d31:	89 f0                	mov    %esi,%eax
}
  800d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    
			sys_yield();
  800d3b:	e8 67 f4 ff ff       	call   8001a7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d40:	8b 03                	mov    (%ebx),%eax
  800d42:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d45:	75 18                	jne    800d5f <devpipe_read+0x58>
			if (i > 0)
  800d47:	85 f6                	test   %esi,%esi
  800d49:	75 e6                	jne    800d31 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d4b:	89 da                	mov    %ebx,%edx
  800d4d:	89 f8                	mov    %edi,%eax
  800d4f:	e8 c8 fe ff ff       	call   800c1c <_pipeisclosed>
  800d54:	85 c0                	test   %eax,%eax
  800d56:	74 e3                	je     800d3b <devpipe_read+0x34>
				return 0;
  800d58:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5d:	eb d4                	jmp    800d33 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d5f:	99                   	cltd   
  800d60:	c1 ea 1b             	shr    $0x1b,%edx
  800d63:	01 d0                	add    %edx,%eax
  800d65:	83 e0 1f             	and    $0x1f,%eax
  800d68:	29 d0                	sub    %edx,%eax
  800d6a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d75:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d78:	83 c6 01             	add    $0x1,%esi
  800d7b:	eb aa                	jmp    800d27 <devpipe_read+0x20>

00800d7d <pipe>:
{
  800d7d:	f3 0f 1e fb          	endbr32 
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d8c:	50                   	push   %eax
  800d8d:	e8 b0 f5 ff ff       	call   800342 <fd_alloc>
  800d92:	89 c3                	mov    %eax,%ebx
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	85 c0                	test   %eax,%eax
  800d99:	0f 88 23 01 00 00    	js     800ec2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9f:	83 ec 04             	sub    $0x4,%esp
  800da2:	68 07 04 00 00       	push   $0x407
  800da7:	ff 75 f4             	pushl  -0xc(%ebp)
  800daa:	6a 00                	push   $0x0
  800dac:	e8 21 f4 ff ff       	call   8001d2 <sys_page_alloc>
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	85 c0                	test   %eax,%eax
  800db8:	0f 88 04 01 00 00    	js     800ec2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc4:	50                   	push   %eax
  800dc5:	e8 78 f5 ff ff       	call   800342 <fd_alloc>
  800dca:	89 c3                	mov    %eax,%ebx
  800dcc:	83 c4 10             	add    $0x10,%esp
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	0f 88 db 00 00 00    	js     800eb2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	68 07 04 00 00       	push   $0x407
  800ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  800de2:	6a 00                	push   $0x0
  800de4:	e8 e9 f3 ff ff       	call   8001d2 <sys_page_alloc>
  800de9:	89 c3                	mov    %eax,%ebx
  800deb:	83 c4 10             	add    $0x10,%esp
  800dee:	85 c0                	test   %eax,%eax
  800df0:	0f 88 bc 00 00 00    	js     800eb2 <pipe+0x135>
	va = fd2data(fd0);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfc:	e8 22 f5 ff ff       	call   800323 <fd2data>
  800e01:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e03:	83 c4 0c             	add    $0xc,%esp
  800e06:	68 07 04 00 00       	push   $0x407
  800e0b:	50                   	push   %eax
  800e0c:	6a 00                	push   $0x0
  800e0e:	e8 bf f3 ff ff       	call   8001d2 <sys_page_alloc>
  800e13:	89 c3                	mov    %eax,%ebx
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	0f 88 82 00 00 00    	js     800ea2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	ff 75 f0             	pushl  -0x10(%ebp)
  800e26:	e8 f8 f4 ff ff       	call   800323 <fd2data>
  800e2b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e32:	50                   	push   %eax
  800e33:	6a 00                	push   $0x0
  800e35:	56                   	push   %esi
  800e36:	6a 00                	push   $0x0
  800e38:	e8 bd f3 ff ff       	call   8001fa <sys_page_map>
  800e3d:	89 c3                	mov    %eax,%ebx
  800e3f:	83 c4 20             	add    $0x20,%esp
  800e42:	85 c0                	test   %eax,%eax
  800e44:	78 4e                	js     800e94 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e46:	a1 24 30 80 00       	mov    0x803024,%eax
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e53:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6f:	e8 9b f4 ff ff       	call   80030f <fd2num>
  800e74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e77:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e79:	83 c4 04             	add    $0x4,%esp
  800e7c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7f:	e8 8b f4 ff ff       	call   80030f <fd2num>
  800e84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e87:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e92:	eb 2e                	jmp    800ec2 <pipe+0x145>
	sys_page_unmap(0, va);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	56                   	push   %esi
  800e98:	6a 00                	push   $0x0
  800e9a:	e8 85 f3 ff ff       	call   800224 <sys_page_unmap>
  800e9f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea8:	6a 00                	push   $0x0
  800eaa:	e8 75 f3 ff ff       	call   800224 <sys_page_unmap>
  800eaf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb8:	6a 00                	push   $0x0
  800eba:	e8 65 f3 ff ff       	call   800224 <sys_page_unmap>
  800ebf:	83 c4 10             	add    $0x10,%esp
}
  800ec2:	89 d8                	mov    %ebx,%eax
  800ec4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <pipeisclosed>:
{
  800ecb:	f3 0f 1e fb          	endbr32 
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed8:	50                   	push   %eax
  800ed9:	ff 75 08             	pushl  0x8(%ebp)
  800edc:	e8 b7 f4 ff ff       	call   800398 <fd_lookup>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	78 18                	js     800f00 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ee8:	83 ec 0c             	sub    $0xc,%esp
  800eeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800eee:	e8 30 f4 ff ff       	call   800323 <fd2data>
  800ef3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef8:	e8 1f fd ff ff       	call   800c1c <_pipeisclosed>
  800efd:	83 c4 10             	add    $0x10,%esp
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f02:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0b:	c3                   	ret    

00800f0c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f0c:	f3 0f 1e fb          	endbr32 
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f16:	68 4f 1f 80 00       	push   $0x801f4f
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	e8 c5 07 00 00       	call   8016e8 <strcpy>
	return 0;
}
  800f23:	b8 00 00 00 00       	mov    $0x0,%eax
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <devcons_write>:
{
  800f2a:	f3 0f 1e fb          	endbr32 
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f3a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f3f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f45:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f48:	73 31                	jae    800f7b <devcons_write+0x51>
		m = n - tot;
  800f4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4d:	29 f3                	sub    %esi,%ebx
  800f4f:	83 fb 7f             	cmp    $0x7f,%ebx
  800f52:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f57:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f5a:	83 ec 04             	sub    $0x4,%esp
  800f5d:	53                   	push   %ebx
  800f5e:	89 f0                	mov    %esi,%eax
  800f60:	03 45 0c             	add    0xc(%ebp),%eax
  800f63:	50                   	push   %eax
  800f64:	57                   	push   %edi
  800f65:	e8 36 09 00 00       	call   8018a0 <memmove>
		sys_cputs(buf, m);
  800f6a:	83 c4 08             	add    $0x8,%esp
  800f6d:	53                   	push   %ebx
  800f6e:	57                   	push   %edi
  800f6f:	e8 93 f1 ff ff       	call   800107 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f74:	01 de                	add    %ebx,%esi
  800f76:	83 c4 10             	add    $0x10,%esp
  800f79:	eb ca                	jmp    800f45 <devcons_write+0x1b>
}
  800f7b:	89 f0                	mov    %esi,%eax
  800f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <devcons_read>:
{
  800f85:	f3 0f 1e fb          	endbr32 
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 21                	je     800fbb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f9a:	e8 92 f1 ff ff       	call   800131 <sys_cgetc>
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	75 07                	jne    800faa <devcons_read+0x25>
		sys_yield();
  800fa3:	e8 ff f1 ff ff       	call   8001a7 <sys_yield>
  800fa8:	eb f0                	jmp    800f9a <devcons_read+0x15>
	if (c < 0)
  800faa:	78 0f                	js     800fbb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fac:	83 f8 04             	cmp    $0x4,%eax
  800faf:	74 0c                	je     800fbd <devcons_read+0x38>
	*(char*)vbuf = c;
  800fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb4:	88 02                	mov    %al,(%edx)
	return 1;
  800fb6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    
		return 0;
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc2:	eb f7                	jmp    800fbb <devcons_read+0x36>

00800fc4 <cputchar>:
{
  800fc4:	f3 0f 1e fb          	endbr32 
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fd4:	6a 01                	push   $0x1
  800fd6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	e8 28 f1 ff ff       	call   800107 <sys_cputs>
}
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <getchar>:
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fee:	6a 01                	push   $0x1
  800ff0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	6a 00                	push   $0x0
  800ff6:	e8 20 f6 ff ff       	call   80061b <read>
	if (r < 0)
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 06                	js     801008 <getchar+0x24>
	if (r < 1)
  801002:	74 06                	je     80100a <getchar+0x26>
	return c;
  801004:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801008:	c9                   	leave  
  801009:	c3                   	ret    
		return -E_EOF;
  80100a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80100f:	eb f7                	jmp    801008 <getchar+0x24>

00801011 <iscons>:
{
  801011:	f3 0f 1e fb          	endbr32 
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80101b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	ff 75 08             	pushl  0x8(%ebp)
  801022:	e8 71 f3 ff ff       	call   800398 <fd_lookup>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 11                	js     80103f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80102e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801031:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801037:	39 10                	cmp    %edx,(%eax)
  801039:	0f 94 c0             	sete   %al
  80103c:	0f b6 c0             	movzbl %al,%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <opencons>:
{
  801041:	f3 0f 1e fb          	endbr32 
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80104b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104e:	50                   	push   %eax
  80104f:	e8 ee f2 ff ff       	call   800342 <fd_alloc>
  801054:	83 c4 10             	add    $0x10,%esp
  801057:	85 c0                	test   %eax,%eax
  801059:	78 3a                	js     801095 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80105b:	83 ec 04             	sub    $0x4,%esp
  80105e:	68 07 04 00 00       	push   $0x407
  801063:	ff 75 f4             	pushl  -0xc(%ebp)
  801066:	6a 00                	push   $0x0
  801068:	e8 65 f1 ff ff       	call   8001d2 <sys_page_alloc>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	85 c0                	test   %eax,%eax
  801072:	78 21                	js     801095 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801077:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80107d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801089:	83 ec 0c             	sub    $0xc,%esp
  80108c:	50                   	push   %eax
  80108d:	e8 7d f2 ff ff       	call   80030f <fd2num>
  801092:	83 c4 10             	add    $0x10,%esp
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801097:	f3 0f 1e fb          	endbr32 
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010a0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010a3:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8010a9:	e8 d1 f0 ff ff       	call   80017f <sys_getenvid>
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	56                   	push   %esi
  8010b8:	50                   	push   %eax
  8010b9:	68 5c 1f 80 00       	push   $0x801f5c
  8010be:	e8 bb 00 00 00       	call   80117e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010c3:	83 c4 18             	add    $0x18,%esp
  8010c6:	53                   	push   %ebx
  8010c7:	ff 75 10             	pushl  0x10(%ebp)
  8010ca:	e8 5a 00 00 00       	call   801129 <vcprintf>
	cprintf("\n");
  8010cf:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010d6:	e8 a3 00 00 00       	call   80117e <cprintf>
  8010db:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010de:	cc                   	int3   
  8010df:	eb fd                	jmp    8010de <_panic+0x47>

008010e1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010e1:	f3 0f 1e fb          	endbr32 
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010ef:	8b 13                	mov    (%ebx),%edx
  8010f1:	8d 42 01             	lea    0x1(%edx),%eax
  8010f4:	89 03                	mov    %eax,(%ebx)
  8010f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010fd:	3d ff 00 00 00       	cmp    $0xff,%eax
  801102:	74 09                	je     80110d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801104:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	68 ff 00 00 00       	push   $0xff
  801115:	8d 43 08             	lea    0x8(%ebx),%eax
  801118:	50                   	push   %eax
  801119:	e8 e9 ef ff ff       	call   800107 <sys_cputs>
		b->idx = 0;
  80111e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	eb db                	jmp    801104 <putch+0x23>

00801129 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801129:	f3 0f 1e fb          	endbr32 
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801136:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80113d:	00 00 00 
	b.cnt = 0;
  801140:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801147:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	ff 75 08             	pushl  0x8(%ebp)
  801150:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	68 e1 10 80 00       	push   $0x8010e1
  80115c:	e8 80 01 00 00       	call   8012e1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801161:	83 c4 08             	add    $0x8,%esp
  801164:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80116a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801170:	50                   	push   %eax
  801171:	e8 91 ef ff ff       	call   800107 <sys_cputs>

	return b.cnt;
}
  801176:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80117e:	f3 0f 1e fb          	endbr32 
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801188:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80118b:	50                   	push   %eax
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 95 ff ff ff       	call   801129 <vcprintf>
	va_end(ap);

	return cnt;
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
  80119c:	83 ec 1c             	sub    $0x1c,%esp
  80119f:	89 c7                	mov    %eax,%edi
  8011a1:	89 d6                	mov    %edx,%esi
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a9:	89 d1                	mov    %edx,%ecx
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011c3:	39 c2                	cmp    %eax,%edx
  8011c5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011c8:	72 3e                	jb     801208 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	ff 75 18             	pushl  0x18(%ebp)
  8011d0:	83 eb 01             	sub    $0x1,%ebx
  8011d3:	53                   	push   %ebx
  8011d4:	50                   	push   %eax
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011db:	ff 75 e0             	pushl  -0x20(%ebp)
  8011de:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8011e4:	e8 b7 09 00 00       	call   801ba0 <__udivdi3>
  8011e9:	83 c4 18             	add    $0x18,%esp
  8011ec:	52                   	push   %edx
  8011ed:	50                   	push   %eax
  8011ee:	89 f2                	mov    %esi,%edx
  8011f0:	89 f8                	mov    %edi,%eax
  8011f2:	e8 9f ff ff ff       	call   801196 <printnum>
  8011f7:	83 c4 20             	add    $0x20,%esp
  8011fa:	eb 13                	jmp    80120f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011fc:	83 ec 08             	sub    $0x8,%esp
  8011ff:	56                   	push   %esi
  801200:	ff 75 18             	pushl  0x18(%ebp)
  801203:	ff d7                	call   *%edi
  801205:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801208:	83 eb 01             	sub    $0x1,%ebx
  80120b:	85 db                	test   %ebx,%ebx
  80120d:	7f ed                	jg     8011fc <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	56                   	push   %esi
  801213:	83 ec 04             	sub    $0x4,%esp
  801216:	ff 75 e4             	pushl  -0x1c(%ebp)
  801219:	ff 75 e0             	pushl  -0x20(%ebp)
  80121c:	ff 75 dc             	pushl  -0x24(%ebp)
  80121f:	ff 75 d8             	pushl  -0x28(%ebp)
  801222:	e8 89 0a 00 00       	call   801cb0 <__umoddi3>
  801227:	83 c4 14             	add    $0x14,%esp
  80122a:	0f be 80 7f 1f 80 00 	movsbl 0x801f7f(%eax),%eax
  801231:	50                   	push   %eax
  801232:	ff d7                	call   *%edi
}
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123a:	5b                   	pop    %ebx
  80123b:	5e                   	pop    %esi
  80123c:	5f                   	pop    %edi
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80123f:	83 fa 01             	cmp    $0x1,%edx
  801242:	7f 13                	jg     801257 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801244:	85 d2                	test   %edx,%edx
  801246:	74 1c                	je     801264 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801248:	8b 10                	mov    (%eax),%edx
  80124a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80124d:	89 08                	mov    %ecx,(%eax)
  80124f:	8b 02                	mov    (%edx),%eax
  801251:	ba 00 00 00 00       	mov    $0x0,%edx
  801256:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801257:	8b 10                	mov    (%eax),%edx
  801259:	8d 4a 08             	lea    0x8(%edx),%ecx
  80125c:	89 08                	mov    %ecx,(%eax)
  80125e:	8b 02                	mov    (%edx),%eax
  801260:	8b 52 04             	mov    0x4(%edx),%edx
  801263:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801264:	8b 10                	mov    (%eax),%edx
  801266:	8d 4a 04             	lea    0x4(%edx),%ecx
  801269:	89 08                	mov    %ecx,(%eax)
  80126b:	8b 02                	mov    (%edx),%eax
  80126d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801272:	c3                   	ret    

00801273 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801273:	83 fa 01             	cmp    $0x1,%edx
  801276:	7f 0f                	jg     801287 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801278:	85 d2                	test   %edx,%edx
  80127a:	74 18                	je     801294 <getint+0x21>
		return va_arg(*ap, long);
  80127c:	8b 10                	mov    (%eax),%edx
  80127e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801281:	89 08                	mov    %ecx,(%eax)
  801283:	8b 02                	mov    (%edx),%eax
  801285:	99                   	cltd   
  801286:	c3                   	ret    
		return va_arg(*ap, long long);
  801287:	8b 10                	mov    (%eax),%edx
  801289:	8d 4a 08             	lea    0x8(%edx),%ecx
  80128c:	89 08                	mov    %ecx,(%eax)
  80128e:	8b 02                	mov    (%edx),%eax
  801290:	8b 52 04             	mov    0x4(%edx),%edx
  801293:	c3                   	ret    
	else
		return va_arg(*ap, int);
  801294:	8b 10                	mov    (%eax),%edx
  801296:	8d 4a 04             	lea    0x4(%edx),%ecx
  801299:	89 08                	mov    %ecx,(%eax)
  80129b:	8b 02                	mov    (%edx),%eax
  80129d:	99                   	cltd   
}
  80129e:	c3                   	ret    

0080129f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ad:	8b 10                	mov    (%eax),%edx
  8012af:	3b 50 04             	cmp    0x4(%eax),%edx
  8012b2:	73 0a                	jae    8012be <sprintputch+0x1f>
		*b->buf++ = ch;
  8012b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b7:	89 08                	mov    %ecx,(%eax)
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	88 02                	mov    %al,(%edx)
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <printfmt>:
{
  8012c0:	f3 0f 1e fb          	endbr32 
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012ca:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 10             	pushl  0x10(%ebp)
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 05 00 00 00       	call   8012e1 <vprintfmt>
}
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <vprintfmt>:
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 2c             	sub    $0x2c,%esp
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012f7:	e9 86 02 00 00       	jmp    801582 <vprintfmt+0x2a1>
		padc = ' ';
  8012fc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801300:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801307:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80130e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801315:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80131a:	8d 47 01             	lea    0x1(%edi),%eax
  80131d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801320:	0f b6 17             	movzbl (%edi),%edx
  801323:	8d 42 dd             	lea    -0x23(%edx),%eax
  801326:	3c 55                	cmp    $0x55,%al
  801328:	0f 87 df 02 00 00    	ja     80160d <vprintfmt+0x32c>
  80132e:	0f b6 c0             	movzbl %al,%eax
  801331:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801338:	00 
  801339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80133c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801340:	eb d8                	jmp    80131a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801345:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801349:	eb cf                	jmp    80131a <vprintfmt+0x39>
  80134b:	0f b6 d2             	movzbl %dl,%edx
  80134e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801359:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80135c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801360:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801363:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801366:	83 f9 09             	cmp    $0x9,%ecx
  801369:	77 52                	ja     8013bd <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80136b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80136e:	eb e9                	jmp    801359 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8d 50 04             	lea    0x4(%eax),%edx
  801376:	89 55 14             	mov    %edx,0x14(%ebp)
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80137e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801381:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801385:	79 93                	jns    80131a <vprintfmt+0x39>
				width = precision, precision = -1;
  801387:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80138a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80138d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801394:	eb 84                	jmp    80131a <vprintfmt+0x39>
  801396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801399:	85 c0                	test   %eax,%eax
  80139b:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a0:	0f 49 d0             	cmovns %eax,%edx
  8013a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013a9:	e9 6c ff ff ff       	jmp    80131a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013b1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013b8:	e9 5d ff ff ff       	jmp    80131a <vprintfmt+0x39>
  8013bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013c3:	eb bc                	jmp    801381 <vprintfmt+0xa0>
			lflag++;
  8013c5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013cb:	e9 4a ff ff ff       	jmp    80131a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8d 50 04             	lea    0x4(%eax),%edx
  8013d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	56                   	push   %esi
  8013dd:	ff 30                	pushl  (%eax)
  8013df:	ff d3                	call   *%ebx
			break;
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	e9 96 01 00 00       	jmp    80157f <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8d 50 04             	lea    0x4(%eax),%edx
  8013ef:	89 55 14             	mov    %edx,0x14(%ebp)
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	99                   	cltd   
  8013f5:	31 d0                	xor    %edx,%eax
  8013f7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013f9:	83 f8 0f             	cmp    $0xf,%eax
  8013fc:	7f 20                	jg     80141e <vprintfmt+0x13d>
  8013fe:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  801405:	85 d2                	test   %edx,%edx
  801407:	74 15                	je     80141e <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801409:	52                   	push   %edx
  80140a:	68 0f 1f 80 00       	push   $0x801f0f
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	e8 aa fe ff ff       	call   8012c0 <printfmt>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	e9 61 01 00 00       	jmp    80157f <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80141e:	50                   	push   %eax
  80141f:	68 97 1f 80 00       	push   $0x801f97
  801424:	56                   	push   %esi
  801425:	53                   	push   %ebx
  801426:	e8 95 fe ff ff       	call   8012c0 <printfmt>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	e9 4c 01 00 00       	jmp    80157f <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8d 50 04             	lea    0x4(%eax),%edx
  801439:	89 55 14             	mov    %edx,0x14(%ebp)
  80143c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80143e:	85 c9                	test   %ecx,%ecx
  801440:	b8 90 1f 80 00       	mov    $0x801f90,%eax
  801445:	0f 45 c1             	cmovne %ecx,%eax
  801448:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80144b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80144f:	7e 06                	jle    801457 <vprintfmt+0x176>
  801451:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801455:	75 0d                	jne    801464 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80145a:	89 c7                	mov    %eax,%edi
  80145c:	03 45 e0             	add    -0x20(%ebp),%eax
  80145f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801462:	eb 57                	jmp    8014bb <vprintfmt+0x1da>
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	ff 75 d8             	pushl  -0x28(%ebp)
  80146a:	ff 75 cc             	pushl  -0x34(%ebp)
  80146d:	e8 4f 02 00 00       	call   8016c1 <strnlen>
  801472:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801475:	29 c2                	sub    %eax,%edx
  801477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80147a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80147d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801481:	89 5d 08             	mov    %ebx,0x8(%ebp)
  801484:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  801486:	85 db                	test   %ebx,%ebx
  801488:	7e 10                	jle    80149a <vprintfmt+0x1b9>
					putch(padc, putdat);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	56                   	push   %esi
  80148e:	57                   	push   %edi
  80148f:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801492:	83 eb 01             	sub    $0x1,%ebx
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	eb ec                	jmp    801486 <vprintfmt+0x1a5>
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80149d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a7:	0f 49 c2             	cmovns %edx,%eax
  8014aa:	29 c2                	sub    %eax,%edx
  8014ac:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014af:	eb a6                	jmp    801457 <vprintfmt+0x176>
					putch(ch, putdat);
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	56                   	push   %esi
  8014b5:	52                   	push   %edx
  8014b6:	ff d3                	call   *%ebx
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014be:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014c0:	83 c7 01             	add    $0x1,%edi
  8014c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014c7:	0f be d0             	movsbl %al,%edx
  8014ca:	85 d2                	test   %edx,%edx
  8014cc:	74 42                	je     801510 <vprintfmt+0x22f>
  8014ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014d2:	78 06                	js     8014da <vprintfmt+0x1f9>
  8014d4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014d8:	78 1e                	js     8014f8 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014de:	74 d1                	je     8014b1 <vprintfmt+0x1d0>
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	83 e8 20             	sub    $0x20,%eax
  8014e6:	83 f8 5e             	cmp    $0x5e,%eax
  8014e9:	76 c6                	jbe    8014b1 <vprintfmt+0x1d0>
					putch('?', putdat);
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	56                   	push   %esi
  8014ef:	6a 3f                	push   $0x3f
  8014f1:	ff d3                	call   *%ebx
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	eb c3                	jmp    8014bb <vprintfmt+0x1da>
  8014f8:	89 cf                	mov    %ecx,%edi
  8014fa:	eb 0e                	jmp    80150a <vprintfmt+0x229>
				putch(' ', putdat);
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	56                   	push   %esi
  801500:	6a 20                	push   $0x20
  801502:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  801504:	83 ef 01             	sub    $0x1,%edi
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 ff                	test   %edi,%edi
  80150c:	7f ee                	jg     8014fc <vprintfmt+0x21b>
  80150e:	eb 6f                	jmp    80157f <vprintfmt+0x29e>
  801510:	89 cf                	mov    %ecx,%edi
  801512:	eb f6                	jmp    80150a <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801514:	89 ca                	mov    %ecx,%edx
  801516:	8d 45 14             	lea    0x14(%ebp),%eax
  801519:	e8 55 fd ff ff       	call   801273 <getint>
  80151e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801521:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801524:	85 d2                	test   %edx,%edx
  801526:	78 0b                	js     801533 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801528:	89 d1                	mov    %edx,%ecx
  80152a:	89 c2                	mov    %eax,%edx
			base = 10;
  80152c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801531:	eb 32                	jmp    801565 <vprintfmt+0x284>
				putch('-', putdat);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	56                   	push   %esi
  801537:	6a 2d                	push   $0x2d
  801539:	ff d3                	call   *%ebx
				num = -(long long) num;
  80153b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80153e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801541:	f7 da                	neg    %edx
  801543:	83 d1 00             	adc    $0x0,%ecx
  801546:	f7 d9                	neg    %ecx
  801548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80154b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801550:	eb 13                	jmp    801565 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801552:	89 ca                	mov    %ecx,%edx
  801554:	8d 45 14             	lea    0x14(%ebp),%eax
  801557:	e8 e3 fc ff ff       	call   80123f <getuint>
  80155c:	89 d1                	mov    %edx,%ecx
  80155e:	89 c2                	mov    %eax,%edx
			base = 10;
  801560:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80156c:	57                   	push   %edi
  80156d:	ff 75 e0             	pushl  -0x20(%ebp)
  801570:	50                   	push   %eax
  801571:	51                   	push   %ecx
  801572:	52                   	push   %edx
  801573:	89 f2                	mov    %esi,%edx
  801575:	89 d8                	mov    %ebx,%eax
  801577:	e8 1a fc ff ff       	call   801196 <printnum>
			break;
  80157c:	83 c4 20             	add    $0x20,%esp
{
  80157f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801582:	83 c7 01             	add    $0x1,%edi
  801585:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801589:	83 f8 25             	cmp    $0x25,%eax
  80158c:	0f 84 6a fd ff ff    	je     8012fc <vprintfmt+0x1b>
			if (ch == '\0')
  801592:	85 c0                	test   %eax,%eax
  801594:	0f 84 93 00 00 00    	je     80162d <vprintfmt+0x34c>
			putch(ch, putdat);
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	56                   	push   %esi
  80159e:	50                   	push   %eax
  80159f:	ff d3                	call   *%ebx
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	eb dc                	jmp    801582 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8015a6:	89 ca                	mov    %ecx,%edx
  8015a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ab:	e8 8f fc ff ff       	call   80123f <getuint>
  8015b0:	89 d1                	mov    %edx,%ecx
  8015b2:	89 c2                	mov    %eax,%edx
			base = 8;
  8015b4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015b9:	eb aa                	jmp    801565 <vprintfmt+0x284>
			putch('0', putdat);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	56                   	push   %esi
  8015bf:	6a 30                	push   $0x30
  8015c1:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015c3:	83 c4 08             	add    $0x8,%esp
  8015c6:	56                   	push   %esi
  8015c7:	6a 78                	push   $0x78
  8015c9:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ce:	8d 50 04             	lea    0x4(%eax),%edx
  8015d1:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015d4:	8b 10                	mov    (%eax),%edx
  8015d6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015db:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015de:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015e3:	eb 80                	jmp    801565 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015e5:	89 ca                	mov    %ecx,%edx
  8015e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ea:	e8 50 fc ff ff       	call   80123f <getuint>
  8015ef:	89 d1                	mov    %edx,%ecx
  8015f1:	89 c2                	mov    %eax,%edx
			base = 16;
  8015f3:	b8 10 00 00 00       	mov    $0x10,%eax
  8015f8:	e9 68 ff ff ff       	jmp    801565 <vprintfmt+0x284>
			putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	56                   	push   %esi
  801601:	6a 25                	push   $0x25
  801603:	ff d3                	call   *%ebx
			break;
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	e9 72 ff ff ff       	jmp    80157f <vprintfmt+0x29e>
			putch('%', putdat);
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	56                   	push   %esi
  801611:	6a 25                	push   $0x25
  801613:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	89 f8                	mov    %edi,%eax
  80161a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80161e:	74 05                	je     801625 <vprintfmt+0x344>
  801620:	83 e8 01             	sub    $0x1,%eax
  801623:	eb f5                	jmp    80161a <vprintfmt+0x339>
  801625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801628:	e9 52 ff ff ff       	jmp    80157f <vprintfmt+0x29e>
}
  80162d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801630:	5b                   	pop    %ebx
  801631:	5e                   	pop    %esi
  801632:	5f                   	pop    %edi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801635:	f3 0f 1e fb          	endbr32 
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 18             	sub    $0x18,%esp
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801645:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801648:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80164c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80164f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801656:	85 c0                	test   %eax,%eax
  801658:	74 26                	je     801680 <vsnprintf+0x4b>
  80165a:	85 d2                	test   %edx,%edx
  80165c:	7e 22                	jle    801680 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80165e:	ff 75 14             	pushl  0x14(%ebp)
  801661:	ff 75 10             	pushl  0x10(%ebp)
  801664:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	68 9f 12 80 00       	push   $0x80129f
  80166d:	e8 6f fc ff ff       	call   8012e1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801675:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167b:	83 c4 10             	add    $0x10,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    
		return -E_INVAL;
  801680:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801685:	eb f7                	jmp    80167e <vsnprintf+0x49>

00801687 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801687:	f3 0f 1e fb          	endbr32 
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801691:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801694:	50                   	push   %eax
  801695:	ff 75 10             	pushl  0x10(%ebp)
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	ff 75 08             	pushl  0x8(%ebp)
  80169e:	e8 92 ff ff ff       	call   801635 <vsnprintf>
	va_end(ap);

	return rc;
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016a5:	f3 0f 1e fb          	endbr32 
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016b8:	74 05                	je     8016bf <strlen+0x1a>
		n++;
  8016ba:	83 c0 01             	add    $0x1,%eax
  8016bd:	eb f5                	jmp    8016b4 <strlen+0xf>
	return n;
}
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016c1:	f3 0f 1e fb          	endbr32 
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	39 d0                	cmp    %edx,%eax
  8016d5:	74 0d                	je     8016e4 <strnlen+0x23>
  8016d7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016db:	74 05                	je     8016e2 <strnlen+0x21>
		n++;
  8016dd:	83 c0 01             	add    $0x1,%eax
  8016e0:	eb f1                	jmp    8016d3 <strnlen+0x12>
  8016e2:	89 c2                	mov    %eax,%edx
	return n;
}
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016e8:	f3 0f 1e fb          	endbr32 
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	53                   	push   %ebx
  8016f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801702:	83 c0 01             	add    $0x1,%eax
  801705:	84 d2                	test   %dl,%dl
  801707:	75 f2                	jne    8016fb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801709:	89 c8                	mov    %ecx,%eax
  80170b:	5b                   	pop    %ebx
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80170e:	f3 0f 1e fb          	endbr32 
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 10             	sub    $0x10,%esp
  801719:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80171c:	53                   	push   %ebx
  80171d:	e8 83 ff ff ff       	call   8016a5 <strlen>
  801722:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	01 d8                	add    %ebx,%eax
  80172a:	50                   	push   %eax
  80172b:	e8 b8 ff ff ff       	call   8016e8 <strcpy>
	return dst;
}
  801730:	89 d8                	mov    %ebx,%eax
  801732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801737:	f3 0f 1e fb          	endbr32 
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	8b 75 08             	mov    0x8(%ebp),%esi
  801743:	8b 55 0c             	mov    0xc(%ebp),%edx
  801746:	89 f3                	mov    %esi,%ebx
  801748:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80174b:	89 f0                	mov    %esi,%eax
  80174d:	39 d8                	cmp    %ebx,%eax
  80174f:	74 11                	je     801762 <strncpy+0x2b>
		*dst++ = *src;
  801751:	83 c0 01             	add    $0x1,%eax
  801754:	0f b6 0a             	movzbl (%edx),%ecx
  801757:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80175a:	80 f9 01             	cmp    $0x1,%cl
  80175d:	83 da ff             	sbb    $0xffffffff,%edx
  801760:	eb eb                	jmp    80174d <strncpy+0x16>
	}
	return ret;
}
  801762:	89 f0                	mov    %esi,%eax
  801764:	5b                   	pop    %ebx
  801765:	5e                   	pop    %esi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	8b 75 08             	mov    0x8(%ebp),%esi
  801774:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801777:	8b 55 10             	mov    0x10(%ebp),%edx
  80177a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80177c:	85 d2                	test   %edx,%edx
  80177e:	74 21                	je     8017a1 <strlcpy+0x39>
  801780:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801784:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 14                	je     80179e <strlcpy+0x36>
  80178a:	0f b6 19             	movzbl (%ecx),%ebx
  80178d:	84 db                	test   %bl,%bl
  80178f:	74 0b                	je     80179c <strlcpy+0x34>
			*dst++ = *src++;
  801791:	83 c1 01             	add    $0x1,%ecx
  801794:	83 c2 01             	add    $0x1,%edx
  801797:	88 5a ff             	mov    %bl,-0x1(%edx)
  80179a:	eb ea                	jmp    801786 <strlcpy+0x1e>
  80179c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80179e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8017a1:	29 f0                	sub    %esi,%eax
}
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017a7:	f3 0f 1e fb          	endbr32 
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017b4:	0f b6 01             	movzbl (%ecx),%eax
  8017b7:	84 c0                	test   %al,%al
  8017b9:	74 0c                	je     8017c7 <strcmp+0x20>
  8017bb:	3a 02                	cmp    (%edx),%al
  8017bd:	75 08                	jne    8017c7 <strcmp+0x20>
		p++, q++;
  8017bf:	83 c1 01             	add    $0x1,%ecx
  8017c2:	83 c2 01             	add    $0x1,%edx
  8017c5:	eb ed                	jmp    8017b4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c7:	0f b6 c0             	movzbl %al,%eax
  8017ca:	0f b6 12             	movzbl (%edx),%edx
  8017cd:	29 d0                	sub    %edx,%eax
}
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    

008017d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017d1:	f3 0f 1e fb          	endbr32 
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017e4:	eb 06                	jmp    8017ec <strncmp+0x1b>
		n--, p++, q++;
  8017e6:	83 c0 01             	add    $0x1,%eax
  8017e9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017ec:	39 d8                	cmp    %ebx,%eax
  8017ee:	74 16                	je     801806 <strncmp+0x35>
  8017f0:	0f b6 08             	movzbl (%eax),%ecx
  8017f3:	84 c9                	test   %cl,%cl
  8017f5:	74 04                	je     8017fb <strncmp+0x2a>
  8017f7:	3a 0a                	cmp    (%edx),%cl
  8017f9:	74 eb                	je     8017e6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017fb:	0f b6 00             	movzbl (%eax),%eax
  8017fe:	0f b6 12             	movzbl (%edx),%edx
  801801:	29 d0                	sub    %edx,%eax
}
  801803:	5b                   	pop    %ebx
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
		return 0;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb f6                	jmp    801803 <strncmp+0x32>

0080180d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80180d:	f3 0f 1e fb          	endbr32 
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80181b:	0f b6 10             	movzbl (%eax),%edx
  80181e:	84 d2                	test   %dl,%dl
  801820:	74 09                	je     80182b <strchr+0x1e>
		if (*s == c)
  801822:	38 ca                	cmp    %cl,%dl
  801824:	74 0a                	je     801830 <strchr+0x23>
	for (; *s; s++)
  801826:	83 c0 01             	add    $0x1,%eax
  801829:	eb f0                	jmp    80181b <strchr+0xe>
			return (char *) s;
	return 0;
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801832:	f3 0f 1e fb          	endbr32 
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801840:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801843:	38 ca                	cmp    %cl,%dl
  801845:	74 09                	je     801850 <strfind+0x1e>
  801847:	84 d2                	test   %dl,%dl
  801849:	74 05                	je     801850 <strfind+0x1e>
	for (; *s; s++)
  80184b:	83 c0 01             	add    $0x1,%eax
  80184e:	eb f0                	jmp    801840 <strfind+0xe>
			break;
	return (char *) s;
}
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	57                   	push   %edi
  80185a:	56                   	push   %esi
  80185b:	53                   	push   %ebx
  80185c:	8b 55 08             	mov    0x8(%ebp),%edx
  80185f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801862:	85 c9                	test   %ecx,%ecx
  801864:	74 33                	je     801899 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801866:	89 d0                	mov    %edx,%eax
  801868:	09 c8                	or     %ecx,%eax
  80186a:	a8 03                	test   $0x3,%al
  80186c:	75 23                	jne    801891 <memset+0x3f>
		c &= 0xFF;
  80186e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801872:	89 d8                	mov    %ebx,%eax
  801874:	c1 e0 08             	shl    $0x8,%eax
  801877:	89 df                	mov    %ebx,%edi
  801879:	c1 e7 18             	shl    $0x18,%edi
  80187c:	89 de                	mov    %ebx,%esi
  80187e:	c1 e6 10             	shl    $0x10,%esi
  801881:	09 f7                	or     %esi,%edi
  801883:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801885:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801888:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80188a:	89 d7                	mov    %edx,%edi
  80188c:	fc                   	cld    
  80188d:	f3 ab                	rep stos %eax,%es:(%edi)
  80188f:	eb 08                	jmp    801899 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801891:	89 d7                	mov    %edx,%edi
  801893:	8b 45 0c             	mov    0xc(%ebp),%eax
  801896:	fc                   	cld    
  801897:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801899:	89 d0                	mov    %edx,%eax
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5f                   	pop    %edi
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8018a0:	f3 0f 1e fb          	endbr32 
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	57                   	push   %edi
  8018a8:	56                   	push   %esi
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018b2:	39 c6                	cmp    %eax,%esi
  8018b4:	73 32                	jae    8018e8 <memmove+0x48>
  8018b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018b9:	39 c2                	cmp    %eax,%edx
  8018bb:	76 2b                	jbe    8018e8 <memmove+0x48>
		s += n;
		d += n;
  8018bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018c0:	89 fe                	mov    %edi,%esi
  8018c2:	09 ce                	or     %ecx,%esi
  8018c4:	09 d6                	or     %edx,%esi
  8018c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018cc:	75 0e                	jne    8018dc <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018ce:	83 ef 04             	sub    $0x4,%edi
  8018d1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018d4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018d7:	fd                   	std    
  8018d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018da:	eb 09                	jmp    8018e5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018dc:	83 ef 01             	sub    $0x1,%edi
  8018df:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018e2:	fd                   	std    
  8018e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018e5:	fc                   	cld    
  8018e6:	eb 1a                	jmp    801902 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018e8:	89 c2                	mov    %eax,%edx
  8018ea:	09 ca                	or     %ecx,%edx
  8018ec:	09 f2                	or     %esi,%edx
  8018ee:	f6 c2 03             	test   $0x3,%dl
  8018f1:	75 0a                	jne    8018fd <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018f3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018f6:	89 c7                	mov    %eax,%edi
  8018f8:	fc                   	cld    
  8018f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018fb:	eb 05                	jmp    801902 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018fd:	89 c7                	mov    %eax,%edi
  8018ff:	fc                   	cld    
  801900:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801906:	f3 0f 1e fb          	endbr32 
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801910:	ff 75 10             	pushl  0x10(%ebp)
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	e8 82 ff ff ff       	call   8018a0 <memmove>
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801920:	f3 0f 1e fb          	endbr32 
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	89 c6                	mov    %eax,%esi
  801931:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801934:	39 f0                	cmp    %esi,%eax
  801936:	74 1c                	je     801954 <memcmp+0x34>
		if (*s1 != *s2)
  801938:	0f b6 08             	movzbl (%eax),%ecx
  80193b:	0f b6 1a             	movzbl (%edx),%ebx
  80193e:	38 d9                	cmp    %bl,%cl
  801940:	75 08                	jne    80194a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801942:	83 c0 01             	add    $0x1,%eax
  801945:	83 c2 01             	add    $0x1,%edx
  801948:	eb ea                	jmp    801934 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80194a:	0f b6 c1             	movzbl %cl,%eax
  80194d:	0f b6 db             	movzbl %bl,%ebx
  801950:	29 d8                	sub    %ebx,%eax
  801952:	eb 05                	jmp    801959 <memcmp+0x39>
	}

	return 0;
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80195d:	f3 0f 1e fb          	endbr32 
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80196a:	89 c2                	mov    %eax,%edx
  80196c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80196f:	39 d0                	cmp    %edx,%eax
  801971:	73 09                	jae    80197c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801973:	38 08                	cmp    %cl,(%eax)
  801975:	74 05                	je     80197c <memfind+0x1f>
	for (; s < ends; s++)
  801977:	83 c0 01             	add    $0x1,%eax
  80197a:	eb f3                	jmp    80196f <memfind+0x12>
			break;
	return (void *) s;
}
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80197e:	f3 0f 1e fb          	endbr32 
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	57                   	push   %edi
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
  801988:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80198b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80198e:	eb 03                	jmp    801993 <strtol+0x15>
		s++;
  801990:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801993:	0f b6 01             	movzbl (%ecx),%eax
  801996:	3c 20                	cmp    $0x20,%al
  801998:	74 f6                	je     801990 <strtol+0x12>
  80199a:	3c 09                	cmp    $0x9,%al
  80199c:	74 f2                	je     801990 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80199e:	3c 2b                	cmp    $0x2b,%al
  8019a0:	74 2a                	je     8019cc <strtol+0x4e>
	int neg = 0;
  8019a2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8019a7:	3c 2d                	cmp    $0x2d,%al
  8019a9:	74 2b                	je     8019d6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019ab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019b1:	75 0f                	jne    8019c2 <strtol+0x44>
  8019b3:	80 39 30             	cmpb   $0x30,(%ecx)
  8019b6:	74 28                	je     8019e0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019b8:	85 db                	test   %ebx,%ebx
  8019ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019bf:	0f 44 d8             	cmove  %eax,%ebx
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019ca:	eb 46                	jmp    801a12 <strtol+0x94>
		s++;
  8019cc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d4:	eb d5                	jmp    8019ab <strtol+0x2d>
		s++, neg = 1;
  8019d6:	83 c1 01             	add    $0x1,%ecx
  8019d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019de:	eb cb                	jmp    8019ab <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019e0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019e4:	74 0e                	je     8019f4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019e6:	85 db                	test   %ebx,%ebx
  8019e8:	75 d8                	jne    8019c2 <strtol+0x44>
		s++, base = 8;
  8019ea:	83 c1 01             	add    $0x1,%ecx
  8019ed:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019f2:	eb ce                	jmp    8019c2 <strtol+0x44>
		s += 2, base = 16;
  8019f4:	83 c1 02             	add    $0x2,%ecx
  8019f7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019fc:	eb c4                	jmp    8019c2 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019fe:	0f be d2             	movsbl %dl,%edx
  801a01:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801a04:	3b 55 10             	cmp    0x10(%ebp),%edx
  801a07:	7d 3a                	jge    801a43 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801a09:	83 c1 01             	add    $0x1,%ecx
  801a0c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a10:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a12:	0f b6 11             	movzbl (%ecx),%edx
  801a15:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a18:	89 f3                	mov    %esi,%ebx
  801a1a:	80 fb 09             	cmp    $0x9,%bl
  801a1d:	76 df                	jbe    8019fe <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a1f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a22:	89 f3                	mov    %esi,%ebx
  801a24:	80 fb 19             	cmp    $0x19,%bl
  801a27:	77 08                	ja     801a31 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a29:	0f be d2             	movsbl %dl,%edx
  801a2c:	83 ea 57             	sub    $0x57,%edx
  801a2f:	eb d3                	jmp    801a04 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a31:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a34:	89 f3                	mov    %esi,%ebx
  801a36:	80 fb 19             	cmp    $0x19,%bl
  801a39:	77 08                	ja     801a43 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a3b:	0f be d2             	movsbl %dl,%edx
  801a3e:	83 ea 37             	sub    $0x37,%edx
  801a41:	eb c1                	jmp    801a04 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 05                	je     801a4e <strtol+0xd0>
		*endptr = (char *) s;
  801a49:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a4c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a4e:	89 c2                	mov    %eax,%edx
  801a50:	f7 da                	neg    %edx
  801a52:	85 ff                	test   %edi,%edi
  801a54:	0f 45 c2             	cmovne %edx,%eax
}
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a5c:	f3 0f 1e fb          	endbr32 
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	8b 75 08             	mov    0x8(%ebp),%esi
  801a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a75:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	50                   	push   %eax
  801a7c:	e8 68 e8 ff ff       	call   8002e9 <sys_ipc_recv>
	if (r < 0) {
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 2b                	js     801ab3 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a88:	85 f6                	test   %esi,%esi
  801a8a:	74 0a                	je     801a96 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a8c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a91:	8b 40 74             	mov    0x74(%eax),%eax
  801a94:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a96:	85 db                	test   %ebx,%ebx
  801a98:	74 0a                	je     801aa4 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9f:	8b 40 78             	mov    0x78(%eax),%eax
  801aa2:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801aa4:	a1 04 40 80 00       	mov    0x804004,%eax
  801aa9:	8b 40 70             	mov    0x70(%eax),%eax
}
  801aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    
		if (from_env_store) {
  801ab3:	85 f6                	test   %esi,%esi
  801ab5:	74 06                	je     801abd <ipc_recv+0x61>
			*from_env_store = 0;
  801ab7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801abd:	85 db                	test   %ebx,%ebx
  801abf:	74 eb                	je     801aac <ipc_recv+0x50>
			*perm_store = 0;
  801ac1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ac7:	eb e3                	jmp    801aac <ipc_recv+0x50>

00801ac9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ac9:	f3 0f 1e fb          	endbr32 
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	57                   	push   %edi
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ad9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801adc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801adf:	85 db                	test   %ebx,%ebx
  801ae1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ae6:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ae9:	ff 75 14             	pushl  0x14(%ebp)
  801aec:	53                   	push   %ebx
  801aed:	56                   	push   %esi
  801aee:	57                   	push   %edi
  801aef:	e8 cc e7 ff ff       	call   8002c0 <sys_ipc_try_send>
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801afa:	75 07                	jne    801b03 <ipc_send+0x3a>
		sys_yield();
  801afc:	e8 a6 e6 ff ff       	call   8001a7 <sys_yield>
  801b01:	eb e6                	jmp    801ae9 <ipc_send+0x20>
	}

	if (ret < 0) {
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 08                	js     801b0f <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5e                   	pop    %esi
  801b0c:	5f                   	pop    %edi
  801b0d:	5d                   	pop    %ebp
  801b0e:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b0f:	50                   	push   %eax
  801b10:	68 7f 22 80 00       	push   $0x80227f
  801b15:	6a 48                	push   $0x48
  801b17:	68 9c 22 80 00       	push   $0x80229c
  801b1c:	e8 76 f5 ff ff       	call   801097 <_panic>

00801b21 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b21:	f3 0f 1e fb          	endbr32 
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b2b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b30:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b33:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b39:	8b 52 50             	mov    0x50(%edx),%edx
  801b3c:	39 ca                	cmp    %ecx,%edx
  801b3e:	74 11                	je     801b51 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b40:	83 c0 01             	add    $0x1,%eax
  801b43:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b48:	75 e6                	jne    801b30 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	eb 0b                	jmp    801b5c <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b51:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b59:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b5e:	f3 0f 1e fb          	endbr32 
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b68:	89 c2                	mov    %eax,%edx
  801b6a:	c1 ea 16             	shr    $0x16,%edx
  801b6d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b74:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b79:	f6 c1 01             	test   $0x1,%cl
  801b7c:	74 1c                	je     801b9a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b7e:	c1 e8 0c             	shr    $0xc,%eax
  801b81:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b88:	a8 01                	test   $0x1,%al
  801b8a:	74 0e                	je     801b9a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b8c:	c1 e8 0c             	shr    $0xc,%eax
  801b8f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b96:	ef 
  801b97:	0f b7 d2             	movzwl %dx,%edx
}
  801b9a:	89 d0                	mov    %edx,%eax
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    
  801b9e:	66 90                	xchg   %ax,%ax

00801ba0 <__udivdi3>:
  801ba0:	f3 0f 1e fb          	endbr32 
  801ba4:	55                   	push   %ebp
  801ba5:	57                   	push   %edi
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801baf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bb7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bbb:	85 d2                	test   %edx,%edx
  801bbd:	75 19                	jne    801bd8 <__udivdi3+0x38>
  801bbf:	39 f3                	cmp    %esi,%ebx
  801bc1:	76 4d                	jbe    801c10 <__udivdi3+0x70>
  801bc3:	31 ff                	xor    %edi,%edi
  801bc5:	89 e8                	mov    %ebp,%eax
  801bc7:	89 f2                	mov    %esi,%edx
  801bc9:	f7 f3                	div    %ebx
  801bcb:	89 fa                	mov    %edi,%edx
  801bcd:	83 c4 1c             	add    $0x1c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    
  801bd5:	8d 76 00             	lea    0x0(%esi),%esi
  801bd8:	39 f2                	cmp    %esi,%edx
  801bda:	76 14                	jbe    801bf0 <__udivdi3+0x50>
  801bdc:	31 ff                	xor    %edi,%edi
  801bde:	31 c0                	xor    %eax,%eax
  801be0:	89 fa                	mov    %edi,%edx
  801be2:	83 c4 1c             	add    $0x1c,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5f                   	pop    %edi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    
  801bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bf0:	0f bd fa             	bsr    %edx,%edi
  801bf3:	83 f7 1f             	xor    $0x1f,%edi
  801bf6:	75 48                	jne    801c40 <__udivdi3+0xa0>
  801bf8:	39 f2                	cmp    %esi,%edx
  801bfa:	72 06                	jb     801c02 <__udivdi3+0x62>
  801bfc:	31 c0                	xor    %eax,%eax
  801bfe:	39 eb                	cmp    %ebp,%ebx
  801c00:	77 de                	ja     801be0 <__udivdi3+0x40>
  801c02:	b8 01 00 00 00       	mov    $0x1,%eax
  801c07:	eb d7                	jmp    801be0 <__udivdi3+0x40>
  801c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c10:	89 d9                	mov    %ebx,%ecx
  801c12:	85 db                	test   %ebx,%ebx
  801c14:	75 0b                	jne    801c21 <__udivdi3+0x81>
  801c16:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	f7 f3                	div    %ebx
  801c1f:	89 c1                	mov    %eax,%ecx
  801c21:	31 d2                	xor    %edx,%edx
  801c23:	89 f0                	mov    %esi,%eax
  801c25:	f7 f1                	div    %ecx
  801c27:	89 c6                	mov    %eax,%esi
  801c29:	89 e8                	mov    %ebp,%eax
  801c2b:	89 f7                	mov    %esi,%edi
  801c2d:	f7 f1                	div    %ecx
  801c2f:	89 fa                	mov    %edi,%edx
  801c31:	83 c4 1c             	add    $0x1c,%esp
  801c34:	5b                   	pop    %ebx
  801c35:	5e                   	pop    %esi
  801c36:	5f                   	pop    %edi
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    
  801c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c40:	89 f9                	mov    %edi,%ecx
  801c42:	b8 20 00 00 00       	mov    $0x20,%eax
  801c47:	29 f8                	sub    %edi,%eax
  801c49:	d3 e2                	shl    %cl,%edx
  801c4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c4f:	89 c1                	mov    %eax,%ecx
  801c51:	89 da                	mov    %ebx,%edx
  801c53:	d3 ea                	shr    %cl,%edx
  801c55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c59:	09 d1                	or     %edx,%ecx
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c61:	89 f9                	mov    %edi,%ecx
  801c63:	d3 e3                	shl    %cl,%ebx
  801c65:	89 c1                	mov    %eax,%ecx
  801c67:	d3 ea                	shr    %cl,%edx
  801c69:	89 f9                	mov    %edi,%ecx
  801c6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c6f:	89 eb                	mov    %ebp,%ebx
  801c71:	d3 e6                	shl    %cl,%esi
  801c73:	89 c1                	mov    %eax,%ecx
  801c75:	d3 eb                	shr    %cl,%ebx
  801c77:	09 de                	or     %ebx,%esi
  801c79:	89 f0                	mov    %esi,%eax
  801c7b:	f7 74 24 08          	divl   0x8(%esp)
  801c7f:	89 d6                	mov    %edx,%esi
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	f7 64 24 0c          	mull   0xc(%esp)
  801c87:	39 d6                	cmp    %edx,%esi
  801c89:	72 15                	jb     801ca0 <__udivdi3+0x100>
  801c8b:	89 f9                	mov    %edi,%ecx
  801c8d:	d3 e5                	shl    %cl,%ebp
  801c8f:	39 c5                	cmp    %eax,%ebp
  801c91:	73 04                	jae    801c97 <__udivdi3+0xf7>
  801c93:	39 d6                	cmp    %edx,%esi
  801c95:	74 09                	je     801ca0 <__udivdi3+0x100>
  801c97:	89 d8                	mov    %ebx,%eax
  801c99:	31 ff                	xor    %edi,%edi
  801c9b:	e9 40 ff ff ff       	jmp    801be0 <__udivdi3+0x40>
  801ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	e9 36 ff ff ff       	jmp    801be0 <__udivdi3+0x40>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	66 90                	xchg   %ax,%ax
  801cae:	66 90                	xchg   %ax,%ax

00801cb0 <__umoddi3>:
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 1c             	sub    $0x1c,%esp
  801cbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801cc3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	75 19                	jne    801ce8 <__umoddi3+0x38>
  801ccf:	39 df                	cmp    %ebx,%edi
  801cd1:	76 5d                	jbe    801d30 <__umoddi3+0x80>
  801cd3:	89 f0                	mov    %esi,%eax
  801cd5:	89 da                	mov    %ebx,%edx
  801cd7:	f7 f7                	div    %edi
  801cd9:	89 d0                	mov    %edx,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	89 f2                	mov    %esi,%edx
  801cea:	39 d8                	cmp    %ebx,%eax
  801cec:	76 12                	jbe    801d00 <__umoddi3+0x50>
  801cee:	89 f0                	mov    %esi,%eax
  801cf0:	89 da                	mov    %ebx,%edx
  801cf2:	83 c4 1c             	add    $0x1c,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
  801cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d00:	0f bd e8             	bsr    %eax,%ebp
  801d03:	83 f5 1f             	xor    $0x1f,%ebp
  801d06:	75 50                	jne    801d58 <__umoddi3+0xa8>
  801d08:	39 d8                	cmp    %ebx,%eax
  801d0a:	0f 82 e0 00 00 00    	jb     801df0 <__umoddi3+0x140>
  801d10:	89 d9                	mov    %ebx,%ecx
  801d12:	39 f7                	cmp    %esi,%edi
  801d14:	0f 86 d6 00 00 00    	jbe    801df0 <__umoddi3+0x140>
  801d1a:	89 d0                	mov    %edx,%eax
  801d1c:	89 ca                	mov    %ecx,%edx
  801d1e:	83 c4 1c             	add    $0x1c,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
  801d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d2d:	8d 76 00             	lea    0x0(%esi),%esi
  801d30:	89 fd                	mov    %edi,%ebp
  801d32:	85 ff                	test   %edi,%edi
  801d34:	75 0b                	jne    801d41 <__umoddi3+0x91>
  801d36:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f7                	div    %edi
  801d3f:	89 c5                	mov    %eax,%ebp
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	31 d2                	xor    %edx,%edx
  801d45:	f7 f5                	div    %ebp
  801d47:	89 f0                	mov    %esi,%eax
  801d49:	f7 f5                	div    %ebp
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	31 d2                	xor    %edx,%edx
  801d4f:	eb 8c                	jmp    801cdd <__umoddi3+0x2d>
  801d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d58:	89 e9                	mov    %ebp,%ecx
  801d5a:	ba 20 00 00 00       	mov    $0x20,%edx
  801d5f:	29 ea                	sub    %ebp,%edx
  801d61:	d3 e0                	shl    %cl,%eax
  801d63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d67:	89 d1                	mov    %edx,%ecx
  801d69:	89 f8                	mov    %edi,%eax
  801d6b:	d3 e8                	shr    %cl,%eax
  801d6d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d75:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d79:	09 c1                	or     %eax,%ecx
  801d7b:	89 d8                	mov    %ebx,%eax
  801d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d81:	89 e9                	mov    %ebp,%ecx
  801d83:	d3 e7                	shl    %cl,%edi
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	d3 e8                	shr    %cl,%eax
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d8f:	d3 e3                	shl    %cl,%ebx
  801d91:	89 c7                	mov    %eax,%edi
  801d93:	89 d1                	mov    %edx,%ecx
  801d95:	89 f0                	mov    %esi,%eax
  801d97:	d3 e8                	shr    %cl,%eax
  801d99:	89 e9                	mov    %ebp,%ecx
  801d9b:	89 fa                	mov    %edi,%edx
  801d9d:	d3 e6                	shl    %cl,%esi
  801d9f:	09 d8                	or     %ebx,%eax
  801da1:	f7 74 24 08          	divl   0x8(%esp)
  801da5:	89 d1                	mov    %edx,%ecx
  801da7:	89 f3                	mov    %esi,%ebx
  801da9:	f7 64 24 0c          	mull   0xc(%esp)
  801dad:	89 c6                	mov    %eax,%esi
  801daf:	89 d7                	mov    %edx,%edi
  801db1:	39 d1                	cmp    %edx,%ecx
  801db3:	72 06                	jb     801dbb <__umoddi3+0x10b>
  801db5:	75 10                	jne    801dc7 <__umoddi3+0x117>
  801db7:	39 c3                	cmp    %eax,%ebx
  801db9:	73 0c                	jae    801dc7 <__umoddi3+0x117>
  801dbb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801dbf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801dc3:	89 d7                	mov    %edx,%edi
  801dc5:	89 c6                	mov    %eax,%esi
  801dc7:	89 ca                	mov    %ecx,%edx
  801dc9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801dce:	29 f3                	sub    %esi,%ebx
  801dd0:	19 fa                	sbb    %edi,%edx
  801dd2:	89 d0                	mov    %edx,%eax
  801dd4:	d3 e0                	shl    %cl,%eax
  801dd6:	89 e9                	mov    %ebp,%ecx
  801dd8:	d3 eb                	shr    %cl,%ebx
  801dda:	d3 ea                	shr    %cl,%edx
  801ddc:	09 d8                	or     %ebx,%eax
  801dde:	83 c4 1c             	add    $0x1c,%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5f                   	pop    %edi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
  801de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ded:	8d 76 00             	lea    0x0(%esi),%esi
  801df0:	29 fe                	sub    %edi,%esi
  801df2:	19 c3                	sbb    %eax,%ebx
  801df4:	89 f2                	mov    %esi,%edx
  801df6:	89 d9                	mov    %ebx,%ecx
  801df8:	e9 1d ff ff ff       	jmp    801d1a <__umoddi3+0x6a>
