
obj/user/badsegment.debug:     formato del fichero elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	f3 0f 1e fb          	endbr32 
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80004d:	e8 19 01 00 00       	call   80016b <sys_getenvid>
	if (id >= 0)
  800052:	85 c0                	test   %eax,%eax
  800054:	78 12                	js     800068 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800063:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800068:	85 db                	test   %ebx,%ebx
  80006a:	7e 07                	jle    800073 <libmain+0x35>
		binaryname = argv[0];
  80006c:	8b 06                	mov    (%esi),%eax
  80006e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800073:	83 ec 08             	sub    $0x8,%esp
  800076:	56                   	push   %esi
  800077:	53                   	push   %ebx
  800078:	e8 b6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007d:	e8 0a 00 00 00       	call   80008c <exit>
}
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800088:	5b                   	pop    %ebx
  800089:	5e                   	pop    %esi
  80008a:	5d                   	pop    %ebp
  80008b:	c3                   	ret    

0080008c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008c:	f3 0f 1e fb          	endbr32 
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 53 04 00 00       	call   8004ee <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 a0 00 00 00       	call   800145 <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	83 ec 1c             	sub    $0x1c,%esp
  8000b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000b9:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c4:	8b 75 14             	mov    0x14(%ebp),%esi
  8000c7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000cd:	74 04                	je     8000d3 <syscall+0x29>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f 08                	jg     8000db <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	50                   	push   %eax
  8000df:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e2:	68 0a 1e 80 00       	push   $0x801e0a
  8000e7:	6a 23                	push   $0x23
  8000e9:	68 27 1e 80 00       	push   $0x801e27
  8000ee:	e8 90 0f 00 00       	call   801083 <_panic>

008000f3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000fd:	6a 00                	push   $0x0
  8000ff:	6a 00                	push   $0x0
  800101:	6a 00                	push   $0x0
  800103:	ff 75 0c             	pushl  0xc(%ebp)
  800106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800109:	ba 00 00 00 00       	mov    $0x0,%edx
  80010e:	b8 00 00 00 00       	mov    $0x0,%eax
  800113:	e8 92 ff ff ff       	call   8000aa <syscall>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    

0080011d <sys_cgetc>:

int
sys_cgetc(void)
{
  80011d:	f3 0f 1e fb          	endbr32 
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800127:	6a 00                	push   $0x0
  800129:	6a 00                	push   $0x0
  80012b:	6a 00                	push   $0x0
  80012d:	6a 00                	push   $0x0
  80012f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 01 00 00 00       	mov    $0x1,%eax
  80013e:	e8 67 ff ff ff       	call   8000aa <syscall>
}
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800145:	f3 0f 1e fb          	endbr32 
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80014f:	6a 00                	push   $0x0
  800151:	6a 00                	push   $0x0
  800153:	6a 00                	push   $0x0
  800155:	6a 00                	push   $0x0
  800157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015a:	ba 01 00 00 00       	mov    $0x1,%edx
  80015f:	b8 03 00 00 00       	mov    $0x3,%eax
  800164:	e8 41 ff ff ff       	call   8000aa <syscall>
}
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016b:	f3 0f 1e fb          	endbr32 
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800175:	6a 00                	push   $0x0
  800177:	6a 00                	push   $0x0
  800179:	6a 00                	push   $0x0
  80017b:	6a 00                	push   $0x0
  80017d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800182:	ba 00 00 00 00       	mov    $0x0,%edx
  800187:	b8 02 00 00 00       	mov    $0x2,%eax
  80018c:	e8 19 ff ff ff       	call   8000aa <syscall>
}
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <sys_yield>:

void
sys_yield(void)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80019d:	6a 00                	push   $0x0
  80019f:	6a 00                	push   $0x0
  8001a1:	6a 00                	push   $0x0
  8001a3:	6a 00                	push   $0x0
  8001a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001af:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001b4:	e8 f1 fe ff ff       	call   8000aa <syscall>
}
  8001b9:	83 c4 10             	add    $0x10,%esp
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001be:	f3 0f 1e fb          	endbr32 
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001c8:	6a 00                	push   $0x0
  8001ca:	6a 00                	push   $0x0
  8001cc:	ff 75 10             	pushl  0x10(%ebp)
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8001da:	b8 04 00 00 00       	mov    $0x4,%eax
  8001df:	e8 c6 fe ff ff       	call   8000aa <syscall>
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e6:	f3 0f 1e fb          	endbr32 
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001f0:	ff 75 18             	pushl  0x18(%ebp)
  8001f3:	ff 75 14             	pushl  0x14(%ebp)
  8001f6:	ff 75 10             	pushl  0x10(%ebp)
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ff:	ba 01 00 00 00       	mov    $0x1,%edx
  800204:	b8 05 00 00 00       	mov    $0x5,%eax
  800209:	e8 9c fe ff ff       	call   8000aa <syscall>
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80021a:	6a 00                	push   $0x0
  80021c:	6a 00                	push   $0x0
  80021e:	6a 00                	push   $0x0
  800220:	ff 75 0c             	pushl  0xc(%ebp)
  800223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800226:	ba 01 00 00 00       	mov    $0x1,%edx
  80022b:	b8 06 00 00 00       	mov    $0x6,%eax
  800230:	e8 75 fe ff ff       	call   8000aa <syscall>
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	f3 0f 1e fb          	endbr32 
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800241:	6a 00                	push   $0x0
  800243:	6a 00                	push   $0x0
  800245:	6a 00                	push   $0x0
  800247:	ff 75 0c             	pushl  0xc(%ebp)
  80024a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024d:	ba 01 00 00 00       	mov    $0x1,%edx
  800252:	b8 08 00 00 00       	mov    $0x8,%eax
  800257:	e8 4e fe ff ff       	call   8000aa <syscall>
}
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025e:	f3 0f 1e fb          	endbr32 
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800268:	6a 00                	push   $0x0
  80026a:	6a 00                	push   $0x0
  80026c:	6a 00                	push   $0x0
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800274:	ba 01 00 00 00       	mov    $0x1,%edx
  800279:	b8 09 00 00 00       	mov    $0x9,%eax
  80027e:	e8 27 fe ff ff       	call   8000aa <syscall>
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800285:	f3 0f 1e fb          	endbr32 
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80028f:	6a 00                	push   $0x0
  800291:	6a 00                	push   $0x0
  800293:	6a 00                	push   $0x0
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029b:	ba 01 00 00 00       	mov    $0x1,%edx
  8002a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a5:	e8 00 fe ff ff       	call   8000aa <syscall>
}
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002ac:	f3 0f 1e fb          	endbr32 
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002b6:	6a 00                	push   $0x0
  8002b8:	ff 75 14             	pushl  0x14(%ebp)
  8002bb:	ff 75 10             	pushl  0x10(%ebp)
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ce:	e8 d7 fd ff ff       	call   8000aa <syscall>
}
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d5:	f3 0f 1e fb          	endbr32 
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002df:	6a 00                	push   $0x0
  8002e1:	6a 00                	push   $0x0
  8002e3:	6a 00                	push   $0x0
  8002e5:	6a 00                	push   $0x0
  8002e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ea:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ef:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002f4:	e8 b1 fd ff ff       	call   8000aa <syscall>
}
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002fb:	f3 0f 1e fb          	endbr32 
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800302:	8b 45 08             	mov    0x8(%ebp),%eax
  800305:	05 00 00 00 30       	add    $0x30000000,%eax
  80030a:	c1 e8 0c             	shr    $0xc,%eax
}
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	e8 da ff ff ff       	call   8002fb <fd2num>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	c1 e0 0c             	shl    $0xc,%eax
  800327:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80032e:	f3 0f 1e fb          	endbr32 
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80033a:	89 c2                	mov    %eax,%edx
  80033c:	c1 ea 16             	shr    $0x16,%edx
  80033f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800346:	f6 c2 01             	test   $0x1,%dl
  800349:	74 2d                	je     800378 <fd_alloc+0x4a>
  80034b:	89 c2                	mov    %eax,%edx
  80034d:	c1 ea 0c             	shr    $0xc,%edx
  800350:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800357:	f6 c2 01             	test   $0x1,%dl
  80035a:	74 1c                	je     800378 <fd_alloc+0x4a>
  80035c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800361:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800366:	75 d2                	jne    80033a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800371:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800376:	eb 0a                	jmp    800382 <fd_alloc+0x54>
			*fd_store = fd;
  800378:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800384:	f3 0f 1e fb          	endbr32 
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80038e:	83 f8 1f             	cmp    $0x1f,%eax
  800391:	77 30                	ja     8003c3 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800393:	c1 e0 0c             	shl    $0xc,%eax
  800396:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80039b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003a1:	f6 c2 01             	test   $0x1,%dl
  8003a4:	74 24                	je     8003ca <fd_lookup+0x46>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	c1 ea 0c             	shr    $0xc,%edx
  8003ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b2:	f6 c2 01             	test   $0x1,%dl
  8003b5:	74 1a                	je     8003d1 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	89 02                	mov    %eax,(%edx)
	return 0;
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    
		return -E_INVAL;
  8003c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003c8:	eb f7                	jmp    8003c1 <fd_lookup+0x3d>
		return -E_INVAL;
  8003ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003cf:	eb f0                	jmp    8003c1 <fd_lookup+0x3d>
  8003d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d6:	eb e9                	jmp    8003c1 <fd_lookup+0x3d>

008003d8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003d8:	f3 0f 1e fb          	endbr32 
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e5:	ba b4 1e 80 00       	mov    $0x801eb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003ea:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003ef:	39 08                	cmp    %ecx,(%eax)
  8003f1:	74 33                	je     800426 <dev_lookup+0x4e>
  8003f3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8003f6:	8b 02                	mov    (%edx),%eax
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	75 f3                	jne    8003ef <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003fc:	a1 04 40 80 00       	mov    0x804004,%eax
  800401:	8b 40 48             	mov    0x48(%eax),%eax
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	51                   	push   %ecx
  800408:	50                   	push   %eax
  800409:	68 38 1e 80 00       	push   $0x801e38
  80040e:	e8 57 0d 00 00       	call   80116a <cprintf>
	*dev = 0;
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800424:	c9                   	leave  
  800425:	c3                   	ret    
			*dev = devtab[i];
  800426:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800429:	89 01                	mov    %eax,(%ecx)
			return 0;
  80042b:	b8 00 00 00 00       	mov    $0x0,%eax
  800430:	eb f2                	jmp    800424 <dev_lookup+0x4c>

00800432 <fd_close>:
{
  800432:	f3 0f 1e fb          	endbr32 
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	57                   	push   %edi
  80043a:	56                   	push   %esi
  80043b:	53                   	push   %ebx
  80043c:	83 ec 28             	sub    $0x28,%esp
  80043f:	8b 75 08             	mov    0x8(%ebp),%esi
  800442:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800445:	56                   	push   %esi
  800446:	e8 b0 fe ff ff       	call   8002fb <fd2num>
  80044b:	83 c4 08             	add    $0x8,%esp
  80044e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800451:	52                   	push   %edx
  800452:	50                   	push   %eax
  800453:	e8 2c ff ff ff       	call   800384 <fd_lookup>
  800458:	89 c3                	mov    %eax,%ebx
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	85 c0                	test   %eax,%eax
  80045f:	78 05                	js     800466 <fd_close+0x34>
	    || fd != fd2)
  800461:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800464:	74 16                	je     80047c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800466:	89 f8                	mov    %edi,%eax
  800468:	84 c0                	test   %al,%al
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
  80046f:	0f 44 d8             	cmove  %eax,%ebx
}
  800472:	89 d8                	mov    %ebx,%eax
  800474:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800477:	5b                   	pop    %ebx
  800478:	5e                   	pop    %esi
  800479:	5f                   	pop    %edi
  80047a:	5d                   	pop    %ebp
  80047b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800482:	50                   	push   %eax
  800483:	ff 36                	pushl  (%esi)
  800485:	e8 4e ff ff ff       	call   8003d8 <dev_lookup>
  80048a:	89 c3                	mov    %eax,%ebx
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	85 c0                	test   %eax,%eax
  800491:	78 1a                	js     8004ad <fd_close+0x7b>
		if (dev->dev_close)
  800493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800496:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800499:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	74 0b                	je     8004ad <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	56                   	push   %esi
  8004a6:	ff d0                	call   *%eax
  8004a8:	89 c3                	mov    %eax,%ebx
  8004aa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	56                   	push   %esi
  8004b1:	6a 00                	push   $0x0
  8004b3:	e8 58 fd ff ff       	call   800210 <sys_page_unmap>
	return r;
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	eb b5                	jmp    800472 <fd_close+0x40>

008004bd <close>:

int
close(int fdnum)
{
  8004bd:	f3 0f 1e fb          	endbr32 
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 08             	pushl  0x8(%ebp)
  8004ce:	e8 b1 fe ff ff       	call   800384 <fd_lookup>
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	79 02                	jns    8004dc <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    
		return fd_close(fd, 1);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	6a 01                	push   $0x1
  8004e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e4:	e8 49 ff ff ff       	call   800432 <fd_close>
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	eb ec                	jmp    8004da <close+0x1d>

008004ee <close_all>:

void
close_all(void)
{
  8004ee:	f3 0f 1e fb          	endbr32 
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004f9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	53                   	push   %ebx
  800502:	e8 b6 ff ff ff       	call   8004bd <close>
	for (i = 0; i < MAXFD; i++)
  800507:	83 c3 01             	add    $0x1,%ebx
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	83 fb 20             	cmp    $0x20,%ebx
  800510:	75 ec                	jne    8004fe <close_all+0x10>
}
  800512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800517:	f3 0f 1e fb          	endbr32 
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	57                   	push   %edi
  80051f:	56                   	push   %esi
  800520:	53                   	push   %ebx
  800521:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800524:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 54 fe ff ff       	call   800384 <fd_lookup>
  800530:	89 c3                	mov    %eax,%ebx
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	85 c0                	test   %eax,%eax
  800537:	0f 88 81 00 00 00    	js     8005be <dup+0xa7>
		return r;
	close(newfdnum);
  80053d:	83 ec 0c             	sub    $0xc,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	e8 75 ff ff ff       	call   8004bd <close>

	newfd = INDEX2FD(newfdnum);
  800548:	8b 75 0c             	mov    0xc(%ebp),%esi
  80054b:	c1 e6 0c             	shl    $0xc,%esi
  80054e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800554:	83 c4 04             	add    $0x4,%esp
  800557:	ff 75 e4             	pushl  -0x1c(%ebp)
  80055a:	e8 b0 fd ff ff       	call   80030f <fd2data>
  80055f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800561:	89 34 24             	mov    %esi,(%esp)
  800564:	e8 a6 fd ff ff       	call   80030f <fd2data>
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80056e:	89 d8                	mov    %ebx,%eax
  800570:	c1 e8 16             	shr    $0x16,%eax
  800573:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80057a:	a8 01                	test   $0x1,%al
  80057c:	74 11                	je     80058f <dup+0x78>
  80057e:	89 d8                	mov    %ebx,%eax
  800580:	c1 e8 0c             	shr    $0xc,%eax
  800583:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80058a:	f6 c2 01             	test   $0x1,%dl
  80058d:	75 39                	jne    8005c8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80058f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800592:	89 d0                	mov    %edx,%eax
  800594:	c1 e8 0c             	shr    $0xc,%eax
  800597:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8005a6:	50                   	push   %eax
  8005a7:	56                   	push   %esi
  8005a8:	6a 00                	push   $0x0
  8005aa:	52                   	push   %edx
  8005ab:	6a 00                	push   $0x0
  8005ad:	e8 34 fc ff ff       	call   8001e6 <sys_page_map>
  8005b2:	89 c3                	mov    %eax,%ebx
  8005b4:	83 c4 20             	add    $0x20,%esp
  8005b7:	85 c0                	test   %eax,%eax
  8005b9:	78 31                	js     8005ec <dup+0xd5>
		goto err;

	return newfdnum;
  8005bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005be:	89 d8                	mov    %ebx,%eax
  8005c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c3:	5b                   	pop    %ebx
  8005c4:	5e                   	pop    %esi
  8005c5:	5f                   	pop    %edi
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d7:	50                   	push   %eax
  8005d8:	57                   	push   %edi
  8005d9:	6a 00                	push   $0x0
  8005db:	53                   	push   %ebx
  8005dc:	6a 00                	push   $0x0
  8005de:	e8 03 fc ff ff       	call   8001e6 <sys_page_map>
  8005e3:	89 c3                	mov    %eax,%ebx
  8005e5:	83 c4 20             	add    $0x20,%esp
  8005e8:	85 c0                	test   %eax,%eax
  8005ea:	79 a3                	jns    80058f <dup+0x78>
	sys_page_unmap(0, newfd);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	56                   	push   %esi
  8005f0:	6a 00                	push   $0x0
  8005f2:	e8 19 fc ff ff       	call   800210 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005f7:	83 c4 08             	add    $0x8,%esp
  8005fa:	57                   	push   %edi
  8005fb:	6a 00                	push   $0x0
  8005fd:	e8 0e fc ff ff       	call   800210 <sys_page_unmap>
	return r;
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb b7                	jmp    8005be <dup+0xa7>

00800607 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800607:	f3 0f 1e fb          	endbr32 
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	53                   	push   %ebx
  80060f:	83 ec 1c             	sub    $0x1c,%esp
  800612:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800615:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800618:	50                   	push   %eax
  800619:	53                   	push   %ebx
  80061a:	e8 65 fd ff ff       	call   800384 <fd_lookup>
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	85 c0                	test   %eax,%eax
  800624:	78 3f                	js     800665 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80062c:	50                   	push   %eax
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800630:	ff 30                	pushl  (%eax)
  800632:	e8 a1 fd ff ff       	call   8003d8 <dev_lookup>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	85 c0                	test   %eax,%eax
  80063c:	78 27                	js     800665 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80063e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800641:	8b 42 08             	mov    0x8(%edx),%eax
  800644:	83 e0 03             	and    $0x3,%eax
  800647:	83 f8 01             	cmp    $0x1,%eax
  80064a:	74 1e                	je     80066a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064f:	8b 40 08             	mov    0x8(%eax),%eax
  800652:	85 c0                	test   %eax,%eax
  800654:	74 35                	je     80068b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800656:	83 ec 04             	sub    $0x4,%esp
  800659:	ff 75 10             	pushl  0x10(%ebp)
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	52                   	push   %edx
  800660:	ff d0                	call   *%eax
  800662:	83 c4 10             	add    $0x10,%esp
}
  800665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800668:	c9                   	leave  
  800669:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80066a:	a1 04 40 80 00       	mov    0x804004,%eax
  80066f:	8b 40 48             	mov    0x48(%eax),%eax
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	53                   	push   %ebx
  800676:	50                   	push   %eax
  800677:	68 79 1e 80 00       	push   $0x801e79
  80067c:	e8 e9 0a 00 00       	call   80116a <cprintf>
		return -E_INVAL;
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800689:	eb da                	jmp    800665 <read+0x5e>
		return -E_NOT_SUPP;
  80068b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800690:	eb d3                	jmp    800665 <read+0x5e>

00800692 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800692:	f3 0f 1e fb          	endbr32 
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
  800699:	57                   	push   %edi
  80069a:	56                   	push   %esi
  80069b:	53                   	push   %ebx
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006aa:	eb 02                	jmp    8006ae <readn+0x1c>
  8006ac:	01 c3                	add    %eax,%ebx
  8006ae:	39 f3                	cmp    %esi,%ebx
  8006b0:	73 21                	jae    8006d3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	29 d8                	sub    %ebx,%eax
  8006b9:	50                   	push   %eax
  8006ba:	89 d8                	mov    %ebx,%eax
  8006bc:	03 45 0c             	add    0xc(%ebp),%eax
  8006bf:	50                   	push   %eax
  8006c0:	57                   	push   %edi
  8006c1:	e8 41 ff ff ff       	call   800607 <read>
		if (m < 0)
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	78 04                	js     8006d1 <readn+0x3f>
			return m;
		if (m == 0)
  8006cd:	75 dd                	jne    8006ac <readn+0x1a>
  8006cf:	eb 02                	jmp    8006d3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006d1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006d3:	89 d8                	mov    %ebx,%eax
  8006d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d8:	5b                   	pop    %ebx
  8006d9:	5e                   	pop    %esi
  8006da:	5f                   	pop    %edi
  8006db:	5d                   	pop    %ebp
  8006dc:	c3                   	ret    

008006dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006dd:	f3 0f 1e fb          	endbr32 
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	53                   	push   %ebx
  8006e5:	83 ec 1c             	sub    $0x1c,%esp
  8006e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	53                   	push   %ebx
  8006f0:	e8 8f fc ff ff       	call   800384 <fd_lookup>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	78 3a                	js     800736 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800702:	50                   	push   %eax
  800703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800706:	ff 30                	pushl  (%eax)
  800708:	e8 cb fc ff ff       	call   8003d8 <dev_lookup>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 22                	js     800736 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800717:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80071b:	74 1e                	je     80073b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80071d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800720:	8b 52 0c             	mov    0xc(%edx),%edx
  800723:	85 d2                	test   %edx,%edx
  800725:	74 35                	je     80075c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	ff 75 10             	pushl  0x10(%ebp)
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	50                   	push   %eax
  800731:	ff d2                	call   *%edx
  800733:	83 c4 10             	add    $0x10,%esp
}
  800736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800739:	c9                   	leave  
  80073a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80073b:	a1 04 40 80 00       	mov    0x804004,%eax
  800740:	8b 40 48             	mov    0x48(%eax),%eax
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	53                   	push   %ebx
  800747:	50                   	push   %eax
  800748:	68 95 1e 80 00       	push   $0x801e95
  80074d:	e8 18 0a 00 00       	call   80116a <cprintf>
		return -E_INVAL;
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075a:	eb da                	jmp    800736 <write+0x59>
		return -E_NOT_SUPP;
  80075c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800761:	eb d3                	jmp    800736 <write+0x59>

00800763 <seek>:

int
seek(int fdnum, off_t offset)
{
  800763:	f3 0f 1e fb          	endbr32 
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80076d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	ff 75 08             	pushl  0x8(%ebp)
  800774:	e8 0b fc ff ff       	call   800384 <fd_lookup>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	85 c0                	test   %eax,%eax
  80077e:	78 0e                	js     80078e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
  800783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800786:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800790:	f3 0f 1e fb          	endbr32 
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	83 ec 1c             	sub    $0x1c,%esp
  80079b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80079e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007a1:	50                   	push   %eax
  8007a2:	53                   	push   %ebx
  8007a3:	e8 dc fb ff ff       	call   800384 <fd_lookup>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	78 37                	js     8007e6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b9:	ff 30                	pushl  (%eax)
  8007bb:	e8 18 fc ff ff       	call   8003d8 <dev_lookup>
  8007c0:	83 c4 10             	add    $0x10,%esp
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	78 1f                	js     8007e6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ce:	74 1b                	je     8007eb <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d3:	8b 52 18             	mov    0x18(%edx),%edx
  8007d6:	85 d2                	test   %edx,%edx
  8007d8:	74 32                	je     80080c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	50                   	push   %eax
  8007e1:	ff d2                	call   *%edx
  8007e3:	83 c4 10             	add    $0x10,%esp
}
  8007e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007eb:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007f0:	8b 40 48             	mov    0x48(%eax),%eax
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	50                   	push   %eax
  8007f8:	68 58 1e 80 00       	push   $0x801e58
  8007fd:	e8 68 09 00 00       	call   80116a <cprintf>
		return -E_INVAL;
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080a:	eb da                	jmp    8007e6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80080c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800811:	eb d3                	jmp    8007e6 <ftruncate+0x56>

00800813 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800813:	f3 0f 1e fb          	endbr32 
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 1c             	sub    $0x1c,%esp
  80081e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800821:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800824:	50                   	push   %eax
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 57 fb ff ff       	call   800384 <fd_lookup>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	85 c0                	test   %eax,%eax
  800832:	78 4b                	js     80087f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083a:	50                   	push   %eax
  80083b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083e:	ff 30                	pushl  (%eax)
  800840:	e8 93 fb ff ff       	call   8003d8 <dev_lookup>
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	85 c0                	test   %eax,%eax
  80084a:	78 33                	js     80087f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80084c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800853:	74 2f                	je     800884 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800855:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800858:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80085f:	00 00 00 
	stat->st_isdir = 0;
  800862:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800869:	00 00 00 
	stat->st_dev = dev;
  80086c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	ff 75 f0             	pushl  -0x10(%ebp)
  800879:	ff 50 14             	call   *0x14(%eax)
  80087c:	83 c4 10             	add    $0x10,%esp
}
  80087f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800882:	c9                   	leave  
  800883:	c3                   	ret    
		return -E_NOT_SUPP;
  800884:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800889:	eb f4                	jmp    80087f <fstat+0x6c>

0080088b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80088b:	f3 0f 1e fb          	endbr32 
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	6a 00                	push   $0x0
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 3a 02 00 00       	call   800adb <open>
  8008a1:	89 c3                	mov    %eax,%ebx
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	78 1b                	js     8008c5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	50                   	push   %eax
  8008b1:	e8 5d ff ff ff       	call   800813 <fstat>
  8008b6:	89 c6                	mov    %eax,%esi
	close(fd);
  8008b8:	89 1c 24             	mov    %ebx,(%esp)
  8008bb:	e8 fd fb ff ff       	call   8004bd <close>
	return r;
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 f3                	mov    %esi,%ebx
}
  8008c5:	89 d8                	mov    %ebx,%eax
  8008c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ca:	5b                   	pop    %ebx
  8008cb:	5e                   	pop    %esi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	56                   	push   %esi
  8008d2:	53                   	push   %ebx
  8008d3:	89 c6                	mov    %eax,%esi
  8008d5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008d7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008de:	74 27                	je     800907 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008e0:	6a 07                	push   $0x7
  8008e2:	68 00 50 80 00       	push   $0x805000
  8008e7:	56                   	push   %esi
  8008e8:	ff 35 00 40 80 00    	pushl  0x804000
  8008ee:	e8 c2 11 00 00       	call   801ab5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008f3:	83 c4 0c             	add    $0xc,%esp
  8008f6:	6a 00                	push   $0x0
  8008f8:	53                   	push   %ebx
  8008f9:	6a 00                	push   $0x0
  8008fb:	e8 48 11 00 00       	call   801a48 <ipc_recv>
}
  800900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800903:	5b                   	pop    %ebx
  800904:	5e                   	pop    %esi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800907:	83 ec 0c             	sub    $0xc,%esp
  80090a:	6a 01                	push   $0x1
  80090c:	e8 fc 11 00 00       	call   801b0d <ipc_find_env>
  800911:	a3 00 40 80 00       	mov    %eax,0x804000
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	eb c5                	jmp    8008e0 <fsipc+0x12>

0080091b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 40 0c             	mov    0xc(%eax),%eax
  80092b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800938:	ba 00 00 00 00       	mov    $0x0,%edx
  80093d:	b8 02 00 00 00       	mov    $0x2,%eax
  800942:	e8 87 ff ff ff       	call   8008ce <fsipc>
}
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <devfile_flush>:
{
  800949:	f3 0f 1e fb          	endbr32 
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 40 0c             	mov    0xc(%eax),%eax
  800959:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	b8 06 00 00 00       	mov    $0x6,%eax
  800968:	e8 61 ff ff ff       	call   8008ce <fsipc>
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <devfile_stat>:
{
  80096f:	f3 0f 1e fb          	endbr32 
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	53                   	push   %ebx
  800977:	83 ec 04             	sub    $0x4,%esp
  80097a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 40 0c             	mov    0xc(%eax),%eax
  800983:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800988:	ba 00 00 00 00       	mov    $0x0,%edx
  80098d:	b8 05 00 00 00       	mov    $0x5,%eax
  800992:	e8 37 ff ff ff       	call   8008ce <fsipc>
  800997:	85 c0                	test   %eax,%eax
  800999:	78 2c                	js     8009c7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	68 00 50 80 00       	push   $0x805000
  8009a3:	53                   	push   %ebx
  8009a4:	e8 2b 0d 00 00       	call   8016d4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009a9:	a1 80 50 80 00       	mov    0x805080,%eax
  8009ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009b4:	a1 84 50 80 00       	mov    0x805084,%eax
  8009b9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <devfile_write>:
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	53                   	push   %ebx
  8009d4:	83 ec 04             	sub    $0x4,%esp
  8009d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009e5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009eb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8009f1:	77 30                	ja     800a23 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8009f3:	83 ec 04             	sub    $0x4,%esp
  8009f6:	53                   	push   %ebx
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	68 08 50 80 00       	push   $0x805008
  8009ff:	e8 88 0e 00 00       	call   80188c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	b8 04 00 00 00       	mov    $0x4,%eax
  800a0e:	e8 bb fe ff ff       	call   8008ce <fsipc>
  800a13:	83 c4 10             	add    $0x10,%esp
  800a16:	85 c0                	test   %eax,%eax
  800a18:	78 04                	js     800a1e <devfile_write+0x52>
	assert(r <= n);
  800a1a:	39 d8                	cmp    %ebx,%eax
  800a1c:	77 1e                	ja     800a3c <devfile_write+0x70>
}
  800a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a23:	68 c4 1e 80 00       	push   $0x801ec4
  800a28:	68 f1 1e 80 00       	push   $0x801ef1
  800a2d:	68 94 00 00 00       	push   $0x94
  800a32:	68 06 1f 80 00       	push   $0x801f06
  800a37:	e8 47 06 00 00       	call   801083 <_panic>
	assert(r <= n);
  800a3c:	68 11 1f 80 00       	push   $0x801f11
  800a41:	68 f1 1e 80 00       	push   $0x801ef1
  800a46:	68 98 00 00 00       	push   $0x98
  800a4b:	68 06 1f 80 00       	push   $0x801f06
  800a50:	e8 2e 06 00 00       	call   801083 <_panic>

00800a55 <devfile_read>:
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 40 0c             	mov    0xc(%eax),%eax
  800a67:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a6c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a72:	ba 00 00 00 00       	mov    $0x0,%edx
  800a77:	b8 03 00 00 00       	mov    $0x3,%eax
  800a7c:	e8 4d fe ff ff       	call   8008ce <fsipc>
  800a81:	89 c3                	mov    %eax,%ebx
  800a83:	85 c0                	test   %eax,%eax
  800a85:	78 1f                	js     800aa6 <devfile_read+0x51>
	assert(r <= n);
  800a87:	39 f0                	cmp    %esi,%eax
  800a89:	77 24                	ja     800aaf <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a90:	7f 33                	jg     800ac5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	50                   	push   %eax
  800a96:	68 00 50 80 00       	push   $0x805000
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	e8 e9 0d 00 00       	call   80188c <memmove>
	return r;
  800aa3:	83 c4 10             	add    $0x10,%esp
}
  800aa6:	89 d8                	mov    %ebx,%eax
  800aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    
	assert(r <= n);
  800aaf:	68 11 1f 80 00       	push   $0x801f11
  800ab4:	68 f1 1e 80 00       	push   $0x801ef1
  800ab9:	6a 7c                	push   $0x7c
  800abb:	68 06 1f 80 00       	push   $0x801f06
  800ac0:	e8 be 05 00 00       	call   801083 <_panic>
	assert(r <= PGSIZE);
  800ac5:	68 18 1f 80 00       	push   $0x801f18
  800aca:	68 f1 1e 80 00       	push   $0x801ef1
  800acf:	6a 7d                	push   $0x7d
  800ad1:	68 06 1f 80 00       	push   $0x801f06
  800ad6:	e8 a8 05 00 00       	call   801083 <_panic>

00800adb <open>:
{
  800adb:	f3 0f 1e fb          	endbr32 
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	56                   	push   %esi
  800ae3:	53                   	push   %ebx
  800ae4:	83 ec 1c             	sub    $0x1c,%esp
  800ae7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800aea:	56                   	push   %esi
  800aeb:	e8 a1 0b 00 00       	call   801691 <strlen>
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800af8:	7f 6c                	jg     800b66 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800afa:	83 ec 0c             	sub    $0xc,%esp
  800afd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b00:	50                   	push   %eax
  800b01:	e8 28 f8 ff ff       	call   80032e <fd_alloc>
  800b06:	89 c3                	mov    %eax,%ebx
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 c0                	test   %eax,%eax
  800b0d:	78 3c                	js     800b4b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	56                   	push   %esi
  800b13:	68 00 50 80 00       	push   $0x805000
  800b18:	e8 b7 0b 00 00       	call   8016d4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b28:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2d:	e8 9c fd ff ff       	call   8008ce <fsipc>
  800b32:	89 c3                	mov    %eax,%ebx
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	85 c0                	test   %eax,%eax
  800b39:	78 19                	js     800b54 <open+0x79>
	return fd2num(fd);
  800b3b:	83 ec 0c             	sub    $0xc,%esp
  800b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b41:	e8 b5 f7 ff ff       	call   8002fb <fd2num>
  800b46:	89 c3                	mov    %eax,%ebx
  800b48:	83 c4 10             	add    $0x10,%esp
}
  800b4b:	89 d8                	mov    %ebx,%eax
  800b4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    
		fd_close(fd, 0);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	6a 00                	push   $0x0
  800b59:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5c:	e8 d1 f8 ff ff       	call   800432 <fd_close>
		return r;
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	eb e5                	jmp    800b4b <open+0x70>
		return -E_BAD_PATH;
  800b66:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b6b:	eb de                	jmp    800b4b <open+0x70>

00800b6d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b6d:	f3 0f 1e fb          	endbr32 
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b77:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b81:	e8 48 fd ff ff       	call   8008ce <fsipc>
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
  800b91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	ff 75 08             	pushl  0x8(%ebp)
  800b9a:	e8 70 f7 ff ff       	call   80030f <fd2data>
  800b9f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800ba1:	83 c4 08             	add    $0x8,%esp
  800ba4:	68 24 1f 80 00       	push   $0x801f24
  800ba9:	53                   	push   %ebx
  800baa:	e8 25 0b 00 00       	call   8016d4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800baf:	8b 46 04             	mov    0x4(%esi),%eax
  800bb2:	2b 06                	sub    (%esi),%eax
  800bb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bc1:	00 00 00 
	stat->st_dev = &devpipe;
  800bc4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bcb:	30 80 00 
	return 0;
}
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bda:	f3 0f 1e fb          	endbr32 
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	53                   	push   %ebx
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800be8:	53                   	push   %ebx
  800be9:	6a 00                	push   $0x0
  800beb:	e8 20 f6 ff ff       	call   800210 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bf0:	89 1c 24             	mov    %ebx,(%esp)
  800bf3:	e8 17 f7 ff ff       	call   80030f <fd2data>
  800bf8:	83 c4 08             	add    $0x8,%esp
  800bfb:	50                   	push   %eax
  800bfc:	6a 00                	push   $0x0
  800bfe:	e8 0d f6 ff ff       	call   800210 <sys_page_unmap>
}
  800c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <_pipeisclosed>:
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 1c             	sub    $0x1c,%esp
  800c11:	89 c7                	mov    %eax,%edi
  800c13:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c15:	a1 04 40 80 00       	mov    0x804004,%eax
  800c1a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	57                   	push   %edi
  800c21:	e8 24 0f 00 00       	call   801b4a <pageref>
  800c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c29:	89 34 24             	mov    %esi,(%esp)
  800c2c:	e8 19 0f 00 00       	call   801b4a <pageref>
		nn = thisenv->env_runs;
  800c31:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c37:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	39 cb                	cmp    %ecx,%ebx
  800c3f:	74 1b                	je     800c5c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c41:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c44:	75 cf                	jne    800c15 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c46:	8b 42 58             	mov    0x58(%edx),%eax
  800c49:	6a 01                	push   $0x1
  800c4b:	50                   	push   %eax
  800c4c:	53                   	push   %ebx
  800c4d:	68 2b 1f 80 00       	push   $0x801f2b
  800c52:	e8 13 05 00 00       	call   80116a <cprintf>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	eb b9                	jmp    800c15 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c5c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c5f:	0f 94 c0             	sete   %al
  800c62:	0f b6 c0             	movzbl %al,%eax
}
  800c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <devpipe_write>:
{
  800c6d:	f3 0f 1e fb          	endbr32 
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 28             	sub    $0x28,%esp
  800c7a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c7d:	56                   	push   %esi
  800c7e:	e8 8c f6 ff ff       	call   80030f <fd2data>
  800c83:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c90:	74 4f                	je     800ce1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c92:	8b 43 04             	mov    0x4(%ebx),%eax
  800c95:	8b 0b                	mov    (%ebx),%ecx
  800c97:	8d 51 20             	lea    0x20(%ecx),%edx
  800c9a:	39 d0                	cmp    %edx,%eax
  800c9c:	72 14                	jb     800cb2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800c9e:	89 da                	mov    %ebx,%edx
  800ca0:	89 f0                	mov    %esi,%eax
  800ca2:	e8 61 ff ff ff       	call   800c08 <_pipeisclosed>
  800ca7:	85 c0                	test   %eax,%eax
  800ca9:	75 3b                	jne    800ce6 <devpipe_write+0x79>
			sys_yield();
  800cab:	e8 e3 f4 ff ff       	call   800193 <sys_yield>
  800cb0:	eb e0                	jmp    800c92 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cb9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cbc:	89 c2                	mov    %eax,%edx
  800cbe:	c1 fa 1f             	sar    $0x1f,%edx
  800cc1:	89 d1                	mov    %edx,%ecx
  800cc3:	c1 e9 1b             	shr    $0x1b,%ecx
  800cc6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cc9:	83 e2 1f             	and    $0x1f,%edx
  800ccc:	29 ca                	sub    %ecx,%edx
  800cce:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cd2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cd6:	83 c0 01             	add    $0x1,%eax
  800cd9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cdc:	83 c7 01             	add    $0x1,%edi
  800cdf:	eb ac                	jmp    800c8d <devpipe_write+0x20>
	return i;
  800ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce4:	eb 05                	jmp    800ceb <devpipe_write+0x7e>
				return 0;
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <devpipe_read>:
{
  800cf3:	f3 0f 1e fb          	endbr32 
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 18             	sub    $0x18,%esp
  800d00:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d03:	57                   	push   %edi
  800d04:	e8 06 f6 ff ff       	call   80030f <fd2data>
  800d09:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0b:	83 c4 10             	add    $0x10,%esp
  800d0e:	be 00 00 00 00       	mov    $0x0,%esi
  800d13:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d16:	75 14                	jne    800d2c <devpipe_read+0x39>
	return i;
  800d18:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1b:	eb 02                	jmp    800d1f <devpipe_read+0x2c>
				return i;
  800d1d:	89 f0                	mov    %esi,%eax
}
  800d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    
			sys_yield();
  800d27:	e8 67 f4 ff ff       	call   800193 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d2c:	8b 03                	mov    (%ebx),%eax
  800d2e:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d31:	75 18                	jne    800d4b <devpipe_read+0x58>
			if (i > 0)
  800d33:	85 f6                	test   %esi,%esi
  800d35:	75 e6                	jne    800d1d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d37:	89 da                	mov    %ebx,%edx
  800d39:	89 f8                	mov    %edi,%eax
  800d3b:	e8 c8 fe ff ff       	call   800c08 <_pipeisclosed>
  800d40:	85 c0                	test   %eax,%eax
  800d42:	74 e3                	je     800d27 <devpipe_read+0x34>
				return 0;
  800d44:	b8 00 00 00 00       	mov    $0x0,%eax
  800d49:	eb d4                	jmp    800d1f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d4b:	99                   	cltd   
  800d4c:	c1 ea 1b             	shr    $0x1b,%edx
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	83 e0 1f             	and    $0x1f,%eax
  800d54:	29 d0                	sub    %edx,%eax
  800d56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d61:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d64:	83 c6 01             	add    $0x1,%esi
  800d67:	eb aa                	jmp    800d13 <devpipe_read+0x20>

00800d69 <pipe>:
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
  800d72:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d78:	50                   	push   %eax
  800d79:	e8 b0 f5 ff ff       	call   80032e <fd_alloc>
  800d7e:	89 c3                	mov    %eax,%ebx
  800d80:	83 c4 10             	add    $0x10,%esp
  800d83:	85 c0                	test   %eax,%eax
  800d85:	0f 88 23 01 00 00    	js     800eae <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	68 07 04 00 00       	push   $0x407
  800d93:	ff 75 f4             	pushl  -0xc(%ebp)
  800d96:	6a 00                	push   $0x0
  800d98:	e8 21 f4 ff ff       	call   8001be <sys_page_alloc>
  800d9d:	89 c3                	mov    %eax,%ebx
  800d9f:	83 c4 10             	add    $0x10,%esp
  800da2:	85 c0                	test   %eax,%eax
  800da4:	0f 88 04 01 00 00    	js     800eae <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800daa:	83 ec 0c             	sub    $0xc,%esp
  800dad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db0:	50                   	push   %eax
  800db1:	e8 78 f5 ff ff       	call   80032e <fd_alloc>
  800db6:	89 c3                	mov    %eax,%ebx
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	0f 88 db 00 00 00    	js     800e9e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dc3:	83 ec 04             	sub    $0x4,%esp
  800dc6:	68 07 04 00 00       	push   $0x407
  800dcb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dce:	6a 00                	push   $0x0
  800dd0:	e8 e9 f3 ff ff       	call   8001be <sys_page_alloc>
  800dd5:	89 c3                	mov    %eax,%ebx
  800dd7:	83 c4 10             	add    $0x10,%esp
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	0f 88 bc 00 00 00    	js     800e9e <pipe+0x135>
	va = fd2data(fd0);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	ff 75 f4             	pushl  -0xc(%ebp)
  800de8:	e8 22 f5 ff ff       	call   80030f <fd2data>
  800ded:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800def:	83 c4 0c             	add    $0xc,%esp
  800df2:	68 07 04 00 00       	push   $0x407
  800df7:	50                   	push   %eax
  800df8:	6a 00                	push   $0x0
  800dfa:	e8 bf f3 ff ff       	call   8001be <sys_page_alloc>
  800dff:	89 c3                	mov    %eax,%ebx
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	85 c0                	test   %eax,%eax
  800e06:	0f 88 82 00 00 00    	js     800e8e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e12:	e8 f8 f4 ff ff       	call   80030f <fd2data>
  800e17:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e1e:	50                   	push   %eax
  800e1f:	6a 00                	push   $0x0
  800e21:	56                   	push   %esi
  800e22:	6a 00                	push   $0x0
  800e24:	e8 bd f3 ff ff       	call   8001e6 <sys_page_map>
  800e29:	89 c3                	mov    %eax,%ebx
  800e2b:	83 c4 20             	add    $0x20,%esp
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	78 4e                	js     800e80 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e32:	a1 20 30 80 00       	mov    0x803020,%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e49:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5b:	e8 9b f4 ff ff       	call   8002fb <fd2num>
  800e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e63:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e65:	83 c4 04             	add    $0x4,%esp
  800e68:	ff 75 f0             	pushl  -0x10(%ebp)
  800e6b:	e8 8b f4 ff ff       	call   8002fb <fd2num>
  800e70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e73:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	eb 2e                	jmp    800eae <pipe+0x145>
	sys_page_unmap(0, va);
  800e80:	83 ec 08             	sub    $0x8,%esp
  800e83:	56                   	push   %esi
  800e84:	6a 00                	push   $0x0
  800e86:	e8 85 f3 ff ff       	call   800210 <sys_page_unmap>
  800e8b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 f0             	pushl  -0x10(%ebp)
  800e94:	6a 00                	push   $0x0
  800e96:	e8 75 f3 ff ff       	call   800210 <sys_page_unmap>
  800e9b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 65 f3 ff ff       	call   800210 <sys_page_unmap>
  800eab:	83 c4 10             	add    $0x10,%esp
}
  800eae:	89 d8                	mov    %ebx,%eax
  800eb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <pipeisclosed>:
{
  800eb7:	f3 0f 1e fb          	endbr32 
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec4:	50                   	push   %eax
  800ec5:	ff 75 08             	pushl  0x8(%ebp)
  800ec8:	e8 b7 f4 ff ff       	call   800384 <fd_lookup>
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	78 18                	js     800eec <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  800eda:	e8 30 f4 ff ff       	call   80030f <fd2data>
  800edf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee4:	e8 1f fd ff ff       	call   800c08 <_pipeisclosed>
  800ee9:	83 c4 10             	add    $0x10,%esp
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800eee:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef7:	c3                   	ret    

00800ef8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800ef8:	f3 0f 1e fb          	endbr32 
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f02:	68 43 1f 80 00       	push   $0x801f43
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	e8 c5 07 00 00       	call   8016d4 <strcpy>
	return 0;
}
  800f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <devcons_write>:
{
  800f16:	f3 0f 1e fb          	endbr32 
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f26:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f2b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f31:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f34:	73 31                	jae    800f67 <devcons_write+0x51>
		m = n - tot;
  800f36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f39:	29 f3                	sub    %esi,%ebx
  800f3b:	83 fb 7f             	cmp    $0x7f,%ebx
  800f3e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f43:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f46:	83 ec 04             	sub    $0x4,%esp
  800f49:	53                   	push   %ebx
  800f4a:	89 f0                	mov    %esi,%eax
  800f4c:	03 45 0c             	add    0xc(%ebp),%eax
  800f4f:	50                   	push   %eax
  800f50:	57                   	push   %edi
  800f51:	e8 36 09 00 00       	call   80188c <memmove>
		sys_cputs(buf, m);
  800f56:	83 c4 08             	add    $0x8,%esp
  800f59:	53                   	push   %ebx
  800f5a:	57                   	push   %edi
  800f5b:	e8 93 f1 ff ff       	call   8000f3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f60:	01 de                	add    %ebx,%esi
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	eb ca                	jmp    800f31 <devcons_write+0x1b>
}
  800f67:	89 f0                	mov    %esi,%eax
  800f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <devcons_read>:
{
  800f71:	f3 0f 1e fb          	endbr32 
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	74 21                	je     800fa7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f86:	e8 92 f1 ff ff       	call   80011d <sys_cgetc>
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	75 07                	jne    800f96 <devcons_read+0x25>
		sys_yield();
  800f8f:	e8 ff f1 ff ff       	call   800193 <sys_yield>
  800f94:	eb f0                	jmp    800f86 <devcons_read+0x15>
	if (c < 0)
  800f96:	78 0f                	js     800fa7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800f98:	83 f8 04             	cmp    $0x4,%eax
  800f9b:	74 0c                	je     800fa9 <devcons_read+0x38>
	*(char*)vbuf = c;
  800f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa0:	88 02                	mov    %al,(%edx)
	return 1;
  800fa2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    
		return 0;
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fae:	eb f7                	jmp    800fa7 <devcons_read+0x36>

00800fb0 <cputchar>:
{
  800fb0:	f3 0f 1e fb          	endbr32 
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fc0:	6a 01                	push   $0x1
  800fc2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fc5:	50                   	push   %eax
  800fc6:	e8 28 f1 ff ff       	call   8000f3 <sys_cputs>
}
  800fcb:	83 c4 10             	add    $0x10,%esp
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <getchar>:
{
  800fd0:	f3 0f 1e fb          	endbr32 
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fda:	6a 01                	push   $0x1
  800fdc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fdf:	50                   	push   %eax
  800fe0:	6a 00                	push   $0x0
  800fe2:	e8 20 f6 ff ff       	call   800607 <read>
	if (r < 0)
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	85 c0                	test   %eax,%eax
  800fec:	78 06                	js     800ff4 <getchar+0x24>
	if (r < 1)
  800fee:	74 06                	je     800ff6 <getchar+0x26>
	return c;
  800ff0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    
		return -E_EOF;
  800ff6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800ffb:	eb f7                	jmp    800ff4 <getchar+0x24>

00800ffd <iscons>:
{
  800ffd:	f3 0f 1e fb          	endbr32 
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801007:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 71 f3 ff ff       	call   800384 <fd_lookup>
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	78 11                	js     80102b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80101a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801023:	39 10                	cmp    %edx,(%eax)
  801025:	0f 94 c0             	sete   %al
  801028:	0f b6 c0             	movzbl %al,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <opencons>:
{
  80102d:	f3 0f 1e fb          	endbr32 
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801037:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80103a:	50                   	push   %eax
  80103b:	e8 ee f2 ff ff       	call   80032e <fd_alloc>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	85 c0                	test   %eax,%eax
  801045:	78 3a                	js     801081 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801047:	83 ec 04             	sub    $0x4,%esp
  80104a:	68 07 04 00 00       	push   $0x407
  80104f:	ff 75 f4             	pushl  -0xc(%ebp)
  801052:	6a 00                	push   $0x0
  801054:	e8 65 f1 ff ff       	call   8001be <sys_page_alloc>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 21                	js     801081 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801069:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801075:	83 ec 0c             	sub    $0xc,%esp
  801078:	50                   	push   %eax
  801079:	e8 7d f2 ff ff       	call   8002fb <fd2num>
  80107e:	83 c4 10             	add    $0x10,%esp
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801083:	f3 0f 1e fb          	endbr32 
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80108c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80108f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801095:	e8 d1 f0 ff ff       	call   80016b <sys_getenvid>
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	ff 75 08             	pushl  0x8(%ebp)
  8010a3:	56                   	push   %esi
  8010a4:	50                   	push   %eax
  8010a5:	68 50 1f 80 00       	push   $0x801f50
  8010aa:	e8 bb 00 00 00       	call   80116a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010af:	83 c4 18             	add    $0x18,%esp
  8010b2:	53                   	push   %ebx
  8010b3:	ff 75 10             	pushl  0x10(%ebp)
  8010b6:	e8 5a 00 00 00       	call   801115 <vcprintf>
	cprintf("\n");
  8010bb:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010c2:	e8 a3 00 00 00       	call   80116a <cprintf>
  8010c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010ca:	cc                   	int3   
  8010cb:	eb fd                	jmp    8010ca <_panic+0x47>

008010cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010cd:	f3 0f 1e fb          	endbr32 
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	53                   	push   %ebx
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010db:	8b 13                	mov    (%ebx),%edx
  8010dd:	8d 42 01             	lea    0x1(%edx),%eax
  8010e0:	89 03                	mov    %eax,(%ebx)
  8010e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010ee:	74 09                	je     8010f9 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010f0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8010f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	68 ff 00 00 00       	push   $0xff
  801101:	8d 43 08             	lea    0x8(%ebx),%eax
  801104:	50                   	push   %eax
  801105:	e8 e9 ef ff ff       	call   8000f3 <sys_cputs>
		b->idx = 0;
  80110a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	eb db                	jmp    8010f0 <putch+0x23>

00801115 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801115:	f3 0f 1e fb          	endbr32 
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801122:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801129:	00 00 00 
	b.cnt = 0;
  80112c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801133:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	ff 75 08             	pushl  0x8(%ebp)
  80113c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801142:	50                   	push   %eax
  801143:	68 cd 10 80 00       	push   $0x8010cd
  801148:	e8 80 01 00 00       	call   8012cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80114d:	83 c4 08             	add    $0x8,%esp
  801150:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801156:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80115c:	50                   	push   %eax
  80115d:	e8 91 ef ff ff       	call   8000f3 <sys_cputs>

	return b.cnt;
}
  801162:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80116a:	f3 0f 1e fb          	endbr32 
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801174:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801177:	50                   	push   %eax
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 95 ff ff ff       	call   801115 <vcprintf>
	va_end(ap);

	return cnt;
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	83 ec 1c             	sub    $0x1c,%esp
  80118b:	89 c7                	mov    %eax,%edi
  80118d:	89 d6                	mov    %edx,%esi
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 55 0c             	mov    0xc(%ebp),%edx
  801195:	89 d1                	mov    %edx,%ecx
  801197:	89 c2                	mov    %eax,%edx
  801199:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80119c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011af:	39 c2                	cmp    %eax,%edx
  8011b1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011b4:	72 3e                	jb     8011f4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	ff 75 18             	pushl  0x18(%ebp)
  8011bc:	83 eb 01             	sub    $0x1,%ebx
  8011bf:	53                   	push   %ebx
  8011c0:	50                   	push   %eax
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8011ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8011cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8011d0:	e8 bb 09 00 00       	call   801b90 <__udivdi3>
  8011d5:	83 c4 18             	add    $0x18,%esp
  8011d8:	52                   	push   %edx
  8011d9:	50                   	push   %eax
  8011da:	89 f2                	mov    %esi,%edx
  8011dc:	89 f8                	mov    %edi,%eax
  8011de:	e8 9f ff ff ff       	call   801182 <printnum>
  8011e3:	83 c4 20             	add    $0x20,%esp
  8011e6:	eb 13                	jmp    8011fb <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	56                   	push   %esi
  8011ec:	ff 75 18             	pushl  0x18(%ebp)
  8011ef:	ff d7                	call   *%edi
  8011f1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8011f4:	83 eb 01             	sub    $0x1,%ebx
  8011f7:	85 db                	test   %ebx,%ebx
  8011f9:	7f ed                	jg     8011e8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8011fb:	83 ec 08             	sub    $0x8,%esp
  8011fe:	56                   	push   %esi
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	ff 75 e4             	pushl  -0x1c(%ebp)
  801205:	ff 75 e0             	pushl  -0x20(%ebp)
  801208:	ff 75 dc             	pushl  -0x24(%ebp)
  80120b:	ff 75 d8             	pushl  -0x28(%ebp)
  80120e:	e8 8d 0a 00 00       	call   801ca0 <__umoddi3>
  801213:	83 c4 14             	add    $0x14,%esp
  801216:	0f be 80 73 1f 80 00 	movsbl 0x801f73(%eax),%eax
  80121d:	50                   	push   %eax
  80121e:	ff d7                	call   *%edi
}
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801226:	5b                   	pop    %ebx
  801227:	5e                   	pop    %esi
  801228:	5f                   	pop    %edi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80122b:	83 fa 01             	cmp    $0x1,%edx
  80122e:	7f 13                	jg     801243 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801230:	85 d2                	test   %edx,%edx
  801232:	74 1c                	je     801250 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801234:	8b 10                	mov    (%eax),%edx
  801236:	8d 4a 04             	lea    0x4(%edx),%ecx
  801239:	89 08                	mov    %ecx,(%eax)
  80123b:	8b 02                	mov    (%edx),%eax
  80123d:	ba 00 00 00 00       	mov    $0x0,%edx
  801242:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801243:	8b 10                	mov    (%eax),%edx
  801245:	8d 4a 08             	lea    0x8(%edx),%ecx
  801248:	89 08                	mov    %ecx,(%eax)
  80124a:	8b 02                	mov    (%edx),%eax
  80124c:	8b 52 04             	mov    0x4(%edx),%edx
  80124f:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801250:	8b 10                	mov    (%eax),%edx
  801252:	8d 4a 04             	lea    0x4(%edx),%ecx
  801255:	89 08                	mov    %ecx,(%eax)
  801257:	8b 02                	mov    (%edx),%eax
  801259:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80125e:	c3                   	ret    

0080125f <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80125f:	83 fa 01             	cmp    $0x1,%edx
  801262:	7f 0f                	jg     801273 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801264:	85 d2                	test   %edx,%edx
  801266:	74 18                	je     801280 <getint+0x21>
		return va_arg(*ap, long);
  801268:	8b 10                	mov    (%eax),%edx
  80126a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80126d:	89 08                	mov    %ecx,(%eax)
  80126f:	8b 02                	mov    (%edx),%eax
  801271:	99                   	cltd   
  801272:	c3                   	ret    
		return va_arg(*ap, long long);
  801273:	8b 10                	mov    (%eax),%edx
  801275:	8d 4a 08             	lea    0x8(%edx),%ecx
  801278:	89 08                	mov    %ecx,(%eax)
  80127a:	8b 02                	mov    (%edx),%eax
  80127c:	8b 52 04             	mov    0x4(%edx),%edx
  80127f:	c3                   	ret    
	else
		return va_arg(*ap, int);
  801280:	8b 10                	mov    (%eax),%edx
  801282:	8d 4a 04             	lea    0x4(%edx),%ecx
  801285:	89 08                	mov    %ecx,(%eax)
  801287:	8b 02                	mov    (%edx),%eax
  801289:	99                   	cltd   
}
  80128a:	c3                   	ret    

0080128b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80128b:	f3 0f 1e fb          	endbr32 
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801295:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801299:	8b 10                	mov    (%eax),%edx
  80129b:	3b 50 04             	cmp    0x4(%eax),%edx
  80129e:	73 0a                	jae    8012aa <sprintputch+0x1f>
		*b->buf++ = ch;
  8012a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a3:	89 08                	mov    %ecx,(%eax)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	88 02                	mov    %al,(%edx)
}
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <printfmt>:
{
  8012ac:	f3 0f 1e fb          	endbr32 
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012b6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012b9:	50                   	push   %eax
  8012ba:	ff 75 10             	pushl  0x10(%ebp)
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	ff 75 08             	pushl  0x8(%ebp)
  8012c3:	e8 05 00 00 00       	call   8012cd <vprintfmt>
}
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <vprintfmt>:
{
  8012cd:	f3 0f 1e fb          	endbr32 
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	57                   	push   %edi
  8012d5:	56                   	push   %esi
  8012d6:	53                   	push   %ebx
  8012d7:	83 ec 2c             	sub    $0x2c,%esp
  8012da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012e0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012e3:	e9 86 02 00 00       	jmp    80156e <vprintfmt+0x2a1>
		padc = ' ';
  8012e8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801301:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801306:	8d 47 01             	lea    0x1(%edi),%eax
  801309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80130c:	0f b6 17             	movzbl (%edi),%edx
  80130f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801312:	3c 55                	cmp    $0x55,%al
  801314:	0f 87 df 02 00 00    	ja     8015f9 <vprintfmt+0x32c>
  80131a:	0f b6 c0             	movzbl %al,%eax
  80131d:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801324:	00 
  801325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801328:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80132c:	eb d8                	jmp    801306 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80132e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801331:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801335:	eb cf                	jmp    801306 <vprintfmt+0x39>
  801337:	0f b6 d2             	movzbl %dl,%edx
  80133a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801345:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801348:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80134c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80134f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801352:	83 f9 09             	cmp    $0x9,%ecx
  801355:	77 52                	ja     8013a9 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801357:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80135a:	eb e9                	jmp    801345 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80135c:	8b 45 14             	mov    0x14(%ebp),%eax
  80135f:	8d 50 04             	lea    0x4(%eax),%edx
  801362:	89 55 14             	mov    %edx,0x14(%ebp)
  801365:	8b 00                	mov    (%eax),%eax
  801367:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80136a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80136d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801371:	79 93                	jns    801306 <vprintfmt+0x39>
				width = precision, precision = -1;
  801373:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801376:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801379:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801380:	eb 84                	jmp    801306 <vprintfmt+0x39>
  801382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801385:	85 c0                	test   %eax,%eax
  801387:	ba 00 00 00 00       	mov    $0x0,%edx
  80138c:	0f 49 d0             	cmovns %eax,%edx
  80138f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801395:	e9 6c ff ff ff       	jmp    801306 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80139a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80139d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013a4:	e9 5d ff ff ff       	jmp    801306 <vprintfmt+0x39>
  8013a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013af:	eb bc                	jmp    80136d <vprintfmt+0xa0>
			lflag++;
  8013b1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b7:	e9 4a ff ff ff       	jmp    801306 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bf:	8d 50 04             	lea    0x4(%eax),%edx
  8013c2:	89 55 14             	mov    %edx,0x14(%ebp)
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	56                   	push   %esi
  8013c9:	ff 30                	pushl  (%eax)
  8013cb:	ff d3                	call   *%ebx
			break;
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	e9 96 01 00 00       	jmp    80156b <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d8:	8d 50 04             	lea    0x4(%eax),%edx
  8013db:	89 55 14             	mov    %edx,0x14(%ebp)
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	99                   	cltd   
  8013e1:	31 d0                	xor    %edx,%eax
  8013e3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013e5:	83 f8 0f             	cmp    $0xf,%eax
  8013e8:	7f 20                	jg     80140a <vprintfmt+0x13d>
  8013ea:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8013f1:	85 d2                	test   %edx,%edx
  8013f3:	74 15                	je     80140a <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8013f5:	52                   	push   %edx
  8013f6:	68 03 1f 80 00       	push   $0x801f03
  8013fb:	56                   	push   %esi
  8013fc:	53                   	push   %ebx
  8013fd:	e8 aa fe ff ff       	call   8012ac <printfmt>
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	e9 61 01 00 00       	jmp    80156b <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80140a:	50                   	push   %eax
  80140b:	68 8b 1f 80 00       	push   $0x801f8b
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	e8 95 fe ff ff       	call   8012ac <printfmt>
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	e9 4c 01 00 00       	jmp    80156b <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80141f:	8b 45 14             	mov    0x14(%ebp),%eax
  801422:	8d 50 04             	lea    0x4(%eax),%edx
  801425:	89 55 14             	mov    %edx,0x14(%ebp)
  801428:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80142a:	85 c9                	test   %ecx,%ecx
  80142c:	b8 84 1f 80 00       	mov    $0x801f84,%eax
  801431:	0f 45 c1             	cmovne %ecx,%eax
  801434:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80143b:	7e 06                	jle    801443 <vprintfmt+0x176>
  80143d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801441:	75 0d                	jne    801450 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801443:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801446:	89 c7                	mov    %eax,%edi
  801448:	03 45 e0             	add    -0x20(%ebp),%eax
  80144b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80144e:	eb 57                	jmp    8014a7 <vprintfmt+0x1da>
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 d8             	pushl  -0x28(%ebp)
  801456:	ff 75 cc             	pushl  -0x34(%ebp)
  801459:	e8 4f 02 00 00       	call   8016ad <strnlen>
  80145e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801461:	29 c2                	sub    %eax,%edx
  801463:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801466:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801469:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80146d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  801470:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  801472:	85 db                	test   %ebx,%ebx
  801474:	7e 10                	jle    801486 <vprintfmt+0x1b9>
					putch(padc, putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	56                   	push   %esi
  80147a:	57                   	push   %edi
  80147b:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80147e:	83 eb 01             	sub    $0x1,%ebx
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	eb ec                	jmp    801472 <vprintfmt+0x1a5>
  801486:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801489:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80148c:	85 d2                	test   %edx,%edx
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	0f 49 c2             	cmovns %edx,%eax
  801496:	29 c2                	sub    %eax,%edx
  801498:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80149b:	eb a6                	jmp    801443 <vprintfmt+0x176>
					putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	56                   	push   %esi
  8014a1:	52                   	push   %edx
  8014a2:	ff d3                	call   *%ebx
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014aa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ac:	83 c7 01             	add    $0x1,%edi
  8014af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014b3:	0f be d0             	movsbl %al,%edx
  8014b6:	85 d2                	test   %edx,%edx
  8014b8:	74 42                	je     8014fc <vprintfmt+0x22f>
  8014ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014be:	78 06                	js     8014c6 <vprintfmt+0x1f9>
  8014c0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014c4:	78 1e                	js     8014e4 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014ca:	74 d1                	je     80149d <vprintfmt+0x1d0>
  8014cc:	0f be c0             	movsbl %al,%eax
  8014cf:	83 e8 20             	sub    $0x20,%eax
  8014d2:	83 f8 5e             	cmp    $0x5e,%eax
  8014d5:	76 c6                	jbe    80149d <vprintfmt+0x1d0>
					putch('?', putdat);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	56                   	push   %esi
  8014db:	6a 3f                	push   $0x3f
  8014dd:	ff d3                	call   *%ebx
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	eb c3                	jmp    8014a7 <vprintfmt+0x1da>
  8014e4:	89 cf                	mov    %ecx,%edi
  8014e6:	eb 0e                	jmp    8014f6 <vprintfmt+0x229>
				putch(' ', putdat);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	56                   	push   %esi
  8014ec:	6a 20                	push   $0x20
  8014ee:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8014f0:	83 ef 01             	sub    $0x1,%edi
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	85 ff                	test   %edi,%edi
  8014f8:	7f ee                	jg     8014e8 <vprintfmt+0x21b>
  8014fa:	eb 6f                	jmp    80156b <vprintfmt+0x29e>
  8014fc:	89 cf                	mov    %ecx,%edi
  8014fe:	eb f6                	jmp    8014f6 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801500:	89 ca                	mov    %ecx,%edx
  801502:	8d 45 14             	lea    0x14(%ebp),%eax
  801505:	e8 55 fd ff ff       	call   80125f <getint>
  80150a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80150d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801510:	85 d2                	test   %edx,%edx
  801512:	78 0b                	js     80151f <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801514:	89 d1                	mov    %edx,%ecx
  801516:	89 c2                	mov    %eax,%edx
			base = 10;
  801518:	b8 0a 00 00 00       	mov    $0xa,%eax
  80151d:	eb 32                	jmp    801551 <vprintfmt+0x284>
				putch('-', putdat);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	56                   	push   %esi
  801523:	6a 2d                	push   $0x2d
  801525:	ff d3                	call   *%ebx
				num = -(long long) num;
  801527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80152a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80152d:	f7 da                	neg    %edx
  80152f:	83 d1 00             	adc    $0x0,%ecx
  801532:	f7 d9                	neg    %ecx
  801534:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801537:	b8 0a 00 00 00       	mov    $0xa,%eax
  80153c:	eb 13                	jmp    801551 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80153e:	89 ca                	mov    %ecx,%edx
  801540:	8d 45 14             	lea    0x14(%ebp),%eax
  801543:	e8 e3 fc ff ff       	call   80122b <getuint>
  801548:	89 d1                	mov    %edx,%ecx
  80154a:	89 c2                	mov    %eax,%edx
			base = 10;
  80154c:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801558:	57                   	push   %edi
  801559:	ff 75 e0             	pushl  -0x20(%ebp)
  80155c:	50                   	push   %eax
  80155d:	51                   	push   %ecx
  80155e:	52                   	push   %edx
  80155f:	89 f2                	mov    %esi,%edx
  801561:	89 d8                	mov    %ebx,%eax
  801563:	e8 1a fc ff ff       	call   801182 <printnum>
			break;
  801568:	83 c4 20             	add    $0x20,%esp
{
  80156b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80156e:	83 c7 01             	add    $0x1,%edi
  801571:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801575:	83 f8 25             	cmp    $0x25,%eax
  801578:	0f 84 6a fd ff ff    	je     8012e8 <vprintfmt+0x1b>
			if (ch == '\0')
  80157e:	85 c0                	test   %eax,%eax
  801580:	0f 84 93 00 00 00    	je     801619 <vprintfmt+0x34c>
			putch(ch, putdat);
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	56                   	push   %esi
  80158a:	50                   	push   %eax
  80158b:	ff d3                	call   *%ebx
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	eb dc                	jmp    80156e <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  801592:	89 ca                	mov    %ecx,%edx
  801594:	8d 45 14             	lea    0x14(%ebp),%eax
  801597:	e8 8f fc ff ff       	call   80122b <getuint>
  80159c:	89 d1                	mov    %edx,%ecx
  80159e:	89 c2                	mov    %eax,%edx
			base = 8;
  8015a0:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015a5:	eb aa                	jmp    801551 <vprintfmt+0x284>
			putch('0', putdat);
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	56                   	push   %esi
  8015ab:	6a 30                	push   $0x30
  8015ad:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015af:	83 c4 08             	add    $0x8,%esp
  8015b2:	56                   	push   %esi
  8015b3:	6a 78                	push   $0x78
  8015b5:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ba:	8d 50 04             	lea    0x4(%eax),%edx
  8015bd:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015c0:	8b 10                	mov    (%eax),%edx
  8015c2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015c7:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015ca:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015cf:	eb 80                	jmp    801551 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015d1:	89 ca                	mov    %ecx,%edx
  8015d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8015d6:	e8 50 fc ff ff       	call   80122b <getuint>
  8015db:	89 d1                	mov    %edx,%ecx
  8015dd:	89 c2                	mov    %eax,%edx
			base = 16;
  8015df:	b8 10 00 00 00       	mov    $0x10,%eax
  8015e4:	e9 68 ff ff ff       	jmp    801551 <vprintfmt+0x284>
			putch(ch, putdat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	56                   	push   %esi
  8015ed:	6a 25                	push   $0x25
  8015ef:	ff d3                	call   *%ebx
			break;
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	e9 72 ff ff ff       	jmp    80156b <vprintfmt+0x29e>
			putch('%', putdat);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	56                   	push   %esi
  8015fd:	6a 25                	push   $0x25
  8015ff:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 f8                	mov    %edi,%eax
  801606:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80160a:	74 05                	je     801611 <vprintfmt+0x344>
  80160c:	83 e8 01             	sub    $0x1,%eax
  80160f:	eb f5                	jmp    801606 <vprintfmt+0x339>
  801611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801614:	e9 52 ff ff ff       	jmp    80156b <vprintfmt+0x29e>
}
  801619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801621:	f3 0f 1e fb          	endbr32 
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 18             	sub    $0x18,%esp
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801631:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801634:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801638:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80163b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801642:	85 c0                	test   %eax,%eax
  801644:	74 26                	je     80166c <vsnprintf+0x4b>
  801646:	85 d2                	test   %edx,%edx
  801648:	7e 22                	jle    80166c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80164a:	ff 75 14             	pushl  0x14(%ebp)
  80164d:	ff 75 10             	pushl  0x10(%ebp)
  801650:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	68 8b 12 80 00       	push   $0x80128b
  801659:	e8 6f fc ff ff       	call   8012cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80165e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801661:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	83 c4 10             	add    $0x10,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    
		return -E_INVAL;
  80166c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801671:	eb f7                	jmp    80166a <vsnprintf+0x49>

00801673 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801673:	f3 0f 1e fb          	endbr32 
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80167d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801680:	50                   	push   %eax
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	e8 92 ff ff ff       	call   801621 <vsnprintf>
	va_end(ap);

	return rc;
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801691:	f3 0f 1e fb          	endbr32 
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016a4:	74 05                	je     8016ab <strlen+0x1a>
		n++;
  8016a6:	83 c0 01             	add    $0x1,%eax
  8016a9:	eb f5                	jmp    8016a0 <strlen+0xf>
	return n;
}
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    

008016ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ad:	f3 0f 1e fb          	endbr32 
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	39 d0                	cmp    %edx,%eax
  8016c1:	74 0d                	je     8016d0 <strnlen+0x23>
  8016c3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016c7:	74 05                	je     8016ce <strnlen+0x21>
		n++;
  8016c9:	83 c0 01             	add    $0x1,%eax
  8016cc:	eb f1                	jmp    8016bf <strnlen+0x12>
  8016ce:	89 c2                	mov    %eax,%edx
	return n;
}
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    

008016d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d4:	f3 0f 1e fb          	endbr32 
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	53                   	push   %ebx
  8016dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016eb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016ee:	83 c0 01             	add    $0x1,%eax
  8016f1:	84 d2                	test   %dl,%dl
  8016f3:	75 f2                	jne    8016e7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8016f5:	89 c8                	mov    %ecx,%eax
  8016f7:	5b                   	pop    %ebx
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016fa:	f3 0f 1e fb          	endbr32 
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	53                   	push   %ebx
  801702:	83 ec 10             	sub    $0x10,%esp
  801705:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801708:	53                   	push   %ebx
  801709:	e8 83 ff ff ff       	call   801691 <strlen>
  80170e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	01 d8                	add    %ebx,%eax
  801716:	50                   	push   %eax
  801717:	e8 b8 ff ff ff       	call   8016d4 <strcpy>
	return dst;
}
  80171c:	89 d8                	mov    %ebx,%eax
  80171e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801723:	f3 0f 1e fb          	endbr32 
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	56                   	push   %esi
  80172b:	53                   	push   %ebx
  80172c:	8b 75 08             	mov    0x8(%ebp),%esi
  80172f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801732:	89 f3                	mov    %esi,%ebx
  801734:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801737:	89 f0                	mov    %esi,%eax
  801739:	39 d8                	cmp    %ebx,%eax
  80173b:	74 11                	je     80174e <strncpy+0x2b>
		*dst++ = *src;
  80173d:	83 c0 01             	add    $0x1,%eax
  801740:	0f b6 0a             	movzbl (%edx),%ecx
  801743:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801746:	80 f9 01             	cmp    $0x1,%cl
  801749:	83 da ff             	sbb    $0xffffffff,%edx
  80174c:	eb eb                	jmp    801739 <strncpy+0x16>
	}
	return ret;
}
  80174e:	89 f0                	mov    %esi,%eax
  801750:	5b                   	pop    %ebx
  801751:	5e                   	pop    %esi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	56                   	push   %esi
  80175c:	53                   	push   %ebx
  80175d:	8b 75 08             	mov    0x8(%ebp),%esi
  801760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801763:	8b 55 10             	mov    0x10(%ebp),%edx
  801766:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801768:	85 d2                	test   %edx,%edx
  80176a:	74 21                	je     80178d <strlcpy+0x39>
  80176c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801770:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801772:	39 c2                	cmp    %eax,%edx
  801774:	74 14                	je     80178a <strlcpy+0x36>
  801776:	0f b6 19             	movzbl (%ecx),%ebx
  801779:	84 db                	test   %bl,%bl
  80177b:	74 0b                	je     801788 <strlcpy+0x34>
			*dst++ = *src++;
  80177d:	83 c1 01             	add    $0x1,%ecx
  801780:	83 c2 01             	add    $0x1,%edx
  801783:	88 5a ff             	mov    %bl,-0x1(%edx)
  801786:	eb ea                	jmp    801772 <strlcpy+0x1e>
  801788:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80178a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80178d:	29 f0                	sub    %esi,%eax
}
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801793:	f3 0f 1e fb          	endbr32 
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017a0:	0f b6 01             	movzbl (%ecx),%eax
  8017a3:	84 c0                	test   %al,%al
  8017a5:	74 0c                	je     8017b3 <strcmp+0x20>
  8017a7:	3a 02                	cmp    (%edx),%al
  8017a9:	75 08                	jne    8017b3 <strcmp+0x20>
		p++, q++;
  8017ab:	83 c1 01             	add    $0x1,%ecx
  8017ae:	83 c2 01             	add    $0x1,%edx
  8017b1:	eb ed                	jmp    8017a0 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017b3:	0f b6 c0             	movzbl %al,%eax
  8017b6:	0f b6 12             	movzbl (%edx),%edx
  8017b9:	29 d0                	sub    %edx,%eax
}
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    

008017bd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017bd:	f3 0f 1e fb          	endbr32 
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	53                   	push   %ebx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017d0:	eb 06                	jmp    8017d8 <strncmp+0x1b>
		n--, p++, q++;
  8017d2:	83 c0 01             	add    $0x1,%eax
  8017d5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017d8:	39 d8                	cmp    %ebx,%eax
  8017da:	74 16                	je     8017f2 <strncmp+0x35>
  8017dc:	0f b6 08             	movzbl (%eax),%ecx
  8017df:	84 c9                	test   %cl,%cl
  8017e1:	74 04                	je     8017e7 <strncmp+0x2a>
  8017e3:	3a 0a                	cmp    (%edx),%cl
  8017e5:	74 eb                	je     8017d2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017e7:	0f b6 00             	movzbl (%eax),%eax
  8017ea:	0f b6 12             	movzbl (%edx),%edx
  8017ed:	29 d0                	sub    %edx,%eax
}
  8017ef:	5b                   	pop    %ebx
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    
		return 0;
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f7:	eb f6                	jmp    8017ef <strncmp+0x32>

008017f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f9:	f3 0f 1e fb          	endbr32 
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801807:	0f b6 10             	movzbl (%eax),%edx
  80180a:	84 d2                	test   %dl,%dl
  80180c:	74 09                	je     801817 <strchr+0x1e>
		if (*s == c)
  80180e:	38 ca                	cmp    %cl,%dl
  801810:	74 0a                	je     80181c <strchr+0x23>
	for (; *s; s++)
  801812:	83 c0 01             	add    $0x1,%eax
  801815:	eb f0                	jmp    801807 <strchr+0xe>
			return (char *) s;
	return 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80181e:	f3 0f 1e fb          	endbr32 
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80182c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80182f:	38 ca                	cmp    %cl,%dl
  801831:	74 09                	je     80183c <strfind+0x1e>
  801833:	84 d2                	test   %dl,%dl
  801835:	74 05                	je     80183c <strfind+0x1e>
	for (; *s; s++)
  801837:	83 c0 01             	add    $0x1,%eax
  80183a:	eb f0                	jmp    80182c <strfind+0xe>
			break;
	return (char *) s;
}
  80183c:	5d                   	pop    %ebp
  80183d:	c3                   	ret    

0080183e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80183e:	f3 0f 1e fb          	endbr32 
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	57                   	push   %edi
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	8b 55 08             	mov    0x8(%ebp),%edx
  80184b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80184e:	85 c9                	test   %ecx,%ecx
  801850:	74 33                	je     801885 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801852:	89 d0                	mov    %edx,%eax
  801854:	09 c8                	or     %ecx,%eax
  801856:	a8 03                	test   $0x3,%al
  801858:	75 23                	jne    80187d <memset+0x3f>
		c &= 0xFF;
  80185a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	c1 e0 08             	shl    $0x8,%eax
  801863:	89 df                	mov    %ebx,%edi
  801865:	c1 e7 18             	shl    $0x18,%edi
  801868:	89 de                	mov    %ebx,%esi
  80186a:	c1 e6 10             	shl    $0x10,%esi
  80186d:	09 f7                	or     %esi,%edi
  80186f:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801871:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801874:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801876:	89 d7                	mov    %edx,%edi
  801878:	fc                   	cld    
  801879:	f3 ab                	rep stos %eax,%es:(%edi)
  80187b:	eb 08                	jmp    801885 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80187d:	89 d7                	mov    %edx,%edi
  80187f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801882:	fc                   	cld    
  801883:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801885:	89 d0                	mov    %edx,%eax
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80188c:	f3 0f 1e fb          	endbr32 
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 75 0c             	mov    0xc(%ebp),%esi
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80189e:	39 c6                	cmp    %eax,%esi
  8018a0:	73 32                	jae    8018d4 <memmove+0x48>
  8018a2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018a5:	39 c2                	cmp    %eax,%edx
  8018a7:	76 2b                	jbe    8018d4 <memmove+0x48>
		s += n;
		d += n;
  8018a9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ac:	89 fe                	mov    %edi,%esi
  8018ae:	09 ce                	or     %ecx,%esi
  8018b0:	09 d6                	or     %edx,%esi
  8018b2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018b8:	75 0e                	jne    8018c8 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018ba:	83 ef 04             	sub    $0x4,%edi
  8018bd:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018c0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018c3:	fd                   	std    
  8018c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018c6:	eb 09                	jmp    8018d1 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018c8:	83 ef 01             	sub    $0x1,%edi
  8018cb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018ce:	fd                   	std    
  8018cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018d1:	fc                   	cld    
  8018d2:	eb 1a                	jmp    8018ee <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018d4:	89 c2                	mov    %eax,%edx
  8018d6:	09 ca                	or     %ecx,%edx
  8018d8:	09 f2                	or     %esi,%edx
  8018da:	f6 c2 03             	test   $0x3,%dl
  8018dd:	75 0a                	jne    8018e9 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018df:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018e2:	89 c7                	mov    %eax,%edi
  8018e4:	fc                   	cld    
  8018e5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018e7:	eb 05                	jmp    8018ee <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018e9:	89 c7                	mov    %eax,%edi
  8018eb:	fc                   	cld    
  8018ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018f2:	f3 0f 1e fb          	endbr32 
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8018fc:	ff 75 10             	pushl  0x10(%ebp)
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 82 ff ff ff       	call   80188c <memmove>
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80190c:	f3 0f 1e fb          	endbr32 
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	56                   	push   %esi
  801914:	53                   	push   %ebx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191b:	89 c6                	mov    %eax,%esi
  80191d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801920:	39 f0                	cmp    %esi,%eax
  801922:	74 1c                	je     801940 <memcmp+0x34>
		if (*s1 != *s2)
  801924:	0f b6 08             	movzbl (%eax),%ecx
  801927:	0f b6 1a             	movzbl (%edx),%ebx
  80192a:	38 d9                	cmp    %bl,%cl
  80192c:	75 08                	jne    801936 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80192e:	83 c0 01             	add    $0x1,%eax
  801931:	83 c2 01             	add    $0x1,%edx
  801934:	eb ea                	jmp    801920 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801936:	0f b6 c1             	movzbl %cl,%eax
  801939:	0f b6 db             	movzbl %bl,%ebx
  80193c:	29 d8                	sub    %ebx,%eax
  80193e:	eb 05                	jmp    801945 <memcmp+0x39>
	}

	return 0;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801949:	f3 0f 1e fb          	endbr32 
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801956:	89 c2                	mov    %eax,%edx
  801958:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80195b:	39 d0                	cmp    %edx,%eax
  80195d:	73 09                	jae    801968 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80195f:	38 08                	cmp    %cl,(%eax)
  801961:	74 05                	je     801968 <memfind+0x1f>
	for (; s < ends; s++)
  801963:	83 c0 01             	add    $0x1,%eax
  801966:	eb f3                	jmp    80195b <memfind+0x12>
			break;
	return (void *) s;
}
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    

0080196a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80196a:	f3 0f 1e fb          	endbr32 
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801977:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80197a:	eb 03                	jmp    80197f <strtol+0x15>
		s++;
  80197c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80197f:	0f b6 01             	movzbl (%ecx),%eax
  801982:	3c 20                	cmp    $0x20,%al
  801984:	74 f6                	je     80197c <strtol+0x12>
  801986:	3c 09                	cmp    $0x9,%al
  801988:	74 f2                	je     80197c <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80198a:	3c 2b                	cmp    $0x2b,%al
  80198c:	74 2a                	je     8019b8 <strtol+0x4e>
	int neg = 0;
  80198e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801993:	3c 2d                	cmp    $0x2d,%al
  801995:	74 2b                	je     8019c2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801997:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80199d:	75 0f                	jne    8019ae <strtol+0x44>
  80199f:	80 39 30             	cmpb   $0x30,(%ecx)
  8019a2:	74 28                	je     8019cc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019a4:	85 db                	test   %ebx,%ebx
  8019a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ab:	0f 44 d8             	cmove  %eax,%ebx
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019b6:	eb 46                	jmp    8019fe <strtol+0x94>
		s++;
  8019b8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8019c0:	eb d5                	jmp    801997 <strtol+0x2d>
		s++, neg = 1;
  8019c2:	83 c1 01             	add    $0x1,%ecx
  8019c5:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ca:	eb cb                	jmp    801997 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019cc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019d0:	74 0e                	je     8019e0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019d2:	85 db                	test   %ebx,%ebx
  8019d4:	75 d8                	jne    8019ae <strtol+0x44>
		s++, base = 8;
  8019d6:	83 c1 01             	add    $0x1,%ecx
  8019d9:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019de:	eb ce                	jmp    8019ae <strtol+0x44>
		s += 2, base = 16;
  8019e0:	83 c1 02             	add    $0x2,%ecx
  8019e3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019e8:	eb c4                	jmp    8019ae <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019ea:	0f be d2             	movsbl %dl,%edx
  8019ed:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019f0:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019f3:	7d 3a                	jge    801a2f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019f5:	83 c1 01             	add    $0x1,%ecx
  8019f8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019fc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019fe:	0f b6 11             	movzbl (%ecx),%edx
  801a01:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a04:	89 f3                	mov    %esi,%ebx
  801a06:	80 fb 09             	cmp    $0x9,%bl
  801a09:	76 df                	jbe    8019ea <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a0e:	89 f3                	mov    %esi,%ebx
  801a10:	80 fb 19             	cmp    $0x19,%bl
  801a13:	77 08                	ja     801a1d <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a15:	0f be d2             	movsbl %dl,%edx
  801a18:	83 ea 57             	sub    $0x57,%edx
  801a1b:	eb d3                	jmp    8019f0 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a20:	89 f3                	mov    %esi,%ebx
  801a22:	80 fb 19             	cmp    $0x19,%bl
  801a25:	77 08                	ja     801a2f <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a27:	0f be d2             	movsbl %dl,%edx
  801a2a:	83 ea 37             	sub    $0x37,%edx
  801a2d:	eb c1                	jmp    8019f0 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a33:	74 05                	je     801a3a <strtol+0xd0>
		*endptr = (char *) s;
  801a35:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a3a:	89 c2                	mov    %eax,%edx
  801a3c:	f7 da                	neg    %edx
  801a3e:	85 ff                	test   %edi,%edi
  801a40:	0f 45 c2             	cmovne %edx,%eax
}
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5f                   	pop    %edi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a48:	f3 0f 1e fb          	endbr32 
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	8b 75 08             	mov    0x8(%ebp),%esi
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a61:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a64:	83 ec 0c             	sub    $0xc,%esp
  801a67:	50                   	push   %eax
  801a68:	e8 68 e8 ff ff       	call   8002d5 <sys_ipc_recv>
	if (r < 0) {
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 2b                	js     801a9f <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a74:	85 f6                	test   %esi,%esi
  801a76:	74 0a                	je     801a82 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a78:	a1 04 40 80 00       	mov    0x804004,%eax
  801a7d:	8b 40 74             	mov    0x74(%eax),%eax
  801a80:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a82:	85 db                	test   %ebx,%ebx
  801a84:	74 0a                	je     801a90 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a86:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8b:	8b 40 78             	mov    0x78(%eax),%eax
  801a8e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801a90:	a1 04 40 80 00       	mov    0x804004,%eax
  801a95:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    
		if (from_env_store) {
  801a9f:	85 f6                	test   %esi,%esi
  801aa1:	74 06                	je     801aa9 <ipc_recv+0x61>
			*from_env_store = 0;
  801aa3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801aa9:	85 db                	test   %ebx,%ebx
  801aab:	74 eb                	je     801a98 <ipc_recv+0x50>
			*perm_store = 0;
  801aad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ab3:	eb e3                	jmp    801a98 <ipc_recv+0x50>

00801ab5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ab5:	f3 0f 1e fb          	endbr32 
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	57                   	push   %edi
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ac8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801acb:	85 db                	test   %ebx,%ebx
  801acd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ad2:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ad5:	ff 75 14             	pushl  0x14(%ebp)
  801ad8:	53                   	push   %ebx
  801ad9:	56                   	push   %esi
  801ada:	57                   	push   %edi
  801adb:	e8 cc e7 ff ff       	call   8002ac <sys_ipc_try_send>
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ae6:	75 07                	jne    801aef <ipc_send+0x3a>
		sys_yield();
  801ae8:	e8 a6 e6 ff ff       	call   800193 <sys_yield>
  801aed:	eb e6                	jmp    801ad5 <ipc_send+0x20>
	}

	if (ret < 0) {
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 08                	js     801afb <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5f                   	pop    %edi
  801af9:	5d                   	pop    %ebp
  801afa:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801afb:	50                   	push   %eax
  801afc:	68 7f 22 80 00       	push   $0x80227f
  801b01:	6a 48                	push   $0x48
  801b03:	68 9c 22 80 00       	push   $0x80229c
  801b08:	e8 76 f5 ff ff       	call   801083 <_panic>

00801b0d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b0d:	f3 0f 1e fb          	endbr32 
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b1c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b1f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b25:	8b 52 50             	mov    0x50(%edx),%edx
  801b28:	39 ca                	cmp    %ecx,%edx
  801b2a:	74 11                	je     801b3d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b2c:	83 c0 01             	add    $0x1,%eax
  801b2f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b34:	75 e6                	jne    801b1c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	eb 0b                	jmp    801b48 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b3d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b40:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b45:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b54:	89 c2                	mov    %eax,%edx
  801b56:	c1 ea 16             	shr    $0x16,%edx
  801b59:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b65:	f6 c1 01             	test   $0x1,%cl
  801b68:	74 1c                	je     801b86 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b6a:	c1 e8 0c             	shr    $0xc,%eax
  801b6d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b74:	a8 01                	test   $0x1,%al
  801b76:	74 0e                	je     801b86 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b78:	c1 e8 0c             	shr    $0xc,%eax
  801b7b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b82:	ef 
  801b83:	0f b7 d2             	movzwl %dx,%edx
}
  801b86:	89 d0                	mov    %edx,%eax
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    
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
