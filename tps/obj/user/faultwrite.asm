
obj/user/faultwrite.debug:     formato del fichero elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	*(unsigned*)0 = 0;
  800037:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003e:	00 00 00 
}
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	f3 0f 1e fb          	endbr32 
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	56                   	push   %esi
  80004a:	53                   	push   %ebx
  80004b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800051:	e8 19 01 00 00       	call   80016f <sys_getenvid>
	if (id >= 0)
  800056:	85 c0                	test   %eax,%eax
  800058:	78 12                	js     80006c <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x35>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	f3 0f 1e fb          	endbr32 
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 53 04 00 00       	call   8004f2 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 a0 00 00 00       	call   800149 <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
  8000b4:	83 ec 1c             	sub    $0x1c,%esp
  8000b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000bd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c8:	8b 75 14             	mov    0x14(%ebp),%esi
  8000cb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000d1:	74 04                	je     8000d7 <syscall+0x29>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	7f 08                	jg     8000df <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	50                   	push   %eax
  8000e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e6:	68 0a 1e 80 00       	push   $0x801e0a
  8000eb:	6a 23                	push   $0x23
  8000ed:	68 27 1e 80 00       	push   $0x801e27
  8000f2:	e8 90 0f 00 00       	call   801087 <_panic>

008000f7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000f7:	f3 0f 1e fb          	endbr32 
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800101:	6a 00                	push   $0x0
  800103:	6a 00                	push   $0x0
  800105:	6a 00                	push   $0x0
  800107:	ff 75 0c             	pushl  0xc(%ebp)
  80010a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010d:	ba 00 00 00 00       	mov    $0x0,%edx
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	e8 92 ff ff ff       	call   8000ae <syscall>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <sys_cgetc>:

int
sys_cgetc(void)
{
  800121:	f3 0f 1e fb          	endbr32 
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80012b:	6a 00                	push   $0x0
  80012d:	6a 00                	push   $0x0
  80012f:	6a 00                	push   $0x0
  800131:	6a 00                	push   $0x0
  800133:	b9 00 00 00 00       	mov    $0x0,%ecx
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 01 00 00 00       	mov    $0x1,%eax
  800142:	e8 67 ff ff ff       	call   8000ae <syscall>
}
  800147:	c9                   	leave  
  800148:	c3                   	ret    

00800149 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800149:	f3 0f 1e fb          	endbr32 
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800153:	6a 00                	push   $0x0
  800155:	6a 00                	push   $0x0
  800157:	6a 00                	push   $0x0
  800159:	6a 00                	push   $0x0
  80015b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015e:	ba 01 00 00 00       	mov    $0x1,%edx
  800163:	b8 03 00 00 00       	mov    $0x3,%eax
  800168:	e8 41 ff ff ff       	call   8000ae <syscall>
}
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016f:	f3 0f 1e fb          	endbr32 
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800179:	6a 00                	push   $0x0
  80017b:	6a 00                	push   $0x0
  80017d:	6a 00                	push   $0x0
  80017f:	6a 00                	push   $0x0
  800181:	b9 00 00 00 00       	mov    $0x0,%ecx
  800186:	ba 00 00 00 00       	mov    $0x0,%edx
  80018b:	b8 02 00 00 00       	mov    $0x2,%eax
  800190:	e8 19 ff ff ff       	call   8000ae <syscall>
}
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <sys_yield>:

void
sys_yield(void)
{
  800197:	f3 0f 1e fb          	endbr32 
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001a1:	6a 00                	push   $0x0
  8001a3:	6a 00                	push   $0x0
  8001a5:	6a 00                	push   $0x0
  8001a7:	6a 00                	push   $0x0
  8001a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001b8:	e8 f1 fe ff ff       	call   8000ae <syscall>
}
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001c2:	f3 0f 1e fb          	endbr32 
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001cc:	6a 00                	push   $0x0
  8001ce:	6a 00                	push   $0x0
  8001d0:	ff 75 10             	pushl  0x10(%ebp)
  8001d3:	ff 75 0c             	pushl  0xc(%ebp)
  8001d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8001de:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e3:	e8 c6 fe ff ff       	call   8000ae <syscall>
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ea:	f3 0f 1e fb          	endbr32 
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	ff 75 14             	pushl  0x14(%ebp)
  8001fa:	ff 75 10             	pushl  0x10(%ebp)
  8001fd:	ff 75 0c             	pushl  0xc(%ebp)
  800200:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800203:	ba 01 00 00 00       	mov    $0x1,%edx
  800208:	b8 05 00 00 00       	mov    $0x5,%eax
  80020d:	e8 9c fe ff ff       	call   8000ae <syscall>
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800214:	f3 0f 1e fb          	endbr32 
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80021e:	6a 00                	push   $0x0
  800220:	6a 00                	push   $0x0
  800222:	6a 00                	push   $0x0
  800224:	ff 75 0c             	pushl  0xc(%ebp)
  800227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022a:	ba 01 00 00 00       	mov    $0x1,%edx
  80022f:	b8 06 00 00 00       	mov    $0x6,%eax
  800234:	e8 75 fe ff ff       	call   8000ae <syscall>
}
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80023b:	f3 0f 1e fb          	endbr32 
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800245:	6a 00                	push   $0x0
  800247:	6a 00                	push   $0x0
  800249:	6a 00                	push   $0x0
  80024b:	ff 75 0c             	pushl  0xc(%ebp)
  80024e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800251:	ba 01 00 00 00       	mov    $0x1,%edx
  800256:	b8 08 00 00 00       	mov    $0x8,%eax
  80025b:	e8 4e fe ff ff       	call   8000ae <syscall>
}
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800262:	f3 0f 1e fb          	endbr32 
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80026c:	6a 00                	push   $0x0
  80026e:	6a 00                	push   $0x0
  800270:	6a 00                	push   $0x0
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800278:	ba 01 00 00 00       	mov    $0x1,%edx
  80027d:	b8 09 00 00 00       	mov    $0x9,%eax
  800282:	e8 27 fe ff ff       	call   8000ae <syscall>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800289:	f3 0f 1e fb          	endbr32 
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800293:	6a 00                	push   $0x0
  800295:	6a 00                	push   $0x0
  800297:	6a 00                	push   $0x0
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029f:	ba 01 00 00 00       	mov    $0x1,%edx
  8002a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a9:	e8 00 fe ff ff       	call   8000ae <syscall>
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002b0:	f3 0f 1e fb          	endbr32 
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002ba:	6a 00                	push   $0x0
  8002bc:	ff 75 14             	pushl  0x14(%ebp)
  8002bf:	ff 75 10             	pushl  0x10(%ebp)
  8002c2:	ff 75 0c             	pushl  0xc(%ebp)
  8002c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002d2:	e8 d7 fd ff ff       	call   8000ae <syscall>
}
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d9:	f3 0f 1e fb          	endbr32 
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002e3:	6a 00                	push   $0x0
  8002e5:	6a 00                	push   $0x0
  8002e7:	6a 00                	push   $0x0
  8002e9:	6a 00                	push   $0x0
  8002eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ee:	ba 01 00 00 00       	mov    $0x1,%edx
  8002f3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002f8:	e8 b1 fd ff ff       	call   8000ae <syscall>
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002ff:	f3 0f 1e fb          	endbr32 
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	05 00 00 00 30       	add    $0x30000000,%eax
  80030e:	c1 e8 0c             	shr    $0xc,%eax
}
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800313:	f3 0f 1e fb          	endbr32 
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80031d:	ff 75 08             	pushl  0x8(%ebp)
  800320:	e8 da ff ff ff       	call   8002ff <fd2num>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	c1 e0 0c             	shl    $0xc,%eax
  80032b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800332:	f3 0f 1e fb          	endbr32 
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80033e:	89 c2                	mov    %eax,%edx
  800340:	c1 ea 16             	shr    $0x16,%edx
  800343:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80034a:	f6 c2 01             	test   $0x1,%dl
  80034d:	74 2d                	je     80037c <fd_alloc+0x4a>
  80034f:	89 c2                	mov    %eax,%edx
  800351:	c1 ea 0c             	shr    $0xc,%edx
  800354:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80035b:	f6 c2 01             	test   $0x1,%dl
  80035e:	74 1c                	je     80037c <fd_alloc+0x4a>
  800360:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800365:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80036a:	75 d2                	jne    80033e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800375:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80037a:	eb 0a                	jmp    800386 <fd_alloc+0x54>
			*fd_store = fd;
  80037c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800381:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800392:	83 f8 1f             	cmp    $0x1f,%eax
  800395:	77 30                	ja     8003c7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800397:	c1 e0 0c             	shl    $0xc,%eax
  80039a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80039f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003a5:	f6 c2 01             	test   $0x1,%dl
  8003a8:	74 24                	je     8003ce <fd_lookup+0x46>
  8003aa:	89 c2                	mov    %eax,%edx
  8003ac:	c1 ea 0c             	shr    $0xc,%edx
  8003af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b6:	f6 c2 01             	test   $0x1,%dl
  8003b9:	74 1a                	je     8003d5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003be:	89 02                	mov    %eax,(%edx)
	return 0;
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003c5:	5d                   	pop    %ebp
  8003c6:	c3                   	ret    
		return -E_INVAL;
  8003c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003cc:	eb f7                	jmp    8003c5 <fd_lookup+0x3d>
		return -E_INVAL;
  8003ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d3:	eb f0                	jmp    8003c5 <fd_lookup+0x3d>
  8003d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003da:	eb e9                	jmp    8003c5 <fd_lookup+0x3d>

008003dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003dc:	f3 0f 1e fb          	endbr32 
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e9:	ba b4 1e 80 00       	mov    $0x801eb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003ee:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003f3:	39 08                	cmp    %ecx,(%eax)
  8003f5:	74 33                	je     80042a <dev_lookup+0x4e>
  8003f7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8003fa:	8b 02                	mov    (%edx),%eax
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	75 f3                	jne    8003f3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800400:	a1 04 40 80 00       	mov    0x804004,%eax
  800405:	8b 40 48             	mov    0x48(%eax),%eax
  800408:	83 ec 04             	sub    $0x4,%esp
  80040b:	51                   	push   %ecx
  80040c:	50                   	push   %eax
  80040d:	68 38 1e 80 00       	push   $0x801e38
  800412:	e8 57 0d 00 00       	call   80116e <cprintf>
	*dev = 0;
  800417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    
			*dev = devtab[i];
  80042a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80042f:	b8 00 00 00 00       	mov    $0x0,%eax
  800434:	eb f2                	jmp    800428 <dev_lookup+0x4c>

00800436 <fd_close>:
{
  800436:	f3 0f 1e fb          	endbr32 
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	57                   	push   %edi
  80043e:	56                   	push   %esi
  80043f:	53                   	push   %ebx
  800440:	83 ec 28             	sub    $0x28,%esp
  800443:	8b 75 08             	mov    0x8(%ebp),%esi
  800446:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800449:	56                   	push   %esi
  80044a:	e8 b0 fe ff ff       	call   8002ff <fd2num>
  80044f:	83 c4 08             	add    $0x8,%esp
  800452:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	e8 2c ff ff ff       	call   800388 <fd_lookup>
  80045c:	89 c3                	mov    %eax,%ebx
  80045e:	83 c4 10             	add    $0x10,%esp
  800461:	85 c0                	test   %eax,%eax
  800463:	78 05                	js     80046a <fd_close+0x34>
	    || fd != fd2)
  800465:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800468:	74 16                	je     800480 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80046a:	89 f8                	mov    %edi,%eax
  80046c:	84 c0                	test   %al,%al
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
  800473:	0f 44 d8             	cmove  %eax,%ebx
}
  800476:	89 d8                	mov    %ebx,%eax
  800478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047b:	5b                   	pop    %ebx
  80047c:	5e                   	pop    %esi
  80047d:	5f                   	pop    %edi
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800486:	50                   	push   %eax
  800487:	ff 36                	pushl  (%esi)
  800489:	e8 4e ff ff ff       	call   8003dc <dev_lookup>
  80048e:	89 c3                	mov    %eax,%ebx
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 c0                	test   %eax,%eax
  800495:	78 1a                	js     8004b1 <fd_close+0x7b>
		if (dev->dev_close)
  800497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80049d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	74 0b                	je     8004b1 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	56                   	push   %esi
  8004aa:	ff d0                	call   *%eax
  8004ac:	89 c3                	mov    %eax,%ebx
  8004ae:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	56                   	push   %esi
  8004b5:	6a 00                	push   $0x0
  8004b7:	e8 58 fd ff ff       	call   800214 <sys_page_unmap>
	return r;
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	eb b5                	jmp    800476 <fd_close+0x40>

008004c1 <close>:

int
close(int fdnum)
{
  8004c1:	f3 0f 1e fb          	endbr32 
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004ce:	50                   	push   %eax
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	e8 b1 fe ff ff       	call   800388 <fd_lookup>
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	79 02                	jns    8004e0 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    
		return fd_close(fd, 1);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	6a 01                	push   $0x1
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	e8 49 ff ff ff       	call   800436 <fd_close>
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	eb ec                	jmp    8004de <close+0x1d>

008004f2 <close_all>:

void
close_all(void)
{
  8004f2:	f3 0f 1e fb          	endbr32 
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	53                   	push   %ebx
  800506:	e8 b6 ff ff ff       	call   8004c1 <close>
	for (i = 0; i < MAXFD; i++)
  80050b:	83 c3 01             	add    $0x1,%ebx
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	83 fb 20             	cmp    $0x20,%ebx
  800514:	75 ec                	jne    800502 <close_all+0x10>
}
  800516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80051b:	f3 0f 1e fb          	endbr32 
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	53                   	push   %ebx
  800525:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800528:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80052b:	50                   	push   %eax
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 54 fe ff ff       	call   800388 <fd_lookup>
  800534:	89 c3                	mov    %eax,%ebx
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	85 c0                	test   %eax,%eax
  80053b:	0f 88 81 00 00 00    	js     8005c2 <dup+0xa7>
		return r;
	close(newfdnum);
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	ff 75 0c             	pushl  0xc(%ebp)
  800547:	e8 75 ff ff ff       	call   8004c1 <close>

	newfd = INDEX2FD(newfdnum);
  80054c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80054f:	c1 e6 0c             	shl    $0xc,%esi
  800552:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800558:	83 c4 04             	add    $0x4,%esp
  80055b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80055e:	e8 b0 fd ff ff       	call   800313 <fd2data>
  800563:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800565:	89 34 24             	mov    %esi,(%esp)
  800568:	e8 a6 fd ff ff       	call   800313 <fd2data>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800572:	89 d8                	mov    %ebx,%eax
  800574:	c1 e8 16             	shr    $0x16,%eax
  800577:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80057e:	a8 01                	test   $0x1,%al
  800580:	74 11                	je     800593 <dup+0x78>
  800582:	89 d8                	mov    %ebx,%eax
  800584:	c1 e8 0c             	shr    $0xc,%eax
  800587:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80058e:	f6 c2 01             	test   $0x1,%dl
  800591:	75 39                	jne    8005cc <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800593:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	c1 e8 0c             	shr    $0xc,%eax
  80059b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005a2:	83 ec 0c             	sub    $0xc,%esp
  8005a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8005aa:	50                   	push   %eax
  8005ab:	56                   	push   %esi
  8005ac:	6a 00                	push   $0x0
  8005ae:	52                   	push   %edx
  8005af:	6a 00                	push   $0x0
  8005b1:	e8 34 fc ff ff       	call   8001ea <sys_page_map>
  8005b6:	89 c3                	mov    %eax,%ebx
  8005b8:	83 c4 20             	add    $0x20,%esp
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	78 31                	js     8005f0 <dup+0xd5>
		goto err;

	return newfdnum;
  8005bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005c2:	89 d8                	mov    %ebx,%eax
  8005c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005d3:	83 ec 0c             	sub    $0xc,%esp
  8005d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8005db:	50                   	push   %eax
  8005dc:	57                   	push   %edi
  8005dd:	6a 00                	push   $0x0
  8005df:	53                   	push   %ebx
  8005e0:	6a 00                	push   $0x0
  8005e2:	e8 03 fc ff ff       	call   8001ea <sys_page_map>
  8005e7:	89 c3                	mov    %eax,%ebx
  8005e9:	83 c4 20             	add    $0x20,%esp
  8005ec:	85 c0                	test   %eax,%eax
  8005ee:	79 a3                	jns    800593 <dup+0x78>
	sys_page_unmap(0, newfd);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	56                   	push   %esi
  8005f4:	6a 00                	push   $0x0
  8005f6:	e8 19 fc ff ff       	call   800214 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005fb:	83 c4 08             	add    $0x8,%esp
  8005fe:	57                   	push   %edi
  8005ff:	6a 00                	push   $0x0
  800601:	e8 0e fc ff ff       	call   800214 <sys_page_unmap>
	return r;
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	eb b7                	jmp    8005c2 <dup+0xa7>

0080060b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80060b:	f3 0f 1e fb          	endbr32 
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	53                   	push   %ebx
  800613:	83 ec 1c             	sub    $0x1c,%esp
  800616:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800619:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80061c:	50                   	push   %eax
  80061d:	53                   	push   %ebx
  80061e:	e8 65 fd ff ff       	call   800388 <fd_lookup>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	85 c0                	test   %eax,%eax
  800628:	78 3f                	js     800669 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800630:	50                   	push   %eax
  800631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800634:	ff 30                	pushl  (%eax)
  800636:	e8 a1 fd ff ff       	call   8003dc <dev_lookup>
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	85 c0                	test   %eax,%eax
  800640:	78 27                	js     800669 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800642:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800645:	8b 42 08             	mov    0x8(%edx),%eax
  800648:	83 e0 03             	and    $0x3,%eax
  80064b:	83 f8 01             	cmp    $0x1,%eax
  80064e:	74 1e                	je     80066e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800653:	8b 40 08             	mov    0x8(%eax),%eax
  800656:	85 c0                	test   %eax,%eax
  800658:	74 35                	je     80068f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	ff 75 10             	pushl  0x10(%ebp)
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	52                   	push   %edx
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
}
  800669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80066c:	c9                   	leave  
  80066d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80066e:	a1 04 40 80 00       	mov    0x804004,%eax
  800673:	8b 40 48             	mov    0x48(%eax),%eax
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	53                   	push   %ebx
  80067a:	50                   	push   %eax
  80067b:	68 79 1e 80 00       	push   $0x801e79
  800680:	e8 e9 0a 00 00       	call   80116e <cprintf>
		return -E_INVAL;
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80068d:	eb da                	jmp    800669 <read+0x5e>
		return -E_NOT_SUPP;
  80068f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800694:	eb d3                	jmp    800669 <read+0x5e>

00800696 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800696:	f3 0f 1e fb          	endbr32 
  80069a:	55                   	push   %ebp
  80069b:	89 e5                	mov    %esp,%ebp
  80069d:	57                   	push   %edi
  80069e:	56                   	push   %esi
  80069f:	53                   	push   %ebx
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ae:	eb 02                	jmp    8006b2 <readn+0x1c>
  8006b0:	01 c3                	add    %eax,%ebx
  8006b2:	39 f3                	cmp    %esi,%ebx
  8006b4:	73 21                	jae    8006d7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006b6:	83 ec 04             	sub    $0x4,%esp
  8006b9:	89 f0                	mov    %esi,%eax
  8006bb:	29 d8                	sub    %ebx,%eax
  8006bd:	50                   	push   %eax
  8006be:	89 d8                	mov    %ebx,%eax
  8006c0:	03 45 0c             	add    0xc(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	57                   	push   %edi
  8006c5:	e8 41 ff ff ff       	call   80060b <read>
		if (m < 0)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	78 04                	js     8006d5 <readn+0x3f>
			return m;
		if (m == 0)
  8006d1:	75 dd                	jne    8006b0 <readn+0x1a>
  8006d3:	eb 02                	jmp    8006d7 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006d5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006d7:	89 d8                	mov    %ebx,%eax
  8006d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006dc:	5b                   	pop    %ebx
  8006dd:	5e                   	pop    %esi
  8006de:	5f                   	pop    %edi
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006e1:	f3 0f 1e fb          	endbr32 
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	53                   	push   %ebx
  8006e9:	83 ec 1c             	sub    $0x1c,%esp
  8006ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	53                   	push   %ebx
  8006f4:	e8 8f fc ff ff       	call   800388 <fd_lookup>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	78 3a                	js     80073a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070a:	ff 30                	pushl  (%eax)
  80070c:	e8 cb fc ff ff       	call   8003dc <dev_lookup>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	85 c0                	test   %eax,%eax
  800716:	78 22                	js     80073a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80071f:	74 1e                	je     80073f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800724:	8b 52 0c             	mov    0xc(%edx),%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	74 35                	je     800760 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	ff 75 10             	pushl  0x10(%ebp)
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	50                   	push   %eax
  800735:	ff d2                	call   *%edx
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80073f:	a1 04 40 80 00       	mov    0x804004,%eax
  800744:	8b 40 48             	mov    0x48(%eax),%eax
  800747:	83 ec 04             	sub    $0x4,%esp
  80074a:	53                   	push   %ebx
  80074b:	50                   	push   %eax
  80074c:	68 95 1e 80 00       	push   $0x801e95
  800751:	e8 18 0a 00 00       	call   80116e <cprintf>
		return -E_INVAL;
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075e:	eb da                	jmp    80073a <write+0x59>
		return -E_NOT_SUPP;
  800760:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800765:	eb d3                	jmp    80073a <write+0x59>

00800767 <seek>:

int
seek(int fdnum, off_t offset)
{
  800767:	f3 0f 1e fb          	endbr32 
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800774:	50                   	push   %eax
  800775:	ff 75 08             	pushl  0x8(%ebp)
  800778:	e8 0b fc ff ff       	call   800388 <fd_lookup>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	85 c0                	test   %eax,%eax
  800782:	78 0e                	js     800792 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800784:	8b 55 0c             	mov    0xc(%ebp),%edx
  800787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80078d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    

00800794 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800794:	f3 0f 1e fb          	endbr32 
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	53                   	push   %ebx
  80079c:	83 ec 1c             	sub    $0x1c,%esp
  80079f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007a5:	50                   	push   %eax
  8007a6:	53                   	push   %ebx
  8007a7:	e8 dc fb ff ff       	call   800388 <fd_lookup>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	78 37                	js     8007ea <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b9:	50                   	push   %eax
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bd:	ff 30                	pushl  (%eax)
  8007bf:	e8 18 fc ff ff       	call   8003dc <dev_lookup>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	78 1f                	js     8007ea <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007d2:	74 1b                	je     8007ef <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d7:	8b 52 18             	mov    0x18(%edx),%edx
  8007da:	85 d2                	test   %edx,%edx
  8007dc:	74 32                	je     800810 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	50                   	push   %eax
  8007e5:	ff d2                	call   *%edx
  8007e7:	83 c4 10             	add    $0x10,%esp
}
  8007ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007ef:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007f4:	8b 40 48             	mov    0x48(%eax),%eax
  8007f7:	83 ec 04             	sub    $0x4,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	50                   	push   %eax
  8007fc:	68 58 1e 80 00       	push   $0x801e58
  800801:	e8 68 09 00 00       	call   80116e <cprintf>
		return -E_INVAL;
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080e:	eb da                	jmp    8007ea <ftruncate+0x56>
		return -E_NOT_SUPP;
  800810:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800815:	eb d3                	jmp    8007ea <ftruncate+0x56>

00800817 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	53                   	push   %ebx
  80081f:	83 ec 1c             	sub    $0x1c,%esp
  800822:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800825:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800828:	50                   	push   %eax
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 57 fb ff ff       	call   800388 <fd_lookup>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	85 c0                	test   %eax,%eax
  800836:	78 4b                	js     800883 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	ff 30                	pushl  (%eax)
  800844:	e8 93 fb ff ff       	call   8003dc <dev_lookup>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	85 c0                	test   %eax,%eax
  80084e:	78 33                	js     800883 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800853:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800857:	74 2f                	je     800888 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800859:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80085c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800863:	00 00 00 
	stat->st_isdir = 0;
  800866:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80086d:	00 00 00 
	stat->st_dev = dev;
  800870:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	ff 75 f0             	pushl  -0x10(%ebp)
  80087d:	ff 50 14             	call   *0x14(%eax)
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    
		return -E_NOT_SUPP;
  800888:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80088d:	eb f4                	jmp    800883 <fstat+0x6c>

0080088f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	6a 00                	push   $0x0
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 3a 02 00 00       	call   800adf <open>
  8008a5:	89 c3                	mov    %eax,%ebx
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	85 c0                	test   %eax,%eax
  8008ac:	78 1b                	js     8008c9 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	e8 5d ff ff ff       	call   800817 <fstat>
  8008ba:	89 c6                	mov    %eax,%esi
	close(fd);
  8008bc:	89 1c 24             	mov    %ebx,(%esp)
  8008bf:	e8 fd fb ff ff       	call   8004c1 <close>
	return r;
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	89 f3                	mov    %esi,%ebx
}
  8008c9:	89 d8                	mov    %ebx,%eax
  8008cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ce:	5b                   	pop    %ebx
  8008cf:	5e                   	pop    %esi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	56                   	push   %esi
  8008d6:	53                   	push   %ebx
  8008d7:	89 c6                	mov    %eax,%esi
  8008d9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008e2:	74 27                	je     80090b <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008e4:	6a 07                	push   $0x7
  8008e6:	68 00 50 80 00       	push   $0x805000
  8008eb:	56                   	push   %esi
  8008ec:	ff 35 00 40 80 00    	pushl  0x804000
  8008f2:	e8 c2 11 00 00       	call   801ab9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008f7:	83 c4 0c             	add    $0xc,%esp
  8008fa:	6a 00                	push   $0x0
  8008fc:	53                   	push   %ebx
  8008fd:	6a 00                	push   $0x0
  8008ff:	e8 48 11 00 00       	call   801a4c <ipc_recv>
}
  800904:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	6a 01                	push   $0x1
  800910:	e8 fc 11 00 00       	call   801b11 <ipc_find_env>
  800915:	a3 00 40 80 00       	mov    %eax,0x804000
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	eb c5                	jmp    8008e4 <fsipc+0x12>

0080091f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80091f:	f3 0f 1e fb          	endbr32 
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 40 0c             	mov    0xc(%eax),%eax
  80092f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
  800937:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	b8 02 00 00 00       	mov    $0x2,%eax
  800946:	e8 87 ff ff ff       	call   8008d2 <fsipc>
}
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    

0080094d <devfile_flush>:
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 40 0c             	mov    0xc(%eax),%eax
  80095d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	b8 06 00 00 00       	mov    $0x6,%eax
  80096c:	e8 61 ff ff ff       	call   8008d2 <fsipc>
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <devfile_stat>:
{
  800973:	f3 0f 1e fb          	endbr32 
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 04             	sub    $0x4,%esp
  80097e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 40 0c             	mov    0xc(%eax),%eax
  800987:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	b8 05 00 00 00       	mov    $0x5,%eax
  800996:	e8 37 ff ff ff       	call   8008d2 <fsipc>
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 2c                	js     8009cb <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	68 00 50 80 00       	push   $0x805000
  8009a7:	53                   	push   %ebx
  8009a8:	e8 2b 0d 00 00       	call   8016d8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009ad:	a1 80 50 80 00       	mov    0x805080,%eax
  8009b2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009b8:	a1 84 50 80 00       	mov    0x805084,%eax
  8009bd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <devfile_write>:
{
  8009d0:	f3 0f 1e fb          	endbr32 
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	53                   	push   %ebx
  8009d8:	83 ec 04             	sub    $0x4,%esp
  8009db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009e9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009ef:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8009f5:	77 30                	ja     800a27 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8009f7:	83 ec 04             	sub    $0x4,%esp
  8009fa:	53                   	push   %ebx
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	68 08 50 80 00       	push   $0x805008
  800a03:	e8 88 0e 00 00       	call   801890 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	b8 04 00 00 00       	mov    $0x4,%eax
  800a12:	e8 bb fe ff ff       	call   8008d2 <fsipc>
  800a17:	83 c4 10             	add    $0x10,%esp
  800a1a:	85 c0                	test   %eax,%eax
  800a1c:	78 04                	js     800a22 <devfile_write+0x52>
	assert(r <= n);
  800a1e:	39 d8                	cmp    %ebx,%eax
  800a20:	77 1e                	ja     800a40 <devfile_write+0x70>
}
  800a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a27:	68 c4 1e 80 00       	push   $0x801ec4
  800a2c:	68 f1 1e 80 00       	push   $0x801ef1
  800a31:	68 94 00 00 00       	push   $0x94
  800a36:	68 06 1f 80 00       	push   $0x801f06
  800a3b:	e8 47 06 00 00       	call   801087 <_panic>
	assert(r <= n);
  800a40:	68 11 1f 80 00       	push   $0x801f11
  800a45:	68 f1 1e 80 00       	push   $0x801ef1
  800a4a:	68 98 00 00 00       	push   $0x98
  800a4f:	68 06 1f 80 00       	push   $0x801f06
  800a54:	e8 2e 06 00 00       	call   801087 <_panic>

00800a59 <devfile_read>:
{
  800a59:	f3 0f 1e fb          	endbr32 
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 40 0c             	mov    0xc(%eax),%eax
  800a6b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a70:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a80:	e8 4d fe ff ff       	call   8008d2 <fsipc>
  800a85:	89 c3                	mov    %eax,%ebx
  800a87:	85 c0                	test   %eax,%eax
  800a89:	78 1f                	js     800aaa <devfile_read+0x51>
	assert(r <= n);
  800a8b:	39 f0                	cmp    %esi,%eax
  800a8d:	77 24                	ja     800ab3 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a8f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a94:	7f 33                	jg     800ac9 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a96:	83 ec 04             	sub    $0x4,%esp
  800a99:	50                   	push   %eax
  800a9a:	68 00 50 80 00       	push   $0x805000
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	e8 e9 0d 00 00       	call   801890 <memmove>
	return r;
  800aa7:	83 c4 10             	add    $0x10,%esp
}
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    
	assert(r <= n);
  800ab3:	68 11 1f 80 00       	push   $0x801f11
  800ab8:	68 f1 1e 80 00       	push   $0x801ef1
  800abd:	6a 7c                	push   $0x7c
  800abf:	68 06 1f 80 00       	push   $0x801f06
  800ac4:	e8 be 05 00 00       	call   801087 <_panic>
	assert(r <= PGSIZE);
  800ac9:	68 18 1f 80 00       	push   $0x801f18
  800ace:	68 f1 1e 80 00       	push   $0x801ef1
  800ad3:	6a 7d                	push   $0x7d
  800ad5:	68 06 1f 80 00       	push   $0x801f06
  800ada:	e8 a8 05 00 00       	call   801087 <_panic>

00800adf <open>:
{
  800adf:	f3 0f 1e fb          	endbr32 
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	83 ec 1c             	sub    $0x1c,%esp
  800aeb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800aee:	56                   	push   %esi
  800aef:	e8 a1 0b 00 00       	call   801695 <strlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800afc:	7f 6c                	jg     800b6a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800afe:	83 ec 0c             	sub    $0xc,%esp
  800b01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b04:	50                   	push   %eax
  800b05:	e8 28 f8 ff ff       	call   800332 <fd_alloc>
  800b0a:	89 c3                	mov    %eax,%ebx
  800b0c:	83 c4 10             	add    $0x10,%esp
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	78 3c                	js     800b4f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	56                   	push   %esi
  800b17:	68 00 50 80 00       	push   $0x805000
  800b1c:	e8 b7 0b 00 00       	call   8016d8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b31:	e8 9c fd ff ff       	call   8008d2 <fsipc>
  800b36:	89 c3                	mov    %eax,%ebx
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	85 c0                	test   %eax,%eax
  800b3d:	78 19                	js     800b58 <open+0x79>
	return fd2num(fd);
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	ff 75 f4             	pushl  -0xc(%ebp)
  800b45:	e8 b5 f7 ff ff       	call   8002ff <fd2num>
  800b4a:	89 c3                	mov    %eax,%ebx
  800b4c:	83 c4 10             	add    $0x10,%esp
}
  800b4f:	89 d8                	mov    %ebx,%eax
  800b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		fd_close(fd, 0);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	6a 00                	push   $0x0
  800b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b60:	e8 d1 f8 ff ff       	call   800436 <fd_close>
		return r;
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	eb e5                	jmp    800b4f <open+0x70>
		return -E_BAD_PATH;
  800b6a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b6f:	eb de                	jmp    800b4f <open+0x70>

00800b71 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b71:	f3 0f 1e fb          	endbr32 
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	b8 08 00 00 00       	mov    $0x8,%eax
  800b85:	e8 48 fd ff ff       	call   8008d2 <fsipc>
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b8c:	f3 0f 1e fb          	endbr32 
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b98:	83 ec 0c             	sub    $0xc,%esp
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	e8 70 f7 ff ff       	call   800313 <fd2data>
  800ba3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800ba5:	83 c4 08             	add    $0x8,%esp
  800ba8:	68 24 1f 80 00       	push   $0x801f24
  800bad:	53                   	push   %ebx
  800bae:	e8 25 0b 00 00       	call   8016d8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bb3:	8b 46 04             	mov    0x4(%esi),%eax
  800bb6:	2b 06                	sub    (%esi),%eax
  800bb8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bbe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bc5:	00 00 00 
	stat->st_dev = &devpipe;
  800bc8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bcf:	30 80 00 
	return 0;
}
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bda:	5b                   	pop    %ebx
  800bdb:	5e                   	pop    %esi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bde:	f3 0f 1e fb          	endbr32 
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	53                   	push   %ebx
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bec:	53                   	push   %ebx
  800bed:	6a 00                	push   $0x0
  800bef:	e8 20 f6 ff ff       	call   800214 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bf4:	89 1c 24             	mov    %ebx,(%esp)
  800bf7:	e8 17 f7 ff ff       	call   800313 <fd2data>
  800bfc:	83 c4 08             	add    $0x8,%esp
  800bff:	50                   	push   %eax
  800c00:	6a 00                	push   $0x0
  800c02:	e8 0d f6 ff ff       	call   800214 <sys_page_unmap>
}
  800c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <_pipeisclosed>:
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	83 ec 1c             	sub    $0x1c,%esp
  800c15:	89 c7                	mov    %eax,%edi
  800c17:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c19:	a1 04 40 80 00       	mov    0x804004,%eax
  800c1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c21:	83 ec 0c             	sub    $0xc,%esp
  800c24:	57                   	push   %edi
  800c25:	e8 24 0f 00 00       	call   801b4e <pageref>
  800c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2d:	89 34 24             	mov    %esi,(%esp)
  800c30:	e8 19 0f 00 00       	call   801b4e <pageref>
		nn = thisenv->env_runs;
  800c35:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	39 cb                	cmp    %ecx,%ebx
  800c43:	74 1b                	je     800c60 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c45:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c48:	75 cf                	jne    800c19 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c4a:	8b 42 58             	mov    0x58(%edx),%eax
  800c4d:	6a 01                	push   $0x1
  800c4f:	50                   	push   %eax
  800c50:	53                   	push   %ebx
  800c51:	68 2b 1f 80 00       	push   $0x801f2b
  800c56:	e8 13 05 00 00       	call   80116e <cprintf>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	eb b9                	jmp    800c19 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c60:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c63:	0f 94 c0             	sete   %al
  800c66:	0f b6 c0             	movzbl %al,%eax
}
  800c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <devpipe_write>:
{
  800c71:	f3 0f 1e fb          	endbr32 
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 28             	sub    $0x28,%esp
  800c7e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c81:	56                   	push   %esi
  800c82:	e8 8c f6 ff ff       	call   800313 <fd2data>
  800c87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c89:	83 c4 10             	add    $0x10,%esp
  800c8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c91:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c94:	74 4f                	je     800ce5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c96:	8b 43 04             	mov    0x4(%ebx),%eax
  800c99:	8b 0b                	mov    (%ebx),%ecx
  800c9b:	8d 51 20             	lea    0x20(%ecx),%edx
  800c9e:	39 d0                	cmp    %edx,%eax
  800ca0:	72 14                	jb     800cb6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800ca2:	89 da                	mov    %ebx,%edx
  800ca4:	89 f0                	mov    %esi,%eax
  800ca6:	e8 61 ff ff ff       	call   800c0c <_pipeisclosed>
  800cab:	85 c0                	test   %eax,%eax
  800cad:	75 3b                	jne    800cea <devpipe_write+0x79>
			sys_yield();
  800caf:	e8 e3 f4 ff ff       	call   800197 <sys_yield>
  800cb4:	eb e0                	jmp    800c96 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cbd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc0:	89 c2                	mov    %eax,%edx
  800cc2:	c1 fa 1f             	sar    $0x1f,%edx
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	c1 e9 1b             	shr    $0x1b,%ecx
  800cca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ccd:	83 e2 1f             	and    $0x1f,%edx
  800cd0:	29 ca                	sub    %ecx,%edx
  800cd2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cda:	83 c0 01             	add    $0x1,%eax
  800cdd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce0:	83 c7 01             	add    $0x1,%edi
  800ce3:	eb ac                	jmp    800c91 <devpipe_write+0x20>
	return i;
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	eb 05                	jmp    800cef <devpipe_write+0x7e>
				return 0;
  800cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <devpipe_read>:
{
  800cf7:	f3 0f 1e fb          	endbr32 
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	83 ec 18             	sub    $0x18,%esp
  800d04:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d07:	57                   	push   %edi
  800d08:	e8 06 f6 ff ff       	call   800313 <fd2data>
  800d0d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	be 00 00 00 00       	mov    $0x0,%esi
  800d17:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d1a:	75 14                	jne    800d30 <devpipe_read+0x39>
	return i;
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	eb 02                	jmp    800d23 <devpipe_read+0x2c>
				return i;
  800d21:	89 f0                	mov    %esi,%eax
}
  800d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    
			sys_yield();
  800d2b:	e8 67 f4 ff ff       	call   800197 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d30:	8b 03                	mov    (%ebx),%eax
  800d32:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d35:	75 18                	jne    800d4f <devpipe_read+0x58>
			if (i > 0)
  800d37:	85 f6                	test   %esi,%esi
  800d39:	75 e6                	jne    800d21 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d3b:	89 da                	mov    %ebx,%edx
  800d3d:	89 f8                	mov    %edi,%eax
  800d3f:	e8 c8 fe ff ff       	call   800c0c <_pipeisclosed>
  800d44:	85 c0                	test   %eax,%eax
  800d46:	74 e3                	je     800d2b <devpipe_read+0x34>
				return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb d4                	jmp    800d23 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4f:	99                   	cltd   
  800d50:	c1 ea 1b             	shr    $0x1b,%edx
  800d53:	01 d0                	add    %edx,%eax
  800d55:	83 e0 1f             	and    $0x1f,%eax
  800d58:	29 d0                	sub    %edx,%eax
  800d5a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d65:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d68:	83 c6 01             	add    $0x1,%esi
  800d6b:	eb aa                	jmp    800d17 <devpipe_read+0x20>

00800d6d <pipe>:
{
  800d6d:	f3 0f 1e fb          	endbr32 
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d7c:	50                   	push   %eax
  800d7d:	e8 b0 f5 ff ff       	call   800332 <fd_alloc>
  800d82:	89 c3                	mov    %eax,%ebx
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	85 c0                	test   %eax,%eax
  800d89:	0f 88 23 01 00 00    	js     800eb2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8f:	83 ec 04             	sub    $0x4,%esp
  800d92:	68 07 04 00 00       	push   $0x407
  800d97:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9a:	6a 00                	push   $0x0
  800d9c:	e8 21 f4 ff ff       	call   8001c2 <sys_page_alloc>
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	85 c0                	test   %eax,%eax
  800da8:	0f 88 04 01 00 00    	js     800eb2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db4:	50                   	push   %eax
  800db5:	e8 78 f5 ff ff       	call   800332 <fd_alloc>
  800dba:	89 c3                	mov    %eax,%ebx
  800dbc:	83 c4 10             	add    $0x10,%esp
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	0f 88 db 00 00 00    	js     800ea2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc7:	83 ec 04             	sub    $0x4,%esp
  800dca:	68 07 04 00 00       	push   $0x407
  800dcf:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd2:	6a 00                	push   $0x0
  800dd4:	e8 e9 f3 ff ff       	call   8001c2 <sys_page_alloc>
  800dd9:	89 c3                	mov    %eax,%ebx
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	85 c0                	test   %eax,%eax
  800de0:	0f 88 bc 00 00 00    	js     800ea2 <pipe+0x135>
	va = fd2data(fd0);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dec:	e8 22 f5 ff ff       	call   800313 <fd2data>
  800df1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df3:	83 c4 0c             	add    $0xc,%esp
  800df6:	68 07 04 00 00       	push   $0x407
  800dfb:	50                   	push   %eax
  800dfc:	6a 00                	push   $0x0
  800dfe:	e8 bf f3 ff ff       	call   8001c2 <sys_page_alloc>
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	0f 88 82 00 00 00    	js     800e92 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	ff 75 f0             	pushl  -0x10(%ebp)
  800e16:	e8 f8 f4 ff ff       	call   800313 <fd2data>
  800e1b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e22:	50                   	push   %eax
  800e23:	6a 00                	push   $0x0
  800e25:	56                   	push   %esi
  800e26:	6a 00                	push   $0x0
  800e28:	e8 bd f3 ff ff       	call   8001ea <sys_page_map>
  800e2d:	89 c3                	mov    %eax,%ebx
  800e2f:	83 c4 20             	add    $0x20,%esp
  800e32:	85 c0                	test   %eax,%eax
  800e34:	78 4e                	js     800e84 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e36:	a1 20 30 80 00       	mov    0x803020,%eax
  800e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e43:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e4d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e52:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5f:	e8 9b f4 ff ff       	call   8002ff <fd2num>
  800e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e67:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e69:	83 c4 04             	add    $0x4,%esp
  800e6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6f:	e8 8b f4 ff ff       	call   8002ff <fd2num>
  800e74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e77:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e7a:	83 c4 10             	add    $0x10,%esp
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e82:	eb 2e                	jmp    800eb2 <pipe+0x145>
	sys_page_unmap(0, va);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	56                   	push   %esi
  800e88:	6a 00                	push   $0x0
  800e8a:	e8 85 f3 ff ff       	call   800214 <sys_page_unmap>
  800e8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 f0             	pushl  -0x10(%ebp)
  800e98:	6a 00                	push   $0x0
  800e9a:	e8 75 f3 ff ff       	call   800214 <sys_page_unmap>
  800e9f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea8:	6a 00                	push   $0x0
  800eaa:	e8 65 f3 ff ff       	call   800214 <sys_page_unmap>
  800eaf:	83 c4 10             	add    $0x10,%esp
}
  800eb2:	89 d8                	mov    %ebx,%eax
  800eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <pipeisclosed>:
{
  800ebb:	f3 0f 1e fb          	endbr32 
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec8:	50                   	push   %eax
  800ec9:	ff 75 08             	pushl  0x8(%ebp)
  800ecc:	e8 b7 f4 ff ff       	call   800388 <fd_lookup>
  800ed1:	83 c4 10             	add    $0x10,%esp
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	78 18                	js     800ef0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ede:	e8 30 f4 ff ff       	call   800313 <fd2data>
  800ee3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee8:	e8 1f fd ff ff       	call   800c0c <_pipeisclosed>
  800eed:	83 c4 10             	add    $0x10,%esp
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800ef2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  800efb:	c3                   	ret    

00800efc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800efc:	f3 0f 1e fb          	endbr32 
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f06:	68 43 1f 80 00       	push   $0x801f43
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	e8 c5 07 00 00       	call   8016d8 <strcpy>
	return 0;
}
  800f13:	b8 00 00 00 00       	mov    $0x0,%eax
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <devcons_write>:
{
  800f1a:	f3 0f 1e fb          	endbr32 
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f2a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f2f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f35:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f38:	73 31                	jae    800f6b <devcons_write+0x51>
		m = n - tot;
  800f3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3d:	29 f3                	sub    %esi,%ebx
  800f3f:	83 fb 7f             	cmp    $0x7f,%ebx
  800f42:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f47:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	53                   	push   %ebx
  800f4e:	89 f0                	mov    %esi,%eax
  800f50:	03 45 0c             	add    0xc(%ebp),%eax
  800f53:	50                   	push   %eax
  800f54:	57                   	push   %edi
  800f55:	e8 36 09 00 00       	call   801890 <memmove>
		sys_cputs(buf, m);
  800f5a:	83 c4 08             	add    $0x8,%esp
  800f5d:	53                   	push   %ebx
  800f5e:	57                   	push   %edi
  800f5f:	e8 93 f1 ff ff       	call   8000f7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f64:	01 de                	add    %ebx,%esi
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	eb ca                	jmp    800f35 <devcons_write+0x1b>
}
  800f6b:	89 f0                	mov    %esi,%eax
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <devcons_read>:
{
  800f75:	f3 0f 1e fb          	endbr32 
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	74 21                	je     800fab <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f8a:	e8 92 f1 ff ff       	call   800121 <sys_cgetc>
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 07                	jne    800f9a <devcons_read+0x25>
		sys_yield();
  800f93:	e8 ff f1 ff ff       	call   800197 <sys_yield>
  800f98:	eb f0                	jmp    800f8a <devcons_read+0x15>
	if (c < 0)
  800f9a:	78 0f                	js     800fab <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800f9c:	83 f8 04             	cmp    $0x4,%eax
  800f9f:	74 0c                	je     800fad <devcons_read+0x38>
	*(char*)vbuf = c;
  800fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa4:	88 02                	mov    %al,(%edx)
	return 1;
  800fa6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    
		return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	eb f7                	jmp    800fab <devcons_read+0x36>

00800fb4 <cputchar>:
{
  800fb4:	f3 0f 1e fb          	endbr32 
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fc4:	6a 01                	push   $0x1
  800fc6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fc9:	50                   	push   %eax
  800fca:	e8 28 f1 ff ff       	call   8000f7 <sys_cputs>
}
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <getchar>:
{
  800fd4:	f3 0f 1e fb          	endbr32 
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fde:	6a 01                	push   $0x1
  800fe0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	6a 00                	push   $0x0
  800fe6:	e8 20 f6 ff ff       	call   80060b <read>
	if (r < 0)
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	78 06                	js     800ff8 <getchar+0x24>
	if (r < 1)
  800ff2:	74 06                	je     800ffa <getchar+0x26>
	return c;
  800ff4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    
		return -E_EOF;
  800ffa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800fff:	eb f7                	jmp    800ff8 <getchar+0x24>

00801001 <iscons>:
{
  801001:	f3 0f 1e fb          	endbr32 
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80100b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80100e:	50                   	push   %eax
  80100f:	ff 75 08             	pushl  0x8(%ebp)
  801012:	e8 71 f3 ff ff       	call   800388 <fd_lookup>
  801017:	83 c4 10             	add    $0x10,%esp
  80101a:	85 c0                	test   %eax,%eax
  80101c:	78 11                	js     80102f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80101e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801021:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801027:	39 10                	cmp    %edx,(%eax)
  801029:	0f 94 c0             	sete   %al
  80102c:	0f b6 c0             	movzbl %al,%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <opencons>:
{
  801031:	f3 0f 1e fb          	endbr32 
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80103b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80103e:	50                   	push   %eax
  80103f:	e8 ee f2 ff ff       	call   800332 <fd_alloc>
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 3a                	js     801085 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80104b:	83 ec 04             	sub    $0x4,%esp
  80104e:	68 07 04 00 00       	push   $0x407
  801053:	ff 75 f4             	pushl  -0xc(%ebp)
  801056:	6a 00                	push   $0x0
  801058:	e8 65 f1 ff ff       	call   8001c2 <sys_page_alloc>
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	78 21                	js     801085 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80106d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80106f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801072:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	e8 7d f2 ff ff       	call   8002ff <fd2num>
  801082:	83 c4 10             	add    $0x10,%esp
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801087:	f3 0f 1e fb          	endbr32 
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801090:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801093:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801099:	e8 d1 f0 ff ff       	call   80016f <sys_getenvid>
  80109e:	83 ec 0c             	sub    $0xc,%esp
  8010a1:	ff 75 0c             	pushl  0xc(%ebp)
  8010a4:	ff 75 08             	pushl  0x8(%ebp)
  8010a7:	56                   	push   %esi
  8010a8:	50                   	push   %eax
  8010a9:	68 50 1f 80 00       	push   $0x801f50
  8010ae:	e8 bb 00 00 00       	call   80116e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010b3:	83 c4 18             	add    $0x18,%esp
  8010b6:	53                   	push   %ebx
  8010b7:	ff 75 10             	pushl  0x10(%ebp)
  8010ba:	e8 5a 00 00 00       	call   801119 <vcprintf>
	cprintf("\n");
  8010bf:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010c6:	e8 a3 00 00 00       	call   80116e <cprintf>
  8010cb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010ce:	cc                   	int3   
  8010cf:	eb fd                	jmp    8010ce <_panic+0x47>

008010d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010d1:	f3 0f 1e fb          	endbr32 
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010df:	8b 13                	mov    (%ebx),%edx
  8010e1:	8d 42 01             	lea    0x1(%edx),%eax
  8010e4:	89 03                	mov    %eax,(%ebx)
  8010e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010f2:	74 09                	je     8010fd <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8010f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	68 ff 00 00 00       	push   $0xff
  801105:	8d 43 08             	lea    0x8(%ebx),%eax
  801108:	50                   	push   %eax
  801109:	e8 e9 ef ff ff       	call   8000f7 <sys_cputs>
		b->idx = 0;
  80110e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	eb db                	jmp    8010f4 <putch+0x23>

00801119 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801119:	f3 0f 1e fb          	endbr32 
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801126:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80112d:	00 00 00 
	b.cnt = 0;
  801130:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801137:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	68 d1 10 80 00       	push   $0x8010d1
  80114c:	e8 80 01 00 00       	call   8012d1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801151:	83 c4 08             	add    $0x8,%esp
  801154:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80115a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	e8 91 ef ff ff       	call   8000f7 <sys_cputs>

	return b.cnt;
}
  801166:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    

0080116e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80116e:	f3 0f 1e fb          	endbr32 
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801178:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80117b:	50                   	push   %eax
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 95 ff ff ff       	call   801119 <vcprintf>
	va_end(ap);

	return cnt;
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	57                   	push   %edi
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	83 ec 1c             	sub    $0x1c,%esp
  80118f:	89 c7                	mov    %eax,%edi
  801191:	89 d6                	mov    %edx,%esi
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8b 55 0c             	mov    0xc(%ebp),%edx
  801199:	89 d1                	mov    %edx,%ecx
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011b3:	39 c2                	cmp    %eax,%edx
  8011b5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011b8:	72 3e                	jb     8011f8 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 18             	pushl  0x18(%ebp)
  8011c0:	83 eb 01             	sub    $0x1,%ebx
  8011c3:	53                   	push   %ebx
  8011c4:	50                   	push   %eax
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8011ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8011d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8011d4:	e8 b7 09 00 00       	call   801b90 <__udivdi3>
  8011d9:	83 c4 18             	add    $0x18,%esp
  8011dc:	52                   	push   %edx
  8011dd:	50                   	push   %eax
  8011de:	89 f2                	mov    %esi,%edx
  8011e0:	89 f8                	mov    %edi,%eax
  8011e2:	e8 9f ff ff ff       	call   801186 <printnum>
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	eb 13                	jmp    8011ff <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	56                   	push   %esi
  8011f0:	ff 75 18             	pushl  0x18(%ebp)
  8011f3:	ff d7                	call   *%edi
  8011f5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8011f8:	83 eb 01             	sub    $0x1,%ebx
  8011fb:	85 db                	test   %ebx,%ebx
  8011fd:	7f ed                	jg     8011ec <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	56                   	push   %esi
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	ff 75 e4             	pushl  -0x1c(%ebp)
  801209:	ff 75 e0             	pushl  -0x20(%ebp)
  80120c:	ff 75 dc             	pushl  -0x24(%ebp)
  80120f:	ff 75 d8             	pushl  -0x28(%ebp)
  801212:	e8 89 0a 00 00       	call   801ca0 <__umoddi3>
  801217:	83 c4 14             	add    $0x14,%esp
  80121a:	0f be 80 73 1f 80 00 	movsbl 0x801f73(%eax),%eax
  801221:	50                   	push   %eax
  801222:	ff d7                	call   *%edi
}
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122a:	5b                   	pop    %ebx
  80122b:	5e                   	pop    %esi
  80122c:	5f                   	pop    %edi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80122f:	83 fa 01             	cmp    $0x1,%edx
  801232:	7f 13                	jg     801247 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801234:	85 d2                	test   %edx,%edx
  801236:	74 1c                	je     801254 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801238:	8b 10                	mov    (%eax),%edx
  80123a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80123d:	89 08                	mov    %ecx,(%eax)
  80123f:	8b 02                	mov    (%edx),%eax
  801241:	ba 00 00 00 00       	mov    $0x0,%edx
  801246:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801247:	8b 10                	mov    (%eax),%edx
  801249:	8d 4a 08             	lea    0x8(%edx),%ecx
  80124c:	89 08                	mov    %ecx,(%eax)
  80124e:	8b 02                	mov    (%edx),%eax
  801250:	8b 52 04             	mov    0x4(%edx),%edx
  801253:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801254:	8b 10                	mov    (%eax),%edx
  801256:	8d 4a 04             	lea    0x4(%edx),%ecx
  801259:	89 08                	mov    %ecx,(%eax)
  80125b:	8b 02                	mov    (%edx),%eax
  80125d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801262:	c3                   	ret    

00801263 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801263:	83 fa 01             	cmp    $0x1,%edx
  801266:	7f 0f                	jg     801277 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801268:	85 d2                	test   %edx,%edx
  80126a:	74 18                	je     801284 <getint+0x21>
		return va_arg(*ap, long);
  80126c:	8b 10                	mov    (%eax),%edx
  80126e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801271:	89 08                	mov    %ecx,(%eax)
  801273:	8b 02                	mov    (%edx),%eax
  801275:	99                   	cltd   
  801276:	c3                   	ret    
		return va_arg(*ap, long long);
  801277:	8b 10                	mov    (%eax),%edx
  801279:	8d 4a 08             	lea    0x8(%edx),%ecx
  80127c:	89 08                	mov    %ecx,(%eax)
  80127e:	8b 02                	mov    (%edx),%eax
  801280:	8b 52 04             	mov    0x4(%edx),%edx
  801283:	c3                   	ret    
	else
		return va_arg(*ap, int);
  801284:	8b 10                	mov    (%eax),%edx
  801286:	8d 4a 04             	lea    0x4(%edx),%ecx
  801289:	89 08                	mov    %ecx,(%eax)
  80128b:	8b 02                	mov    (%edx),%eax
  80128d:	99                   	cltd   
}
  80128e:	c3                   	ret    

0080128f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80128f:	f3 0f 1e fb          	endbr32 
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801299:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80129d:	8b 10                	mov    (%eax),%edx
  80129f:	3b 50 04             	cmp    0x4(%eax),%edx
  8012a2:	73 0a                	jae    8012ae <sprintputch+0x1f>
		*b->buf++ = ch;
  8012a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a7:	89 08                	mov    %ecx,(%eax)
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	88 02                	mov    %al,(%edx)
}
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <printfmt>:
{
  8012b0:	f3 0f 1e fb          	endbr32 
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012ba:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012bd:	50                   	push   %eax
  8012be:	ff 75 10             	pushl  0x10(%ebp)
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	e8 05 00 00 00       	call   8012d1 <vprintfmt>
}
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <vprintfmt>:
{
  8012d1:	f3 0f 1e fb          	endbr32 
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 2c             	sub    $0x2c,%esp
  8012de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012e7:	e9 86 02 00 00       	jmp    801572 <vprintfmt+0x2a1>
		padc = ' ';
  8012ec:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80130a:	8d 47 01             	lea    0x1(%edi),%eax
  80130d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801310:	0f b6 17             	movzbl (%edi),%edx
  801313:	8d 42 dd             	lea    -0x23(%edx),%eax
  801316:	3c 55                	cmp    $0x55,%al
  801318:	0f 87 df 02 00 00    	ja     8015fd <vprintfmt+0x32c>
  80131e:	0f b6 c0             	movzbl %al,%eax
  801321:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801328:	00 
  801329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80132c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801330:	eb d8                	jmp    80130a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801335:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801339:	eb cf                	jmp    80130a <vprintfmt+0x39>
  80133b:	0f b6 d2             	movzbl %dl,%edx
  80133e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
  801346:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80134c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801350:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801353:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801356:	83 f9 09             	cmp    $0x9,%ecx
  801359:	77 52                	ja     8013ad <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  80135b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80135e:	eb e9                	jmp    801349 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	8d 50 04             	lea    0x4(%eax),%edx
  801366:	89 55 14             	mov    %edx,0x14(%ebp)
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80136e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801371:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801375:	79 93                	jns    80130a <vprintfmt+0x39>
				width = precision, precision = -1;
  801377:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80137a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80137d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801384:	eb 84                	jmp    80130a <vprintfmt+0x39>
  801386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801389:	85 c0                	test   %eax,%eax
  80138b:	ba 00 00 00 00       	mov    $0x0,%edx
  801390:	0f 49 d0             	cmovns %eax,%edx
  801393:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801399:	e9 6c ff ff ff       	jmp    80130a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80139e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013a1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013a8:	e9 5d ff ff ff       	jmp    80130a <vprintfmt+0x39>
  8013ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013b3:	eb bc                	jmp    801371 <vprintfmt+0xa0>
			lflag++;
  8013b5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013bb:	e9 4a ff ff ff       	jmp    80130a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c3:	8d 50 04             	lea    0x4(%eax),%edx
  8013c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8013c9:	83 ec 08             	sub    $0x8,%esp
  8013cc:	56                   	push   %esi
  8013cd:	ff 30                	pushl  (%eax)
  8013cf:	ff d3                	call   *%ebx
			break;
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	e9 96 01 00 00       	jmp    80156f <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013dc:	8d 50 04             	lea    0x4(%eax),%edx
  8013df:	89 55 14             	mov    %edx,0x14(%ebp)
  8013e2:	8b 00                	mov    (%eax),%eax
  8013e4:	99                   	cltd   
  8013e5:	31 d0                	xor    %edx,%eax
  8013e7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013e9:	83 f8 0f             	cmp    $0xf,%eax
  8013ec:	7f 20                	jg     80140e <vprintfmt+0x13d>
  8013ee:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	74 15                	je     80140e <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8013f9:	52                   	push   %edx
  8013fa:	68 03 1f 80 00       	push   $0x801f03
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
  801401:	e8 aa fe ff ff       	call   8012b0 <printfmt>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	e9 61 01 00 00       	jmp    80156f <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80140e:	50                   	push   %eax
  80140f:	68 8b 1f 80 00       	push   $0x801f8b
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	e8 95 fe ff ff       	call   8012b0 <printfmt>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	e9 4c 01 00 00       	jmp    80156f <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  801423:	8b 45 14             	mov    0x14(%ebp),%eax
  801426:	8d 50 04             	lea    0x4(%eax),%edx
  801429:	89 55 14             	mov    %edx,0x14(%ebp)
  80142c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80142e:	85 c9                	test   %ecx,%ecx
  801430:	b8 84 1f 80 00       	mov    $0x801f84,%eax
  801435:	0f 45 c1             	cmovne %ecx,%eax
  801438:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80143b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80143f:	7e 06                	jle    801447 <vprintfmt+0x176>
  801441:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801445:	75 0d                	jne    801454 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80144a:	89 c7                	mov    %eax,%edi
  80144c:	03 45 e0             	add    -0x20(%ebp),%eax
  80144f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801452:	eb 57                	jmp    8014ab <vprintfmt+0x1da>
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	ff 75 d8             	pushl  -0x28(%ebp)
  80145a:	ff 75 cc             	pushl  -0x34(%ebp)
  80145d:	e8 4f 02 00 00       	call   8016b1 <strnlen>
  801462:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801465:	29 c2                	sub    %eax,%edx
  801467:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80146a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80146d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801471:	89 5d 08             	mov    %ebx,0x8(%ebp)
  801474:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  801476:	85 db                	test   %ebx,%ebx
  801478:	7e 10                	jle    80148a <vprintfmt+0x1b9>
					putch(padc, putdat);
  80147a:	83 ec 08             	sub    $0x8,%esp
  80147d:	56                   	push   %esi
  80147e:	57                   	push   %edi
  80147f:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801482:	83 eb 01             	sub    $0x1,%ebx
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	eb ec                	jmp    801476 <vprintfmt+0x1a5>
  80148a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80148d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	b8 00 00 00 00       	mov    $0x0,%eax
  801497:	0f 49 c2             	cmovns %edx,%eax
  80149a:	29 c2                	sub    %eax,%edx
  80149c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80149f:	eb a6                	jmp    801447 <vprintfmt+0x176>
					putch(ch, putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	56                   	push   %esi
  8014a5:	52                   	push   %edx
  8014a6:	ff d3                	call   *%ebx
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014ae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014b0:	83 c7 01             	add    $0x1,%edi
  8014b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014b7:	0f be d0             	movsbl %al,%edx
  8014ba:	85 d2                	test   %edx,%edx
  8014bc:	74 42                	je     801500 <vprintfmt+0x22f>
  8014be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c2:	78 06                	js     8014ca <vprintfmt+0x1f9>
  8014c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c8:	78 1e                	js     8014e8 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ce:	74 d1                	je     8014a1 <vprintfmt+0x1d0>
  8014d0:	0f be c0             	movsbl %al,%eax
  8014d3:	83 e8 20             	sub    $0x20,%eax
  8014d6:	83 f8 5e             	cmp    $0x5e,%eax
  8014d9:	76 c6                	jbe    8014a1 <vprintfmt+0x1d0>
					putch('?', putdat);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	56                   	push   %esi
  8014df:	6a 3f                	push   $0x3f
  8014e1:	ff d3                	call   *%ebx
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	eb c3                	jmp    8014ab <vprintfmt+0x1da>
  8014e8:	89 cf                	mov    %ecx,%edi
  8014ea:	eb 0e                	jmp    8014fa <vprintfmt+0x229>
				putch(' ', putdat);
  8014ec:	83 ec 08             	sub    $0x8,%esp
  8014ef:	56                   	push   %esi
  8014f0:	6a 20                	push   $0x20
  8014f2:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8014f4:	83 ef 01             	sub    $0x1,%edi
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 ff                	test   %edi,%edi
  8014fc:	7f ee                	jg     8014ec <vprintfmt+0x21b>
  8014fe:	eb 6f                	jmp    80156f <vprintfmt+0x29e>
  801500:	89 cf                	mov    %ecx,%edi
  801502:	eb f6                	jmp    8014fa <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801504:	89 ca                	mov    %ecx,%edx
  801506:	8d 45 14             	lea    0x14(%ebp),%eax
  801509:	e8 55 fd ff ff       	call   801263 <getint>
  80150e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801511:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801514:	85 d2                	test   %edx,%edx
  801516:	78 0b                	js     801523 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801518:	89 d1                	mov    %edx,%ecx
  80151a:	89 c2                	mov    %eax,%edx
			base = 10;
  80151c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801521:	eb 32                	jmp    801555 <vprintfmt+0x284>
				putch('-', putdat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	56                   	push   %esi
  801527:	6a 2d                	push   $0x2d
  801529:	ff d3                	call   *%ebx
				num = -(long long) num;
  80152b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80152e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801531:	f7 da                	neg    %edx
  801533:	83 d1 00             	adc    $0x0,%ecx
  801536:	f7 d9                	neg    %ecx
  801538:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80153b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801540:	eb 13                	jmp    801555 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801542:	89 ca                	mov    %ecx,%edx
  801544:	8d 45 14             	lea    0x14(%ebp),%eax
  801547:	e8 e3 fc ff ff       	call   80122f <getuint>
  80154c:	89 d1                	mov    %edx,%ecx
  80154e:	89 c2                	mov    %eax,%edx
			base = 10;
  801550:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80155c:	57                   	push   %edi
  80155d:	ff 75 e0             	pushl  -0x20(%ebp)
  801560:	50                   	push   %eax
  801561:	51                   	push   %ecx
  801562:	52                   	push   %edx
  801563:	89 f2                	mov    %esi,%edx
  801565:	89 d8                	mov    %ebx,%eax
  801567:	e8 1a fc ff ff       	call   801186 <printnum>
			break;
  80156c:	83 c4 20             	add    $0x20,%esp
{
  80156f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801572:	83 c7 01             	add    $0x1,%edi
  801575:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801579:	83 f8 25             	cmp    $0x25,%eax
  80157c:	0f 84 6a fd ff ff    	je     8012ec <vprintfmt+0x1b>
			if (ch == '\0')
  801582:	85 c0                	test   %eax,%eax
  801584:	0f 84 93 00 00 00    	je     80161d <vprintfmt+0x34c>
			putch(ch, putdat);
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	56                   	push   %esi
  80158e:	50                   	push   %eax
  80158f:	ff d3                	call   *%ebx
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	eb dc                	jmp    801572 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  801596:	89 ca                	mov    %ecx,%edx
  801598:	8d 45 14             	lea    0x14(%ebp),%eax
  80159b:	e8 8f fc ff ff       	call   80122f <getuint>
  8015a0:	89 d1                	mov    %edx,%ecx
  8015a2:	89 c2                	mov    %eax,%edx
			base = 8;
  8015a4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015a9:	eb aa                	jmp    801555 <vprintfmt+0x284>
			putch('0', putdat);
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	56                   	push   %esi
  8015af:	6a 30                	push   $0x30
  8015b1:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015b3:	83 c4 08             	add    $0x8,%esp
  8015b6:	56                   	push   %esi
  8015b7:	6a 78                	push   $0x78
  8015b9:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015be:	8d 50 04             	lea    0x4(%eax),%edx
  8015c1:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015c4:	8b 10                	mov    (%eax),%edx
  8015c6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015cb:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015ce:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015d3:	eb 80                	jmp    801555 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015d5:	89 ca                	mov    %ecx,%edx
  8015d7:	8d 45 14             	lea    0x14(%ebp),%eax
  8015da:	e8 50 fc ff ff       	call   80122f <getuint>
  8015df:	89 d1                	mov    %edx,%ecx
  8015e1:	89 c2                	mov    %eax,%edx
			base = 16;
  8015e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8015e8:	e9 68 ff ff ff       	jmp    801555 <vprintfmt+0x284>
			putch(ch, putdat);
  8015ed:	83 ec 08             	sub    $0x8,%esp
  8015f0:	56                   	push   %esi
  8015f1:	6a 25                	push   $0x25
  8015f3:	ff d3                	call   *%ebx
			break;
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	e9 72 ff ff ff       	jmp    80156f <vprintfmt+0x29e>
			putch('%', putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	56                   	push   %esi
  801601:	6a 25                	push   $0x25
  801603:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	89 f8                	mov    %edi,%eax
  80160a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80160e:	74 05                	je     801615 <vprintfmt+0x344>
  801610:	83 e8 01             	sub    $0x1,%eax
  801613:	eb f5                	jmp    80160a <vprintfmt+0x339>
  801615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801618:	e9 52 ff ff ff       	jmp    80156f <vprintfmt+0x29e>
}
  80161d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801620:	5b                   	pop    %ebx
  801621:	5e                   	pop    %esi
  801622:	5f                   	pop    %edi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801625:	f3 0f 1e fb          	endbr32 
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 18             	sub    $0x18,%esp
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801635:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801638:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80163c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801646:	85 c0                	test   %eax,%eax
  801648:	74 26                	je     801670 <vsnprintf+0x4b>
  80164a:	85 d2                	test   %edx,%edx
  80164c:	7e 22                	jle    801670 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80164e:	ff 75 14             	pushl  0x14(%ebp)
  801651:	ff 75 10             	pushl  0x10(%ebp)
  801654:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	68 8f 12 80 00       	push   $0x80128f
  80165d:	e8 6f fc ff ff       	call   8012d1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801665:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166b:	83 c4 10             	add    $0x10,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    
		return -E_INVAL;
  801670:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801675:	eb f7                	jmp    80166e <vsnprintf+0x49>

00801677 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801677:	f3 0f 1e fb          	endbr32 
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801681:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801684:	50                   	push   %eax
  801685:	ff 75 10             	pushl  0x10(%ebp)
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 92 ff ff ff       	call   801625 <vsnprintf>
	va_end(ap);

	return rc;
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801695:	f3 0f 1e fb          	endbr32 
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016a8:	74 05                	je     8016af <strlen+0x1a>
		n++;
  8016aa:	83 c0 01             	add    $0x1,%eax
  8016ad:	eb f5                	jmp    8016a4 <strlen+0xf>
	return n;
}
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016b1:	f3 0f 1e fb          	endbr32 
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c3:	39 d0                	cmp    %edx,%eax
  8016c5:	74 0d                	je     8016d4 <strnlen+0x23>
  8016c7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016cb:	74 05                	je     8016d2 <strnlen+0x21>
		n++;
  8016cd:	83 c0 01             	add    $0x1,%eax
  8016d0:	eb f1                	jmp    8016c3 <strnlen+0x12>
  8016d2:	89 c2                	mov    %eax,%edx
	return n;
}
  8016d4:	89 d0                	mov    %edx,%eax
  8016d6:	5d                   	pop    %ebp
  8016d7:	c3                   	ret    

008016d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d8:	f3 0f 1e fb          	endbr32 
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	53                   	push   %ebx
  8016e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016ef:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016f2:	83 c0 01             	add    $0x1,%eax
  8016f5:	84 d2                	test   %dl,%dl
  8016f7:	75 f2                	jne    8016eb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8016f9:	89 c8                	mov    %ecx,%eax
  8016fb:	5b                   	pop    %ebx
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	53                   	push   %ebx
  801706:	83 ec 10             	sub    $0x10,%esp
  801709:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80170c:	53                   	push   %ebx
  80170d:	e8 83 ff ff ff       	call   801695 <strlen>
  801712:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	01 d8                	add    %ebx,%eax
  80171a:	50                   	push   %eax
  80171b:	e8 b8 ff ff ff       	call   8016d8 <strcpy>
	return dst;
}
  801720:	89 d8                	mov    %ebx,%eax
  801722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801727:	f3 0f 1e fb          	endbr32 
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	8b 75 08             	mov    0x8(%ebp),%esi
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	89 f3                	mov    %esi,%ebx
  801738:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80173b:	89 f0                	mov    %esi,%eax
  80173d:	39 d8                	cmp    %ebx,%eax
  80173f:	74 11                	je     801752 <strncpy+0x2b>
		*dst++ = *src;
  801741:	83 c0 01             	add    $0x1,%eax
  801744:	0f b6 0a             	movzbl (%edx),%ecx
  801747:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80174a:	80 f9 01             	cmp    $0x1,%cl
  80174d:	83 da ff             	sbb    $0xffffffff,%edx
  801750:	eb eb                	jmp    80173d <strncpy+0x16>
	}
	return ret;
}
  801752:	89 f0                	mov    %esi,%eax
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801758:	f3 0f 1e fb          	endbr32 
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	8b 75 08             	mov    0x8(%ebp),%esi
  801764:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801767:	8b 55 10             	mov    0x10(%ebp),%edx
  80176a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80176c:	85 d2                	test   %edx,%edx
  80176e:	74 21                	je     801791 <strlcpy+0x39>
  801770:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801774:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801776:	39 c2                	cmp    %eax,%edx
  801778:	74 14                	je     80178e <strlcpy+0x36>
  80177a:	0f b6 19             	movzbl (%ecx),%ebx
  80177d:	84 db                	test   %bl,%bl
  80177f:	74 0b                	je     80178c <strlcpy+0x34>
			*dst++ = *src++;
  801781:	83 c1 01             	add    $0x1,%ecx
  801784:	83 c2 01             	add    $0x1,%edx
  801787:	88 5a ff             	mov    %bl,-0x1(%edx)
  80178a:	eb ea                	jmp    801776 <strlcpy+0x1e>
  80178c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80178e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801791:	29 f0                	sub    %esi,%eax
}
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801797:	f3 0f 1e fb          	endbr32 
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017a4:	0f b6 01             	movzbl (%ecx),%eax
  8017a7:	84 c0                	test   %al,%al
  8017a9:	74 0c                	je     8017b7 <strcmp+0x20>
  8017ab:	3a 02                	cmp    (%edx),%al
  8017ad:	75 08                	jne    8017b7 <strcmp+0x20>
		p++, q++;
  8017af:	83 c1 01             	add    $0x1,%ecx
  8017b2:	83 c2 01             	add    $0x1,%edx
  8017b5:	eb ed                	jmp    8017a4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017b7:	0f b6 c0             	movzbl %al,%eax
  8017ba:	0f b6 12             	movzbl (%edx),%edx
  8017bd:	29 d0                	sub    %edx,%eax
}
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017d4:	eb 06                	jmp    8017dc <strncmp+0x1b>
		n--, p++, q++;
  8017d6:	83 c0 01             	add    $0x1,%eax
  8017d9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017dc:	39 d8                	cmp    %ebx,%eax
  8017de:	74 16                	je     8017f6 <strncmp+0x35>
  8017e0:	0f b6 08             	movzbl (%eax),%ecx
  8017e3:	84 c9                	test   %cl,%cl
  8017e5:	74 04                	je     8017eb <strncmp+0x2a>
  8017e7:	3a 0a                	cmp    (%edx),%cl
  8017e9:	74 eb                	je     8017d6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017eb:	0f b6 00             	movzbl (%eax),%eax
  8017ee:	0f b6 12             	movzbl (%edx),%edx
  8017f1:	29 d0                	sub    %edx,%eax
}
  8017f3:	5b                   	pop    %ebx
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    
		return 0;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb f6                	jmp    8017f3 <strncmp+0x32>

008017fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017fd:	f3 0f 1e fb          	endbr32 
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80180b:	0f b6 10             	movzbl (%eax),%edx
  80180e:	84 d2                	test   %dl,%dl
  801810:	74 09                	je     80181b <strchr+0x1e>
		if (*s == c)
  801812:	38 ca                	cmp    %cl,%dl
  801814:	74 0a                	je     801820 <strchr+0x23>
	for (; *s; s++)
  801816:	83 c0 01             	add    $0x1,%eax
  801819:	eb f0                	jmp    80180b <strchr+0xe>
			return (char *) s;
	return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    

00801822 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801822:	f3 0f 1e fb          	endbr32 
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801830:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801833:	38 ca                	cmp    %cl,%dl
  801835:	74 09                	je     801840 <strfind+0x1e>
  801837:	84 d2                	test   %dl,%dl
  801839:	74 05                	je     801840 <strfind+0x1e>
	for (; *s; s++)
  80183b:	83 c0 01             	add    $0x1,%eax
  80183e:	eb f0                	jmp    801830 <strfind+0xe>
			break;
	return (char *) s;
}
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801842:	f3 0f 1e fb          	endbr32 
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	57                   	push   %edi
  80184a:	56                   	push   %esi
  80184b:	53                   	push   %ebx
  80184c:	8b 55 08             	mov    0x8(%ebp),%edx
  80184f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801852:	85 c9                	test   %ecx,%ecx
  801854:	74 33                	je     801889 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801856:	89 d0                	mov    %edx,%eax
  801858:	09 c8                	or     %ecx,%eax
  80185a:	a8 03                	test   $0x3,%al
  80185c:	75 23                	jne    801881 <memset+0x3f>
		c &= 0xFF;
  80185e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801862:	89 d8                	mov    %ebx,%eax
  801864:	c1 e0 08             	shl    $0x8,%eax
  801867:	89 df                	mov    %ebx,%edi
  801869:	c1 e7 18             	shl    $0x18,%edi
  80186c:	89 de                	mov    %ebx,%esi
  80186e:	c1 e6 10             	shl    $0x10,%esi
  801871:	09 f7                	or     %esi,%edi
  801873:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801875:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801878:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  80187a:	89 d7                	mov    %edx,%edi
  80187c:	fc                   	cld    
  80187d:	f3 ab                	rep stos %eax,%es:(%edi)
  80187f:	eb 08                	jmp    801889 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801881:	89 d7                	mov    %edx,%edi
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	fc                   	cld    
  801887:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801889:	89 d0                	mov    %edx,%eax
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801890:	f3 0f 1e fb          	endbr32 
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	57                   	push   %edi
  801898:	56                   	push   %esi
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80189f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018a2:	39 c6                	cmp    %eax,%esi
  8018a4:	73 32                	jae    8018d8 <memmove+0x48>
  8018a6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018a9:	39 c2                	cmp    %eax,%edx
  8018ab:	76 2b                	jbe    8018d8 <memmove+0x48>
		s += n;
		d += n;
  8018ad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018b0:	89 fe                	mov    %edi,%esi
  8018b2:	09 ce                	or     %ecx,%esi
  8018b4:	09 d6                	or     %edx,%esi
  8018b6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018bc:	75 0e                	jne    8018cc <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018be:	83 ef 04             	sub    $0x4,%edi
  8018c1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018c4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018c7:	fd                   	std    
  8018c8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018ca:	eb 09                	jmp    8018d5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018cc:	83 ef 01             	sub    $0x1,%edi
  8018cf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018d2:	fd                   	std    
  8018d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018d5:	fc                   	cld    
  8018d6:	eb 1a                	jmp    8018f2 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	09 ca                	or     %ecx,%edx
  8018dc:	09 f2                	or     %esi,%edx
  8018de:	f6 c2 03             	test   $0x3,%dl
  8018e1:	75 0a                	jne    8018ed <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018e3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018e6:	89 c7                	mov    %eax,%edi
  8018e8:	fc                   	cld    
  8018e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018eb:	eb 05                	jmp    8018f2 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018ed:	89 c7                	mov    %eax,%edi
  8018ef:	fc                   	cld    
  8018f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018f2:	5e                   	pop    %esi
  8018f3:	5f                   	pop    %edi
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018f6:	f3 0f 1e fb          	endbr32 
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801900:	ff 75 10             	pushl  0x10(%ebp)
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	e8 82 ff ff ff       	call   801890 <memmove>
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801910:	f3 0f 1e fb          	endbr32 
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	89 c6                	mov    %eax,%esi
  801921:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801924:	39 f0                	cmp    %esi,%eax
  801926:	74 1c                	je     801944 <memcmp+0x34>
		if (*s1 != *s2)
  801928:	0f b6 08             	movzbl (%eax),%ecx
  80192b:	0f b6 1a             	movzbl (%edx),%ebx
  80192e:	38 d9                	cmp    %bl,%cl
  801930:	75 08                	jne    80193a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801932:	83 c0 01             	add    $0x1,%eax
  801935:	83 c2 01             	add    $0x1,%edx
  801938:	eb ea                	jmp    801924 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80193a:	0f b6 c1             	movzbl %cl,%eax
  80193d:	0f b6 db             	movzbl %bl,%ebx
  801940:	29 d8                	sub    %ebx,%eax
  801942:	eb 05                	jmp    801949 <memcmp+0x39>
	}

	return 0;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80194d:	f3 0f 1e fb          	endbr32 
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80195a:	89 c2                	mov    %eax,%edx
  80195c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80195f:	39 d0                	cmp    %edx,%eax
  801961:	73 09                	jae    80196c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801963:	38 08                	cmp    %cl,(%eax)
  801965:	74 05                	je     80196c <memfind+0x1f>
	for (; s < ends; s++)
  801967:	83 c0 01             	add    $0x1,%eax
  80196a:	eb f3                	jmp    80195f <memfind+0x12>
			break;
	return (void *) s;
}
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80196e:	f3 0f 1e fb          	endbr32 
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80197e:	eb 03                	jmp    801983 <strtol+0x15>
		s++;
  801980:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801983:	0f b6 01             	movzbl (%ecx),%eax
  801986:	3c 20                	cmp    $0x20,%al
  801988:	74 f6                	je     801980 <strtol+0x12>
  80198a:	3c 09                	cmp    $0x9,%al
  80198c:	74 f2                	je     801980 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80198e:	3c 2b                	cmp    $0x2b,%al
  801990:	74 2a                	je     8019bc <strtol+0x4e>
	int neg = 0;
  801992:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801997:	3c 2d                	cmp    $0x2d,%al
  801999:	74 2b                	je     8019c6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80199b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019a1:	75 0f                	jne    8019b2 <strtol+0x44>
  8019a3:	80 39 30             	cmpb   $0x30,(%ecx)
  8019a6:	74 28                	je     8019d0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019a8:	85 db                	test   %ebx,%ebx
  8019aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019af:	0f 44 d8             	cmove  %eax,%ebx
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019ba:	eb 46                	jmp    801a02 <strtol+0x94>
		s++;
  8019bc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8019c4:	eb d5                	jmp    80199b <strtol+0x2d>
		s++, neg = 1;
  8019c6:	83 c1 01             	add    $0x1,%ecx
  8019c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ce:	eb cb                	jmp    80199b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019d4:	74 0e                	je     8019e4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019d6:	85 db                	test   %ebx,%ebx
  8019d8:	75 d8                	jne    8019b2 <strtol+0x44>
		s++, base = 8;
  8019da:	83 c1 01             	add    $0x1,%ecx
  8019dd:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019e2:	eb ce                	jmp    8019b2 <strtol+0x44>
		s += 2, base = 16;
  8019e4:	83 c1 02             	add    $0x2,%ecx
  8019e7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019ec:	eb c4                	jmp    8019b2 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019ee:	0f be d2             	movsbl %dl,%edx
  8019f1:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019f4:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019f7:	7d 3a                	jge    801a33 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019f9:	83 c1 01             	add    $0x1,%ecx
  8019fc:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a02:	0f b6 11             	movzbl (%ecx),%edx
  801a05:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a08:	89 f3                	mov    %esi,%ebx
  801a0a:	80 fb 09             	cmp    $0x9,%bl
  801a0d:	76 df                	jbe    8019ee <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a0f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a12:	89 f3                	mov    %esi,%ebx
  801a14:	80 fb 19             	cmp    $0x19,%bl
  801a17:	77 08                	ja     801a21 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a19:	0f be d2             	movsbl %dl,%edx
  801a1c:	83 ea 57             	sub    $0x57,%edx
  801a1f:	eb d3                	jmp    8019f4 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a21:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a24:	89 f3                	mov    %esi,%ebx
  801a26:	80 fb 19             	cmp    $0x19,%bl
  801a29:	77 08                	ja     801a33 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a2b:	0f be d2             	movsbl %dl,%edx
  801a2e:	83 ea 37             	sub    $0x37,%edx
  801a31:	eb c1                	jmp    8019f4 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a37:	74 05                	je     801a3e <strtol+0xd0>
		*endptr = (char *) s;
  801a39:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a3e:	89 c2                	mov    %eax,%edx
  801a40:	f7 da                	neg    %edx
  801a42:	85 ff                	test   %edi,%edi
  801a44:	0f 45 c2             	cmovne %edx,%eax
}
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a4c:	f3 0f 1e fb          	endbr32 
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	56                   	push   %esi
  801a54:	53                   	push   %ebx
  801a55:	8b 75 08             	mov    0x8(%ebp),%esi
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a65:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	50                   	push   %eax
  801a6c:	e8 68 e8 ff ff       	call   8002d9 <sys_ipc_recv>
	if (r < 0) {
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 2b                	js     801aa3 <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a78:	85 f6                	test   %esi,%esi
  801a7a:	74 0a                	je     801a86 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a7c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a81:	8b 40 74             	mov    0x74(%eax),%eax
  801a84:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a86:	85 db                	test   %ebx,%ebx
  801a88:	74 0a                	je     801a94 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a8a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8f:	8b 40 78             	mov    0x78(%eax),%eax
  801a92:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801a94:	a1 04 40 80 00       	mov    0x804004,%eax
  801a99:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    
		if (from_env_store) {
  801aa3:	85 f6                	test   %esi,%esi
  801aa5:	74 06                	je     801aad <ipc_recv+0x61>
			*from_env_store = 0;
  801aa7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801aad:	85 db                	test   %ebx,%ebx
  801aaf:	74 eb                	je     801a9c <ipc_recv+0x50>
			*perm_store = 0;
  801ab1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ab7:	eb e3                	jmp    801a9c <ipc_recv+0x50>

00801ab9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ab9:	f3 0f 1e fb          	endbr32 
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	57                   	push   %edi
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801acf:	85 db                	test   %ebx,%ebx
  801ad1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ad6:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ad9:	ff 75 14             	pushl  0x14(%ebp)
  801adc:	53                   	push   %ebx
  801add:	56                   	push   %esi
  801ade:	57                   	push   %edi
  801adf:	e8 cc e7 ff ff       	call   8002b0 <sys_ipc_try_send>
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801aea:	75 07                	jne    801af3 <ipc_send+0x3a>
		sys_yield();
  801aec:	e8 a6 e6 ff ff       	call   800197 <sys_yield>
  801af1:	eb e6                	jmp    801ad9 <ipc_send+0x20>
	}

	if (ret < 0) {
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 08                	js     801aff <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5f                   	pop    %edi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801aff:	50                   	push   %eax
  801b00:	68 7f 22 80 00       	push   $0x80227f
  801b05:	6a 48                	push   $0x48
  801b07:	68 9c 22 80 00       	push   $0x80229c
  801b0c:	e8 76 f5 ff ff       	call   801087 <_panic>

00801b11 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b11:	f3 0f 1e fb          	endbr32 
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b1b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b20:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b23:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b29:	8b 52 50             	mov    0x50(%edx),%edx
  801b2c:	39 ca                	cmp    %ecx,%edx
  801b2e:	74 11                	je     801b41 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b30:	83 c0 01             	add    $0x1,%eax
  801b33:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b38:	75 e6                	jne    801b20 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3f:	eb 0b                	jmp    801b4c <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b41:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b44:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b49:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b4e:	f3 0f 1e fb          	endbr32 
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b58:	89 c2                	mov    %eax,%edx
  801b5a:	c1 ea 16             	shr    $0x16,%edx
  801b5d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b64:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b69:	f6 c1 01             	test   $0x1,%cl
  801b6c:	74 1c                	je     801b8a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b6e:	c1 e8 0c             	shr    $0xc,%eax
  801b71:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b78:	a8 01                	test   $0x1,%al
  801b7a:	74 0e                	je     801b8a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b7c:	c1 e8 0c             	shr    $0xc,%eax
  801b7f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b86:	ef 
  801b87:	0f b7 d2             	movzwl %dx,%edx
}
  801b8a:	89 d0                	mov    %edx,%eax
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax

00801b90 <__udivdi3>:
  801b90:	f3 0f 1e fb          	endbr32 
  801b94:	55                   	push   %ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 1c             	sub    $0x1c,%esp
  801b9b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801b9f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801ba3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ba7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bab:	85 d2                	test   %edx,%edx
  801bad:	75 19                	jne    801bc8 <__udivdi3+0x38>
  801baf:	39 f3                	cmp    %esi,%ebx
  801bb1:	76 4d                	jbe    801c00 <__udivdi3+0x70>
  801bb3:	31 ff                	xor    %edi,%edi
  801bb5:	89 e8                	mov    %ebp,%eax
  801bb7:	89 f2                	mov    %esi,%edx
  801bb9:	f7 f3                	div    %ebx
  801bbb:	89 fa                	mov    %edi,%edx
  801bbd:	83 c4 1c             	add    $0x1c,%esp
  801bc0:	5b                   	pop    %ebx
  801bc1:	5e                   	pop    %esi
  801bc2:	5f                   	pop    %edi
  801bc3:	5d                   	pop    %ebp
  801bc4:	c3                   	ret    
  801bc5:	8d 76 00             	lea    0x0(%esi),%esi
  801bc8:	39 f2                	cmp    %esi,%edx
  801bca:	76 14                	jbe    801be0 <__udivdi3+0x50>
  801bcc:	31 ff                	xor    %edi,%edi
  801bce:	31 c0                	xor    %eax,%eax
  801bd0:	89 fa                	mov    %edi,%edx
  801bd2:	83 c4 1c             	add    $0x1c,%esp
  801bd5:	5b                   	pop    %ebx
  801bd6:	5e                   	pop    %esi
  801bd7:	5f                   	pop    %edi
  801bd8:	5d                   	pop    %ebp
  801bd9:	c3                   	ret    
  801bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801be0:	0f bd fa             	bsr    %edx,%edi
  801be3:	83 f7 1f             	xor    $0x1f,%edi
  801be6:	75 48                	jne    801c30 <__udivdi3+0xa0>
  801be8:	39 f2                	cmp    %esi,%edx
  801bea:	72 06                	jb     801bf2 <__udivdi3+0x62>
  801bec:	31 c0                	xor    %eax,%eax
  801bee:	39 eb                	cmp    %ebp,%ebx
  801bf0:	77 de                	ja     801bd0 <__udivdi3+0x40>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	eb d7                	jmp    801bd0 <__udivdi3+0x40>
  801bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c00:	89 d9                	mov    %ebx,%ecx
  801c02:	85 db                	test   %ebx,%ebx
  801c04:	75 0b                	jne    801c11 <__udivdi3+0x81>
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f3                	div    %ebx
  801c0f:	89 c1                	mov    %eax,%ecx
  801c11:	31 d2                	xor    %edx,%edx
  801c13:	89 f0                	mov    %esi,%eax
  801c15:	f7 f1                	div    %ecx
  801c17:	89 c6                	mov    %eax,%esi
  801c19:	89 e8                	mov    %ebp,%eax
  801c1b:	89 f7                	mov    %esi,%edi
  801c1d:	f7 f1                	div    %ecx
  801c1f:	89 fa                	mov    %edi,%edx
  801c21:	83 c4 1c             	add    $0x1c,%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5f                   	pop    %edi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    
  801c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c30:	89 f9                	mov    %edi,%ecx
  801c32:	b8 20 00 00 00       	mov    $0x20,%eax
  801c37:	29 f8                	sub    %edi,%eax
  801c39:	d3 e2                	shl    %cl,%edx
  801c3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c3f:	89 c1                	mov    %eax,%ecx
  801c41:	89 da                	mov    %ebx,%edx
  801c43:	d3 ea                	shr    %cl,%edx
  801c45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c49:	09 d1                	or     %edx,%ecx
  801c4b:	89 f2                	mov    %esi,%edx
  801c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c51:	89 f9                	mov    %edi,%ecx
  801c53:	d3 e3                	shl    %cl,%ebx
  801c55:	89 c1                	mov    %eax,%ecx
  801c57:	d3 ea                	shr    %cl,%edx
  801c59:	89 f9                	mov    %edi,%ecx
  801c5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c5f:	89 eb                	mov    %ebp,%ebx
  801c61:	d3 e6                	shl    %cl,%esi
  801c63:	89 c1                	mov    %eax,%ecx
  801c65:	d3 eb                	shr    %cl,%ebx
  801c67:	09 de                	or     %ebx,%esi
  801c69:	89 f0                	mov    %esi,%eax
  801c6b:	f7 74 24 08          	divl   0x8(%esp)
  801c6f:	89 d6                	mov    %edx,%esi
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	f7 64 24 0c          	mull   0xc(%esp)
  801c77:	39 d6                	cmp    %edx,%esi
  801c79:	72 15                	jb     801c90 <__udivdi3+0x100>
  801c7b:	89 f9                	mov    %edi,%ecx
  801c7d:	d3 e5                	shl    %cl,%ebp
  801c7f:	39 c5                	cmp    %eax,%ebp
  801c81:	73 04                	jae    801c87 <__udivdi3+0xf7>
  801c83:	39 d6                	cmp    %edx,%esi
  801c85:	74 09                	je     801c90 <__udivdi3+0x100>
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	31 ff                	xor    %edi,%edi
  801c8b:	e9 40 ff ff ff       	jmp    801bd0 <__udivdi3+0x40>
  801c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c93:	31 ff                	xor    %edi,%edi
  801c95:	e9 36 ff ff ff       	jmp    801bd0 <__udivdi3+0x40>
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <__umoddi3>:
  801ca0:	f3 0f 1e fb          	endbr32 
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801caf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801cb3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	75 19                	jne    801cd8 <__umoddi3+0x38>
  801cbf:	39 df                	cmp    %ebx,%edi
  801cc1:	76 5d                	jbe    801d20 <__umoddi3+0x80>
  801cc3:	89 f0                	mov    %esi,%eax
  801cc5:	89 da                	mov    %ebx,%edx
  801cc7:	f7 f7                	div    %edi
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	89 f2                	mov    %esi,%edx
  801cda:	39 d8                	cmp    %ebx,%eax
  801cdc:	76 12                	jbe    801cf0 <__umoddi3+0x50>
  801cde:	89 f0                	mov    %esi,%eax
  801ce0:	89 da                	mov    %ebx,%edx
  801ce2:	83 c4 1c             	add    $0x1c,%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
  801cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cf0:	0f bd e8             	bsr    %eax,%ebp
  801cf3:	83 f5 1f             	xor    $0x1f,%ebp
  801cf6:	75 50                	jne    801d48 <__umoddi3+0xa8>
  801cf8:	39 d8                	cmp    %ebx,%eax
  801cfa:	0f 82 e0 00 00 00    	jb     801de0 <__umoddi3+0x140>
  801d00:	89 d9                	mov    %ebx,%ecx
  801d02:	39 f7                	cmp    %esi,%edi
  801d04:	0f 86 d6 00 00 00    	jbe    801de0 <__umoddi3+0x140>
  801d0a:	89 d0                	mov    %edx,%eax
  801d0c:	89 ca                	mov    %ecx,%edx
  801d0e:	83 c4 1c             	add    $0x1c,%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5f                   	pop    %edi
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    
  801d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	89 fd                	mov    %edi,%ebp
  801d22:	85 ff                	test   %edi,%edi
  801d24:	75 0b                	jne    801d31 <__umoddi3+0x91>
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	f7 f7                	div    %edi
  801d2f:	89 c5                	mov    %eax,%ebp
  801d31:	89 d8                	mov    %ebx,%eax
  801d33:	31 d2                	xor    %edx,%edx
  801d35:	f7 f5                	div    %ebp
  801d37:	89 f0                	mov    %esi,%eax
  801d39:	f7 f5                	div    %ebp
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	31 d2                	xor    %edx,%edx
  801d3f:	eb 8c                	jmp    801ccd <__umoddi3+0x2d>
  801d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d48:	89 e9                	mov    %ebp,%ecx
  801d4a:	ba 20 00 00 00       	mov    $0x20,%edx
  801d4f:	29 ea                	sub    %ebp,%edx
  801d51:	d3 e0                	shl    %cl,%eax
  801d53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d57:	89 d1                	mov    %edx,%ecx
  801d59:	89 f8                	mov    %edi,%eax
  801d5b:	d3 e8                	shr    %cl,%eax
  801d5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d65:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d69:	09 c1                	or     %eax,%ecx
  801d6b:	89 d8                	mov    %ebx,%eax
  801d6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d71:	89 e9                	mov    %ebp,%ecx
  801d73:	d3 e7                	shl    %cl,%edi
  801d75:	89 d1                	mov    %edx,%ecx
  801d77:	d3 e8                	shr    %cl,%eax
  801d79:	89 e9                	mov    %ebp,%ecx
  801d7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d7f:	d3 e3                	shl    %cl,%ebx
  801d81:	89 c7                	mov    %eax,%edi
  801d83:	89 d1                	mov    %edx,%ecx
  801d85:	89 f0                	mov    %esi,%eax
  801d87:	d3 e8                	shr    %cl,%eax
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	89 fa                	mov    %edi,%edx
  801d8d:	d3 e6                	shl    %cl,%esi
  801d8f:	09 d8                	or     %ebx,%eax
  801d91:	f7 74 24 08          	divl   0x8(%esp)
  801d95:	89 d1                	mov    %edx,%ecx
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	f7 64 24 0c          	mull   0xc(%esp)
  801d9d:	89 c6                	mov    %eax,%esi
  801d9f:	89 d7                	mov    %edx,%edi
  801da1:	39 d1                	cmp    %edx,%ecx
  801da3:	72 06                	jb     801dab <__umoddi3+0x10b>
  801da5:	75 10                	jne    801db7 <__umoddi3+0x117>
  801da7:	39 c3                	cmp    %eax,%ebx
  801da9:	73 0c                	jae    801db7 <__umoddi3+0x117>
  801dab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801daf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801db3:	89 d7                	mov    %edx,%edi
  801db5:	89 c6                	mov    %eax,%esi
  801db7:	89 ca                	mov    %ecx,%edx
  801db9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801dbe:	29 f3                	sub    %esi,%ebx
  801dc0:	19 fa                	sbb    %edi,%edx
  801dc2:	89 d0                	mov    %edx,%eax
  801dc4:	d3 e0                	shl    %cl,%eax
  801dc6:	89 e9                	mov    %ebp,%ecx
  801dc8:	d3 eb                	shr    %cl,%ebx
  801dca:	d3 ea                	shr    %cl,%edx
  801dcc:	09 d8                	or     %ebx,%eax
  801dce:	83 c4 1c             	add    $0x1c,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
  801dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ddd:	8d 76 00             	lea    0x0(%esi),%esi
  801de0:	29 fe                	sub    %edi,%esi
  801de2:	19 c3                	sbb    %eax,%ebx
  801de4:	89 f2                	mov    %esi,%edx
  801de6:	89 d9                	mov    %ebx,%ecx
  801de8:	e9 1d ff ff ff       	jmp    801d0a <__umoddi3+0x6a>
