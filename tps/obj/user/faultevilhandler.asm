
obj/user/faultevilhandler.debug:     formato del fichero elf32-i386


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
  80002c:	e8 38 00 00 00       	call   800069 <libmain>
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
  80003a:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80003d:	6a 07                	push   $0x7
  80003f:	68 00 f0 bf ee       	push   $0xeebff000
  800044:	6a 00                	push   $0x0
  800046:	e8 9e 01 00 00       	call   8001e9 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	68 20 00 10 f0       	push   $0xf0100020
  800053:	6a 00                	push   $0x0
  800055:	e8 56 02 00 00       	call   8002b0 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80005a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800061:	00 00 00 
}
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	c9                   	leave  
  800068:	c3                   	ret    

00800069 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800069:	f3 0f 1e fb          	endbr32 
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	56                   	push   %esi
  800071:	53                   	push   %ebx
  800072:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800075:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800078:	e8 19 01 00 00       	call   800196 <sys_getenvid>
	if (id >= 0)
  80007d:	85 c0                	test   %eax,%eax
  80007f:	78 12                	js     800093 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800081:	25 ff 03 00 00       	and    $0x3ff,%eax
  800086:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800089:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800093:	85 db                	test   %ebx,%ebx
  800095:	7e 07                	jle    80009e <libmain+0x35>
		binaryname = argv[0];
  800097:	8b 06                	mov    (%esi),%eax
  800099:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	e8 8b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a8:	e8 0a 00 00 00       	call   8000b7 <exit>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b7:	f3 0f 1e fb          	endbr32 
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c1:	e8 53 04 00 00       	call   800519 <close_all>
	sys_env_destroy(0);
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	6a 00                	push   $0x0
  8000cb:	e8 a0 00 00 00       	call   800170 <sys_env_destroy>
}
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    

008000d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000d5:	55                   	push   %ebp
  8000d6:	89 e5                	mov    %esp,%ebp
  8000d8:	57                   	push   %edi
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	83 ec 1c             	sub    $0x1c,%esp
  8000de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000e4:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000ef:	8b 75 14             	mov    0x14(%ebp),%esi
  8000f2:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000f8:	74 04                	je     8000fe <syscall+0x29>
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7f 08                	jg     800106 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800101:	5b                   	pop    %ebx
  800102:	5e                   	pop    %esi
  800103:	5f                   	pop    %edi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	50                   	push   %eax
  80010a:	ff 75 e0             	pushl  -0x20(%ebp)
  80010d:	68 2a 1e 80 00       	push   $0x801e2a
  800112:	6a 23                	push   $0x23
  800114:	68 47 1e 80 00       	push   $0x801e47
  800119:	e8 90 0f 00 00       	call   8010ae <_panic>

0080011e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80011e:	f3 0f 1e fb          	endbr32 
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800128:	6a 00                	push   $0x0
  80012a:	6a 00                	push   $0x0
  80012c:	6a 00                	push   $0x0
  80012e:	ff 75 0c             	pushl  0xc(%ebp)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 00 00 00 00       	mov    $0x0,%eax
  80013e:	e8 92 ff ff ff       	call   8000d5 <syscall>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <sys_cgetc>:

int
sys_cgetc(void)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800152:	6a 00                	push   $0x0
  800154:	6a 00                	push   $0x0
  800156:	6a 00                	push   $0x0
  800158:	6a 00                	push   $0x0
  80015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80015f:	ba 00 00 00 00       	mov    $0x0,%edx
  800164:	b8 01 00 00 00       	mov    $0x1,%eax
  800169:	e8 67 ff ff ff       	call   8000d5 <syscall>
}
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800170:	f3 0f 1e fb          	endbr32 
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80017a:	6a 00                	push   $0x0
  80017c:	6a 00                	push   $0x0
  80017e:	6a 00                	push   $0x0
  800180:	6a 00                	push   $0x0
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	ba 01 00 00 00       	mov    $0x1,%edx
  80018a:	b8 03 00 00 00       	mov    $0x3,%eax
  80018f:	e8 41 ff ff ff       	call   8000d5 <syscall>
}
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800196:	f3 0f 1e fb          	endbr32 
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001a0:	6a 00                	push   $0x0
  8001a2:	6a 00                	push   $0x0
  8001a4:	6a 00                	push   $0x0
  8001a6:	6a 00                	push   $0x0
  8001a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8001b7:	e8 19 ff ff ff       	call   8000d5 <syscall>
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <sys_yield>:

void
sys_yield(void)
{
  8001be:	f3 0f 1e fb          	endbr32 
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001c8:	6a 00                	push   $0x0
  8001ca:	6a 00                	push   $0x0
  8001cc:	6a 00                	push   $0x0
  8001ce:	6a 00                	push   $0x0
  8001d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001da:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001df:	e8 f1 fe ff ff       	call   8000d5 <syscall>
}
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001e9:	f3 0f 1e fb          	endbr32 
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001f3:	6a 00                	push   $0x0
  8001f5:	6a 00                	push   $0x0
  8001f7:	ff 75 10             	pushl  0x10(%ebp)
  8001fa:	ff 75 0c             	pushl  0xc(%ebp)
  8001fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800200:	ba 01 00 00 00       	mov    $0x1,%edx
  800205:	b8 04 00 00 00       	mov    $0x4,%eax
  80020a:	e8 c6 fe ff ff       	call   8000d5 <syscall>
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800211:	f3 0f 1e fb          	endbr32 
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80021b:	ff 75 18             	pushl  0x18(%ebp)
  80021e:	ff 75 14             	pushl  0x14(%ebp)
  800221:	ff 75 10             	pushl  0x10(%ebp)
  800224:	ff 75 0c             	pushl  0xc(%ebp)
  800227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022a:	ba 01 00 00 00       	mov    $0x1,%edx
  80022f:	b8 05 00 00 00       	mov    $0x5,%eax
  800234:	e8 9c fe ff ff       	call   8000d5 <syscall>
}
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80023b:	f3 0f 1e fb          	endbr32 
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800245:	6a 00                	push   $0x0
  800247:	6a 00                	push   $0x0
  800249:	6a 00                	push   $0x0
  80024b:	ff 75 0c             	pushl  0xc(%ebp)
  80024e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800251:	ba 01 00 00 00       	mov    $0x1,%edx
  800256:	b8 06 00 00 00       	mov    $0x6,%eax
  80025b:	e8 75 fe ff ff       	call   8000d5 <syscall>
}
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800262:	f3 0f 1e fb          	endbr32 
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80026c:	6a 00                	push   $0x0
  80026e:	6a 00                	push   $0x0
  800270:	6a 00                	push   $0x0
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800278:	ba 01 00 00 00       	mov    $0x1,%edx
  80027d:	b8 08 00 00 00       	mov    $0x8,%eax
  800282:	e8 4e fe ff ff       	call   8000d5 <syscall>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800289:	f3 0f 1e fb          	endbr32 
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800293:	6a 00                	push   $0x0
  800295:	6a 00                	push   $0x0
  800297:	6a 00                	push   $0x0
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029f:	ba 01 00 00 00       	mov    $0x1,%edx
  8002a4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a9:	e8 27 fe ff ff       	call   8000d5 <syscall>
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b0:	f3 0f 1e fb          	endbr32 
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8002ba:	6a 00                	push   $0x0
  8002bc:	6a 00                	push   $0x0
  8002be:	6a 00                	push   $0x0
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c6:	ba 01 00 00 00       	mov    $0x1,%edx
  8002cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d0:	e8 00 fe ff ff       	call   8000d5 <syscall>
}
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002d7:	f3 0f 1e fb          	endbr32 
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002e1:	6a 00                	push   $0x0
  8002e3:	ff 75 14             	pushl  0x14(%ebp)
  8002e6:	ff 75 10             	pushl  0x10(%ebp)
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f9:	e8 d7 fd ff ff       	call   8000d5 <syscall>
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800300:	f3 0f 1e fb          	endbr32 
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80030a:	6a 00                	push   $0x0
  80030c:	6a 00                	push   $0x0
  80030e:	6a 00                	push   $0x0
  800310:	6a 00                	push   $0x0
  800312:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800315:	ba 01 00 00 00       	mov    $0x1,%edx
  80031a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031f:	e8 b1 fd ff ff       	call   8000d5 <syscall>
}
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800326:	f3 0f 1e fb          	endbr32 
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	05 00 00 00 30       	add    $0x30000000,%eax
  800335:	c1 e8 0c             	shr    $0xc,%eax
}
  800338:	5d                   	pop    %ebp
  800339:	c3                   	ret    

0080033a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80033a:	f3 0f 1e fb          	endbr32 
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 da ff ff ff       	call   800326 <fd2num>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	c1 e0 0c             	shl    $0xc,%eax
  800352:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800359:	f3 0f 1e fb          	endbr32 
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800365:	89 c2                	mov    %eax,%edx
  800367:	c1 ea 16             	shr    $0x16,%edx
  80036a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800371:	f6 c2 01             	test   $0x1,%dl
  800374:	74 2d                	je     8003a3 <fd_alloc+0x4a>
  800376:	89 c2                	mov    %eax,%edx
  800378:	c1 ea 0c             	shr    $0xc,%edx
  80037b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800382:	f6 c2 01             	test   $0x1,%dl
  800385:	74 1c                	je     8003a3 <fd_alloc+0x4a>
  800387:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80038c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800391:	75 d2                	jne    800365 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800393:	8b 45 08             	mov    0x8(%ebp),%eax
  800396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80039c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003a1:	eb 0a                	jmp    8003ad <fd_alloc+0x54>
			*fd_store = fd;
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003af:	f3 0f 1e fb          	endbr32 
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003b9:	83 f8 1f             	cmp    $0x1f,%eax
  8003bc:	77 30                	ja     8003ee <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003be:	c1 e0 0c             	shl    $0xc,%eax
  8003c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003c6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003cc:	f6 c2 01             	test   $0x1,%dl
  8003cf:	74 24                	je     8003f5 <fd_lookup+0x46>
  8003d1:	89 c2                	mov    %eax,%edx
  8003d3:	c1 ea 0c             	shr    $0xc,%edx
  8003d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003dd:	f6 c2 01             	test   $0x1,%dl
  8003e0:	74 1a                	je     8003fc <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e5:	89 02                	mov    %eax,(%edx)
	return 0;
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    
		return -E_INVAL;
  8003ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003f3:	eb f7                	jmp    8003ec <fd_lookup+0x3d>
		return -E_INVAL;
  8003f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003fa:	eb f0                	jmp    8003ec <fd_lookup+0x3d>
  8003fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800401:	eb e9                	jmp    8003ec <fd_lookup+0x3d>

00800403 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800403:	f3 0f 1e fb          	endbr32 
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800410:	ba d4 1e 80 00       	mov    $0x801ed4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800415:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80041a:	39 08                	cmp    %ecx,(%eax)
  80041c:	74 33                	je     800451 <dev_lookup+0x4e>
  80041e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800421:	8b 02                	mov    (%edx),%eax
  800423:	85 c0                	test   %eax,%eax
  800425:	75 f3                	jne    80041a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800427:	a1 04 40 80 00       	mov    0x804004,%eax
  80042c:	8b 40 48             	mov    0x48(%eax),%eax
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	51                   	push   %ecx
  800433:	50                   	push   %eax
  800434:	68 58 1e 80 00       	push   $0x801e58
  800439:	e8 57 0d 00 00       	call   801195 <cprintf>
	*dev = 0;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80044f:	c9                   	leave  
  800450:	c3                   	ret    
			*dev = devtab[i];
  800451:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800454:	89 01                	mov    %eax,(%ecx)
			return 0;
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	eb f2                	jmp    80044f <dev_lookup+0x4c>

0080045d <fd_close>:
{
  80045d:	f3 0f 1e fb          	endbr32 
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	57                   	push   %edi
  800465:	56                   	push   %esi
  800466:	53                   	push   %ebx
  800467:	83 ec 28             	sub    $0x28,%esp
  80046a:	8b 75 08             	mov    0x8(%ebp),%esi
  80046d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800470:	56                   	push   %esi
  800471:	e8 b0 fe ff ff       	call   800326 <fd2num>
  800476:	83 c4 08             	add    $0x8,%esp
  800479:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	e8 2c ff ff ff       	call   8003af <fd_lookup>
  800483:	89 c3                	mov    %eax,%ebx
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	85 c0                	test   %eax,%eax
  80048a:	78 05                	js     800491 <fd_close+0x34>
	    || fd != fd2)
  80048c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80048f:	74 16                	je     8004a7 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800491:	89 f8                	mov    %edi,%eax
  800493:	84 c0                	test   %al,%al
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	0f 44 d8             	cmove  %eax,%ebx
}
  80049d:	89 d8                	mov    %ebx,%eax
  80049f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a2:	5b                   	pop    %ebx
  8004a3:	5e                   	pop    %esi
  8004a4:	5f                   	pop    %edi
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ad:	50                   	push   %eax
  8004ae:	ff 36                	pushl  (%esi)
  8004b0:	e8 4e ff ff ff       	call   800403 <dev_lookup>
  8004b5:	89 c3                	mov    %eax,%ebx
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	78 1a                	js     8004d8 <fd_close+0x7b>
		if (dev->dev_close)
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004c4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004c9:	85 c0                	test   %eax,%eax
  8004cb:	74 0b                	je     8004d8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004cd:	83 ec 0c             	sub    $0xc,%esp
  8004d0:	56                   	push   %esi
  8004d1:	ff d0                	call   *%eax
  8004d3:	89 c3                	mov    %eax,%ebx
  8004d5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	56                   	push   %esi
  8004dc:	6a 00                	push   $0x0
  8004de:	e8 58 fd ff ff       	call   80023b <sys_page_unmap>
	return r;
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	eb b5                	jmp    80049d <fd_close+0x40>

008004e8 <close>:

int
close(int fdnum)
{
  8004e8:	f3 0f 1e fb          	endbr32 
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	ff 75 08             	pushl  0x8(%ebp)
  8004f9:	e8 b1 fe ff ff       	call   8003af <fd_lookup>
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 c0                	test   %eax,%eax
  800503:	79 02                	jns    800507 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800505:	c9                   	leave  
  800506:	c3                   	ret    
		return fd_close(fd, 1);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	6a 01                	push   $0x1
  80050c:	ff 75 f4             	pushl  -0xc(%ebp)
  80050f:	e8 49 ff ff ff       	call   80045d <fd_close>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	eb ec                	jmp    800505 <close+0x1d>

00800519 <close_all>:

void
close_all(void)
{
  800519:	f3 0f 1e fb          	endbr32 
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	53                   	push   %ebx
  800521:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800524:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800529:	83 ec 0c             	sub    $0xc,%esp
  80052c:	53                   	push   %ebx
  80052d:	e8 b6 ff ff ff       	call   8004e8 <close>
	for (i = 0; i < MAXFD; i++)
  800532:	83 c3 01             	add    $0x1,%ebx
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	83 fb 20             	cmp    $0x20,%ebx
  80053b:	75 ec                	jne    800529 <close_all+0x10>
}
  80053d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800542:	f3 0f 1e fb          	endbr32 
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	57                   	push   %edi
  80054a:	56                   	push   %esi
  80054b:	53                   	push   %ebx
  80054c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80054f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800552:	50                   	push   %eax
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	e8 54 fe ff ff       	call   8003af <fd_lookup>
  80055b:	89 c3                	mov    %eax,%ebx
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	85 c0                	test   %eax,%eax
  800562:	0f 88 81 00 00 00    	js     8005e9 <dup+0xa7>
		return r;
	close(newfdnum);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	e8 75 ff ff ff       	call   8004e8 <close>

	newfd = INDEX2FD(newfdnum);
  800573:	8b 75 0c             	mov    0xc(%ebp),%esi
  800576:	c1 e6 0c             	shl    $0xc,%esi
  800579:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80057f:	83 c4 04             	add    $0x4,%esp
  800582:	ff 75 e4             	pushl  -0x1c(%ebp)
  800585:	e8 b0 fd ff ff       	call   80033a <fd2data>
  80058a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80058c:	89 34 24             	mov    %esi,(%esp)
  80058f:	e8 a6 fd ff ff       	call   80033a <fd2data>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800599:	89 d8                	mov    %ebx,%eax
  80059b:	c1 e8 16             	shr    $0x16,%eax
  80059e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005a5:	a8 01                	test   $0x1,%al
  8005a7:	74 11                	je     8005ba <dup+0x78>
  8005a9:	89 d8                	mov    %ebx,%eax
  8005ab:	c1 e8 0c             	shr    $0xc,%eax
  8005ae:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005b5:	f6 c2 01             	test   $0x1,%dl
  8005b8:	75 39                	jne    8005f3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005bd:	89 d0                	mov    %edx,%eax
  8005bf:	c1 e8 0c             	shr    $0xc,%eax
  8005c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005c9:	83 ec 0c             	sub    $0xc,%esp
  8005cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d1:	50                   	push   %eax
  8005d2:	56                   	push   %esi
  8005d3:	6a 00                	push   $0x0
  8005d5:	52                   	push   %edx
  8005d6:	6a 00                	push   $0x0
  8005d8:	e8 34 fc ff ff       	call   800211 <sys_page_map>
  8005dd:	89 c3                	mov    %eax,%ebx
  8005df:	83 c4 20             	add    $0x20,%esp
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	78 31                	js     800617 <dup+0xd5>
		goto err;

	return newfdnum;
  8005e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005e9:	89 d8                	mov    %ebx,%eax
  8005eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ee:	5b                   	pop    %ebx
  8005ef:	5e                   	pop    %esi
  8005f0:	5f                   	pop    %edi
  8005f1:	5d                   	pop    %ebp
  8005f2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	25 07 0e 00 00       	and    $0xe07,%eax
  800602:	50                   	push   %eax
  800603:	57                   	push   %edi
  800604:	6a 00                	push   $0x0
  800606:	53                   	push   %ebx
  800607:	6a 00                	push   $0x0
  800609:	e8 03 fc ff ff       	call   800211 <sys_page_map>
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	83 c4 20             	add    $0x20,%esp
  800613:	85 c0                	test   %eax,%eax
  800615:	79 a3                	jns    8005ba <dup+0x78>
	sys_page_unmap(0, newfd);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	56                   	push   %esi
  80061b:	6a 00                	push   $0x0
  80061d:	e8 19 fc ff ff       	call   80023b <sys_page_unmap>
	sys_page_unmap(0, nva);
  800622:	83 c4 08             	add    $0x8,%esp
  800625:	57                   	push   %edi
  800626:	6a 00                	push   $0x0
  800628:	e8 0e fc ff ff       	call   80023b <sys_page_unmap>
	return r;
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb b7                	jmp    8005e9 <dup+0xa7>

00800632 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800632:	f3 0f 1e fb          	endbr32 
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	53                   	push   %ebx
  80063a:	83 ec 1c             	sub    $0x1c,%esp
  80063d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800643:	50                   	push   %eax
  800644:	53                   	push   %ebx
  800645:	e8 65 fd ff ff       	call   8003af <fd_lookup>
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	85 c0                	test   %eax,%eax
  80064f:	78 3f                	js     800690 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800657:	50                   	push   %eax
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065b:	ff 30                	pushl  (%eax)
  80065d:	e8 a1 fd ff ff       	call   800403 <dev_lookup>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	85 c0                	test   %eax,%eax
  800667:	78 27                	js     800690 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80066c:	8b 42 08             	mov    0x8(%edx),%eax
  80066f:	83 e0 03             	and    $0x3,%eax
  800672:	83 f8 01             	cmp    $0x1,%eax
  800675:	74 1e                	je     800695 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067a:	8b 40 08             	mov    0x8(%eax),%eax
  80067d:	85 c0                	test   %eax,%eax
  80067f:	74 35                	je     8006b6 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	ff 75 10             	pushl  0x10(%ebp)
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	52                   	push   %edx
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800693:	c9                   	leave  
  800694:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800695:	a1 04 40 80 00       	mov    0x804004,%eax
  80069a:	8b 40 48             	mov    0x48(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	50                   	push   %eax
  8006a2:	68 99 1e 80 00       	push   $0x801e99
  8006a7:	e8 e9 0a 00 00       	call   801195 <cprintf>
		return -E_INVAL;
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b4:	eb da                	jmp    800690 <read+0x5e>
		return -E_NOT_SUPP;
  8006b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006bb:	eb d3                	jmp    800690 <read+0x5e>

008006bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006bd:	f3 0f 1e fb          	endbr32 
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	57                   	push   %edi
  8006c5:	56                   	push   %esi
  8006c6:	53                   	push   %ebx
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006cd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d5:	eb 02                	jmp    8006d9 <readn+0x1c>
  8006d7:	01 c3                	add    %eax,%ebx
  8006d9:	39 f3                	cmp    %esi,%ebx
  8006db:	73 21                	jae    8006fe <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	89 f0                	mov    %esi,%eax
  8006e2:	29 d8                	sub    %ebx,%eax
  8006e4:	50                   	push   %eax
  8006e5:	89 d8                	mov    %ebx,%eax
  8006e7:	03 45 0c             	add    0xc(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	57                   	push   %edi
  8006ec:	e8 41 ff ff ff       	call   800632 <read>
		if (m < 0)
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	78 04                	js     8006fc <readn+0x3f>
			return m;
		if (m == 0)
  8006f8:	75 dd                	jne    8006d7 <readn+0x1a>
  8006fa:	eb 02                	jmp    8006fe <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006fc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006fe:	89 d8                	mov    %ebx,%eax
  800700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800703:	5b                   	pop    %ebx
  800704:	5e                   	pop    %esi
  800705:	5f                   	pop    %edi
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800708:	f3 0f 1e fb          	endbr32 
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	53                   	push   %ebx
  800710:	83 ec 1c             	sub    $0x1c,%esp
  800713:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800716:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	53                   	push   %ebx
  80071b:	e8 8f fc ff ff       	call   8003af <fd_lookup>
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	85 c0                	test   %eax,%eax
  800725:	78 3a                	js     800761 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	ff 30                	pushl  (%eax)
  800733:	e8 cb fc ff ff       	call   800403 <dev_lookup>
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	85 c0                	test   %eax,%eax
  80073d:	78 22                	js     800761 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80073f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800742:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800746:	74 1e                	je     800766 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074b:	8b 52 0c             	mov    0xc(%edx),%edx
  80074e:	85 d2                	test   %edx,%edx
  800750:	74 35                	je     800787 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	ff 75 10             	pushl  0x10(%ebp)
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	ff d2                	call   *%edx
  80075e:	83 c4 10             	add    $0x10,%esp
}
  800761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800764:	c9                   	leave  
  800765:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800766:	a1 04 40 80 00       	mov    0x804004,%eax
  80076b:	8b 40 48             	mov    0x48(%eax),%eax
  80076e:	83 ec 04             	sub    $0x4,%esp
  800771:	53                   	push   %ebx
  800772:	50                   	push   %eax
  800773:	68 b5 1e 80 00       	push   $0x801eb5
  800778:	e8 18 0a 00 00       	call   801195 <cprintf>
		return -E_INVAL;
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800785:	eb da                	jmp    800761 <write+0x59>
		return -E_NOT_SUPP;
  800787:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80078c:	eb d3                	jmp    800761 <write+0x59>

0080078e <seek>:

int
seek(int fdnum, off_t offset)
{
  80078e:	f3 0f 1e fb          	endbr32 
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800798:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 0b fc ff ff       	call   8003af <fd_lookup>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	78 0e                	js     8007b9 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	53                   	push   %ebx
  8007c3:	83 ec 1c             	sub    $0x1c,%esp
  8007c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007cc:	50                   	push   %eax
  8007cd:	53                   	push   %ebx
  8007ce:	e8 dc fb ff ff       	call   8003af <fd_lookup>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	85 c0                	test   %eax,%eax
  8007d8:	78 37                	js     800811 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e0:	50                   	push   %eax
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e4:	ff 30                	pushl  (%eax)
  8007e6:	e8 18 fc ff ff       	call   800403 <dev_lookup>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	85 c0                	test   %eax,%eax
  8007f0:	78 1f                	js     800811 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007f9:	74 1b                	je     800816 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fe:	8b 52 18             	mov    0x18(%edx),%edx
  800801:	85 d2                	test   %edx,%edx
  800803:	74 32                	je     800837 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	50                   	push   %eax
  80080c:	ff d2                	call   *%edx
  80080e:	83 c4 10             	add    $0x10,%esp
}
  800811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800814:	c9                   	leave  
  800815:	c3                   	ret    
			thisenv->env_id, fdnum);
  800816:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80081b:	8b 40 48             	mov    0x48(%eax),%eax
  80081e:	83 ec 04             	sub    $0x4,%esp
  800821:	53                   	push   %ebx
  800822:	50                   	push   %eax
  800823:	68 78 1e 80 00       	push   $0x801e78
  800828:	e8 68 09 00 00       	call   801195 <cprintf>
		return -E_INVAL;
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800835:	eb da                	jmp    800811 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800837:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80083c:	eb d3                	jmp    800811 <ftruncate+0x56>

0080083e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80083e:	f3 0f 1e fb          	endbr32 
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	53                   	push   %ebx
  800846:	83 ec 1c             	sub    $0x1c,%esp
  800849:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084f:	50                   	push   %eax
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 57 fb ff ff       	call   8003af <fd_lookup>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	85 c0                	test   %eax,%eax
  80085d:	78 4b                	js     8008aa <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800869:	ff 30                	pushl  (%eax)
  80086b:	e8 93 fb ff ff       	call   800403 <dev_lookup>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	85 c0                	test   %eax,%eax
  800875:	78 33                	js     8008aa <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80087e:	74 2f                	je     8008af <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800880:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800883:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80088a:	00 00 00 
	stat->st_isdir = 0;
  80088d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800894:	00 00 00 
	stat->st_dev = dev;
  800897:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a4:	ff 50 14             	call   *0x14(%eax)
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    
		return -E_NOT_SUPP;
  8008af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008b4:	eb f4                	jmp    8008aa <fstat+0x6c>

008008b6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008b6:	f3 0f 1e fb          	endbr32 
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	56                   	push   %esi
  8008be:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	6a 00                	push   $0x0
  8008c4:	ff 75 08             	pushl  0x8(%ebp)
  8008c7:	e8 3a 02 00 00       	call   800b06 <open>
  8008cc:	89 c3                	mov    %eax,%ebx
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	85 c0                	test   %eax,%eax
  8008d3:	78 1b                	js     8008f0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	50                   	push   %eax
  8008dc:	e8 5d ff ff ff       	call   80083e <fstat>
  8008e1:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e3:	89 1c 24             	mov    %ebx,(%esp)
  8008e6:	e8 fd fb ff ff       	call   8004e8 <close>
	return r;
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 f3                	mov    %esi,%ebx
}
  8008f0:	89 d8                	mov    %ebx,%eax
  8008f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	56                   	push   %esi
  8008fd:	53                   	push   %ebx
  8008fe:	89 c6                	mov    %eax,%esi
  800900:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800902:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800909:	74 27                	je     800932 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090b:	6a 07                	push   $0x7
  80090d:	68 00 50 80 00       	push   $0x805000
  800912:	56                   	push   %esi
  800913:	ff 35 00 40 80 00    	pushl  0x804000
  800919:	e8 c2 11 00 00       	call   801ae0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80091e:	83 c4 0c             	add    $0xc,%esp
  800921:	6a 00                	push   $0x0
  800923:	53                   	push   %ebx
  800924:	6a 00                	push   $0x0
  800926:	e8 48 11 00 00       	call   801a73 <ipc_recv>
}
  80092b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80092e:	5b                   	pop    %ebx
  80092f:	5e                   	pop    %esi
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800932:	83 ec 0c             	sub    $0xc,%esp
  800935:	6a 01                	push   $0x1
  800937:	e8 fc 11 00 00       	call   801b38 <ipc_find_env>
  80093c:	a3 00 40 80 00       	mov    %eax,0x804000
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	eb c5                	jmp    80090b <fsipc+0x12>

00800946 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800946:	f3 0f 1e fb          	endbr32 
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 40 0c             	mov    0xc(%eax),%eax
  800956:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
  800968:	b8 02 00 00 00       	mov    $0x2,%eax
  80096d:	e8 87 ff ff ff       	call   8008f9 <fsipc>
}
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <devfile_flush>:
{
  800974:	f3 0f 1e fb          	endbr32 
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 40 0c             	mov    0xc(%eax),%eax
  800984:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	b8 06 00 00 00       	mov    $0x6,%eax
  800993:	e8 61 ff ff ff       	call   8008f9 <fsipc>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <devfile_stat>:
{
  80099a:	f3 0f 1e fb          	endbr32 
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ae:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8009bd:	e8 37 ff ff ff       	call   8008f9 <fsipc>
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	78 2c                	js     8009f2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	68 00 50 80 00       	push   $0x805000
  8009ce:	53                   	push   %ebx
  8009cf:	e8 2b 0d 00 00       	call   8016ff <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d4:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009df:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_write>:
{
  8009f7:	f3 0f 1e fb          	endbr32 
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a10:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a16:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a1c:	77 30                	ja     800a4e <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a1e:	83 ec 04             	sub    $0x4,%esp
  800a21:	53                   	push   %ebx
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	68 08 50 80 00       	push   $0x805008
  800a2a:	e8 88 0e 00 00       	call   8018b7 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	b8 04 00 00 00       	mov    $0x4,%eax
  800a39:	e8 bb fe ff ff       	call   8008f9 <fsipc>
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	85 c0                	test   %eax,%eax
  800a43:	78 04                	js     800a49 <devfile_write+0x52>
	assert(r <= n);
  800a45:	39 d8                	cmp    %ebx,%eax
  800a47:	77 1e                	ja     800a67 <devfile_write+0x70>
}
  800a49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4c:	c9                   	leave  
  800a4d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a4e:	68 e4 1e 80 00       	push   $0x801ee4
  800a53:	68 11 1f 80 00       	push   $0x801f11
  800a58:	68 94 00 00 00       	push   $0x94
  800a5d:	68 26 1f 80 00       	push   $0x801f26
  800a62:	e8 47 06 00 00       	call   8010ae <_panic>
	assert(r <= n);
  800a67:	68 31 1f 80 00       	push   $0x801f31
  800a6c:	68 11 1f 80 00       	push   $0x801f11
  800a71:	68 98 00 00 00       	push   $0x98
  800a76:	68 26 1f 80 00       	push   $0x801f26
  800a7b:	e8 2e 06 00 00       	call   8010ae <_panic>

00800a80 <devfile_read>:
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a92:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a97:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa7:	e8 4d fe ff ff       	call   8008f9 <fsipc>
  800aac:	89 c3                	mov    %eax,%ebx
  800aae:	85 c0                	test   %eax,%eax
  800ab0:	78 1f                	js     800ad1 <devfile_read+0x51>
	assert(r <= n);
  800ab2:	39 f0                	cmp    %esi,%eax
  800ab4:	77 24                	ja     800ada <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800ab6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800abb:	7f 33                	jg     800af0 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	68 00 50 80 00       	push   $0x805000
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	e8 e9 0d 00 00       	call   8018b7 <memmove>
	return r;
  800ace:	83 c4 10             	add    $0x10,%esp
}
  800ad1:	89 d8                	mov    %ebx,%eax
  800ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    
	assert(r <= n);
  800ada:	68 31 1f 80 00       	push   $0x801f31
  800adf:	68 11 1f 80 00       	push   $0x801f11
  800ae4:	6a 7c                	push   $0x7c
  800ae6:	68 26 1f 80 00       	push   $0x801f26
  800aeb:	e8 be 05 00 00       	call   8010ae <_panic>
	assert(r <= PGSIZE);
  800af0:	68 38 1f 80 00       	push   $0x801f38
  800af5:	68 11 1f 80 00       	push   $0x801f11
  800afa:	6a 7d                	push   $0x7d
  800afc:	68 26 1f 80 00       	push   $0x801f26
  800b01:	e8 a8 05 00 00       	call   8010ae <_panic>

00800b06 <open>:
{
  800b06:	f3 0f 1e fb          	endbr32 
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	83 ec 1c             	sub    $0x1c,%esp
  800b12:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b15:	56                   	push   %esi
  800b16:	e8 a1 0b 00 00       	call   8016bc <strlen>
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b23:	7f 6c                	jg     800b91 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b25:	83 ec 0c             	sub    $0xc,%esp
  800b28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b2b:	50                   	push   %eax
  800b2c:	e8 28 f8 ff ff       	call   800359 <fd_alloc>
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	85 c0                	test   %eax,%eax
  800b38:	78 3c                	js     800b76 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	56                   	push   %esi
  800b3e:	68 00 50 80 00       	push   $0x805000
  800b43:	e8 b7 0b 00 00       	call   8016ff <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b53:	b8 01 00 00 00       	mov    $0x1,%eax
  800b58:	e8 9c fd ff ff       	call   8008f9 <fsipc>
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	85 c0                	test   %eax,%eax
  800b64:	78 19                	js     800b7f <open+0x79>
	return fd2num(fd);
  800b66:	83 ec 0c             	sub    $0xc,%esp
  800b69:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6c:	e8 b5 f7 ff ff       	call   800326 <fd2num>
  800b71:	89 c3                	mov    %eax,%ebx
  800b73:	83 c4 10             	add    $0x10,%esp
}
  800b76:	89 d8                	mov    %ebx,%eax
  800b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    
		fd_close(fd, 0);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	6a 00                	push   $0x0
  800b84:	ff 75 f4             	pushl  -0xc(%ebp)
  800b87:	e8 d1 f8 ff ff       	call   80045d <fd_close>
		return r;
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb e5                	jmp    800b76 <open+0x70>
		return -E_BAD_PATH;
  800b91:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b96:	eb de                	jmp    800b76 <open+0x70>

00800b98 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b98:	f3 0f 1e fb          	endbr32 
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 08 00 00 00       	mov    $0x8,%eax
  800bac:	e8 48 fd ff ff       	call   8008f9 <fsipc>
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bb3:	f3 0f 1e fb          	endbr32 
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
  800bbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bbf:	83 ec 0c             	sub    $0xc,%esp
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	e8 70 f7 ff ff       	call   80033a <fd2data>
  800bca:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bcc:	83 c4 08             	add    $0x8,%esp
  800bcf:	68 44 1f 80 00       	push   $0x801f44
  800bd4:	53                   	push   %ebx
  800bd5:	e8 25 0b 00 00       	call   8016ff <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bda:	8b 46 04             	mov    0x4(%esi),%eax
  800bdd:	2b 06                	sub    (%esi),%eax
  800bdf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800be5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bec:	00 00 00 
	stat->st_dev = &devpipe;
  800bef:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bf6:	30 80 00 
	return 0;
}
  800bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c05:	f3 0f 1e fb          	endbr32 
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c13:	53                   	push   %ebx
  800c14:	6a 00                	push   $0x0
  800c16:	e8 20 f6 ff ff       	call   80023b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c1b:	89 1c 24             	mov    %ebx,(%esp)
  800c1e:	e8 17 f7 ff ff       	call   80033a <fd2data>
  800c23:	83 c4 08             	add    $0x8,%esp
  800c26:	50                   	push   %eax
  800c27:	6a 00                	push   $0x0
  800c29:	e8 0d f6 ff ff       	call   80023b <sys_page_unmap>
}
  800c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <_pipeisclosed>:
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 1c             	sub    $0x1c,%esp
  800c3c:	89 c7                	mov    %eax,%edi
  800c3e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c40:	a1 04 40 80 00       	mov    0x804004,%eax
  800c45:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	57                   	push   %edi
  800c4c:	e8 24 0f 00 00       	call   801b75 <pageref>
  800c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c54:	89 34 24             	mov    %esi,(%esp)
  800c57:	e8 19 0f 00 00       	call   801b75 <pageref>
		nn = thisenv->env_runs;
  800c5c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c62:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	39 cb                	cmp    %ecx,%ebx
  800c6a:	74 1b                	je     800c87 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c6c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6f:	75 cf                	jne    800c40 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c71:	8b 42 58             	mov    0x58(%edx),%eax
  800c74:	6a 01                	push   $0x1
  800c76:	50                   	push   %eax
  800c77:	53                   	push   %ebx
  800c78:	68 4b 1f 80 00       	push   $0x801f4b
  800c7d:	e8 13 05 00 00       	call   801195 <cprintf>
  800c82:	83 c4 10             	add    $0x10,%esp
  800c85:	eb b9                	jmp    800c40 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c87:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c8a:	0f 94 c0             	sete   %al
  800c8d:	0f b6 c0             	movzbl %al,%eax
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <devpipe_write>:
{
  800c98:	f3 0f 1e fb          	endbr32 
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 28             	sub    $0x28,%esp
  800ca5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800ca8:	56                   	push   %esi
  800ca9:	e8 8c f6 ff ff       	call   80033a <fd2data>
  800cae:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cb0:	83 c4 10             	add    $0x10,%esp
  800cb3:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cbb:	74 4f                	je     800d0c <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cbd:	8b 43 04             	mov    0x4(%ebx),%eax
  800cc0:	8b 0b                	mov    (%ebx),%ecx
  800cc2:	8d 51 20             	lea    0x20(%ecx),%edx
  800cc5:	39 d0                	cmp    %edx,%eax
  800cc7:	72 14                	jb     800cdd <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cc9:	89 da                	mov    %ebx,%edx
  800ccb:	89 f0                	mov    %esi,%eax
  800ccd:	e8 61 ff ff ff       	call   800c33 <_pipeisclosed>
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	75 3b                	jne    800d11 <devpipe_write+0x79>
			sys_yield();
  800cd6:	e8 e3 f4 ff ff       	call   8001be <sys_yield>
  800cdb:	eb e0                	jmp    800cbd <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800ce4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ce7:	89 c2                	mov    %eax,%edx
  800ce9:	c1 fa 1f             	sar    $0x1f,%edx
  800cec:	89 d1                	mov    %edx,%ecx
  800cee:	c1 e9 1b             	shr    $0x1b,%ecx
  800cf1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cf4:	83 e2 1f             	and    $0x1f,%edx
  800cf7:	29 ca                	sub    %ecx,%edx
  800cf9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cfd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d01:	83 c0 01             	add    $0x1,%eax
  800d04:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d07:	83 c7 01             	add    $0x1,%edi
  800d0a:	eb ac                	jmp    800cb8 <devpipe_write+0x20>
	return i;
  800d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0f:	eb 05                	jmp    800d16 <devpipe_write+0x7e>
				return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <devpipe_read>:
{
  800d1e:	f3 0f 1e fb          	endbr32 
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 18             	sub    $0x18,%esp
  800d2b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d2e:	57                   	push   %edi
  800d2f:	e8 06 f6 ff ff       	call   80033a <fd2data>
  800d34:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	be 00 00 00 00       	mov    $0x0,%esi
  800d3e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d41:	75 14                	jne    800d57 <devpipe_read+0x39>
	return i;
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	eb 02                	jmp    800d4a <devpipe_read+0x2c>
				return i;
  800d48:	89 f0                	mov    %esi,%eax
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
			sys_yield();
  800d52:	e8 67 f4 ff ff       	call   8001be <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d57:	8b 03                	mov    (%ebx),%eax
  800d59:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d5c:	75 18                	jne    800d76 <devpipe_read+0x58>
			if (i > 0)
  800d5e:	85 f6                	test   %esi,%esi
  800d60:	75 e6                	jne    800d48 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d62:	89 da                	mov    %ebx,%edx
  800d64:	89 f8                	mov    %edi,%eax
  800d66:	e8 c8 fe ff ff       	call   800c33 <_pipeisclosed>
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	74 e3                	je     800d52 <devpipe_read+0x34>
				return 0;
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	eb d4                	jmp    800d4a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d76:	99                   	cltd   
  800d77:	c1 ea 1b             	shr    $0x1b,%edx
  800d7a:	01 d0                	add    %edx,%eax
  800d7c:	83 e0 1f             	and    $0x1f,%eax
  800d7f:	29 d0                	sub    %edx,%eax
  800d81:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d8c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d8f:	83 c6 01             	add    $0x1,%esi
  800d92:	eb aa                	jmp    800d3e <devpipe_read+0x20>

00800d94 <pipe>:
{
  800d94:	f3 0f 1e fb          	endbr32 
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800da3:	50                   	push   %eax
  800da4:	e8 b0 f5 ff ff       	call   800359 <fd_alloc>
  800da9:	89 c3                	mov    %eax,%ebx
  800dab:	83 c4 10             	add    $0x10,%esp
  800dae:	85 c0                	test   %eax,%eax
  800db0:	0f 88 23 01 00 00    	js     800ed9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db6:	83 ec 04             	sub    $0x4,%esp
  800db9:	68 07 04 00 00       	push   $0x407
  800dbe:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc1:	6a 00                	push   $0x0
  800dc3:	e8 21 f4 ff ff       	call   8001e9 <sys_page_alloc>
  800dc8:	89 c3                	mov    %eax,%ebx
  800dca:	83 c4 10             	add    $0x10,%esp
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	0f 88 04 01 00 00    	js     800ed9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ddb:	50                   	push   %eax
  800ddc:	e8 78 f5 ff ff       	call   800359 <fd_alloc>
  800de1:	89 c3                	mov    %eax,%ebx
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	85 c0                	test   %eax,%eax
  800de8:	0f 88 db 00 00 00    	js     800ec9 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dee:	83 ec 04             	sub    $0x4,%esp
  800df1:	68 07 04 00 00       	push   $0x407
  800df6:	ff 75 f0             	pushl  -0x10(%ebp)
  800df9:	6a 00                	push   $0x0
  800dfb:	e8 e9 f3 ff ff       	call   8001e9 <sys_page_alloc>
  800e00:	89 c3                	mov    %eax,%ebx
  800e02:	83 c4 10             	add    $0x10,%esp
  800e05:	85 c0                	test   %eax,%eax
  800e07:	0f 88 bc 00 00 00    	js     800ec9 <pipe+0x135>
	va = fd2data(fd0);
  800e0d:	83 ec 0c             	sub    $0xc,%esp
  800e10:	ff 75 f4             	pushl  -0xc(%ebp)
  800e13:	e8 22 f5 ff ff       	call   80033a <fd2data>
  800e18:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1a:	83 c4 0c             	add    $0xc,%esp
  800e1d:	68 07 04 00 00       	push   $0x407
  800e22:	50                   	push   %eax
  800e23:	6a 00                	push   $0x0
  800e25:	e8 bf f3 ff ff       	call   8001e9 <sys_page_alloc>
  800e2a:	89 c3                	mov    %eax,%ebx
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	0f 88 82 00 00 00    	js     800eb9 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e37:	83 ec 0c             	sub    $0xc,%esp
  800e3a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e3d:	e8 f8 f4 ff ff       	call   80033a <fd2data>
  800e42:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e49:	50                   	push   %eax
  800e4a:	6a 00                	push   $0x0
  800e4c:	56                   	push   %esi
  800e4d:	6a 00                	push   $0x0
  800e4f:	e8 bd f3 ff ff       	call   800211 <sys_page_map>
  800e54:	89 c3                	mov    %eax,%ebx
  800e56:	83 c4 20             	add    $0x20,%esp
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	78 4e                	js     800eab <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e5d:	a1 20 30 80 00       	mov    0x803020,%eax
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e74:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e79:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	ff 75 f4             	pushl  -0xc(%ebp)
  800e86:	e8 9b f4 ff ff       	call   800326 <fd2num>
  800e8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e90:	83 c4 04             	add    $0x4,%esp
  800e93:	ff 75 f0             	pushl  -0x10(%ebp)
  800e96:	e8 8b f4 ff ff       	call   800326 <fd2num>
  800e9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea9:	eb 2e                	jmp    800ed9 <pipe+0x145>
	sys_page_unmap(0, va);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	56                   	push   %esi
  800eaf:	6a 00                	push   $0x0
  800eb1:	e8 85 f3 ff ff       	call   80023b <sys_page_unmap>
  800eb6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  800ebf:	6a 00                	push   $0x0
  800ec1:	e8 75 f3 ff ff       	call   80023b <sys_page_unmap>
  800ec6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ecf:	6a 00                	push   $0x0
  800ed1:	e8 65 f3 ff ff       	call   80023b <sys_page_unmap>
  800ed6:	83 c4 10             	add    $0x10,%esp
}
  800ed9:	89 d8                	mov    %ebx,%eax
  800edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <pipeisclosed>:
{
  800ee2:	f3 0f 1e fb          	endbr32 
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eef:	50                   	push   %eax
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	e8 b7 f4 ff ff       	call   8003af <fd_lookup>
  800ef8:	83 c4 10             	add    $0x10,%esp
  800efb:	85 c0                	test   %eax,%eax
  800efd:	78 18                	js     800f17 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff 75 f4             	pushl  -0xc(%ebp)
  800f05:	e8 30 f4 ff ff       	call   80033a <fd2data>
  800f0a:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0f:	e8 1f fd ff ff       	call   800c33 <_pipeisclosed>
  800f14:	83 c4 10             	add    $0x10,%esp
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f19:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f22:	c3                   	ret    

00800f23 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f23:	f3 0f 1e fb          	endbr32 
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f2d:	68 63 1f 80 00       	push   $0x801f63
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	e8 c5 07 00 00       	call   8016ff <strcpy>
	return 0;
}
  800f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <devcons_write>:
{
  800f41:	f3 0f 1e fb          	endbr32 
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f51:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f56:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f5c:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f5f:	73 31                	jae    800f92 <devcons_write+0x51>
		m = n - tot;
  800f61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f64:	29 f3                	sub    %esi,%ebx
  800f66:	83 fb 7f             	cmp    $0x7f,%ebx
  800f69:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f6e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f71:	83 ec 04             	sub    $0x4,%esp
  800f74:	53                   	push   %ebx
  800f75:	89 f0                	mov    %esi,%eax
  800f77:	03 45 0c             	add    0xc(%ebp),%eax
  800f7a:	50                   	push   %eax
  800f7b:	57                   	push   %edi
  800f7c:	e8 36 09 00 00       	call   8018b7 <memmove>
		sys_cputs(buf, m);
  800f81:	83 c4 08             	add    $0x8,%esp
  800f84:	53                   	push   %ebx
  800f85:	57                   	push   %edi
  800f86:	e8 93 f1 ff ff       	call   80011e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f8b:	01 de                	add    %ebx,%esi
  800f8d:	83 c4 10             	add    $0x10,%esp
  800f90:	eb ca                	jmp    800f5c <devcons_write+0x1b>
}
  800f92:	89 f0                	mov    %esi,%eax
  800f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <devcons_read>:
{
  800f9c:	f3 0f 1e fb          	endbr32 
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	74 21                	je     800fd2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fb1:	e8 92 f1 ff ff       	call   800148 <sys_cgetc>
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 07                	jne    800fc1 <devcons_read+0x25>
		sys_yield();
  800fba:	e8 ff f1 ff ff       	call   8001be <sys_yield>
  800fbf:	eb f0                	jmp    800fb1 <devcons_read+0x15>
	if (c < 0)
  800fc1:	78 0f                	js     800fd2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fc3:	83 f8 04             	cmp    $0x4,%eax
  800fc6:	74 0c                	je     800fd4 <devcons_read+0x38>
	*(char*)vbuf = c;
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	88 02                	mov    %al,(%edx)
	return 1;
  800fcd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    
		return 0;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd9:	eb f7                	jmp    800fd2 <devcons_read+0x36>

00800fdb <cputchar>:
{
  800fdb:	f3 0f 1e fb          	endbr32 
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800feb:	6a 01                	push   $0x1
  800fed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	e8 28 f1 ff ff       	call   80011e <sys_cputs>
}
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <getchar>:
{
  800ffb:	f3 0f 1e fb          	endbr32 
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801005:	6a 01                	push   $0x1
  801007:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	6a 00                	push   $0x0
  80100d:	e8 20 f6 ff ff       	call   800632 <read>
	if (r < 0)
  801012:	83 c4 10             	add    $0x10,%esp
  801015:	85 c0                	test   %eax,%eax
  801017:	78 06                	js     80101f <getchar+0x24>
	if (r < 1)
  801019:	74 06                	je     801021 <getchar+0x26>
	return c;
  80101b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    
		return -E_EOF;
  801021:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801026:	eb f7                	jmp    80101f <getchar+0x24>

00801028 <iscons>:
{
  801028:	f3 0f 1e fb          	endbr32 
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801032:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801035:	50                   	push   %eax
  801036:	ff 75 08             	pushl  0x8(%ebp)
  801039:	e8 71 f3 ff ff       	call   8003af <fd_lookup>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	78 11                	js     801056 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801048:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80104e:	39 10                	cmp    %edx,(%eax)
  801050:	0f 94 c0             	sete   %al
  801053:	0f b6 c0             	movzbl %al,%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <opencons>:
{
  801058:	f3 0f 1e fb          	endbr32 
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801062:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	e8 ee f2 ff ff       	call   800359 <fd_alloc>
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	85 c0                	test   %eax,%eax
  801070:	78 3a                	js     8010ac <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801072:	83 ec 04             	sub    $0x4,%esp
  801075:	68 07 04 00 00       	push   $0x407
  80107a:	ff 75 f4             	pushl  -0xc(%ebp)
  80107d:	6a 00                	push   $0x0
  80107f:	e8 65 f1 ff ff       	call   8001e9 <sys_page_alloc>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 21                	js     8010ac <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801094:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801099:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010a0:	83 ec 0c             	sub    $0xc,%esp
  8010a3:	50                   	push   %eax
  8010a4:	e8 7d f2 ff ff       	call   800326 <fd2num>
  8010a9:	83 c4 10             	add    $0x10,%esp
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010ae:	f3 0f 1e fb          	endbr32 
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	56                   	push   %esi
  8010b6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010b7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010ba:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010c0:	e8 d1 f0 ff ff       	call   800196 <sys_getenvid>
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	ff 75 08             	pushl  0x8(%ebp)
  8010ce:	56                   	push   %esi
  8010cf:	50                   	push   %eax
  8010d0:	68 70 1f 80 00       	push   $0x801f70
  8010d5:	e8 bb 00 00 00       	call   801195 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010da:	83 c4 18             	add    $0x18,%esp
  8010dd:	53                   	push   %ebx
  8010de:	ff 75 10             	pushl  0x10(%ebp)
  8010e1:	e8 5a 00 00 00       	call   801140 <vcprintf>
	cprintf("\n");
  8010e6:	c7 04 24 ba 22 80 00 	movl   $0x8022ba,(%esp)
  8010ed:	e8 a3 00 00 00       	call   801195 <cprintf>
  8010f2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010f5:	cc                   	int3   
  8010f6:	eb fd                	jmp    8010f5 <_panic+0x47>

008010f8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010f8:	f3 0f 1e fb          	endbr32 
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	53                   	push   %ebx
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801106:	8b 13                	mov    (%ebx),%edx
  801108:	8d 42 01             	lea    0x1(%edx),%eax
  80110b:	89 03                	mov    %eax,(%ebx)
  80110d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801110:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801114:	3d ff 00 00 00       	cmp    $0xff,%eax
  801119:	74 09                	je     801124 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80111b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80111f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801122:	c9                   	leave  
  801123:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	68 ff 00 00 00       	push   $0xff
  80112c:	8d 43 08             	lea    0x8(%ebx),%eax
  80112f:	50                   	push   %eax
  801130:	e8 e9 ef ff ff       	call   80011e <sys_cputs>
		b->idx = 0;
  801135:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	eb db                	jmp    80111b <putch+0x23>

00801140 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801140:	f3 0f 1e fb          	endbr32 
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80114d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801154:	00 00 00 
	b.cnt = 0;
  801157:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80115e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80116d:	50                   	push   %eax
  80116e:	68 f8 10 80 00       	push   $0x8010f8
  801173:	e8 80 01 00 00       	call   8012f8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801178:	83 c4 08             	add    $0x8,%esp
  80117b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801181:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801187:	50                   	push   %eax
  801188:	e8 91 ef ff ff       	call   80011e <sys_cputs>

	return b.cnt;
}
  80118d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801195:	f3 0f 1e fb          	endbr32 
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80119f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011a2:	50                   	push   %eax
  8011a3:	ff 75 08             	pushl  0x8(%ebp)
  8011a6:	e8 95 ff ff ff       	call   801140 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 1c             	sub    $0x1c,%esp
  8011b6:	89 c7                	mov    %eax,%edi
  8011b8:	89 d6                	mov    %edx,%esi
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c0:	89 d1                	mov    %edx,%ecx
  8011c2:	89 c2                	mov    %eax,%edx
  8011c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011c7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011da:	39 c2                	cmp    %eax,%edx
  8011dc:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011df:	72 3e                	jb     80121f <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	ff 75 18             	pushl  0x18(%ebp)
  8011e7:	83 eb 01             	sub    $0x1,%ebx
  8011ea:	53                   	push   %ebx
  8011eb:	50                   	push   %eax
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8011f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8011f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8011fb:	e8 c0 09 00 00       	call   801bc0 <__udivdi3>
  801200:	83 c4 18             	add    $0x18,%esp
  801203:	52                   	push   %edx
  801204:	50                   	push   %eax
  801205:	89 f2                	mov    %esi,%edx
  801207:	89 f8                	mov    %edi,%eax
  801209:	e8 9f ff ff ff       	call   8011ad <printnum>
  80120e:	83 c4 20             	add    $0x20,%esp
  801211:	eb 13                	jmp    801226 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	56                   	push   %esi
  801217:	ff 75 18             	pushl  0x18(%ebp)
  80121a:	ff d7                	call   *%edi
  80121c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80121f:	83 eb 01             	sub    $0x1,%ebx
  801222:	85 db                	test   %ebx,%ebx
  801224:	7f ed                	jg     801213 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	56                   	push   %esi
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801230:	ff 75 e0             	pushl  -0x20(%ebp)
  801233:	ff 75 dc             	pushl  -0x24(%ebp)
  801236:	ff 75 d8             	pushl  -0x28(%ebp)
  801239:	e8 92 0a 00 00       	call   801cd0 <__umoddi3>
  80123e:	83 c4 14             	add    $0x14,%esp
  801241:	0f be 80 93 1f 80 00 	movsbl 0x801f93(%eax),%eax
  801248:	50                   	push   %eax
  801249:	ff d7                	call   *%edi
}
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801256:	83 fa 01             	cmp    $0x1,%edx
  801259:	7f 13                	jg     80126e <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  80125b:	85 d2                	test   %edx,%edx
  80125d:	74 1c                	je     80127b <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80125f:	8b 10                	mov    (%eax),%edx
  801261:	8d 4a 04             	lea    0x4(%edx),%ecx
  801264:	89 08                	mov    %ecx,(%eax)
  801266:	8b 02                	mov    (%edx),%eax
  801268:	ba 00 00 00 00       	mov    $0x0,%edx
  80126d:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80126e:	8b 10                	mov    (%eax),%edx
  801270:	8d 4a 08             	lea    0x8(%edx),%ecx
  801273:	89 08                	mov    %ecx,(%eax)
  801275:	8b 02                	mov    (%edx),%eax
  801277:	8b 52 04             	mov    0x4(%edx),%edx
  80127a:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80127b:	8b 10                	mov    (%eax),%edx
  80127d:	8d 4a 04             	lea    0x4(%edx),%ecx
  801280:	89 08                	mov    %ecx,(%eax)
  801282:	8b 02                	mov    (%edx),%eax
  801284:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801289:	c3                   	ret    

0080128a <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80128a:	83 fa 01             	cmp    $0x1,%edx
  80128d:	7f 0f                	jg     80129e <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80128f:	85 d2                	test   %edx,%edx
  801291:	74 18                	je     8012ab <getint+0x21>
		return va_arg(*ap, long);
  801293:	8b 10                	mov    (%eax),%edx
  801295:	8d 4a 04             	lea    0x4(%edx),%ecx
  801298:	89 08                	mov    %ecx,(%eax)
  80129a:	8b 02                	mov    (%edx),%eax
  80129c:	99                   	cltd   
  80129d:	c3                   	ret    
		return va_arg(*ap, long long);
  80129e:	8b 10                	mov    (%eax),%edx
  8012a0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8012a3:	89 08                	mov    %ecx,(%eax)
  8012a5:	8b 02                	mov    (%edx),%eax
  8012a7:	8b 52 04             	mov    0x4(%edx),%edx
  8012aa:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8012ab:	8b 10                	mov    (%eax),%edx
  8012ad:	8d 4a 04             	lea    0x4(%edx),%ecx
  8012b0:	89 08                	mov    %ecx,(%eax)
  8012b2:	8b 02                	mov    (%edx),%eax
  8012b4:	99                   	cltd   
}
  8012b5:	c3                   	ret    

008012b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012b6:	f3 0f 1e fb          	endbr32 
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012c0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012c4:	8b 10                	mov    (%eax),%edx
  8012c6:	3b 50 04             	cmp    0x4(%eax),%edx
  8012c9:	73 0a                	jae    8012d5 <sprintputch+0x1f>
		*b->buf++ = ch;
  8012cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ce:	89 08                	mov    %ecx,(%eax)
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	88 02                	mov    %al,(%edx)
}
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <printfmt>:
{
  8012d7:	f3 0f 1e fb          	endbr32 
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012e1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 10             	pushl  0x10(%ebp)
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	ff 75 08             	pushl  0x8(%ebp)
  8012ee:	e8 05 00 00 00       	call   8012f8 <vprintfmt>
}
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <vprintfmt>:
{
  8012f8:	f3 0f 1e fb          	endbr32 
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	83 ec 2c             	sub    $0x2c,%esp
  801305:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801308:	8b 75 0c             	mov    0xc(%ebp),%esi
  80130b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80130e:	e9 86 02 00 00       	jmp    801599 <vprintfmt+0x2a1>
		padc = ' ';
  801313:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801317:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80131e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801325:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80132c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801331:	8d 47 01             	lea    0x1(%edi),%eax
  801334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801337:	0f b6 17             	movzbl (%edi),%edx
  80133a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80133d:	3c 55                	cmp    $0x55,%al
  80133f:	0f 87 df 02 00 00    	ja     801624 <vprintfmt+0x32c>
  801345:	0f b6 c0             	movzbl %al,%eax
  801348:	3e ff 24 85 e0 20 80 	notrack jmp *0x8020e0(,%eax,4)
  80134f:	00 
  801350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801353:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801357:	eb d8                	jmp    801331 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801359:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80135c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801360:	eb cf                	jmp    801331 <vprintfmt+0x39>
  801362:	0f b6 d2             	movzbl %dl,%edx
  801365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801370:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801373:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801377:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80137a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80137d:	83 f9 09             	cmp    $0x9,%ecx
  801380:	77 52                	ja     8013d4 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801382:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801385:	eb e9                	jmp    801370 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801387:	8b 45 14             	mov    0x14(%ebp),%eax
  80138a:	8d 50 04             	lea    0x4(%eax),%edx
  80138d:	89 55 14             	mov    %edx,0x14(%ebp)
  801390:	8b 00                	mov    (%eax),%eax
  801392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801398:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139c:	79 93                	jns    801331 <vprintfmt+0x39>
				width = precision, precision = -1;
  80139e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013a4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8013ab:	eb 84                	jmp    801331 <vprintfmt+0x39>
  8013ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b7:	0f 49 d0             	cmovns %eax,%edx
  8013ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013c0:	e9 6c ff ff ff       	jmp    801331 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013c8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013cf:	e9 5d ff ff ff       	jmp    801331 <vprintfmt+0x39>
  8013d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013da:	eb bc                	jmp    801398 <vprintfmt+0xa0>
			lflag++;
  8013dc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013e2:	e9 4a ff ff ff       	jmp    801331 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ea:	8d 50 04             	lea    0x4(%eax),%edx
  8013ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	56                   	push   %esi
  8013f4:	ff 30                	pushl  (%eax)
  8013f6:	ff d3                	call   *%ebx
			break;
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	e9 96 01 00 00       	jmp    801596 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  801400:	8b 45 14             	mov    0x14(%ebp),%eax
  801403:	8d 50 04             	lea    0x4(%eax),%edx
  801406:	89 55 14             	mov    %edx,0x14(%ebp)
  801409:	8b 00                	mov    (%eax),%eax
  80140b:	99                   	cltd   
  80140c:	31 d0                	xor    %edx,%eax
  80140e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801410:	83 f8 0f             	cmp    $0xf,%eax
  801413:	7f 20                	jg     801435 <vprintfmt+0x13d>
  801415:	8b 14 85 40 22 80 00 	mov    0x802240(,%eax,4),%edx
  80141c:	85 d2                	test   %edx,%edx
  80141e:	74 15                	je     801435 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801420:	52                   	push   %edx
  801421:	68 23 1f 80 00       	push   $0x801f23
  801426:	56                   	push   %esi
  801427:	53                   	push   %ebx
  801428:	e8 aa fe ff ff       	call   8012d7 <printfmt>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	e9 61 01 00 00       	jmp    801596 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  801435:	50                   	push   %eax
  801436:	68 ab 1f 80 00       	push   $0x801fab
  80143b:	56                   	push   %esi
  80143c:	53                   	push   %ebx
  80143d:	e8 95 fe ff ff       	call   8012d7 <printfmt>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	e9 4c 01 00 00       	jmp    801596 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8d 50 04             	lea    0x4(%eax),%edx
  801450:	89 55 14             	mov    %edx,0x14(%ebp)
  801453:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  801455:	85 c9                	test   %ecx,%ecx
  801457:	b8 a4 1f 80 00       	mov    $0x801fa4,%eax
  80145c:	0f 45 c1             	cmovne %ecx,%eax
  80145f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801462:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801466:	7e 06                	jle    80146e <vprintfmt+0x176>
  801468:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80146c:	75 0d                	jne    80147b <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80146e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801471:	89 c7                	mov    %eax,%edi
  801473:	03 45 e0             	add    -0x20(%ebp),%eax
  801476:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801479:	eb 57                	jmp    8014d2 <vprintfmt+0x1da>
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	ff 75 d8             	pushl  -0x28(%ebp)
  801481:	ff 75 cc             	pushl  -0x34(%ebp)
  801484:	e8 4f 02 00 00       	call   8016d8 <strnlen>
  801489:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80148c:	29 c2                	sub    %eax,%edx
  80148e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801491:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801494:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801498:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80149b:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80149d:	85 db                	test   %ebx,%ebx
  80149f:	7e 10                	jle    8014b1 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	56                   	push   %esi
  8014a5:	57                   	push   %edi
  8014a6:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8014a9:	83 eb 01             	sub    $0x1,%ebx
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	eb ec                	jmp    80149d <vprintfmt+0x1a5>
  8014b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b7:	85 d2                	test   %edx,%edx
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014be:	0f 49 c2             	cmovns %edx,%eax
  8014c1:	29 c2                	sub    %eax,%edx
  8014c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014c6:	eb a6                	jmp    80146e <vprintfmt+0x176>
					putch(ch, putdat);
  8014c8:	83 ec 08             	sub    $0x8,%esp
  8014cb:	56                   	push   %esi
  8014cc:	52                   	push   %edx
  8014cd:	ff d3                	call   *%ebx
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014d5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014d7:	83 c7 01             	add    $0x1,%edi
  8014da:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014de:	0f be d0             	movsbl %al,%edx
  8014e1:	85 d2                	test   %edx,%edx
  8014e3:	74 42                	je     801527 <vprintfmt+0x22f>
  8014e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014e9:	78 06                	js     8014f1 <vprintfmt+0x1f9>
  8014eb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014ef:	78 1e                	js     80150f <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014f5:	74 d1                	je     8014c8 <vprintfmt+0x1d0>
  8014f7:	0f be c0             	movsbl %al,%eax
  8014fa:	83 e8 20             	sub    $0x20,%eax
  8014fd:	83 f8 5e             	cmp    $0x5e,%eax
  801500:	76 c6                	jbe    8014c8 <vprintfmt+0x1d0>
					putch('?', putdat);
  801502:	83 ec 08             	sub    $0x8,%esp
  801505:	56                   	push   %esi
  801506:	6a 3f                	push   $0x3f
  801508:	ff d3                	call   *%ebx
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	eb c3                	jmp    8014d2 <vprintfmt+0x1da>
  80150f:	89 cf                	mov    %ecx,%edi
  801511:	eb 0e                	jmp    801521 <vprintfmt+0x229>
				putch(' ', putdat);
  801513:	83 ec 08             	sub    $0x8,%esp
  801516:	56                   	push   %esi
  801517:	6a 20                	push   $0x20
  801519:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  80151b:	83 ef 01             	sub    $0x1,%edi
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 ff                	test   %edi,%edi
  801523:	7f ee                	jg     801513 <vprintfmt+0x21b>
  801525:	eb 6f                	jmp    801596 <vprintfmt+0x29e>
  801527:	89 cf                	mov    %ecx,%edi
  801529:	eb f6                	jmp    801521 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  80152b:	89 ca                	mov    %ecx,%edx
  80152d:	8d 45 14             	lea    0x14(%ebp),%eax
  801530:	e8 55 fd ff ff       	call   80128a <getint>
  801535:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801538:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80153b:	85 d2                	test   %edx,%edx
  80153d:	78 0b                	js     80154a <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80153f:	89 d1                	mov    %edx,%ecx
  801541:	89 c2                	mov    %eax,%edx
			base = 10;
  801543:	b8 0a 00 00 00       	mov    $0xa,%eax
  801548:	eb 32                	jmp    80157c <vprintfmt+0x284>
				putch('-', putdat);
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	56                   	push   %esi
  80154e:	6a 2d                	push   $0x2d
  801550:	ff d3                	call   *%ebx
				num = -(long long) num;
  801552:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801555:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801558:	f7 da                	neg    %edx
  80155a:	83 d1 00             	adc    $0x0,%ecx
  80155d:	f7 d9                	neg    %ecx
  80155f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801562:	b8 0a 00 00 00       	mov    $0xa,%eax
  801567:	eb 13                	jmp    80157c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801569:	89 ca                	mov    %ecx,%edx
  80156b:	8d 45 14             	lea    0x14(%ebp),%eax
  80156e:	e8 e3 fc ff ff       	call   801256 <getuint>
  801573:	89 d1                	mov    %edx,%ecx
  801575:	89 c2                	mov    %eax,%edx
			base = 10;
  801577:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80157c:	83 ec 0c             	sub    $0xc,%esp
  80157f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801583:	57                   	push   %edi
  801584:	ff 75 e0             	pushl  -0x20(%ebp)
  801587:	50                   	push   %eax
  801588:	51                   	push   %ecx
  801589:	52                   	push   %edx
  80158a:	89 f2                	mov    %esi,%edx
  80158c:	89 d8                	mov    %ebx,%eax
  80158e:	e8 1a fc ff ff       	call   8011ad <printnum>
			break;
  801593:	83 c4 20             	add    $0x20,%esp
{
  801596:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801599:	83 c7 01             	add    $0x1,%edi
  80159c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8015a0:	83 f8 25             	cmp    $0x25,%eax
  8015a3:	0f 84 6a fd ff ff    	je     801313 <vprintfmt+0x1b>
			if (ch == '\0')
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	0f 84 93 00 00 00    	je     801644 <vprintfmt+0x34c>
			putch(ch, putdat);
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	56                   	push   %esi
  8015b5:	50                   	push   %eax
  8015b6:	ff d3                	call   *%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	eb dc                	jmp    801599 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8015bd:	89 ca                	mov    %ecx,%edx
  8015bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8015c2:	e8 8f fc ff ff       	call   801256 <getuint>
  8015c7:	89 d1                	mov    %edx,%ecx
  8015c9:	89 c2                	mov    %eax,%edx
			base = 8;
  8015cb:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015d0:	eb aa                	jmp    80157c <vprintfmt+0x284>
			putch('0', putdat);
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	56                   	push   %esi
  8015d6:	6a 30                	push   $0x30
  8015d8:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015da:	83 c4 08             	add    $0x8,%esp
  8015dd:	56                   	push   %esi
  8015de:	6a 78                	push   $0x78
  8015e0:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e5:	8d 50 04             	lea    0x4(%eax),%edx
  8015e8:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015eb:	8b 10                	mov    (%eax),%edx
  8015ed:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015f2:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015f5:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015fa:	eb 80                	jmp    80157c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015fc:	89 ca                	mov    %ecx,%edx
  8015fe:	8d 45 14             	lea    0x14(%ebp),%eax
  801601:	e8 50 fc ff ff       	call   801256 <getuint>
  801606:	89 d1                	mov    %edx,%ecx
  801608:	89 c2                	mov    %eax,%edx
			base = 16;
  80160a:	b8 10 00 00 00       	mov    $0x10,%eax
  80160f:	e9 68 ff ff ff       	jmp    80157c <vprintfmt+0x284>
			putch(ch, putdat);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	56                   	push   %esi
  801618:	6a 25                	push   $0x25
  80161a:	ff d3                	call   *%ebx
			break;
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	e9 72 ff ff ff       	jmp    801596 <vprintfmt+0x29e>
			putch('%', putdat);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	56                   	push   %esi
  801628:	6a 25                	push   $0x25
  80162a:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 f8                	mov    %edi,%eax
  801631:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801635:	74 05                	je     80163c <vprintfmt+0x344>
  801637:	83 e8 01             	sub    $0x1,%eax
  80163a:	eb f5                	jmp    801631 <vprintfmt+0x339>
  80163c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80163f:	e9 52 ff ff ff       	jmp    801596 <vprintfmt+0x29e>
}
  801644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801647:	5b                   	pop    %ebx
  801648:	5e                   	pop    %esi
  801649:	5f                   	pop    %edi
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80164c:	f3 0f 1e fb          	endbr32 
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 18             	sub    $0x18,%esp
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80165c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80165f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801663:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80166d:	85 c0                	test   %eax,%eax
  80166f:	74 26                	je     801697 <vsnprintf+0x4b>
  801671:	85 d2                	test   %edx,%edx
  801673:	7e 22                	jle    801697 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801675:	ff 75 14             	pushl  0x14(%ebp)
  801678:	ff 75 10             	pushl  0x10(%ebp)
  80167b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	68 b6 12 80 00       	push   $0x8012b6
  801684:	e8 6f fc ff ff       	call   8012f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	83 c4 10             	add    $0x10,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    
		return -E_INVAL;
  801697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169c:	eb f7                	jmp    801695 <vsnprintf+0x49>

0080169e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80169e:	f3 0f 1e fb          	endbr32 
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8016a8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8016ab:	50                   	push   %eax
  8016ac:	ff 75 10             	pushl  0x10(%ebp)
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 92 ff ff ff       	call   80164c <vsnprintf>
	va_end(ap);

	return rc;
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016bc:	f3 0f 1e fb          	endbr32 
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016cf:	74 05                	je     8016d6 <strlen+0x1a>
		n++;
  8016d1:	83 c0 01             	add    $0x1,%eax
  8016d4:	eb f5                	jmp    8016cb <strlen+0xf>
	return n;
}
  8016d6:	5d                   	pop    %ebp
  8016d7:	c3                   	ret    

008016d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016d8:	f3 0f 1e fb          	endbr32 
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	39 d0                	cmp    %edx,%eax
  8016ec:	74 0d                	je     8016fb <strnlen+0x23>
  8016ee:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016f2:	74 05                	je     8016f9 <strnlen+0x21>
		n++;
  8016f4:	83 c0 01             	add    $0x1,%eax
  8016f7:	eb f1                	jmp    8016ea <strnlen+0x12>
  8016f9:	89 c2                	mov    %eax,%edx
	return n;
}
  8016fb:	89 d0                	mov    %edx,%eax
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ff:	f3 0f 1e fb          	endbr32 
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	53                   	push   %ebx
  801707:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
  801712:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801716:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801719:	83 c0 01             	add    $0x1,%eax
  80171c:	84 d2                	test   %dl,%dl
  80171e:	75 f2                	jne    801712 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801720:	89 c8                	mov    %ecx,%eax
  801722:	5b                   	pop    %ebx
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801725:	f3 0f 1e fb          	endbr32 
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	53                   	push   %ebx
  80172d:	83 ec 10             	sub    $0x10,%esp
  801730:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801733:	53                   	push   %ebx
  801734:	e8 83 ff ff ff       	call   8016bc <strlen>
  801739:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	01 d8                	add    %ebx,%eax
  801741:	50                   	push   %eax
  801742:	e8 b8 ff ff ff       	call   8016ff <strcpy>
	return dst;
}
  801747:	89 d8                	mov    %ebx,%eax
  801749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80174e:	f3 0f 1e fb          	endbr32 
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	8b 75 08             	mov    0x8(%ebp),%esi
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	89 f3                	mov    %esi,%ebx
  80175f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801762:	89 f0                	mov    %esi,%eax
  801764:	39 d8                	cmp    %ebx,%eax
  801766:	74 11                	je     801779 <strncpy+0x2b>
		*dst++ = *src;
  801768:	83 c0 01             	add    $0x1,%eax
  80176b:	0f b6 0a             	movzbl (%edx),%ecx
  80176e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801771:	80 f9 01             	cmp    $0x1,%cl
  801774:	83 da ff             	sbb    $0xffffffff,%edx
  801777:	eb eb                	jmp    801764 <strncpy+0x16>
	}
	return ret;
}
  801779:	89 f0                	mov    %esi,%eax
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80177f:	f3 0f 1e fb          	endbr32 
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	8b 75 08             	mov    0x8(%ebp),%esi
  80178b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80178e:	8b 55 10             	mov    0x10(%ebp),%edx
  801791:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801793:	85 d2                	test   %edx,%edx
  801795:	74 21                	je     8017b8 <strlcpy+0x39>
  801797:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80179b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80179d:	39 c2                	cmp    %eax,%edx
  80179f:	74 14                	je     8017b5 <strlcpy+0x36>
  8017a1:	0f b6 19             	movzbl (%ecx),%ebx
  8017a4:	84 db                	test   %bl,%bl
  8017a6:	74 0b                	je     8017b3 <strlcpy+0x34>
			*dst++ = *src++;
  8017a8:	83 c1 01             	add    $0x1,%ecx
  8017ab:	83 c2 01             	add    $0x1,%edx
  8017ae:	88 5a ff             	mov    %bl,-0x1(%edx)
  8017b1:	eb ea                	jmp    80179d <strlcpy+0x1e>
  8017b3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8017b5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8017b8:	29 f0                	sub    %esi,%eax
}
  8017ba:	5b                   	pop    %ebx
  8017bb:	5e                   	pop    %esi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017be:	f3 0f 1e fb          	endbr32 
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017cb:	0f b6 01             	movzbl (%ecx),%eax
  8017ce:	84 c0                	test   %al,%al
  8017d0:	74 0c                	je     8017de <strcmp+0x20>
  8017d2:	3a 02                	cmp    (%edx),%al
  8017d4:	75 08                	jne    8017de <strcmp+0x20>
		p++, q++;
  8017d6:	83 c1 01             	add    $0x1,%ecx
  8017d9:	83 c2 01             	add    $0x1,%edx
  8017dc:	eb ed                	jmp    8017cb <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017de:	0f b6 c0             	movzbl %al,%eax
  8017e1:	0f b6 12             	movzbl (%edx),%edx
  8017e4:	29 d0                	sub    %edx,%eax
}
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017e8:	f3 0f 1e fb          	endbr32 
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	89 c3                	mov    %eax,%ebx
  8017f8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017fb:	eb 06                	jmp    801803 <strncmp+0x1b>
		n--, p++, q++;
  8017fd:	83 c0 01             	add    $0x1,%eax
  801800:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801803:	39 d8                	cmp    %ebx,%eax
  801805:	74 16                	je     80181d <strncmp+0x35>
  801807:	0f b6 08             	movzbl (%eax),%ecx
  80180a:	84 c9                	test   %cl,%cl
  80180c:	74 04                	je     801812 <strncmp+0x2a>
  80180e:	3a 0a                	cmp    (%edx),%cl
  801810:	74 eb                	je     8017fd <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801812:	0f b6 00             	movzbl (%eax),%eax
  801815:	0f b6 12             	movzbl (%edx),%edx
  801818:	29 d0                	sub    %edx,%eax
}
  80181a:	5b                   	pop    %ebx
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    
		return 0;
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	eb f6                	jmp    80181a <strncmp+0x32>

00801824 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801824:	f3 0f 1e fb          	endbr32 
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801832:	0f b6 10             	movzbl (%eax),%edx
  801835:	84 d2                	test   %dl,%dl
  801837:	74 09                	je     801842 <strchr+0x1e>
		if (*s == c)
  801839:	38 ca                	cmp    %cl,%dl
  80183b:	74 0a                	je     801847 <strchr+0x23>
	for (; *s; s++)
  80183d:	83 c0 01             	add    $0x1,%eax
  801840:	eb f0                	jmp    801832 <strchr+0xe>
			return (char *) s;
	return 0;
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801849:	f3 0f 1e fb          	endbr32 
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801857:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80185a:	38 ca                	cmp    %cl,%dl
  80185c:	74 09                	je     801867 <strfind+0x1e>
  80185e:	84 d2                	test   %dl,%dl
  801860:	74 05                	je     801867 <strfind+0x1e>
	for (; *s; s++)
  801862:	83 c0 01             	add    $0x1,%eax
  801865:	eb f0                	jmp    801857 <strfind+0xe>
			break;
	return (char *) s;
}
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801869:	f3 0f 1e fb          	endbr32 
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	57                   	push   %edi
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
  801873:	8b 55 08             	mov    0x8(%ebp),%edx
  801876:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801879:	85 c9                	test   %ecx,%ecx
  80187b:	74 33                	je     8018b0 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80187d:	89 d0                	mov    %edx,%eax
  80187f:	09 c8                	or     %ecx,%eax
  801881:	a8 03                	test   $0x3,%al
  801883:	75 23                	jne    8018a8 <memset+0x3f>
		c &= 0xFF;
  801885:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	c1 e0 08             	shl    $0x8,%eax
  80188e:	89 df                	mov    %ebx,%edi
  801890:	c1 e7 18             	shl    $0x18,%edi
  801893:	89 de                	mov    %ebx,%esi
  801895:	c1 e6 10             	shl    $0x10,%esi
  801898:	09 f7                	or     %esi,%edi
  80189a:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80189c:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80189f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8018a1:	89 d7                	mov    %edx,%edi
  8018a3:	fc                   	cld    
  8018a4:	f3 ab                	rep stos %eax,%es:(%edi)
  8018a6:	eb 08                	jmp    8018b0 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8018a8:	89 d7                	mov    %edx,%edi
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	fc                   	cld    
  8018ae:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	57                   	push   %edi
  8018bf:	56                   	push   %esi
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018c9:	39 c6                	cmp    %eax,%esi
  8018cb:	73 32                	jae    8018ff <memmove+0x48>
  8018cd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018d0:	39 c2                	cmp    %eax,%edx
  8018d2:	76 2b                	jbe    8018ff <memmove+0x48>
		s += n;
		d += n;
  8018d4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018d7:	89 fe                	mov    %edi,%esi
  8018d9:	09 ce                	or     %ecx,%esi
  8018db:	09 d6                	or     %edx,%esi
  8018dd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018e3:	75 0e                	jne    8018f3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018e5:	83 ef 04             	sub    $0x4,%edi
  8018e8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018eb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018ee:	fd                   	std    
  8018ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018f1:	eb 09                	jmp    8018fc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018f3:	83 ef 01             	sub    $0x1,%edi
  8018f6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018f9:	fd                   	std    
  8018fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018fc:	fc                   	cld    
  8018fd:	eb 1a                	jmp    801919 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ff:	89 c2                	mov    %eax,%edx
  801901:	09 ca                	or     %ecx,%edx
  801903:	09 f2                	or     %esi,%edx
  801905:	f6 c2 03             	test   $0x3,%dl
  801908:	75 0a                	jne    801914 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80190a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80190d:	89 c7                	mov    %eax,%edi
  80190f:	fc                   	cld    
  801910:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801912:	eb 05                	jmp    801919 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801914:	89 c7                	mov    %eax,%edi
  801916:	fc                   	cld    
  801917:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801919:	5e                   	pop    %esi
  80191a:	5f                   	pop    %edi
  80191b:	5d                   	pop    %ebp
  80191c:	c3                   	ret    

0080191d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80191d:	f3 0f 1e fb          	endbr32 
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801927:	ff 75 10             	pushl  0x10(%ebp)
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 82 ff ff ff       	call   8018b7 <memmove>
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801937:	f3 0f 1e fb          	endbr32 
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	89 c6                	mov    %eax,%esi
  801948:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80194b:	39 f0                	cmp    %esi,%eax
  80194d:	74 1c                	je     80196b <memcmp+0x34>
		if (*s1 != *s2)
  80194f:	0f b6 08             	movzbl (%eax),%ecx
  801952:	0f b6 1a             	movzbl (%edx),%ebx
  801955:	38 d9                	cmp    %bl,%cl
  801957:	75 08                	jne    801961 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801959:	83 c0 01             	add    $0x1,%eax
  80195c:	83 c2 01             	add    $0x1,%edx
  80195f:	eb ea                	jmp    80194b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801961:	0f b6 c1             	movzbl %cl,%eax
  801964:	0f b6 db             	movzbl %bl,%ebx
  801967:	29 d8                	sub    %ebx,%eax
  801969:	eb 05                	jmp    801970 <memcmp+0x39>
	}

	return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801974:	f3 0f 1e fb          	endbr32 
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801981:	89 c2                	mov    %eax,%edx
  801983:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801986:	39 d0                	cmp    %edx,%eax
  801988:	73 09                	jae    801993 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80198a:	38 08                	cmp    %cl,(%eax)
  80198c:	74 05                	je     801993 <memfind+0x1f>
	for (; s < ends; s++)
  80198e:	83 c0 01             	add    $0x1,%eax
  801991:	eb f3                	jmp    801986 <memfind+0x12>
			break;
	return (void *) s;
}
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    

00801995 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801995:	f3 0f 1e fb          	endbr32 
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	57                   	push   %edi
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
  80199f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a5:	eb 03                	jmp    8019aa <strtol+0x15>
		s++;
  8019a7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8019aa:	0f b6 01             	movzbl (%ecx),%eax
  8019ad:	3c 20                	cmp    $0x20,%al
  8019af:	74 f6                	je     8019a7 <strtol+0x12>
  8019b1:	3c 09                	cmp    $0x9,%al
  8019b3:	74 f2                	je     8019a7 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8019b5:	3c 2b                	cmp    $0x2b,%al
  8019b7:	74 2a                	je     8019e3 <strtol+0x4e>
	int neg = 0;
  8019b9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8019be:	3c 2d                	cmp    $0x2d,%al
  8019c0:	74 2b                	je     8019ed <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019c8:	75 0f                	jne    8019d9 <strtol+0x44>
  8019ca:	80 39 30             	cmpb   $0x30,(%ecx)
  8019cd:	74 28                	je     8019f7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019cf:	85 db                	test   %ebx,%ebx
  8019d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019d6:	0f 44 d8             	cmove  %eax,%ebx
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019e1:	eb 46                	jmp    801a29 <strtol+0x94>
		s++;
  8019e3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8019eb:	eb d5                	jmp    8019c2 <strtol+0x2d>
		s++, neg = 1;
  8019ed:	83 c1 01             	add    $0x1,%ecx
  8019f0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019f5:	eb cb                	jmp    8019c2 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019fb:	74 0e                	je     801a0b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019fd:	85 db                	test   %ebx,%ebx
  8019ff:	75 d8                	jne    8019d9 <strtol+0x44>
		s++, base = 8;
  801a01:	83 c1 01             	add    $0x1,%ecx
  801a04:	bb 08 00 00 00       	mov    $0x8,%ebx
  801a09:	eb ce                	jmp    8019d9 <strtol+0x44>
		s += 2, base = 16;
  801a0b:	83 c1 02             	add    $0x2,%ecx
  801a0e:	bb 10 00 00 00       	mov    $0x10,%ebx
  801a13:	eb c4                	jmp    8019d9 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801a15:	0f be d2             	movsbl %dl,%edx
  801a18:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801a1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  801a1e:	7d 3a                	jge    801a5a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801a20:	83 c1 01             	add    $0x1,%ecx
  801a23:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a27:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a29:	0f b6 11             	movzbl (%ecx),%edx
  801a2c:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a2f:	89 f3                	mov    %esi,%ebx
  801a31:	80 fb 09             	cmp    $0x9,%bl
  801a34:	76 df                	jbe    801a15 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a36:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a39:	89 f3                	mov    %esi,%ebx
  801a3b:	80 fb 19             	cmp    $0x19,%bl
  801a3e:	77 08                	ja     801a48 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a40:	0f be d2             	movsbl %dl,%edx
  801a43:	83 ea 57             	sub    $0x57,%edx
  801a46:	eb d3                	jmp    801a1b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a48:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a4b:	89 f3                	mov    %esi,%ebx
  801a4d:	80 fb 19             	cmp    $0x19,%bl
  801a50:	77 08                	ja     801a5a <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a52:	0f be d2             	movsbl %dl,%edx
  801a55:	83 ea 37             	sub    $0x37,%edx
  801a58:	eb c1                	jmp    801a1b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a5e:	74 05                	je     801a65 <strtol+0xd0>
		*endptr = (char *) s;
  801a60:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a63:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a65:	89 c2                	mov    %eax,%edx
  801a67:	f7 da                	neg    %edx
  801a69:	85 ff                	test   %edi,%edi
  801a6b:	0f 45 c2             	cmovne %edx,%eax
}
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5f                   	pop    %edi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a73:	f3 0f 1e fb          	endbr32 
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	8b 75 08             	mov    0x8(%ebp),%esi
  801a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a85:	85 c0                	test   %eax,%eax
  801a87:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a8c:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	50                   	push   %eax
  801a93:	e8 68 e8 ff ff       	call   800300 <sys_ipc_recv>
	if (r < 0) {
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 2b                	js     801aca <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a9f:	85 f6                	test   %esi,%esi
  801aa1:	74 0a                	je     801aad <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801aa3:	a1 04 40 80 00       	mov    0x804004,%eax
  801aa8:	8b 40 74             	mov    0x74(%eax),%eax
  801aab:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801aad:	85 db                	test   %ebx,%ebx
  801aaf:	74 0a                	je     801abb <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801ab1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab6:	8b 40 78             	mov    0x78(%eax),%eax
  801ab9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801abb:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5e                   	pop    %esi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    
		if (from_env_store) {
  801aca:	85 f6                	test   %esi,%esi
  801acc:	74 06                	je     801ad4 <ipc_recv+0x61>
			*from_env_store = 0;
  801ace:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801ad4:	85 db                	test   %ebx,%ebx
  801ad6:	74 eb                	je     801ac3 <ipc_recv+0x50>
			*perm_store = 0;
  801ad8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ade:	eb e3                	jmp    801ac3 <ipc_recv+0x50>

00801ae0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ae0:	f3 0f 1e fb          	endbr32 
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	57                   	push   %edi
  801ae8:	56                   	push   %esi
  801ae9:	53                   	push   %ebx
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801af3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801af6:	85 db                	test   %ebx,%ebx
  801af8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801afd:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b00:	ff 75 14             	pushl  0x14(%ebp)
  801b03:	53                   	push   %ebx
  801b04:	56                   	push   %esi
  801b05:	57                   	push   %edi
  801b06:	e8 cc e7 ff ff       	call   8002d7 <sys_ipc_try_send>
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b11:	75 07                	jne    801b1a <ipc_send+0x3a>
		sys_yield();
  801b13:	e8 a6 e6 ff ff       	call   8001be <sys_yield>
  801b18:	eb e6                	jmp    801b00 <ipc_send+0x20>
	}

	if (ret < 0) {
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 08                	js     801b26 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b26:	50                   	push   %eax
  801b27:	68 9f 22 80 00       	push   $0x80229f
  801b2c:	6a 48                	push   $0x48
  801b2e:	68 bc 22 80 00       	push   $0x8022bc
  801b33:	e8 76 f5 ff ff       	call   8010ae <_panic>

00801b38 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b38:	f3 0f 1e fb          	endbr32 
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b42:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b47:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b4a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b50:	8b 52 50             	mov    0x50(%edx),%edx
  801b53:	39 ca                	cmp    %ecx,%edx
  801b55:	74 11                	je     801b68 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b57:	83 c0 01             	add    $0x1,%eax
  801b5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b5f:	75 e6                	jne    801b47 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	eb 0b                	jmp    801b73 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b68:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b6b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b70:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b75:	f3 0f 1e fb          	endbr32 
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b7f:	89 c2                	mov    %eax,%edx
  801b81:	c1 ea 16             	shr    $0x16,%edx
  801b84:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b8b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b90:	f6 c1 01             	test   $0x1,%cl
  801b93:	74 1c                	je     801bb1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b95:	c1 e8 0c             	shr    $0xc,%eax
  801b98:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b9f:	a8 01                	test   $0x1,%al
  801ba1:	74 0e                	je     801bb1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ba3:	c1 e8 0c             	shr    $0xc,%eax
  801ba6:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801bad:	ef 
  801bae:	0f b7 d2             	movzwl %dx,%edx
}
  801bb1:	89 d0                	mov    %edx,%eax
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	66 90                	xchg   %ax,%ax
  801bb7:	66 90                	xchg   %ax,%ax
  801bb9:	66 90                	xchg   %ax,%ax
  801bbb:	66 90                	xchg   %ax,%ax
  801bbd:	66 90                	xchg   %ax,%ax
  801bbf:	90                   	nop

00801bc0 <__udivdi3>:
  801bc0:	f3 0f 1e fb          	endbr32 
  801bc4:	55                   	push   %ebp
  801bc5:	57                   	push   %edi
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 1c             	sub    $0x1c,%esp
  801bcb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bcf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bdb:	85 d2                	test   %edx,%edx
  801bdd:	75 19                	jne    801bf8 <__udivdi3+0x38>
  801bdf:	39 f3                	cmp    %esi,%ebx
  801be1:	76 4d                	jbe    801c30 <__udivdi3+0x70>
  801be3:	31 ff                	xor    %edi,%edi
  801be5:	89 e8                	mov    %ebp,%eax
  801be7:	89 f2                	mov    %esi,%edx
  801be9:	f7 f3                	div    %ebx
  801beb:	89 fa                	mov    %edi,%edx
  801bed:	83 c4 1c             	add    $0x1c,%esp
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5f                   	pop    %edi
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    
  801bf5:	8d 76 00             	lea    0x0(%esi),%esi
  801bf8:	39 f2                	cmp    %esi,%edx
  801bfa:	76 14                	jbe    801c10 <__udivdi3+0x50>
  801bfc:	31 ff                	xor    %edi,%edi
  801bfe:	31 c0                	xor    %eax,%eax
  801c00:	89 fa                	mov    %edi,%edx
  801c02:	83 c4 1c             	add    $0x1c,%esp
  801c05:	5b                   	pop    %ebx
  801c06:	5e                   	pop    %esi
  801c07:	5f                   	pop    %edi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    
  801c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c10:	0f bd fa             	bsr    %edx,%edi
  801c13:	83 f7 1f             	xor    $0x1f,%edi
  801c16:	75 48                	jne    801c60 <__udivdi3+0xa0>
  801c18:	39 f2                	cmp    %esi,%edx
  801c1a:	72 06                	jb     801c22 <__udivdi3+0x62>
  801c1c:	31 c0                	xor    %eax,%eax
  801c1e:	39 eb                	cmp    %ebp,%ebx
  801c20:	77 de                	ja     801c00 <__udivdi3+0x40>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	eb d7                	jmp    801c00 <__udivdi3+0x40>
  801c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c30:	89 d9                	mov    %ebx,%ecx
  801c32:	85 db                	test   %ebx,%ebx
  801c34:	75 0b                	jne    801c41 <__udivdi3+0x81>
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	31 d2                	xor    %edx,%edx
  801c3d:	f7 f3                	div    %ebx
  801c3f:	89 c1                	mov    %eax,%ecx
  801c41:	31 d2                	xor    %edx,%edx
  801c43:	89 f0                	mov    %esi,%eax
  801c45:	f7 f1                	div    %ecx
  801c47:	89 c6                	mov    %eax,%esi
  801c49:	89 e8                	mov    %ebp,%eax
  801c4b:	89 f7                	mov    %esi,%edi
  801c4d:	f7 f1                	div    %ecx
  801c4f:	89 fa                	mov    %edi,%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	89 f9                	mov    %edi,%ecx
  801c62:	b8 20 00 00 00       	mov    $0x20,%eax
  801c67:	29 f8                	sub    %edi,%eax
  801c69:	d3 e2                	shl    %cl,%edx
  801c6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c6f:	89 c1                	mov    %eax,%ecx
  801c71:	89 da                	mov    %ebx,%edx
  801c73:	d3 ea                	shr    %cl,%edx
  801c75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c79:	09 d1                	or     %edx,%ecx
  801c7b:	89 f2                	mov    %esi,%edx
  801c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c81:	89 f9                	mov    %edi,%ecx
  801c83:	d3 e3                	shl    %cl,%ebx
  801c85:	89 c1                	mov    %eax,%ecx
  801c87:	d3 ea                	shr    %cl,%edx
  801c89:	89 f9                	mov    %edi,%ecx
  801c8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c8f:	89 eb                	mov    %ebp,%ebx
  801c91:	d3 e6                	shl    %cl,%esi
  801c93:	89 c1                	mov    %eax,%ecx
  801c95:	d3 eb                	shr    %cl,%ebx
  801c97:	09 de                	or     %ebx,%esi
  801c99:	89 f0                	mov    %esi,%eax
  801c9b:	f7 74 24 08          	divl   0x8(%esp)
  801c9f:	89 d6                	mov    %edx,%esi
  801ca1:	89 c3                	mov    %eax,%ebx
  801ca3:	f7 64 24 0c          	mull   0xc(%esp)
  801ca7:	39 d6                	cmp    %edx,%esi
  801ca9:	72 15                	jb     801cc0 <__udivdi3+0x100>
  801cab:	89 f9                	mov    %edi,%ecx
  801cad:	d3 e5                	shl    %cl,%ebp
  801caf:	39 c5                	cmp    %eax,%ebp
  801cb1:	73 04                	jae    801cb7 <__udivdi3+0xf7>
  801cb3:	39 d6                	cmp    %edx,%esi
  801cb5:	74 09                	je     801cc0 <__udivdi3+0x100>
  801cb7:	89 d8                	mov    %ebx,%eax
  801cb9:	31 ff                	xor    %edi,%edi
  801cbb:	e9 40 ff ff ff       	jmp    801c00 <__udivdi3+0x40>
  801cc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	e9 36 ff ff ff       	jmp    801c00 <__udivdi3+0x40>
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	66 90                	xchg   %ax,%ax
  801cce:	66 90                	xchg   %ax,%ax

00801cd0 <__umoddi3>:
  801cd0:	f3 0f 1e fb          	endbr32 
  801cd4:	55                   	push   %ebp
  801cd5:	57                   	push   %edi
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 1c             	sub    $0x1c,%esp
  801cdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cdf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ce3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ce7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	75 19                	jne    801d08 <__umoddi3+0x38>
  801cef:	39 df                	cmp    %ebx,%edi
  801cf1:	76 5d                	jbe    801d50 <__umoddi3+0x80>
  801cf3:	89 f0                	mov    %esi,%eax
  801cf5:	89 da                	mov    %ebx,%edx
  801cf7:	f7 f7                	div    %edi
  801cf9:	89 d0                	mov    %edx,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	83 c4 1c             	add    $0x1c,%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5f                   	pop    %edi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    
  801d05:	8d 76 00             	lea    0x0(%esi),%esi
  801d08:	89 f2                	mov    %esi,%edx
  801d0a:	39 d8                	cmp    %ebx,%eax
  801d0c:	76 12                	jbe    801d20 <__umoddi3+0x50>
  801d0e:	89 f0                	mov    %esi,%eax
  801d10:	89 da                	mov    %ebx,%edx
  801d12:	83 c4 1c             	add    $0x1c,%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5f                   	pop    %edi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
  801d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d20:	0f bd e8             	bsr    %eax,%ebp
  801d23:	83 f5 1f             	xor    $0x1f,%ebp
  801d26:	75 50                	jne    801d78 <__umoddi3+0xa8>
  801d28:	39 d8                	cmp    %ebx,%eax
  801d2a:	0f 82 e0 00 00 00    	jb     801e10 <__umoddi3+0x140>
  801d30:	89 d9                	mov    %ebx,%ecx
  801d32:	39 f7                	cmp    %esi,%edi
  801d34:	0f 86 d6 00 00 00    	jbe    801e10 <__umoddi3+0x140>
  801d3a:	89 d0                	mov    %edx,%eax
  801d3c:	89 ca                	mov    %ecx,%edx
  801d3e:	83 c4 1c             	add    $0x1c,%esp
  801d41:	5b                   	pop    %ebx
  801d42:	5e                   	pop    %esi
  801d43:	5f                   	pop    %edi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    
  801d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d4d:	8d 76 00             	lea    0x0(%esi),%esi
  801d50:	89 fd                	mov    %edi,%ebp
  801d52:	85 ff                	test   %edi,%edi
  801d54:	75 0b                	jne    801d61 <__umoddi3+0x91>
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f7                	div    %edi
  801d5f:	89 c5                	mov    %eax,%ebp
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f5                	div    %ebp
  801d67:	89 f0                	mov    %esi,%eax
  801d69:	f7 f5                	div    %ebp
  801d6b:	89 d0                	mov    %edx,%eax
  801d6d:	31 d2                	xor    %edx,%edx
  801d6f:	eb 8c                	jmp    801cfd <__umoddi3+0x2d>
  801d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d78:	89 e9                	mov    %ebp,%ecx
  801d7a:	ba 20 00 00 00       	mov    $0x20,%edx
  801d7f:	29 ea                	sub    %ebp,%edx
  801d81:	d3 e0                	shl    %cl,%eax
  801d83:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d87:	89 d1                	mov    %edx,%ecx
  801d89:	89 f8                	mov    %edi,%eax
  801d8b:	d3 e8                	shr    %cl,%eax
  801d8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d91:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d95:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d99:	09 c1                	or     %eax,%ecx
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 e7                	shl    %cl,%edi
  801da5:	89 d1                	mov    %edx,%ecx
  801da7:	d3 e8                	shr    %cl,%eax
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801daf:	d3 e3                	shl    %cl,%ebx
  801db1:	89 c7                	mov    %eax,%edi
  801db3:	89 d1                	mov    %edx,%ecx
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	d3 e8                	shr    %cl,%eax
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	89 fa                	mov    %edi,%edx
  801dbd:	d3 e6                	shl    %cl,%esi
  801dbf:	09 d8                	or     %ebx,%eax
  801dc1:	f7 74 24 08          	divl   0x8(%esp)
  801dc5:	89 d1                	mov    %edx,%ecx
  801dc7:	89 f3                	mov    %esi,%ebx
  801dc9:	f7 64 24 0c          	mull   0xc(%esp)
  801dcd:	89 c6                	mov    %eax,%esi
  801dcf:	89 d7                	mov    %edx,%edi
  801dd1:	39 d1                	cmp    %edx,%ecx
  801dd3:	72 06                	jb     801ddb <__umoddi3+0x10b>
  801dd5:	75 10                	jne    801de7 <__umoddi3+0x117>
  801dd7:	39 c3                	cmp    %eax,%ebx
  801dd9:	73 0c                	jae    801de7 <__umoddi3+0x117>
  801ddb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801ddf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801de3:	89 d7                	mov    %edx,%edi
  801de5:	89 c6                	mov    %eax,%esi
  801de7:	89 ca                	mov    %ecx,%edx
  801de9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801dee:	29 f3                	sub    %esi,%ebx
  801df0:	19 fa                	sbb    %edi,%edx
  801df2:	89 d0                	mov    %edx,%eax
  801df4:	d3 e0                	shl    %cl,%eax
  801df6:	89 e9                	mov    %ebp,%ecx
  801df8:	d3 eb                	shr    %cl,%ebx
  801dfa:	d3 ea                	shr    %cl,%edx
  801dfc:	09 d8                	or     %ebx,%eax
  801dfe:	83 c4 1c             	add    $0x1c,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5f                   	pop    %edi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
  801e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	29 fe                	sub    %edi,%esi
  801e12:	19 c3                	sbb    %eax,%ebx
  801e14:	89 f2                	mov    %esi,%edx
  801e16:	89 d9                	mov    %ebx,%ecx
  801e18:	e9 1d ff ff ff       	jmp    801d3a <__umoddi3+0x6a>
