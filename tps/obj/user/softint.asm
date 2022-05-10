
obj/user/softint.debug:     formato del fichero elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $14");	// page fault
  800037:	cd 0e                	int    $0xe
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	f3 0f 1e fb          	endbr32 
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800049:	e8 19 01 00 00       	call   800167 <sys_getenvid>
	if (id >= 0)
  80004e:	85 c0                	test   %eax,%eax
  800050:	78 12                	js     800064 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x35>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800092:	e8 53 04 00 00       	call   8004ea <close_all>
	sys_env_destroy(0);
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	e8 a0 00 00 00       	call   800141 <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	83 ec 1c             	sub    $0x1c,%esp
  8000af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000b5:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c0:	8b 75 14             	mov    0x14(%ebp),%esi
  8000c3:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c9:	74 04                	je     8000cf <syscall+0x29>
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	7f 08                	jg     8000d7 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	50                   	push   %eax
  8000db:	ff 75 e0             	pushl  -0x20(%ebp)
  8000de:	68 0a 1e 80 00       	push   $0x801e0a
  8000e3:	6a 23                	push   $0x23
  8000e5:	68 27 1e 80 00       	push   $0x801e27
  8000ea:	e8 90 0f 00 00       	call   80107f <_panic>

008000ef <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000f9:	6a 00                	push   $0x0
  8000fb:	6a 00                	push   $0x0
  8000fd:	6a 00                	push   $0x0
  8000ff:	ff 75 0c             	pushl  0xc(%ebp)
  800102:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	b8 00 00 00 00       	mov    $0x0,%eax
  80010f:	e8 92 ff ff ff       	call   8000a6 <syscall>
}
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <sys_cgetc>:

int
sys_cgetc(void)
{
  800119:	f3 0f 1e fb          	endbr32 
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	6a 00                	push   $0x0
  80012b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 01 00 00 00       	mov    $0x1,%eax
  80013a:	e8 67 ff ff ff       	call   8000a6 <syscall>
}
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800141:	f3 0f 1e fb          	endbr32 
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80014b:	6a 00                	push   $0x0
  80014d:	6a 00                	push   $0x0
  80014f:	6a 00                	push   $0x0
  800151:	6a 00                	push   $0x0
  800153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800156:	ba 01 00 00 00       	mov    $0x1,%edx
  80015b:	b8 03 00 00 00       	mov    $0x3,%eax
  800160:	e8 41 ff ff ff       	call   8000a6 <syscall>
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800171:	6a 00                	push   $0x0
  800173:	6a 00                	push   $0x0
  800175:	6a 00                	push   $0x0
  800177:	6a 00                	push   $0x0
  800179:	b9 00 00 00 00       	mov    $0x0,%ecx
  80017e:	ba 00 00 00 00       	mov    $0x0,%edx
  800183:	b8 02 00 00 00       	mov    $0x2,%eax
  800188:	e8 19 ff ff ff       	call   8000a6 <syscall>
}
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <sys_yield>:

void
sys_yield(void)
{
  80018f:	f3 0f 1e fb          	endbr32 
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800199:	6a 00                	push   $0x0
  80019b:	6a 00                	push   $0x0
  80019d:	6a 00                	push   $0x0
  80019f:	6a 00                	push   $0x0
  8001a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ab:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001b0:	e8 f1 fe ff ff       	call   8000a6 <syscall>
}
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    

008001ba <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ba:	f3 0f 1e fb          	endbr32 
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001c4:	6a 00                	push   $0x0
  8001c6:	6a 00                	push   $0x0
  8001c8:	ff 75 10             	pushl  0x10(%ebp)
  8001cb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d1:	ba 01 00 00 00       	mov    $0x1,%edx
  8001d6:	b8 04 00 00 00       	mov    $0x4,%eax
  8001db:	e8 c6 fe ff ff       	call   8000a6 <syscall>
}
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e2:	f3 0f 1e fb          	endbr32 
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001ec:	ff 75 18             	pushl  0x18(%ebp)
  8001ef:	ff 75 14             	pushl  0x14(%ebp)
  8001f2:	ff 75 10             	pushl  0x10(%ebp)
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fb:	ba 01 00 00 00       	mov    $0x1,%edx
  800200:	b8 05 00 00 00       	mov    $0x5,%eax
  800205:	e8 9c fe ff ff       	call   8000a6 <syscall>
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800216:	6a 00                	push   $0x0
  800218:	6a 00                	push   $0x0
  80021a:	6a 00                	push   $0x0
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800222:	ba 01 00 00 00       	mov    $0x1,%edx
  800227:	b8 06 00 00 00       	mov    $0x6,%eax
  80022c:	e8 75 fe ff ff       	call   8000a6 <syscall>
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800233:	f3 0f 1e fb          	endbr32 
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80023d:	6a 00                	push   $0x0
  80023f:	6a 00                	push   $0x0
  800241:	6a 00                	push   $0x0
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	ba 01 00 00 00       	mov    $0x1,%edx
  80024e:	b8 08 00 00 00       	mov    $0x8,%eax
  800253:	e8 4e fe ff ff       	call   8000a6 <syscall>
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800264:	6a 00                	push   $0x0
  800266:	6a 00                	push   $0x0
  800268:	6a 00                	push   $0x0
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800270:	ba 01 00 00 00       	mov    $0x1,%edx
  800275:	b8 09 00 00 00       	mov    $0x9,%eax
  80027a:	e8 27 fe ff ff       	call   8000a6 <syscall>
}
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800281:	f3 0f 1e fb          	endbr32 
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80028b:	6a 00                	push   $0x0
  80028d:	6a 00                	push   $0x0
  80028f:	6a 00                	push   $0x0
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800297:	ba 01 00 00 00       	mov    $0x1,%edx
  80029c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a1:	e8 00 fe ff ff       	call   8000a6 <syscall>
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a8:	f3 0f 1e fb          	endbr32 
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002b2:	6a 00                	push   $0x0
  8002b4:	ff 75 14             	pushl  0x14(%ebp)
  8002b7:	ff 75 10             	pushl  0x10(%ebp)
  8002ba:	ff 75 0c             	pushl  0xc(%ebp)
  8002bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ca:	e8 d7 fd ff ff       	call   8000a6 <syscall>
}
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002db:	6a 00                	push   $0x0
  8002dd:	6a 00                	push   $0x0
  8002df:	6a 00                	push   $0x0
  8002e1:	6a 00                	push   $0x0
  8002e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e6:	ba 01 00 00 00       	mov    $0x1,%edx
  8002eb:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002f0:	e8 b1 fd ff ff       	call   8000a6 <syscall>
}
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	05 00 00 00 30       	add    $0x30000000,%eax
  800306:	c1 e8 0c             	shr    $0xc,%eax
}
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80030b:	f3 0f 1e fb          	endbr32 
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	e8 da ff ff ff       	call   8002f7 <fd2num>
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	c1 e0 0c             	shl    $0xc,%eax
  800323:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80032a:	f3 0f 1e fb          	endbr32 
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800336:	89 c2                	mov    %eax,%edx
  800338:	c1 ea 16             	shr    $0x16,%edx
  80033b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800342:	f6 c2 01             	test   $0x1,%dl
  800345:	74 2d                	je     800374 <fd_alloc+0x4a>
  800347:	89 c2                	mov    %eax,%edx
  800349:	c1 ea 0c             	shr    $0xc,%edx
  80034c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800353:	f6 c2 01             	test   $0x1,%dl
  800356:	74 1c                	je     800374 <fd_alloc+0x4a>
  800358:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80035d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800362:	75 d2                	jne    800336 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80036d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800372:	eb 0a                	jmp    80037e <fd_alloc+0x54>
			*fd_store = fd;
  800374:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800377:	89 01                	mov    %eax,(%ecx)
			return 0;
  800379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    

00800380 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800380:	f3 0f 1e fb          	endbr32 
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80038a:	83 f8 1f             	cmp    $0x1f,%eax
  80038d:	77 30                	ja     8003bf <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80038f:	c1 e0 0c             	shl    $0xc,%eax
  800392:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800397:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80039d:	f6 c2 01             	test   $0x1,%dl
  8003a0:	74 24                	je     8003c6 <fd_lookup+0x46>
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	c1 ea 0c             	shr    $0xc,%edx
  8003a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ae:	f6 c2 01             	test   $0x1,%dl
  8003b1:	74 1a                	je     8003cd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b6:	89 02                	mov    %eax,(%edx)
	return 0;
  8003b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
		return -E_INVAL;
  8003bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003c4:	eb f7                	jmp    8003bd <fd_lookup+0x3d>
		return -E_INVAL;
  8003c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003cb:	eb f0                	jmp    8003bd <fd_lookup+0x3d>
  8003cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d2:	eb e9                	jmp    8003bd <fd_lookup+0x3d>

008003d4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003d4:	f3 0f 1e fb          	endbr32 
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e1:	ba b4 1e 80 00       	mov    $0x801eb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003e6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003eb:	39 08                	cmp    %ecx,(%eax)
  8003ed:	74 33                	je     800422 <dev_lookup+0x4e>
  8003ef:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8003f2:	8b 02                	mov    (%edx),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 f3                	jne    8003eb <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8003fd:	8b 40 48             	mov    0x48(%eax),%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	51                   	push   %ecx
  800404:	50                   	push   %eax
  800405:	68 38 1e 80 00       	push   $0x801e38
  80040a:	e8 57 0d 00 00       	call   801166 <cprintf>
	*dev = 0;
  80040f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800420:	c9                   	leave  
  800421:	c3                   	ret    
			*dev = devtab[i];
  800422:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800425:	89 01                	mov    %eax,(%ecx)
			return 0;
  800427:	b8 00 00 00 00       	mov    $0x0,%eax
  80042c:	eb f2                	jmp    800420 <dev_lookup+0x4c>

0080042e <fd_close>:
{
  80042e:	f3 0f 1e fb          	endbr32 
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	57                   	push   %edi
  800436:	56                   	push   %esi
  800437:	53                   	push   %ebx
  800438:	83 ec 28             	sub    $0x28,%esp
  80043b:	8b 75 08             	mov    0x8(%ebp),%esi
  80043e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800441:	56                   	push   %esi
  800442:	e8 b0 fe ff ff       	call   8002f7 <fd2num>
  800447:	83 c4 08             	add    $0x8,%esp
  80044a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80044d:	52                   	push   %edx
  80044e:	50                   	push   %eax
  80044f:	e8 2c ff ff ff       	call   800380 <fd_lookup>
  800454:	89 c3                	mov    %eax,%ebx
  800456:	83 c4 10             	add    $0x10,%esp
  800459:	85 c0                	test   %eax,%eax
  80045b:	78 05                	js     800462 <fd_close+0x34>
	    || fd != fd2)
  80045d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800460:	74 16                	je     800478 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800462:	89 f8                	mov    %edi,%eax
  800464:	84 c0                	test   %al,%al
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
  80046b:	0f 44 d8             	cmove  %eax,%ebx
}
  80046e:	89 d8                	mov    %ebx,%eax
  800470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80047e:	50                   	push   %eax
  80047f:	ff 36                	pushl  (%esi)
  800481:	e8 4e ff ff ff       	call   8003d4 <dev_lookup>
  800486:	89 c3                	mov    %eax,%ebx
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	85 c0                	test   %eax,%eax
  80048d:	78 1a                	js     8004a9 <fd_close+0x7b>
		if (dev->dev_close)
  80048f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800492:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800495:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80049a:	85 c0                	test   %eax,%eax
  80049c:	74 0b                	je     8004a9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	56                   	push   %esi
  8004a2:	ff d0                	call   *%eax
  8004a4:	89 c3                	mov    %eax,%ebx
  8004a6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	56                   	push   %esi
  8004ad:	6a 00                	push   $0x0
  8004af:	e8 58 fd ff ff       	call   80020c <sys_page_unmap>
	return r;
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	eb b5                	jmp    80046e <fd_close+0x40>

008004b9 <close>:

int
close(int fdnum)
{
  8004b9:	f3 0f 1e fb          	endbr32 
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c6:	50                   	push   %eax
  8004c7:	ff 75 08             	pushl  0x8(%ebp)
  8004ca:	e8 b1 fe ff ff       	call   800380 <fd_lookup>
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 c0                	test   %eax,%eax
  8004d4:	79 02                	jns    8004d8 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    
		return fd_close(fd, 1);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	6a 01                	push   $0x1
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	e8 49 ff ff ff       	call   80042e <fd_close>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	eb ec                	jmp    8004d6 <close+0x1d>

008004ea <close_all>:

void
close_all(void)
{
  8004ea:	f3 0f 1e fb          	endbr32 
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	53                   	push   %ebx
  8004f2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	e8 b6 ff ff ff       	call   8004b9 <close>
	for (i = 0; i < MAXFD; i++)
  800503:	83 c3 01             	add    $0x1,%ebx
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	83 fb 20             	cmp    $0x20,%ebx
  80050c:	75 ec                	jne    8004fa <close_all+0x10>
}
  80050e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800511:	c9                   	leave  
  800512:	c3                   	ret    

00800513 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800513:	f3 0f 1e fb          	endbr32 
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	57                   	push   %edi
  80051b:	56                   	push   %esi
  80051c:	53                   	push   %ebx
  80051d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800520:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800523:	50                   	push   %eax
  800524:	ff 75 08             	pushl  0x8(%ebp)
  800527:	e8 54 fe ff ff       	call   800380 <fd_lookup>
  80052c:	89 c3                	mov    %eax,%ebx
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	85 c0                	test   %eax,%eax
  800533:	0f 88 81 00 00 00    	js     8005ba <dup+0xa7>
		return r;
	close(newfdnum);
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	ff 75 0c             	pushl  0xc(%ebp)
  80053f:	e8 75 ff ff ff       	call   8004b9 <close>

	newfd = INDEX2FD(newfdnum);
  800544:	8b 75 0c             	mov    0xc(%ebp),%esi
  800547:	c1 e6 0c             	shl    $0xc,%esi
  80054a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800550:	83 c4 04             	add    $0x4,%esp
  800553:	ff 75 e4             	pushl  -0x1c(%ebp)
  800556:	e8 b0 fd ff ff       	call   80030b <fd2data>
  80055b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80055d:	89 34 24             	mov    %esi,(%esp)
  800560:	e8 a6 fd ff ff       	call   80030b <fd2data>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80056a:	89 d8                	mov    %ebx,%eax
  80056c:	c1 e8 16             	shr    $0x16,%eax
  80056f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800576:	a8 01                	test   $0x1,%al
  800578:	74 11                	je     80058b <dup+0x78>
  80057a:	89 d8                	mov    %ebx,%eax
  80057c:	c1 e8 0c             	shr    $0xc,%eax
  80057f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800586:	f6 c2 01             	test   $0x1,%dl
  800589:	75 39                	jne    8005c4 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80058b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	c1 e8 0c             	shr    $0xc,%eax
  800593:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80059a:	83 ec 0c             	sub    $0xc,%esp
  80059d:	25 07 0e 00 00       	and    $0xe07,%eax
  8005a2:	50                   	push   %eax
  8005a3:	56                   	push   %esi
  8005a4:	6a 00                	push   $0x0
  8005a6:	52                   	push   %edx
  8005a7:	6a 00                	push   $0x0
  8005a9:	e8 34 fc ff ff       	call   8001e2 <sys_page_map>
  8005ae:	89 c3                	mov    %eax,%ebx
  8005b0:	83 c4 20             	add    $0x20,%esp
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	78 31                	js     8005e8 <dup+0xd5>
		goto err;

	return newfdnum;
  8005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005ba:	89 d8                	mov    %ebx,%eax
  8005bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005bf:	5b                   	pop    %ebx
  8005c0:	5e                   	pop    %esi
  8005c1:	5f                   	pop    %edi
  8005c2:	5d                   	pop    %ebp
  8005c3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d3:	50                   	push   %eax
  8005d4:	57                   	push   %edi
  8005d5:	6a 00                	push   $0x0
  8005d7:	53                   	push   %ebx
  8005d8:	6a 00                	push   $0x0
  8005da:	e8 03 fc ff ff       	call   8001e2 <sys_page_map>
  8005df:	89 c3                	mov    %eax,%ebx
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	79 a3                	jns    80058b <dup+0x78>
	sys_page_unmap(0, newfd);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	56                   	push   %esi
  8005ec:	6a 00                	push   $0x0
  8005ee:	e8 19 fc ff ff       	call   80020c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005f3:	83 c4 08             	add    $0x8,%esp
  8005f6:	57                   	push   %edi
  8005f7:	6a 00                	push   $0x0
  8005f9:	e8 0e fc ff ff       	call   80020c <sys_page_unmap>
	return r;
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	eb b7                	jmp    8005ba <dup+0xa7>

00800603 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800603:	f3 0f 1e fb          	endbr32 
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	53                   	push   %ebx
  80060b:	83 ec 1c             	sub    $0x1c,%esp
  80060e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800611:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	53                   	push   %ebx
  800616:	e8 65 fd ff ff       	call   800380 <fd_lookup>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	85 c0                	test   %eax,%eax
  800620:	78 3f                	js     800661 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800628:	50                   	push   %eax
  800629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062c:	ff 30                	pushl  (%eax)
  80062e:	e8 a1 fd ff ff       	call   8003d4 <dev_lookup>
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	85 c0                	test   %eax,%eax
  800638:	78 27                	js     800661 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80063a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80063d:	8b 42 08             	mov    0x8(%edx),%eax
  800640:	83 e0 03             	and    $0x3,%eax
  800643:	83 f8 01             	cmp    $0x1,%eax
  800646:	74 1e                	je     800666 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064b:	8b 40 08             	mov    0x8(%eax),%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	74 35                	je     800687 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800652:	83 ec 04             	sub    $0x4,%esp
  800655:	ff 75 10             	pushl  0x10(%ebp)
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	52                   	push   %edx
  80065c:	ff d0                	call   *%eax
  80065e:	83 c4 10             	add    $0x10,%esp
}
  800661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800664:	c9                   	leave  
  800665:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800666:	a1 04 40 80 00       	mov    0x804004,%eax
  80066b:	8b 40 48             	mov    0x48(%eax),%eax
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	53                   	push   %ebx
  800672:	50                   	push   %eax
  800673:	68 79 1e 80 00       	push   $0x801e79
  800678:	e8 e9 0a 00 00       	call   801166 <cprintf>
		return -E_INVAL;
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800685:	eb da                	jmp    800661 <read+0x5e>
		return -E_NOT_SUPP;
  800687:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80068c:	eb d3                	jmp    800661 <read+0x5e>

0080068e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80068e:	f3 0f 1e fb          	endbr32 
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
  800695:	57                   	push   %edi
  800696:	56                   	push   %esi
  800697:	53                   	push   %ebx
  800698:	83 ec 0c             	sub    $0xc,%esp
  80069b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80069e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a6:	eb 02                	jmp    8006aa <readn+0x1c>
  8006a8:	01 c3                	add    %eax,%ebx
  8006aa:	39 f3                	cmp    %esi,%ebx
  8006ac:	73 21                	jae    8006cf <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	89 f0                	mov    %esi,%eax
  8006b3:	29 d8                	sub    %ebx,%eax
  8006b5:	50                   	push   %eax
  8006b6:	89 d8                	mov    %ebx,%eax
  8006b8:	03 45 0c             	add    0xc(%ebp),%eax
  8006bb:	50                   	push   %eax
  8006bc:	57                   	push   %edi
  8006bd:	e8 41 ff ff ff       	call   800603 <read>
		if (m < 0)
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	78 04                	js     8006cd <readn+0x3f>
			return m;
		if (m == 0)
  8006c9:	75 dd                	jne    8006a8 <readn+0x1a>
  8006cb:	eb 02                	jmp    8006cf <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006cd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006cf:	89 d8                	mov    %ebx,%eax
  8006d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d4:	5b                   	pop    %ebx
  8006d5:	5e                   	pop    %esi
  8006d6:	5f                   	pop    %edi
  8006d7:	5d                   	pop    %ebp
  8006d8:	c3                   	ret    

008006d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006d9:	f3 0f 1e fb          	endbr32 
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	53                   	push   %ebx
  8006e1:	83 ec 1c             	sub    $0x1c,%esp
  8006e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	53                   	push   %ebx
  8006ec:	e8 8f fc ff ff       	call   800380 <fd_lookup>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	78 3a                	js     800732 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800702:	ff 30                	pushl  (%eax)
  800704:	e8 cb fc ff ff       	call   8003d4 <dev_lookup>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	85 c0                	test   %eax,%eax
  80070e:	78 22                	js     800732 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800713:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800717:	74 1e                	je     800737 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071c:	8b 52 0c             	mov    0xc(%edx),%edx
  80071f:	85 d2                	test   %edx,%edx
  800721:	74 35                	je     800758 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800723:	83 ec 04             	sub    $0x4,%esp
  800726:	ff 75 10             	pushl  0x10(%ebp)
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	50                   	push   %eax
  80072d:	ff d2                	call   *%edx
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800735:	c9                   	leave  
  800736:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800737:	a1 04 40 80 00       	mov    0x804004,%eax
  80073c:	8b 40 48             	mov    0x48(%eax),%eax
  80073f:	83 ec 04             	sub    $0x4,%esp
  800742:	53                   	push   %ebx
  800743:	50                   	push   %eax
  800744:	68 95 1e 80 00       	push   $0x801e95
  800749:	e8 18 0a 00 00       	call   801166 <cprintf>
		return -E_INVAL;
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800756:	eb da                	jmp    800732 <write+0x59>
		return -E_NOT_SUPP;
  800758:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80075d:	eb d3                	jmp    800732 <write+0x59>

0080075f <seek>:

int
seek(int fdnum, off_t offset)
{
  80075f:	f3 0f 1e fb          	endbr32 
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80076c:	50                   	push   %eax
  80076d:	ff 75 08             	pushl  0x8(%ebp)
  800770:	e8 0b fc ff ff       	call   800380 <fd_lookup>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	85 c0                	test   %eax,%eax
  80077a:	78 0e                	js     80078a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80077c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800782:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80078c:	f3 0f 1e fb          	endbr32 
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	53                   	push   %ebx
  800794:	83 ec 1c             	sub    $0x1c,%esp
  800797:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80079a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	53                   	push   %ebx
  80079f:	e8 dc fb ff ff       	call   800380 <fd_lookup>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	78 37                	js     8007e2 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b1:	50                   	push   %eax
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b5:	ff 30                	pushl  (%eax)
  8007b7:	e8 18 fc ff ff       	call   8003d4 <dev_lookup>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 1f                	js     8007e2 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ca:	74 1b                	je     8007e7 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007cf:	8b 52 18             	mov    0x18(%edx),%edx
  8007d2:	85 d2                	test   %edx,%edx
  8007d4:	74 32                	je     800808 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	ff d2                	call   *%edx
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007e7:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007ec:	8b 40 48             	mov    0x48(%eax),%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	50                   	push   %eax
  8007f4:	68 58 1e 80 00       	push   $0x801e58
  8007f9:	e8 68 09 00 00       	call   801166 <cprintf>
		return -E_INVAL;
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800806:	eb da                	jmp    8007e2 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800808:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80080d:	eb d3                	jmp    8007e2 <ftruncate+0x56>

0080080f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80080f:	f3 0f 1e fb          	endbr32 
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	53                   	push   %ebx
  800817:	83 ec 1c             	sub    $0x1c,%esp
  80081a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80081d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	ff 75 08             	pushl  0x8(%ebp)
  800824:	e8 57 fb ff ff       	call   800380 <fd_lookup>
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	85 c0                	test   %eax,%eax
  80082e:	78 4b                	js     80087b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083a:	ff 30                	pushl  (%eax)
  80083c:	e8 93 fb ff ff       	call   8003d4 <dev_lookup>
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	78 33                	js     80087b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80084f:	74 2f                	je     800880 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800851:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800854:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80085b:	00 00 00 
	stat->st_isdir = 0;
  80085e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800865:	00 00 00 
	stat->st_dev = dev;
  800868:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	ff 75 f0             	pushl  -0x10(%ebp)
  800875:	ff 50 14             	call   *0x14(%eax)
  800878:	83 c4 10             	add    $0x10,%esp
}
  80087b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    
		return -E_NOT_SUPP;
  800880:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800885:	eb f4                	jmp    80087b <fstat+0x6c>

00800887 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	6a 00                	push   $0x0
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	e8 3a 02 00 00       	call   800ad7 <open>
  80089d:	89 c3                	mov    %eax,%ebx
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	78 1b                	js     8008c1 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	50                   	push   %eax
  8008ad:	e8 5d ff ff ff       	call   80080f <fstat>
  8008b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8008b4:	89 1c 24             	mov    %ebx,(%esp)
  8008b7:	e8 fd fb ff ff       	call   8004b9 <close>
	return r;
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	89 f3                	mov    %esi,%ebx
}
  8008c1:	89 d8                	mov    %ebx,%eax
  8008c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008c6:	5b                   	pop    %ebx
  8008c7:	5e                   	pop    %esi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	89 c6                	mov    %eax,%esi
  8008d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008da:	74 27                	je     800903 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008dc:	6a 07                	push   $0x7
  8008de:	68 00 50 80 00       	push   $0x805000
  8008e3:	56                   	push   %esi
  8008e4:	ff 35 00 40 80 00    	pushl  0x804000
  8008ea:	e8 c2 11 00 00       	call   801ab1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008ef:	83 c4 0c             	add    $0xc,%esp
  8008f2:	6a 00                	push   $0x0
  8008f4:	53                   	push   %ebx
  8008f5:	6a 00                	push   $0x0
  8008f7:	e8 48 11 00 00       	call   801a44 <ipc_recv>
}
  8008fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	6a 01                	push   $0x1
  800908:	e8 fc 11 00 00       	call   801b09 <ipc_find_env>
  80090d:	a3 00 40 80 00       	mov    %eax,0x804000
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb c5                	jmp    8008dc <fsipc+0x12>

00800917 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 40 0c             	mov    0xc(%eax),%eax
  800927:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800934:	ba 00 00 00 00       	mov    $0x0,%edx
  800939:	b8 02 00 00 00       	mov    $0x2,%eax
  80093e:	e8 87 ff ff ff       	call   8008ca <fsipc>
}
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <devfile_flush>:
{
  800945:	f3 0f 1e fb          	endbr32 
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 40 0c             	mov    0xc(%eax),%eax
  800955:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	b8 06 00 00 00       	mov    $0x6,%eax
  800964:	e8 61 ff ff ff       	call   8008ca <fsipc>
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <devfile_stat>:
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	53                   	push   %ebx
  800973:	83 ec 04             	sub    $0x4,%esp
  800976:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 40 0c             	mov    0xc(%eax),%eax
  80097f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	b8 05 00 00 00       	mov    $0x5,%eax
  80098e:	e8 37 ff ff ff       	call   8008ca <fsipc>
  800993:	85 c0                	test   %eax,%eax
  800995:	78 2c                	js     8009c3 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	68 00 50 80 00       	push   $0x805000
  80099f:	53                   	push   %ebx
  8009a0:	e8 2b 0d 00 00       	call   8016d0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009a5:	a1 80 50 80 00       	mov    0x805080,%eax
  8009aa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009b0:	a1 84 50 80 00       	mov    0x805084,%eax
  8009b5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c6:	c9                   	leave  
  8009c7:	c3                   	ret    

008009c8 <devfile_write>:
{
  8009c8:	f3 0f 1e fb          	endbr32 
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	53                   	push   %ebx
  8009d0:	83 ec 04             	sub    $0x4,%esp
  8009d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8009dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009e1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009e7:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8009ed:	77 30                	ja     800a1f <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8009ef:	83 ec 04             	sub    $0x4,%esp
  8009f2:	53                   	push   %ebx
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	68 08 50 80 00       	push   $0x805008
  8009fb:	e8 88 0e 00 00       	call   801888 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
  800a05:	b8 04 00 00 00       	mov    $0x4,%eax
  800a0a:	e8 bb fe ff ff       	call   8008ca <fsipc>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	85 c0                	test   %eax,%eax
  800a14:	78 04                	js     800a1a <devfile_write+0x52>
	assert(r <= n);
  800a16:	39 d8                	cmp    %ebx,%eax
  800a18:	77 1e                	ja     800a38 <devfile_write+0x70>
}
  800a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a1f:	68 c4 1e 80 00       	push   $0x801ec4
  800a24:	68 f1 1e 80 00       	push   $0x801ef1
  800a29:	68 94 00 00 00       	push   $0x94
  800a2e:	68 06 1f 80 00       	push   $0x801f06
  800a33:	e8 47 06 00 00       	call   80107f <_panic>
	assert(r <= n);
  800a38:	68 11 1f 80 00       	push   $0x801f11
  800a3d:	68 f1 1e 80 00       	push   $0x801ef1
  800a42:	68 98 00 00 00       	push   $0x98
  800a47:	68 06 1f 80 00       	push   $0x801f06
  800a4c:	e8 2e 06 00 00       	call   80107f <_panic>

00800a51 <devfile_read>:
{
  800a51:	f3 0f 1e fb          	endbr32 
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	56                   	push   %esi
  800a59:	53                   	push   %ebx
  800a5a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8b 40 0c             	mov    0xc(%eax),%eax
  800a63:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a68:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a73:	b8 03 00 00 00       	mov    $0x3,%eax
  800a78:	e8 4d fe ff ff       	call   8008ca <fsipc>
  800a7d:	89 c3                	mov    %eax,%ebx
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	78 1f                	js     800aa2 <devfile_read+0x51>
	assert(r <= n);
  800a83:	39 f0                	cmp    %esi,%eax
  800a85:	77 24                	ja     800aab <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a87:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a8c:	7f 33                	jg     800ac1 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	50                   	push   %eax
  800a92:	68 00 50 80 00       	push   $0x805000
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	e8 e9 0d 00 00       	call   801888 <memmove>
	return r;
  800a9f:	83 c4 10             	add    $0x10,%esp
}
  800aa2:	89 d8                	mov    %ebx,%eax
  800aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    
	assert(r <= n);
  800aab:	68 11 1f 80 00       	push   $0x801f11
  800ab0:	68 f1 1e 80 00       	push   $0x801ef1
  800ab5:	6a 7c                	push   $0x7c
  800ab7:	68 06 1f 80 00       	push   $0x801f06
  800abc:	e8 be 05 00 00       	call   80107f <_panic>
	assert(r <= PGSIZE);
  800ac1:	68 18 1f 80 00       	push   $0x801f18
  800ac6:	68 f1 1e 80 00       	push   $0x801ef1
  800acb:	6a 7d                	push   $0x7d
  800acd:	68 06 1f 80 00       	push   $0x801f06
  800ad2:	e8 a8 05 00 00       	call   80107f <_panic>

00800ad7 <open>:
{
  800ad7:	f3 0f 1e fb          	endbr32 
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	56                   	push   %esi
  800adf:	53                   	push   %ebx
  800ae0:	83 ec 1c             	sub    $0x1c,%esp
  800ae3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ae6:	56                   	push   %esi
  800ae7:	e8 a1 0b 00 00       	call   80168d <strlen>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800af4:	7f 6c                	jg     800b62 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800af6:	83 ec 0c             	sub    $0xc,%esp
  800af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800afc:	50                   	push   %eax
  800afd:	e8 28 f8 ff ff       	call   80032a <fd_alloc>
  800b02:	89 c3                	mov    %eax,%ebx
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	85 c0                	test   %eax,%eax
  800b09:	78 3c                	js     800b47 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	56                   	push   %esi
  800b0f:	68 00 50 80 00       	push   $0x805000
  800b14:	e8 b7 0b 00 00       	call   8016d0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b24:	b8 01 00 00 00       	mov    $0x1,%eax
  800b29:	e8 9c fd ff ff       	call   8008ca <fsipc>
  800b2e:	89 c3                	mov    %eax,%ebx
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	85 c0                	test   %eax,%eax
  800b35:	78 19                	js     800b50 <open+0x79>
	return fd2num(fd);
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	e8 b5 f7 ff ff       	call   8002f7 <fd2num>
  800b42:	89 c3                	mov    %eax,%ebx
  800b44:	83 c4 10             	add    $0x10,%esp
}
  800b47:	89 d8                	mov    %ebx,%eax
  800b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    
		fd_close(fd, 0);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	6a 00                	push   $0x0
  800b55:	ff 75 f4             	pushl  -0xc(%ebp)
  800b58:	e8 d1 f8 ff ff       	call   80042e <fd_close>
		return r;
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	eb e5                	jmp    800b47 <open+0x70>
		return -E_BAD_PATH;
  800b62:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b67:	eb de                	jmp    800b47 <open+0x70>

00800b69 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b69:	f3 0f 1e fb          	endbr32 
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7d:	e8 48 fd ff ff       	call   8008ca <fsipc>
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b84:	f3 0f 1e fb          	endbr32 
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	ff 75 08             	pushl  0x8(%ebp)
  800b96:	e8 70 f7 ff ff       	call   80030b <fd2data>
  800b9b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b9d:	83 c4 08             	add    $0x8,%esp
  800ba0:	68 24 1f 80 00       	push   $0x801f24
  800ba5:	53                   	push   %ebx
  800ba6:	e8 25 0b 00 00       	call   8016d0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bab:	8b 46 04             	mov    0x4(%esi),%eax
  800bae:	2b 06                	sub    (%esi),%eax
  800bb0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bb6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bbd:	00 00 00 
	stat->st_dev = &devpipe;
  800bc0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bc7:	30 80 00 
	return 0;
}
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bd6:	f3 0f 1e fb          	endbr32 
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	53                   	push   %ebx
  800bde:	83 ec 0c             	sub    $0xc,%esp
  800be1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800be4:	53                   	push   %ebx
  800be5:	6a 00                	push   $0x0
  800be7:	e8 20 f6 ff ff       	call   80020c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bec:	89 1c 24             	mov    %ebx,(%esp)
  800bef:	e8 17 f7 ff ff       	call   80030b <fd2data>
  800bf4:	83 c4 08             	add    $0x8,%esp
  800bf7:	50                   	push   %eax
  800bf8:	6a 00                	push   $0x0
  800bfa:	e8 0d f6 ff ff       	call   80020c <sys_page_unmap>
}
  800bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <_pipeisclosed>:
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
  800c0a:	83 ec 1c             	sub    $0x1c,%esp
  800c0d:	89 c7                	mov    %eax,%edi
  800c0f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c11:	a1 04 40 80 00       	mov    0x804004,%eax
  800c16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	57                   	push   %edi
  800c1d:	e8 24 0f 00 00       	call   801b46 <pageref>
  800c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c25:	89 34 24             	mov    %esi,(%esp)
  800c28:	e8 19 0f 00 00       	call   801b46 <pageref>
		nn = thisenv->env_runs;
  800c2d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c33:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	39 cb                	cmp    %ecx,%ebx
  800c3b:	74 1b                	je     800c58 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c3d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c40:	75 cf                	jne    800c11 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c42:	8b 42 58             	mov    0x58(%edx),%eax
  800c45:	6a 01                	push   $0x1
  800c47:	50                   	push   %eax
  800c48:	53                   	push   %ebx
  800c49:	68 2b 1f 80 00       	push   $0x801f2b
  800c4e:	e8 13 05 00 00       	call   801166 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	eb b9                	jmp    800c11 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c58:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c5b:	0f 94 c0             	sete   %al
  800c5e:	0f b6 c0             	movzbl %al,%eax
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <devpipe_write>:
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 28             	sub    $0x28,%esp
  800c76:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c79:	56                   	push   %esi
  800c7a:	e8 8c f6 ff ff       	call   80030b <fd2data>
  800c7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	bf 00 00 00 00       	mov    $0x0,%edi
  800c89:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c8c:	74 4f                	je     800cdd <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c8e:	8b 43 04             	mov    0x4(%ebx),%eax
  800c91:	8b 0b                	mov    (%ebx),%ecx
  800c93:	8d 51 20             	lea    0x20(%ecx),%edx
  800c96:	39 d0                	cmp    %edx,%eax
  800c98:	72 14                	jb     800cae <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800c9a:	89 da                	mov    %ebx,%edx
  800c9c:	89 f0                	mov    %esi,%eax
  800c9e:	e8 61 ff ff ff       	call   800c04 <_pipeisclosed>
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	75 3b                	jne    800ce2 <devpipe_write+0x79>
			sys_yield();
  800ca7:	e8 e3 f4 ff ff       	call   80018f <sys_yield>
  800cac:	eb e0                	jmp    800c8e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cb5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cb8:	89 c2                	mov    %eax,%edx
  800cba:	c1 fa 1f             	sar    $0x1f,%edx
  800cbd:	89 d1                	mov    %edx,%ecx
  800cbf:	c1 e9 1b             	shr    $0x1b,%ecx
  800cc2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cc5:	83 e2 1f             	and    $0x1f,%edx
  800cc8:	29 ca                	sub    %ecx,%edx
  800cca:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cd8:	83 c7 01             	add    $0x1,%edi
  800cdb:	eb ac                	jmp    800c89 <devpipe_write+0x20>
	return i;
  800cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce0:	eb 05                	jmp    800ce7 <devpipe_write+0x7e>
				return 0;
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <devpipe_read>:
{
  800cef:	f3 0f 1e fb          	endbr32 
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 18             	sub    $0x18,%esp
  800cfc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800cff:	57                   	push   %edi
  800d00:	e8 06 f6 ff ff       	call   80030b <fd2data>
  800d05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d07:	83 c4 10             	add    $0x10,%esp
  800d0a:	be 00 00 00 00       	mov    $0x0,%esi
  800d0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d12:	75 14                	jne    800d28 <devpipe_read+0x39>
	return i;
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	eb 02                	jmp    800d1b <devpipe_read+0x2c>
				return i;
  800d19:	89 f0                	mov    %esi,%eax
}
  800d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    
			sys_yield();
  800d23:	e8 67 f4 ff ff       	call   80018f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d28:	8b 03                	mov    (%ebx),%eax
  800d2a:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d2d:	75 18                	jne    800d47 <devpipe_read+0x58>
			if (i > 0)
  800d2f:	85 f6                	test   %esi,%esi
  800d31:	75 e6                	jne    800d19 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d33:	89 da                	mov    %ebx,%edx
  800d35:	89 f8                	mov    %edi,%eax
  800d37:	e8 c8 fe ff ff       	call   800c04 <_pipeisclosed>
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 e3                	je     800d23 <devpipe_read+0x34>
				return 0;
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	eb d4                	jmp    800d1b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d47:	99                   	cltd   
  800d48:	c1 ea 1b             	shr    $0x1b,%edx
  800d4b:	01 d0                	add    %edx,%eax
  800d4d:	83 e0 1f             	and    $0x1f,%eax
  800d50:	29 d0                	sub    %edx,%eax
  800d52:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d5d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d60:	83 c6 01             	add    $0x1,%esi
  800d63:	eb aa                	jmp    800d0f <devpipe_read+0x20>

00800d65 <pipe>:
{
  800d65:	f3 0f 1e fb          	endbr32 
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d74:	50                   	push   %eax
  800d75:	e8 b0 f5 ff ff       	call   80032a <fd_alloc>
  800d7a:	89 c3                	mov    %eax,%ebx
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	0f 88 23 01 00 00    	js     800eaa <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d87:	83 ec 04             	sub    $0x4,%esp
  800d8a:	68 07 04 00 00       	push   $0x407
  800d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d92:	6a 00                	push   $0x0
  800d94:	e8 21 f4 ff ff       	call   8001ba <sys_page_alloc>
  800d99:	89 c3                	mov    %eax,%ebx
  800d9b:	83 c4 10             	add    $0x10,%esp
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	0f 88 04 01 00 00    	js     800eaa <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	e8 78 f5 ff ff       	call   80032a <fd_alloc>
  800db2:	89 c3                	mov    %eax,%ebx
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	85 c0                	test   %eax,%eax
  800db9:	0f 88 db 00 00 00    	js     800e9a <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dbf:	83 ec 04             	sub    $0x4,%esp
  800dc2:	68 07 04 00 00       	push   $0x407
  800dc7:	ff 75 f0             	pushl  -0x10(%ebp)
  800dca:	6a 00                	push   $0x0
  800dcc:	e8 e9 f3 ff ff       	call   8001ba <sys_page_alloc>
  800dd1:	89 c3                	mov    %eax,%ebx
  800dd3:	83 c4 10             	add    $0x10,%esp
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	0f 88 bc 00 00 00    	js     800e9a <pipe+0x135>
	va = fd2data(fd0);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	ff 75 f4             	pushl  -0xc(%ebp)
  800de4:	e8 22 f5 ff ff       	call   80030b <fd2data>
  800de9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800deb:	83 c4 0c             	add    $0xc,%esp
  800dee:	68 07 04 00 00       	push   $0x407
  800df3:	50                   	push   %eax
  800df4:	6a 00                	push   $0x0
  800df6:	e8 bf f3 ff ff       	call   8001ba <sys_page_alloc>
  800dfb:	89 c3                	mov    %eax,%ebx
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	85 c0                	test   %eax,%eax
  800e02:	0f 88 82 00 00 00    	js     800e8a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e08:	83 ec 0c             	sub    $0xc,%esp
  800e0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e0e:	e8 f8 f4 ff ff       	call   80030b <fd2data>
  800e13:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e1a:	50                   	push   %eax
  800e1b:	6a 00                	push   $0x0
  800e1d:	56                   	push   %esi
  800e1e:	6a 00                	push   $0x0
  800e20:	e8 bd f3 ff ff       	call   8001e2 <sys_page_map>
  800e25:	89 c3                	mov    %eax,%ebx
  800e27:	83 c4 20             	add    $0x20,%esp
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	78 4e                	js     800e7c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e2e:	a1 20 30 80 00       	mov    0x803020,%eax
  800e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e36:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e45:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	ff 75 f4             	pushl  -0xc(%ebp)
  800e57:	e8 9b f4 ff ff       	call   8002f7 <fd2num>
  800e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e61:	83 c4 04             	add    $0x4,%esp
  800e64:	ff 75 f0             	pushl  -0x10(%ebp)
  800e67:	e8 8b f4 ff ff       	call   8002f7 <fd2num>
  800e6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7a:	eb 2e                	jmp    800eaa <pipe+0x145>
	sys_page_unmap(0, va);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	56                   	push   %esi
  800e80:	6a 00                	push   $0x0
  800e82:	e8 85 f3 ff ff       	call   80020c <sys_page_unmap>
  800e87:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e8a:	83 ec 08             	sub    $0x8,%esp
  800e8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e90:	6a 00                	push   $0x0
  800e92:	e8 75 f3 ff ff       	call   80020c <sys_page_unmap>
  800e97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea0:	6a 00                	push   $0x0
  800ea2:	e8 65 f3 ff ff       	call   80020c <sys_page_unmap>
  800ea7:	83 c4 10             	add    $0x10,%esp
}
  800eaa:	89 d8                	mov    %ebx,%eax
  800eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <pipeisclosed>:
{
  800eb3:	f3 0f 1e fb          	endbr32 
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ebd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec0:	50                   	push   %eax
  800ec1:	ff 75 08             	pushl  0x8(%ebp)
  800ec4:	e8 b7 f4 ff ff       	call   800380 <fd_lookup>
  800ec9:	83 c4 10             	add    $0x10,%esp
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	78 18                	js     800ee8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed6:	e8 30 f4 ff ff       	call   80030b <fd2data>
  800edb:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee0:	e8 1f fd ff ff       	call   800c04 <_pipeisclosed>
  800ee5:	83 c4 10             	add    $0x10,%esp
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800eea:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef3:	c3                   	ret    

00800ef4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800ef4:	f3 0f 1e fb          	endbr32 
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800efe:	68 43 1f 80 00       	push   $0x801f43
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	e8 c5 07 00 00       	call   8016d0 <strcpy>
	return 0;
}
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <devcons_write>:
{
  800f12:	f3 0f 1e fb          	endbr32 
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
  800f1c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f22:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f27:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f2d:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f30:	73 31                	jae    800f63 <devcons_write+0x51>
		m = n - tot;
  800f32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f35:	29 f3                	sub    %esi,%ebx
  800f37:	83 fb 7f             	cmp    $0x7f,%ebx
  800f3a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f3f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f42:	83 ec 04             	sub    $0x4,%esp
  800f45:	53                   	push   %ebx
  800f46:	89 f0                	mov    %esi,%eax
  800f48:	03 45 0c             	add    0xc(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	57                   	push   %edi
  800f4d:	e8 36 09 00 00       	call   801888 <memmove>
		sys_cputs(buf, m);
  800f52:	83 c4 08             	add    $0x8,%esp
  800f55:	53                   	push   %ebx
  800f56:	57                   	push   %edi
  800f57:	e8 93 f1 ff ff       	call   8000ef <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f5c:	01 de                	add    %ebx,%esi
  800f5e:	83 c4 10             	add    $0x10,%esp
  800f61:	eb ca                	jmp    800f2d <devcons_write+0x1b>
}
  800f63:	89 f0                	mov    %esi,%eax
  800f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <devcons_read>:
{
  800f6d:	f3 0f 1e fb          	endbr32 
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f80:	74 21                	je     800fa3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f82:	e8 92 f1 ff ff       	call   800119 <sys_cgetc>
  800f87:	85 c0                	test   %eax,%eax
  800f89:	75 07                	jne    800f92 <devcons_read+0x25>
		sys_yield();
  800f8b:	e8 ff f1 ff ff       	call   80018f <sys_yield>
  800f90:	eb f0                	jmp    800f82 <devcons_read+0x15>
	if (c < 0)
  800f92:	78 0f                	js     800fa3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800f94:	83 f8 04             	cmp    $0x4,%eax
  800f97:	74 0c                	je     800fa5 <devcons_read+0x38>
	*(char*)vbuf = c;
  800f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9c:	88 02                	mov    %al,(%edx)
	return 1;
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    
		return 0;
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	eb f7                	jmp    800fa3 <devcons_read+0x36>

00800fac <cputchar>:
{
  800fac:	f3 0f 1e fb          	endbr32 
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fbc:	6a 01                	push   $0x1
  800fbe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fc1:	50                   	push   %eax
  800fc2:	e8 28 f1 ff ff       	call   8000ef <sys_cputs>
}
  800fc7:	83 c4 10             	add    $0x10,%esp
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <getchar>:
{
  800fcc:	f3 0f 1e fb          	endbr32 
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fd6:	6a 01                	push   $0x1
  800fd8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	6a 00                	push   $0x0
  800fde:	e8 20 f6 ff ff       	call   800603 <read>
	if (r < 0)
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 06                	js     800ff0 <getchar+0x24>
	if (r < 1)
  800fea:	74 06                	je     800ff2 <getchar+0x26>
	return c;
  800fec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    
		return -E_EOF;
  800ff2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800ff7:	eb f7                	jmp    800ff0 <getchar+0x24>

00800ff9 <iscons>:
{
  800ff9:	f3 0f 1e fb          	endbr32 
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801003:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801006:	50                   	push   %eax
  801007:	ff 75 08             	pushl  0x8(%ebp)
  80100a:	e8 71 f3 ff ff       	call   800380 <fd_lookup>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 11                	js     801027 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801019:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80101f:	39 10                	cmp    %edx,(%eax)
  801021:	0f 94 c0             	sete   %al
  801024:	0f b6 c0             	movzbl %al,%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <opencons>:
{
  801029:	f3 0f 1e fb          	endbr32 
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801033:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801036:	50                   	push   %eax
  801037:	e8 ee f2 ff ff       	call   80032a <fd_alloc>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 3a                	js     80107d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	68 07 04 00 00       	push   $0x407
  80104b:	ff 75 f4             	pushl  -0xc(%ebp)
  80104e:	6a 00                	push   $0x0
  801050:	e8 65 f1 ff ff       	call   8001ba <sys_page_alloc>
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 21                	js     80107d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80105c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801065:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	e8 7d f2 ff ff       	call   8002f7 <fd2num>
  80107a:	83 c4 10             	add    $0x10,%esp
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80107f:	f3 0f 1e fb          	endbr32 
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801088:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80108b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801091:	e8 d1 f0 ff ff       	call   800167 <sys_getenvid>
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	56                   	push   %esi
  8010a0:	50                   	push   %eax
  8010a1:	68 50 1f 80 00       	push   $0x801f50
  8010a6:	e8 bb 00 00 00       	call   801166 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010ab:	83 c4 18             	add    $0x18,%esp
  8010ae:	53                   	push   %ebx
  8010af:	ff 75 10             	pushl  0x10(%ebp)
  8010b2:	e8 5a 00 00 00       	call   801111 <vcprintf>
	cprintf("\n");
  8010b7:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010be:	e8 a3 00 00 00       	call   801166 <cprintf>
  8010c3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010c6:	cc                   	int3   
  8010c7:	eb fd                	jmp    8010c6 <_panic+0x47>

008010c9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010c9:	f3 0f 1e fb          	endbr32 
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	53                   	push   %ebx
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010d7:	8b 13                	mov    (%ebx),%edx
  8010d9:	8d 42 01             	lea    0x1(%edx),%eax
  8010dc:	89 03                	mov    %eax,(%ebx)
  8010de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010ea:	74 09                	je     8010f5 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010ec:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8010f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8010f5:	83 ec 08             	sub    $0x8,%esp
  8010f8:	68 ff 00 00 00       	push   $0xff
  8010fd:	8d 43 08             	lea    0x8(%ebx),%eax
  801100:	50                   	push   %eax
  801101:	e8 e9 ef ff ff       	call   8000ef <sys_cputs>
		b->idx = 0;
  801106:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	eb db                	jmp    8010ec <putch+0x23>

00801111 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801111:	f3 0f 1e fb          	endbr32 
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80111e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801125:	00 00 00 
	b.cnt = 0;
  801128:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80112f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	68 c9 10 80 00       	push   $0x8010c9
  801144:	e8 80 01 00 00       	call   8012c9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801149:	83 c4 08             	add    $0x8,%esp
  80114c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801152:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801158:	50                   	push   %eax
  801159:	e8 91 ef ff ff       	call   8000ef <sys_cputs>

	return b.cnt;
}
  80115e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801166:	f3 0f 1e fb          	endbr32 
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801170:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801173:	50                   	push   %eax
  801174:	ff 75 08             	pushl  0x8(%ebp)
  801177:	e8 95 ff ff ff       	call   801111 <vcprintf>
	va_end(ap);

	return cnt;
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	57                   	push   %edi
  801182:	56                   	push   %esi
  801183:	53                   	push   %ebx
  801184:	83 ec 1c             	sub    $0x1c,%esp
  801187:	89 c7                	mov    %eax,%edi
  801189:	89 d6                	mov    %edx,%esi
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801191:	89 d1                	mov    %edx,%ecx
  801193:	89 c2                	mov    %eax,%edx
  801195:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801198:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011ab:	39 c2                	cmp    %eax,%edx
  8011ad:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011b0:	72 3e                	jb     8011f0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011b2:	83 ec 0c             	sub    $0xc,%esp
  8011b5:	ff 75 18             	pushl  0x18(%ebp)
  8011b8:	83 eb 01             	sub    $0x1,%ebx
  8011bb:	53                   	push   %ebx
  8011bc:	50                   	push   %eax
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8011c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8011c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8011cc:	e8 bf 09 00 00       	call   801b90 <__udivdi3>
  8011d1:	83 c4 18             	add    $0x18,%esp
  8011d4:	52                   	push   %edx
  8011d5:	50                   	push   %eax
  8011d6:	89 f2                	mov    %esi,%edx
  8011d8:	89 f8                	mov    %edi,%eax
  8011da:	e8 9f ff ff ff       	call   80117e <printnum>
  8011df:	83 c4 20             	add    $0x20,%esp
  8011e2:	eb 13                	jmp    8011f7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	56                   	push   %esi
  8011e8:	ff 75 18             	pushl  0x18(%ebp)
  8011eb:	ff d7                	call   *%edi
  8011ed:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8011f0:	83 eb 01             	sub    $0x1,%ebx
  8011f3:	85 db                	test   %ebx,%ebx
  8011f5:	7f ed                	jg     8011e4 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	56                   	push   %esi
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801201:	ff 75 e0             	pushl  -0x20(%ebp)
  801204:	ff 75 dc             	pushl  -0x24(%ebp)
  801207:	ff 75 d8             	pushl  -0x28(%ebp)
  80120a:	e8 91 0a 00 00       	call   801ca0 <__umoddi3>
  80120f:	83 c4 14             	add    $0x14,%esp
  801212:	0f be 80 73 1f 80 00 	movsbl 0x801f73(%eax),%eax
  801219:	50                   	push   %eax
  80121a:	ff d7                	call   *%edi
}
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801222:	5b                   	pop    %ebx
  801223:	5e                   	pop    %esi
  801224:	5f                   	pop    %edi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    

00801227 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801227:	83 fa 01             	cmp    $0x1,%edx
  80122a:	7f 13                	jg     80123f <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  80122c:	85 d2                	test   %edx,%edx
  80122e:	74 1c                	je     80124c <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801230:	8b 10                	mov    (%eax),%edx
  801232:	8d 4a 04             	lea    0x4(%edx),%ecx
  801235:	89 08                	mov    %ecx,(%eax)
  801237:	8b 02                	mov    (%edx),%eax
  801239:	ba 00 00 00 00       	mov    $0x0,%edx
  80123e:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80123f:	8b 10                	mov    (%eax),%edx
  801241:	8d 4a 08             	lea    0x8(%edx),%ecx
  801244:	89 08                	mov    %ecx,(%eax)
  801246:	8b 02                	mov    (%edx),%eax
  801248:	8b 52 04             	mov    0x4(%edx),%edx
  80124b:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80124c:	8b 10                	mov    (%eax),%edx
  80124e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801251:	89 08                	mov    %ecx,(%eax)
  801253:	8b 02                	mov    (%edx),%eax
  801255:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80125a:	c3                   	ret    

0080125b <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80125b:	83 fa 01             	cmp    $0x1,%edx
  80125e:	7f 0f                	jg     80126f <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801260:	85 d2                	test   %edx,%edx
  801262:	74 18                	je     80127c <getint+0x21>
		return va_arg(*ap, long);
  801264:	8b 10                	mov    (%eax),%edx
  801266:	8d 4a 04             	lea    0x4(%edx),%ecx
  801269:	89 08                	mov    %ecx,(%eax)
  80126b:	8b 02                	mov    (%edx),%eax
  80126d:	99                   	cltd   
  80126e:	c3                   	ret    
		return va_arg(*ap, long long);
  80126f:	8b 10                	mov    (%eax),%edx
  801271:	8d 4a 08             	lea    0x8(%edx),%ecx
  801274:	89 08                	mov    %ecx,(%eax)
  801276:	8b 02                	mov    (%edx),%eax
  801278:	8b 52 04             	mov    0x4(%edx),%edx
  80127b:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80127c:	8b 10                	mov    (%eax),%edx
  80127e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801281:	89 08                	mov    %ecx,(%eax)
  801283:	8b 02                	mov    (%edx),%eax
  801285:	99                   	cltd   
}
  801286:	c3                   	ret    

00801287 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801287:	f3 0f 1e fb          	endbr32 
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801291:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801295:	8b 10                	mov    (%eax),%edx
  801297:	3b 50 04             	cmp    0x4(%eax),%edx
  80129a:	73 0a                	jae    8012a6 <sprintputch+0x1f>
		*b->buf++ = ch;
  80129c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129f:	89 08                	mov    %ecx,(%eax)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	88 02                	mov    %al,(%edx)
}
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <printfmt>:
{
  8012a8:	f3 0f 1e fb          	endbr32 
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012b5:	50                   	push   %eax
  8012b6:	ff 75 10             	pushl  0x10(%ebp)
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	ff 75 08             	pushl  0x8(%ebp)
  8012bf:	e8 05 00 00 00       	call   8012c9 <vprintfmt>
}
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <vprintfmt>:
{
  8012c9:	f3 0f 1e fb          	endbr32 
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	57                   	push   %edi
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
  8012d3:	83 ec 2c             	sub    $0x2c,%esp
  8012d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012df:	e9 86 02 00 00       	jmp    80156a <vprintfmt+0x2a1>
		padc = ' ';
  8012e4:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012fd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801302:	8d 47 01             	lea    0x1(%edi),%eax
  801305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801308:	0f b6 17             	movzbl (%edi),%edx
  80130b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80130e:	3c 55                	cmp    $0x55,%al
  801310:	0f 87 df 02 00 00    	ja     8015f5 <vprintfmt+0x32c>
  801316:	0f b6 c0             	movzbl %al,%eax
  801319:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801320:	00 
  801321:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801324:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801328:	eb d8                	jmp    801302 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80132a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80132d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801331:	eb cf                	jmp    801302 <vprintfmt+0x39>
  801333:	0f b6 d2             	movzbl %dl,%edx
  801336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801341:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801344:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801348:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80134b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80134e:	83 f9 09             	cmp    $0x9,%ecx
  801351:	77 52                	ja     8013a5 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801353:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801356:	eb e9                	jmp    801341 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801358:	8b 45 14             	mov    0x14(%ebp),%eax
  80135b:	8d 50 04             	lea    0x4(%eax),%edx
  80135e:	89 55 14             	mov    %edx,0x14(%ebp)
  801361:	8b 00                	mov    (%eax),%eax
  801363:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801369:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136d:	79 93                	jns    801302 <vprintfmt+0x39>
				width = precision, precision = -1;
  80136f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801372:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801375:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80137c:	eb 84                	jmp    801302 <vprintfmt+0x39>
  80137e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801381:	85 c0                	test   %eax,%eax
  801383:	ba 00 00 00 00       	mov    $0x0,%edx
  801388:	0f 49 d0             	cmovns %eax,%edx
  80138b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80138e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801391:	e9 6c ff ff ff       	jmp    801302 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801399:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013a0:	e9 5d ff ff ff       	jmp    801302 <vprintfmt+0x39>
  8013a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013ab:	eb bc                	jmp    801369 <vprintfmt+0xa0>
			lflag++;
  8013ad:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b3:	e9 4a ff ff ff       	jmp    801302 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8d 50 04             	lea    0x4(%eax),%edx
  8013be:	89 55 14             	mov    %edx,0x14(%ebp)
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	56                   	push   %esi
  8013c5:	ff 30                	pushl  (%eax)
  8013c7:	ff d3                	call   *%ebx
			break;
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	e9 96 01 00 00       	jmp    801567 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d4:	8d 50 04             	lea    0x4(%eax),%edx
  8013d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8013da:	8b 00                	mov    (%eax),%eax
  8013dc:	99                   	cltd   
  8013dd:	31 d0                	xor    %edx,%eax
  8013df:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013e1:	83 f8 0f             	cmp    $0xf,%eax
  8013e4:	7f 20                	jg     801406 <vprintfmt+0x13d>
  8013e6:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8013ed:	85 d2                	test   %edx,%edx
  8013ef:	74 15                	je     801406 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8013f1:	52                   	push   %edx
  8013f2:	68 03 1f 80 00       	push   $0x801f03
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	e8 aa fe ff ff       	call   8012a8 <printfmt>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	e9 61 01 00 00       	jmp    801567 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  801406:	50                   	push   %eax
  801407:	68 8b 1f 80 00       	push   $0x801f8b
  80140c:	56                   	push   %esi
  80140d:	53                   	push   %ebx
  80140e:	e8 95 fe ff ff       	call   8012a8 <printfmt>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	e9 4c 01 00 00       	jmp    801567 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80141b:	8b 45 14             	mov    0x14(%ebp),%eax
  80141e:	8d 50 04             	lea    0x4(%eax),%edx
  801421:	89 55 14             	mov    %edx,0x14(%ebp)
  801424:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  801426:	85 c9                	test   %ecx,%ecx
  801428:	b8 84 1f 80 00       	mov    $0x801f84,%eax
  80142d:	0f 45 c1             	cmovne %ecx,%eax
  801430:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801433:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801437:	7e 06                	jle    80143f <vprintfmt+0x176>
  801439:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80143d:	75 0d                	jne    80144c <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80143f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801442:	89 c7                	mov    %eax,%edi
  801444:	03 45 e0             	add    -0x20(%ebp),%eax
  801447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80144a:	eb 57                	jmp    8014a3 <vprintfmt+0x1da>
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 d8             	pushl  -0x28(%ebp)
  801452:	ff 75 cc             	pushl  -0x34(%ebp)
  801455:	e8 4f 02 00 00       	call   8016a9 <strnlen>
  80145a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145d:	29 c2                	sub    %eax,%edx
  80145f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801462:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801465:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801469:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80146c:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80146e:	85 db                	test   %ebx,%ebx
  801470:	7e 10                	jle    801482 <vprintfmt+0x1b9>
					putch(padc, putdat);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	56                   	push   %esi
  801476:	57                   	push   %edi
  801477:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80147a:	83 eb 01             	sub    $0x1,%ebx
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	eb ec                	jmp    80146e <vprintfmt+0x1a5>
  801482:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801488:	85 d2                	test   %edx,%edx
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	0f 49 c2             	cmovns %edx,%eax
  801492:	29 c2                	sub    %eax,%edx
  801494:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801497:	eb a6                	jmp    80143f <vprintfmt+0x176>
					putch(ch, putdat);
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	56                   	push   %esi
  80149d:	52                   	push   %edx
  80149e:	ff d3                	call   *%ebx
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014a8:	83 c7 01             	add    $0x1,%edi
  8014ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014af:	0f be d0             	movsbl %al,%edx
  8014b2:	85 d2                	test   %edx,%edx
  8014b4:	74 42                	je     8014f8 <vprintfmt+0x22f>
  8014b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014ba:	78 06                	js     8014c2 <vprintfmt+0x1f9>
  8014bc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c0:	78 1e                	js     8014e0 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014c6:	74 d1                	je     801499 <vprintfmt+0x1d0>
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 20             	sub    $0x20,%eax
  8014ce:	83 f8 5e             	cmp    $0x5e,%eax
  8014d1:	76 c6                	jbe    801499 <vprintfmt+0x1d0>
					putch('?', putdat);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	56                   	push   %esi
  8014d7:	6a 3f                	push   $0x3f
  8014d9:	ff d3                	call   *%ebx
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	eb c3                	jmp    8014a3 <vprintfmt+0x1da>
  8014e0:	89 cf                	mov    %ecx,%edi
  8014e2:	eb 0e                	jmp    8014f2 <vprintfmt+0x229>
				putch(' ', putdat);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	56                   	push   %esi
  8014e8:	6a 20                	push   $0x20
  8014ea:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8014ec:	83 ef 01             	sub    $0x1,%edi
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 ff                	test   %edi,%edi
  8014f4:	7f ee                	jg     8014e4 <vprintfmt+0x21b>
  8014f6:	eb 6f                	jmp    801567 <vprintfmt+0x29e>
  8014f8:	89 cf                	mov    %ecx,%edi
  8014fa:	eb f6                	jmp    8014f2 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8014fc:	89 ca                	mov    %ecx,%edx
  8014fe:	8d 45 14             	lea    0x14(%ebp),%eax
  801501:	e8 55 fd ff ff       	call   80125b <getint>
  801506:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801509:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80150c:	85 d2                	test   %edx,%edx
  80150e:	78 0b                	js     80151b <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801510:	89 d1                	mov    %edx,%ecx
  801512:	89 c2                	mov    %eax,%edx
			base = 10;
  801514:	b8 0a 00 00 00       	mov    $0xa,%eax
  801519:	eb 32                	jmp    80154d <vprintfmt+0x284>
				putch('-', putdat);
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	56                   	push   %esi
  80151f:	6a 2d                	push   $0x2d
  801521:	ff d3                	call   *%ebx
				num = -(long long) num;
  801523:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801526:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801529:	f7 da                	neg    %edx
  80152b:	83 d1 00             	adc    $0x0,%ecx
  80152e:	f7 d9                	neg    %ecx
  801530:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801533:	b8 0a 00 00 00       	mov    $0xa,%eax
  801538:	eb 13                	jmp    80154d <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80153a:	89 ca                	mov    %ecx,%edx
  80153c:	8d 45 14             	lea    0x14(%ebp),%eax
  80153f:	e8 e3 fc ff ff       	call   801227 <getuint>
  801544:	89 d1                	mov    %edx,%ecx
  801546:	89 c2                	mov    %eax,%edx
			base = 10;
  801548:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801554:	57                   	push   %edi
  801555:	ff 75 e0             	pushl  -0x20(%ebp)
  801558:	50                   	push   %eax
  801559:	51                   	push   %ecx
  80155a:	52                   	push   %edx
  80155b:	89 f2                	mov    %esi,%edx
  80155d:	89 d8                	mov    %ebx,%eax
  80155f:	e8 1a fc ff ff       	call   80117e <printnum>
			break;
  801564:	83 c4 20             	add    $0x20,%esp
{
  801567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80156a:	83 c7 01             	add    $0x1,%edi
  80156d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801571:	83 f8 25             	cmp    $0x25,%eax
  801574:	0f 84 6a fd ff ff    	je     8012e4 <vprintfmt+0x1b>
			if (ch == '\0')
  80157a:	85 c0                	test   %eax,%eax
  80157c:	0f 84 93 00 00 00    	je     801615 <vprintfmt+0x34c>
			putch(ch, putdat);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	56                   	push   %esi
  801586:	50                   	push   %eax
  801587:	ff d3                	call   *%ebx
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	eb dc                	jmp    80156a <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80158e:	89 ca                	mov    %ecx,%edx
  801590:	8d 45 14             	lea    0x14(%ebp),%eax
  801593:	e8 8f fc ff ff       	call   801227 <getuint>
  801598:	89 d1                	mov    %edx,%ecx
  80159a:	89 c2                	mov    %eax,%edx
			base = 8;
  80159c:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015a1:	eb aa                	jmp    80154d <vprintfmt+0x284>
			putch('0', putdat);
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	56                   	push   %esi
  8015a7:	6a 30                	push   $0x30
  8015a9:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015ab:	83 c4 08             	add    $0x8,%esp
  8015ae:	56                   	push   %esi
  8015af:	6a 78                	push   $0x78
  8015b1:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8d 50 04             	lea    0x4(%eax),%edx
  8015b9:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015bc:	8b 10                	mov    (%eax),%edx
  8015be:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015c3:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015c6:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015cb:	eb 80                	jmp    80154d <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015cd:	89 ca                	mov    %ecx,%edx
  8015cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8015d2:	e8 50 fc ff ff       	call   801227 <getuint>
  8015d7:	89 d1                	mov    %edx,%ecx
  8015d9:	89 c2                	mov    %eax,%edx
			base = 16;
  8015db:	b8 10 00 00 00       	mov    $0x10,%eax
  8015e0:	e9 68 ff ff ff       	jmp    80154d <vprintfmt+0x284>
			putch(ch, putdat);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	56                   	push   %esi
  8015e9:	6a 25                	push   $0x25
  8015eb:	ff d3                	call   *%ebx
			break;
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	e9 72 ff ff ff       	jmp    801567 <vprintfmt+0x29e>
			putch('%', putdat);
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	56                   	push   %esi
  8015f9:	6a 25                	push   $0x25
  8015fb:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	89 f8                	mov    %edi,%eax
  801602:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801606:	74 05                	je     80160d <vprintfmt+0x344>
  801608:	83 e8 01             	sub    $0x1,%eax
  80160b:	eb f5                	jmp    801602 <vprintfmt+0x339>
  80160d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801610:	e9 52 ff ff ff       	jmp    801567 <vprintfmt+0x29e>
}
  801615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5f                   	pop    %edi
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80161d:	f3 0f 1e fb          	endbr32 
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80162d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801630:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801634:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801637:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80163e:	85 c0                	test   %eax,%eax
  801640:	74 26                	je     801668 <vsnprintf+0x4b>
  801642:	85 d2                	test   %edx,%edx
  801644:	7e 22                	jle    801668 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801646:	ff 75 14             	pushl  0x14(%ebp)
  801649:	ff 75 10             	pushl  0x10(%ebp)
  80164c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80164f:	50                   	push   %eax
  801650:	68 87 12 80 00       	push   $0x801287
  801655:	e8 6f fc ff ff       	call   8012c9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80165a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	83 c4 10             	add    $0x10,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    
		return -E_INVAL;
  801668:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166d:	eb f7                	jmp    801666 <vsnprintf+0x49>

0080166f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80166f:	f3 0f 1e fb          	endbr32 
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801679:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80167c:	50                   	push   %eax
  80167d:	ff 75 10             	pushl  0x10(%ebp)
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	ff 75 08             	pushl  0x8(%ebp)
  801686:	e8 92 ff ff ff       	call   80161d <vsnprintf>
	va_end(ap);

	return rc;
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80168d:	f3 0f 1e fb          	endbr32 
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016a0:	74 05                	je     8016a7 <strlen+0x1a>
		n++;
  8016a2:	83 c0 01             	add    $0x1,%eax
  8016a5:	eb f5                	jmp    80169c <strlen+0xf>
	return n;
}
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016a9:	f3 0f 1e fb          	endbr32 
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	39 d0                	cmp    %edx,%eax
  8016bd:	74 0d                	je     8016cc <strnlen+0x23>
  8016bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016c3:	74 05                	je     8016ca <strnlen+0x21>
		n++;
  8016c5:	83 c0 01             	add    $0x1,%eax
  8016c8:	eb f1                	jmp    8016bb <strnlen+0x12>
  8016ca:	89 c2                	mov    %eax,%edx
	return n;
}
  8016cc:	89 d0                	mov    %edx,%eax
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d0:	f3 0f 1e fb          	endbr32 
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016e7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016ea:	83 c0 01             	add    $0x1,%eax
  8016ed:	84 d2                	test   %dl,%dl
  8016ef:	75 f2                	jne    8016e3 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8016f1:	89 c8                	mov    %ecx,%eax
  8016f3:	5b                   	pop    %ebx
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016f6:	f3 0f 1e fb          	endbr32 
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 10             	sub    $0x10,%esp
  801701:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801704:	53                   	push   %ebx
  801705:	e8 83 ff ff ff       	call   80168d <strlen>
  80170a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	01 d8                	add    %ebx,%eax
  801712:	50                   	push   %eax
  801713:	e8 b8 ff ff ff       	call   8016d0 <strcpy>
	return dst;
}
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80171f:	f3 0f 1e fb          	endbr32 
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	8b 75 08             	mov    0x8(%ebp),%esi
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172e:	89 f3                	mov    %esi,%ebx
  801730:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801733:	89 f0                	mov    %esi,%eax
  801735:	39 d8                	cmp    %ebx,%eax
  801737:	74 11                	je     80174a <strncpy+0x2b>
		*dst++ = *src;
  801739:	83 c0 01             	add    $0x1,%eax
  80173c:	0f b6 0a             	movzbl (%edx),%ecx
  80173f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801742:	80 f9 01             	cmp    $0x1,%cl
  801745:	83 da ff             	sbb    $0xffffffff,%edx
  801748:	eb eb                	jmp    801735 <strncpy+0x16>
	}
	return ret;
}
  80174a:	89 f0                	mov    %esi,%eax
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801750:	f3 0f 1e fb          	endbr32 
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
  801759:	8b 75 08             	mov    0x8(%ebp),%esi
  80175c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175f:	8b 55 10             	mov    0x10(%ebp),%edx
  801762:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801764:	85 d2                	test   %edx,%edx
  801766:	74 21                	je     801789 <strlcpy+0x39>
  801768:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80176c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80176e:	39 c2                	cmp    %eax,%edx
  801770:	74 14                	je     801786 <strlcpy+0x36>
  801772:	0f b6 19             	movzbl (%ecx),%ebx
  801775:	84 db                	test   %bl,%bl
  801777:	74 0b                	je     801784 <strlcpy+0x34>
			*dst++ = *src++;
  801779:	83 c1 01             	add    $0x1,%ecx
  80177c:	83 c2 01             	add    $0x1,%edx
  80177f:	88 5a ff             	mov    %bl,-0x1(%edx)
  801782:	eb ea                	jmp    80176e <strlcpy+0x1e>
  801784:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801786:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801789:	29 f0                	sub    %esi,%eax
}
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80178f:	f3 0f 1e fb          	endbr32 
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801799:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80179c:	0f b6 01             	movzbl (%ecx),%eax
  80179f:	84 c0                	test   %al,%al
  8017a1:	74 0c                	je     8017af <strcmp+0x20>
  8017a3:	3a 02                	cmp    (%edx),%al
  8017a5:	75 08                	jne    8017af <strcmp+0x20>
		p++, q++;
  8017a7:	83 c1 01             	add    $0x1,%ecx
  8017aa:	83 c2 01             	add    $0x1,%edx
  8017ad:	eb ed                	jmp    80179c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017af:	0f b6 c0             	movzbl %al,%eax
  8017b2:	0f b6 12             	movzbl (%edx),%edx
  8017b5:	29 d0                	sub    %edx,%eax
}
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017b9:	f3 0f 1e fb          	endbr32 
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	53                   	push   %ebx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017cc:	eb 06                	jmp    8017d4 <strncmp+0x1b>
		n--, p++, q++;
  8017ce:	83 c0 01             	add    $0x1,%eax
  8017d1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017d4:	39 d8                	cmp    %ebx,%eax
  8017d6:	74 16                	je     8017ee <strncmp+0x35>
  8017d8:	0f b6 08             	movzbl (%eax),%ecx
  8017db:	84 c9                	test   %cl,%cl
  8017dd:	74 04                	je     8017e3 <strncmp+0x2a>
  8017df:	3a 0a                	cmp    (%edx),%cl
  8017e1:	74 eb                	je     8017ce <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017e3:	0f b6 00             	movzbl (%eax),%eax
  8017e6:	0f b6 12             	movzbl (%edx),%edx
  8017e9:	29 d0                	sub    %edx,%eax
}
  8017eb:	5b                   	pop    %ebx
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    
		return 0;
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f3:	eb f6                	jmp    8017eb <strncmp+0x32>

008017f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f5:	f3 0f 1e fb          	endbr32 
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801803:	0f b6 10             	movzbl (%eax),%edx
  801806:	84 d2                	test   %dl,%dl
  801808:	74 09                	je     801813 <strchr+0x1e>
		if (*s == c)
  80180a:	38 ca                	cmp    %cl,%dl
  80180c:	74 0a                	je     801818 <strchr+0x23>
	for (; *s; s++)
  80180e:	83 c0 01             	add    $0x1,%eax
  801811:	eb f0                	jmp    801803 <strchr+0xe>
			return (char *) s;
	return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80181a:	f3 0f 1e fb          	endbr32 
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801828:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80182b:	38 ca                	cmp    %cl,%dl
  80182d:	74 09                	je     801838 <strfind+0x1e>
  80182f:	84 d2                	test   %dl,%dl
  801831:	74 05                	je     801838 <strfind+0x1e>
	for (; *s; s++)
  801833:	83 c0 01             	add    $0x1,%eax
  801836:	eb f0                	jmp    801828 <strfind+0xe>
			break;
	return (char *) s;
}
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    

0080183a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80183a:	f3 0f 1e fb          	endbr32 
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	57                   	push   %edi
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	8b 55 08             	mov    0x8(%ebp),%edx
  801847:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80184a:	85 c9                	test   %ecx,%ecx
  80184c:	74 33                	je     801881 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80184e:	89 d0                	mov    %edx,%eax
  801850:	09 c8                	or     %ecx,%eax
  801852:	a8 03                	test   $0x3,%al
  801854:	75 23                	jne    801879 <memset+0x3f>
		c &= 0xFF;
  801856:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	c1 e0 08             	shl    $0x8,%eax
  80185f:	89 df                	mov    %ebx,%edi
  801861:	c1 e7 18             	shl    $0x18,%edi
  801864:	89 de                	mov    %ebx,%esi
  801866:	c1 e6 10             	shl    $0x10,%esi
  801869:	09 f7                	or     %esi,%edi
  80186b:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80186d:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801870:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801872:	89 d7                	mov    %edx,%edi
  801874:	fc                   	cld    
  801875:	f3 ab                	rep stos %eax,%es:(%edi)
  801877:	eb 08                	jmp    801881 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801879:	89 d7                	mov    %edx,%edi
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	fc                   	cld    
  80187f:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801881:	89 d0                	mov    %edx,%eax
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801888:	f3 0f 1e fb          	endbr32 
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	8b 75 0c             	mov    0xc(%ebp),%esi
  801897:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80189a:	39 c6                	cmp    %eax,%esi
  80189c:	73 32                	jae    8018d0 <memmove+0x48>
  80189e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018a1:	39 c2                	cmp    %eax,%edx
  8018a3:	76 2b                	jbe    8018d0 <memmove+0x48>
		s += n;
		d += n;
  8018a5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018a8:	89 fe                	mov    %edi,%esi
  8018aa:	09 ce                	or     %ecx,%esi
  8018ac:	09 d6                	or     %edx,%esi
  8018ae:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018b4:	75 0e                	jne    8018c4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018b6:	83 ef 04             	sub    $0x4,%edi
  8018b9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018bc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018bf:	fd                   	std    
  8018c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018c2:	eb 09                	jmp    8018cd <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018c4:	83 ef 01             	sub    $0x1,%edi
  8018c7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018ca:	fd                   	std    
  8018cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018cd:	fc                   	cld    
  8018ce:	eb 1a                	jmp    8018ea <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	09 ca                	or     %ecx,%edx
  8018d4:	09 f2                	or     %esi,%edx
  8018d6:	f6 c2 03             	test   $0x3,%dl
  8018d9:	75 0a                	jne    8018e5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018db:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018de:	89 c7                	mov    %eax,%edi
  8018e0:	fc                   	cld    
  8018e1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018e3:	eb 05                	jmp    8018ea <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018e5:	89 c7                	mov    %eax,%edi
  8018e7:	fc                   	cld    
  8018e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018ea:	5e                   	pop    %esi
  8018eb:	5f                   	pop    %edi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018ee:	f3 0f 1e fb          	endbr32 
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	e8 82 ff ff ff       	call   801888 <memmove>
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801908:	f3 0f 1e fb          	endbr32 
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	89 c6                	mov    %eax,%esi
  801919:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80191c:	39 f0                	cmp    %esi,%eax
  80191e:	74 1c                	je     80193c <memcmp+0x34>
		if (*s1 != *s2)
  801920:	0f b6 08             	movzbl (%eax),%ecx
  801923:	0f b6 1a             	movzbl (%edx),%ebx
  801926:	38 d9                	cmp    %bl,%cl
  801928:	75 08                	jne    801932 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80192a:	83 c0 01             	add    $0x1,%eax
  80192d:	83 c2 01             	add    $0x1,%edx
  801930:	eb ea                	jmp    80191c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801932:	0f b6 c1             	movzbl %cl,%eax
  801935:	0f b6 db             	movzbl %bl,%ebx
  801938:	29 d8                	sub    %ebx,%eax
  80193a:	eb 05                	jmp    801941 <memcmp+0x39>
	}

	return 0;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801945:	f3 0f 1e fb          	endbr32 
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801952:	89 c2                	mov    %eax,%edx
  801954:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801957:	39 d0                	cmp    %edx,%eax
  801959:	73 09                	jae    801964 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80195b:	38 08                	cmp    %cl,(%eax)
  80195d:	74 05                	je     801964 <memfind+0x1f>
	for (; s < ends; s++)
  80195f:	83 c0 01             	add    $0x1,%eax
  801962:	eb f3                	jmp    801957 <memfind+0x12>
			break;
	return (void *) s;
}
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801966:	f3 0f 1e fb          	endbr32 
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801973:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801976:	eb 03                	jmp    80197b <strtol+0x15>
		s++;
  801978:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80197b:	0f b6 01             	movzbl (%ecx),%eax
  80197e:	3c 20                	cmp    $0x20,%al
  801980:	74 f6                	je     801978 <strtol+0x12>
  801982:	3c 09                	cmp    $0x9,%al
  801984:	74 f2                	je     801978 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801986:	3c 2b                	cmp    $0x2b,%al
  801988:	74 2a                	je     8019b4 <strtol+0x4e>
	int neg = 0;
  80198a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80198f:	3c 2d                	cmp    $0x2d,%al
  801991:	74 2b                	je     8019be <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801993:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801999:	75 0f                	jne    8019aa <strtol+0x44>
  80199b:	80 39 30             	cmpb   $0x30,(%ecx)
  80199e:	74 28                	je     8019c8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019a0:	85 db                	test   %ebx,%ebx
  8019a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a7:	0f 44 d8             	cmove  %eax,%ebx
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019af:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019b2:	eb 46                	jmp    8019fa <strtol+0x94>
		s++;
  8019b4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8019bc:	eb d5                	jmp    801993 <strtol+0x2d>
		s++, neg = 1;
  8019be:	83 c1 01             	add    $0x1,%ecx
  8019c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8019c6:	eb cb                	jmp    801993 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019cc:	74 0e                	je     8019dc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019ce:	85 db                	test   %ebx,%ebx
  8019d0:	75 d8                	jne    8019aa <strtol+0x44>
		s++, base = 8;
  8019d2:	83 c1 01             	add    $0x1,%ecx
  8019d5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019da:	eb ce                	jmp    8019aa <strtol+0x44>
		s += 2, base = 16;
  8019dc:	83 c1 02             	add    $0x2,%ecx
  8019df:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019e4:	eb c4                	jmp    8019aa <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019e6:	0f be d2             	movsbl %dl,%edx
  8019e9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019ec:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019ef:	7d 3a                	jge    801a2b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019f1:	83 c1 01             	add    $0x1,%ecx
  8019f4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019fa:	0f b6 11             	movzbl (%ecx),%edx
  8019fd:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a00:	89 f3                	mov    %esi,%ebx
  801a02:	80 fb 09             	cmp    $0x9,%bl
  801a05:	76 df                	jbe    8019e6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a07:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a0a:	89 f3                	mov    %esi,%ebx
  801a0c:	80 fb 19             	cmp    $0x19,%bl
  801a0f:	77 08                	ja     801a19 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a11:	0f be d2             	movsbl %dl,%edx
  801a14:	83 ea 57             	sub    $0x57,%edx
  801a17:	eb d3                	jmp    8019ec <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a19:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a1c:	89 f3                	mov    %esi,%ebx
  801a1e:	80 fb 19             	cmp    $0x19,%bl
  801a21:	77 08                	ja     801a2b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a23:	0f be d2             	movsbl %dl,%edx
  801a26:	83 ea 37             	sub    $0x37,%edx
  801a29:	eb c1                	jmp    8019ec <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2f:	74 05                	je     801a36 <strtol+0xd0>
		*endptr = (char *) s;
  801a31:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a34:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a36:	89 c2                	mov    %eax,%edx
  801a38:	f7 da                	neg    %edx
  801a3a:	85 ff                	test   %edi,%edi
  801a3c:	0f 45 c2             	cmovne %edx,%eax
}
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a44:	f3 0f 1e fb          	endbr32 
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  801a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a56:	85 c0                	test   %eax,%eax
  801a58:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a5d:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	50                   	push   %eax
  801a64:	e8 68 e8 ff ff       	call   8002d1 <sys_ipc_recv>
	if (r < 0) {
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 2b                	js     801a9b <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a70:	85 f6                	test   %esi,%esi
  801a72:	74 0a                	je     801a7e <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a74:	a1 04 40 80 00       	mov    0x804004,%eax
  801a79:	8b 40 74             	mov    0x74(%eax),%eax
  801a7c:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a7e:	85 db                	test   %ebx,%ebx
  801a80:	74 0a                	je     801a8c <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a82:	a1 04 40 80 00       	mov    0x804004,%eax
  801a87:	8b 40 78             	mov    0x78(%eax),%eax
  801a8a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801a8c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a91:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    
		if (from_env_store) {
  801a9b:	85 f6                	test   %esi,%esi
  801a9d:	74 06                	je     801aa5 <ipc_recv+0x61>
			*from_env_store = 0;
  801a9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801aa5:	85 db                	test   %ebx,%ebx
  801aa7:	74 eb                	je     801a94 <ipc_recv+0x50>
			*perm_store = 0;
  801aa9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801aaf:	eb e3                	jmp    801a94 <ipc_recv+0x50>

00801ab1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ab1:	f3 0f 1e fb          	endbr32 
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	57                   	push   %edi
  801ab9:	56                   	push   %esi
  801aba:	53                   	push   %ebx
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ac1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ac4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801ac7:	85 db                	test   %ebx,%ebx
  801ac9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ace:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ad1:	ff 75 14             	pushl  0x14(%ebp)
  801ad4:	53                   	push   %ebx
  801ad5:	56                   	push   %esi
  801ad6:	57                   	push   %edi
  801ad7:	e8 cc e7 ff ff       	call   8002a8 <sys_ipc_try_send>
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ae2:	75 07                	jne    801aeb <ipc_send+0x3a>
		sys_yield();
  801ae4:	e8 a6 e6 ff ff       	call   80018f <sys_yield>
  801ae9:	eb e6                	jmp    801ad1 <ipc_send+0x20>
	}

	if (ret < 0) {
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 08                	js     801af7 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5f                   	pop    %edi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801af7:	50                   	push   %eax
  801af8:	68 7f 22 80 00       	push   $0x80227f
  801afd:	6a 48                	push   $0x48
  801aff:	68 9c 22 80 00       	push   $0x80229c
  801b04:	e8 76 f5 ff ff       	call   80107f <_panic>

00801b09 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b09:	f3 0f 1e fb          	endbr32 
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b18:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b1b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b21:	8b 52 50             	mov    0x50(%edx),%edx
  801b24:	39 ca                	cmp    %ecx,%edx
  801b26:	74 11                	je     801b39 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b28:	83 c0 01             	add    $0x1,%eax
  801b2b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b30:	75 e6                	jne    801b18 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
  801b37:	eb 0b                	jmp    801b44 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b39:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b3c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b41:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b46:	f3 0f 1e fb          	endbr32 
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	c1 ea 16             	shr    $0x16,%edx
  801b55:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b61:	f6 c1 01             	test   $0x1,%cl
  801b64:	74 1c                	je     801b82 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b66:	c1 e8 0c             	shr    $0xc,%eax
  801b69:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b70:	a8 01                	test   $0x1,%al
  801b72:	74 0e                	je     801b82 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b74:	c1 e8 0c             	shr    $0xc,%eax
  801b77:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b7e:	ef 
  801b7f:	0f b7 d2             	movzwl %dx,%edx
}
  801b82:	89 d0                	mov    %edx,%eax
  801b84:	5d                   	pop    %ebp
  801b85:	c3                   	ret    
  801b86:	66 90                	xchg   %ax,%ax
  801b88:	66 90                	xchg   %ax,%ax
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	66 90                	xchg   %ax,%ax
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
