
obj/user/breakpoint.debug:     formato del fichero elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $3");
  800037:	cc                   	int3   
}
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	f3 0f 1e fb          	endbr32 
  80003d:	55                   	push   %ebp
  80003e:	89 e5                	mov    %esp,%ebp
  800040:	56                   	push   %esi
  800041:	53                   	push   %ebx
  800042:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800045:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800048:	e8 19 01 00 00       	call   800166 <sys_getenvid>
	if (id >= 0)
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 12                	js     800063 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800051:	25 ff 03 00 00       	and    $0x3ff,%eax
  800056:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800059:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800063:	85 db                	test   %ebx,%ebx
  800065:	7e 07                	jle    80006e <libmain+0x35>
		binaryname = argv[0];
  800067:	8b 06                	mov    (%esi),%eax
  800069:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	e8 bb ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800078:	e8 0a 00 00 00       	call   800087 <exit>
}
  80007d:	83 c4 10             	add    $0x10,%esp
  800080:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800083:	5b                   	pop    %ebx
  800084:	5e                   	pop    %esi
  800085:	5d                   	pop    %ebp
  800086:	c3                   	ret    

00800087 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800087:	f3 0f 1e fb          	endbr32 
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800091:	e8 53 04 00 00       	call   8004e9 <close_all>
	sys_env_destroy(0);
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	6a 00                	push   $0x0
  80009b:	e8 a0 00 00 00       	call   800140 <sys_env_destroy>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 1c             	sub    $0x1c,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000b4:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000bf:	8b 75 14             	mov    0x14(%ebp),%esi
  8000c2:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c8:	74 04                	je     8000ce <syscall+0x29>
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f 08                	jg     8000d6 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	50                   	push   %eax
  8000da:	ff 75 e0             	pushl  -0x20(%ebp)
  8000dd:	68 0a 1e 80 00       	push   $0x801e0a
  8000e2:	6a 23                	push   $0x23
  8000e4:	68 27 1e 80 00       	push   $0x801e27
  8000e9:	e8 90 0f 00 00       	call   80107e <_panic>

008000ee <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000ee:	f3 0f 1e fb          	endbr32 
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000f8:	6a 00                	push   $0x0
  8000fa:	6a 00                	push   $0x0
  8000fc:	6a 00                	push   $0x0
  8000fe:	ff 75 0c             	pushl  0xc(%ebp)
  800101:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	e8 92 ff ff ff       	call   8000a5 <syscall>
}
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <sys_cgetc>:

int
sys_cgetc(void)
{
  800118:	f3 0f 1e fb          	endbr32 
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800122:	6a 00                	push   $0x0
  800124:	6a 00                	push   $0x0
  800126:	6a 00                	push   $0x0
  800128:	6a 00                	push   $0x0
  80012a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012f:	ba 00 00 00 00       	mov    $0x0,%edx
  800134:	b8 01 00 00 00       	mov    $0x1,%eax
  800139:	e8 67 ff ff ff       	call   8000a5 <syscall>
}
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800140:	f3 0f 1e fb          	endbr32 
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80014a:	6a 00                	push   $0x0
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	6a 00                	push   $0x0
  800152:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800155:	ba 01 00 00 00       	mov    $0x1,%edx
  80015a:	b8 03 00 00 00       	mov    $0x3,%eax
  80015f:	e8 41 ff ff ff       	call   8000a5 <syscall>
}
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800166:	f3 0f 1e fb          	endbr32 
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800170:	6a 00                	push   $0x0
  800172:	6a 00                	push   $0x0
  800174:	6a 00                	push   $0x0
  800176:	6a 00                	push   $0x0
  800178:	b9 00 00 00 00       	mov    $0x0,%ecx
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	b8 02 00 00 00       	mov    $0x2,%eax
  800187:	e8 19 ff ff ff       	call   8000a5 <syscall>
}
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <sys_yield>:

void
sys_yield(void)
{
  80018e:	f3 0f 1e fb          	endbr32 
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800198:	6a 00                	push   $0x0
  80019a:	6a 00                	push   $0x0
  80019c:	6a 00                	push   $0x0
  80019e:	6a 00                	push   $0x0
  8001a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001aa:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001af:	e8 f1 fe ff ff       	call   8000a5 <syscall>
}
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b9:	f3 0f 1e fb          	endbr32 
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001c3:	6a 00                	push   $0x0
  8001c5:	6a 00                	push   $0x0
  8001c7:	ff 75 10             	pushl  0x10(%ebp)
  8001ca:	ff 75 0c             	pushl  0xc(%ebp)
  8001cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8001d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8001da:	e8 c6 fe ff ff       	call   8000a5 <syscall>
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e1:	f3 0f 1e fb          	endbr32 
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001eb:	ff 75 18             	pushl  0x18(%ebp)
  8001ee:	ff 75 14             	pushl  0x14(%ebp)
  8001f1:	ff 75 10             	pushl  0x10(%ebp)
  8001f4:	ff 75 0c             	pushl  0xc(%ebp)
  8001f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ff:	b8 05 00 00 00       	mov    $0x5,%eax
  800204:	e8 9c fe ff ff       	call   8000a5 <syscall>
}
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80020b:	f3 0f 1e fb          	endbr32 
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800215:	6a 00                	push   $0x0
  800217:	6a 00                	push   $0x0
  800219:	6a 00                	push   $0x0
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800221:	ba 01 00 00 00       	mov    $0x1,%edx
  800226:	b8 06 00 00 00       	mov    $0x6,%eax
  80022b:	e8 75 fe ff ff       	call   8000a5 <syscall>
}
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800232:	f3 0f 1e fb          	endbr32 
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80023c:	6a 00                	push   $0x0
  80023e:	6a 00                	push   $0x0
  800240:	6a 00                	push   $0x0
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800248:	ba 01 00 00 00       	mov    $0x1,%edx
  80024d:	b8 08 00 00 00       	mov    $0x8,%eax
  800252:	e8 4e fe ff ff       	call   8000a5 <syscall>
}
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800259:	f3 0f 1e fb          	endbr32 
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800263:	6a 00                	push   $0x0
  800265:	6a 00                	push   $0x0
  800267:	6a 00                	push   $0x0
  800269:	ff 75 0c             	pushl  0xc(%ebp)
  80026c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026f:	ba 01 00 00 00       	mov    $0x1,%edx
  800274:	b8 09 00 00 00       	mov    $0x9,%eax
  800279:	e8 27 fe ff ff       	call   8000a5 <syscall>
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800280:	f3 0f 1e fb          	endbr32 
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80028a:	6a 00                	push   $0x0
  80028c:	6a 00                	push   $0x0
  80028e:	6a 00                	push   $0x0
  800290:	ff 75 0c             	pushl  0xc(%ebp)
  800293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800296:	ba 01 00 00 00       	mov    $0x1,%edx
  80029b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002a0:	e8 00 fe ff ff       	call   8000a5 <syscall>
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a7:	f3 0f 1e fb          	endbr32 
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002b1:	6a 00                	push   $0x0
  8002b3:	ff 75 14             	pushl  0x14(%ebp)
  8002b6:	ff 75 10             	pushl  0x10(%ebp)
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002c9:	e8 d7 fd ff ff       	call   8000a5 <syscall>
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d0:	f3 0f 1e fb          	endbr32 
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002da:	6a 00                	push   $0x0
  8002dc:	6a 00                	push   $0x0
  8002de:	6a 00                	push   $0x0
  8002e0:	6a 00                	push   $0x0
  8002e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e5:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ea:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002ef:	e8 b1 fd ff ff       	call   8000a5 <syscall>
}
  8002f4:	c9                   	leave  
  8002f5:	c3                   	ret    

008002f6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002f6:	f3 0f 1e fb          	endbr32 
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	05 00 00 00 30       	add    $0x30000000,%eax
  800305:	c1 e8 0c             	shr    $0xc,%eax
}
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80030a:	f3 0f 1e fb          	endbr32 
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 da ff ff ff       	call   8002f6 <fd2num>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c1 e0 0c             	shl    $0xc,%eax
  800322:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800329:	f3 0f 1e fb          	endbr32 
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800335:	89 c2                	mov    %eax,%edx
  800337:	c1 ea 16             	shr    $0x16,%edx
  80033a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800341:	f6 c2 01             	test   $0x1,%dl
  800344:	74 2d                	je     800373 <fd_alloc+0x4a>
  800346:	89 c2                	mov    %eax,%edx
  800348:	c1 ea 0c             	shr    $0xc,%edx
  80034b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800352:	f6 c2 01             	test   $0x1,%dl
  800355:	74 1c                	je     800373 <fd_alloc+0x4a>
  800357:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80035c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800361:	75 d2                	jne    800335 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800363:	8b 45 08             	mov    0x8(%ebp),%eax
  800366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80036c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800371:	eb 0a                	jmp    80037d <fd_alloc+0x54>
			*fd_store = fd;
  800373:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800376:	89 01                	mov    %eax,(%ecx)
			return 0;
  800378:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80037f:	f3 0f 1e fb          	endbr32 
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800389:	83 f8 1f             	cmp    $0x1f,%eax
  80038c:	77 30                	ja     8003be <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80038e:	c1 e0 0c             	shl    $0xc,%eax
  800391:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800396:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80039c:	f6 c2 01             	test   $0x1,%dl
  80039f:	74 24                	je     8003c5 <fd_lookup+0x46>
  8003a1:	89 c2                	mov    %eax,%edx
  8003a3:	c1 ea 0c             	shr    $0xc,%edx
  8003a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ad:	f6 c2 01             	test   $0x1,%dl
  8003b0:	74 1a                	je     8003cc <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b5:	89 02                	mov    %eax,(%edx)
	return 0;
  8003b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    
		return -E_INVAL;
  8003be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003c3:	eb f7                	jmp    8003bc <fd_lookup+0x3d>
		return -E_INVAL;
  8003c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003ca:	eb f0                	jmp    8003bc <fd_lookup+0x3d>
  8003cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d1:	eb e9                	jmp    8003bc <fd_lookup+0x3d>

008003d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003d3:	f3 0f 1e fb          	endbr32 
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e0:	ba b4 1e 80 00       	mov    $0x801eb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003e5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003ea:	39 08                	cmp    %ecx,(%eax)
  8003ec:	74 33                	je     800421 <dev_lookup+0x4e>
  8003ee:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8003f1:	8b 02                	mov    (%edx),%eax
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	75 f3                	jne    8003ea <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003f7:	a1 04 40 80 00       	mov    0x804004,%eax
  8003fc:	8b 40 48             	mov    0x48(%eax),%eax
  8003ff:	83 ec 04             	sub    $0x4,%esp
  800402:	51                   	push   %ecx
  800403:	50                   	push   %eax
  800404:	68 38 1e 80 00       	push   $0x801e38
  800409:	e8 57 0d 00 00       	call   801165 <cprintf>
	*dev = 0;
  80040e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80041f:	c9                   	leave  
  800420:	c3                   	ret    
			*dev = devtab[i];
  800421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800424:	89 01                	mov    %eax,(%ecx)
			return 0;
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	eb f2                	jmp    80041f <dev_lookup+0x4c>

0080042d <fd_close>:
{
  80042d:	f3 0f 1e fb          	endbr32 
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	57                   	push   %edi
  800435:	56                   	push   %esi
  800436:	53                   	push   %ebx
  800437:	83 ec 28             	sub    $0x28,%esp
  80043a:	8b 75 08             	mov    0x8(%ebp),%esi
  80043d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800440:	56                   	push   %esi
  800441:	e8 b0 fe ff ff       	call   8002f6 <fd2num>
  800446:	83 c4 08             	add    $0x8,%esp
  800449:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80044c:	52                   	push   %edx
  80044d:	50                   	push   %eax
  80044e:	e8 2c ff ff ff       	call   80037f <fd_lookup>
  800453:	89 c3                	mov    %eax,%ebx
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	85 c0                	test   %eax,%eax
  80045a:	78 05                	js     800461 <fd_close+0x34>
	    || fd != fd2)
  80045c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80045f:	74 16                	je     800477 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800461:	89 f8                	mov    %edi,%eax
  800463:	84 c0                	test   %al,%al
  800465:	b8 00 00 00 00       	mov    $0x0,%eax
  80046a:	0f 44 d8             	cmove  %eax,%ebx
}
  80046d:	89 d8                	mov    %ebx,%eax
  80046f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800472:	5b                   	pop    %ebx
  800473:	5e                   	pop    %esi
  800474:	5f                   	pop    %edi
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80047d:	50                   	push   %eax
  80047e:	ff 36                	pushl  (%esi)
  800480:	e8 4e ff ff ff       	call   8003d3 <dev_lookup>
  800485:	89 c3                	mov    %eax,%ebx
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 c0                	test   %eax,%eax
  80048c:	78 1a                	js     8004a8 <fd_close+0x7b>
		if (dev->dev_close)
  80048e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800491:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800494:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800499:	85 c0                	test   %eax,%eax
  80049b:	74 0b                	je     8004a8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	56                   	push   %esi
  8004a1:	ff d0                	call   *%eax
  8004a3:	89 c3                	mov    %eax,%ebx
  8004a5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	56                   	push   %esi
  8004ac:	6a 00                	push   $0x0
  8004ae:	e8 58 fd ff ff       	call   80020b <sys_page_unmap>
	return r;
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	eb b5                	jmp    80046d <fd_close+0x40>

008004b8 <close>:

int
close(int fdnum)
{
  8004b8:	f3 0f 1e fb          	endbr32 
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c5:	50                   	push   %eax
  8004c6:	ff 75 08             	pushl  0x8(%ebp)
  8004c9:	e8 b1 fe ff ff       	call   80037f <fd_lookup>
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	85 c0                	test   %eax,%eax
  8004d3:	79 02                	jns    8004d7 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    
		return fd_close(fd, 1);
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	6a 01                	push   $0x1
  8004dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8004df:	e8 49 ff ff ff       	call   80042d <fd_close>
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	eb ec                	jmp    8004d5 <close+0x1d>

008004e9 <close_all>:

void
close_all(void)
{
  8004e9:	f3 0f 1e fb          	endbr32 
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004f9:	83 ec 0c             	sub    $0xc,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	e8 b6 ff ff ff       	call   8004b8 <close>
	for (i = 0; i < MAXFD; i++)
  800502:	83 c3 01             	add    $0x1,%ebx
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	83 fb 20             	cmp    $0x20,%ebx
  80050b:	75 ec                	jne    8004f9 <close_all+0x10>
}
  80050d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800510:	c9                   	leave  
  800511:	c3                   	ret    

00800512 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800512:	f3 0f 1e fb          	endbr32 
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	57                   	push   %edi
  80051a:	56                   	push   %esi
  80051b:	53                   	push   %ebx
  80051c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80051f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800522:	50                   	push   %eax
  800523:	ff 75 08             	pushl  0x8(%ebp)
  800526:	e8 54 fe ff ff       	call   80037f <fd_lookup>
  80052b:	89 c3                	mov    %eax,%ebx
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	85 c0                	test   %eax,%eax
  800532:	0f 88 81 00 00 00    	js     8005b9 <dup+0xa7>
		return r;
	close(newfdnum);
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	e8 75 ff ff ff       	call   8004b8 <close>

	newfd = INDEX2FD(newfdnum);
  800543:	8b 75 0c             	mov    0xc(%ebp),%esi
  800546:	c1 e6 0c             	shl    $0xc,%esi
  800549:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80054f:	83 c4 04             	add    $0x4,%esp
  800552:	ff 75 e4             	pushl  -0x1c(%ebp)
  800555:	e8 b0 fd ff ff       	call   80030a <fd2data>
  80055a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80055c:	89 34 24             	mov    %esi,(%esp)
  80055f:	e8 a6 fd ff ff       	call   80030a <fd2data>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800569:	89 d8                	mov    %ebx,%eax
  80056b:	c1 e8 16             	shr    $0x16,%eax
  80056e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800575:	a8 01                	test   $0x1,%al
  800577:	74 11                	je     80058a <dup+0x78>
  800579:	89 d8                	mov    %ebx,%eax
  80057b:	c1 e8 0c             	shr    $0xc,%eax
  80057e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800585:	f6 c2 01             	test   $0x1,%dl
  800588:	75 39                	jne    8005c3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80058a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80058d:	89 d0                	mov    %edx,%eax
  80058f:	c1 e8 0c             	shr    $0xc,%eax
  800592:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	25 07 0e 00 00       	and    $0xe07,%eax
  8005a1:	50                   	push   %eax
  8005a2:	56                   	push   %esi
  8005a3:	6a 00                	push   $0x0
  8005a5:	52                   	push   %edx
  8005a6:	6a 00                	push   $0x0
  8005a8:	e8 34 fc ff ff       	call   8001e1 <sys_page_map>
  8005ad:	89 c3                	mov    %eax,%ebx
  8005af:	83 c4 20             	add    $0x20,%esp
  8005b2:	85 c0                	test   %eax,%eax
  8005b4:	78 31                	js     8005e7 <dup+0xd5>
		goto err;

	return newfdnum;
  8005b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005b9:	89 d8                	mov    %ebx,%eax
  8005bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005be:	5b                   	pop    %ebx
  8005bf:	5e                   	pop    %esi
  8005c0:	5f                   	pop    %edi
  8005c1:	5d                   	pop    %ebp
  8005c2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d2:	50                   	push   %eax
  8005d3:	57                   	push   %edi
  8005d4:	6a 00                	push   $0x0
  8005d6:	53                   	push   %ebx
  8005d7:	6a 00                	push   $0x0
  8005d9:	e8 03 fc ff ff       	call   8001e1 <sys_page_map>
  8005de:	89 c3                	mov    %eax,%ebx
  8005e0:	83 c4 20             	add    $0x20,%esp
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	79 a3                	jns    80058a <dup+0x78>
	sys_page_unmap(0, newfd);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	56                   	push   %esi
  8005eb:	6a 00                	push   $0x0
  8005ed:	e8 19 fc ff ff       	call   80020b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005f2:	83 c4 08             	add    $0x8,%esp
  8005f5:	57                   	push   %edi
  8005f6:	6a 00                	push   $0x0
  8005f8:	e8 0e fc ff ff       	call   80020b <sys_page_unmap>
	return r;
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	eb b7                	jmp    8005b9 <dup+0xa7>

00800602 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800602:	f3 0f 1e fb          	endbr32 
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	53                   	push   %ebx
  80060a:	83 ec 1c             	sub    $0x1c,%esp
  80060d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800613:	50                   	push   %eax
  800614:	53                   	push   %ebx
  800615:	e8 65 fd ff ff       	call   80037f <fd_lookup>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	85 c0                	test   %eax,%eax
  80061f:	78 3f                	js     800660 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800627:	50                   	push   %eax
  800628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062b:	ff 30                	pushl  (%eax)
  80062d:	e8 a1 fd ff ff       	call   8003d3 <dev_lookup>
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	85 c0                	test   %eax,%eax
  800637:	78 27                	js     800660 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800639:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80063c:	8b 42 08             	mov    0x8(%edx),%eax
  80063f:	83 e0 03             	and    $0x3,%eax
  800642:	83 f8 01             	cmp    $0x1,%eax
  800645:	74 1e                	je     800665 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8b 40 08             	mov    0x8(%eax),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 35                	je     800686 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	ff 75 10             	pushl  0x10(%ebp)
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	52                   	push   %edx
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
}
  800660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800663:	c9                   	leave  
  800664:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800665:	a1 04 40 80 00       	mov    0x804004,%eax
  80066a:	8b 40 48             	mov    0x48(%eax),%eax
  80066d:	83 ec 04             	sub    $0x4,%esp
  800670:	53                   	push   %ebx
  800671:	50                   	push   %eax
  800672:	68 79 1e 80 00       	push   $0x801e79
  800677:	e8 e9 0a 00 00       	call   801165 <cprintf>
		return -E_INVAL;
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800684:	eb da                	jmp    800660 <read+0x5e>
		return -E_NOT_SUPP;
  800686:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80068b:	eb d3                	jmp    800660 <read+0x5e>

0080068d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80068d:	f3 0f 1e fb          	endbr32 
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	57                   	push   %edi
  800695:	56                   	push   %esi
  800696:	53                   	push   %ebx
  800697:	83 ec 0c             	sub    $0xc,%esp
  80069a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80069d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a5:	eb 02                	jmp    8006a9 <readn+0x1c>
  8006a7:	01 c3                	add    %eax,%ebx
  8006a9:	39 f3                	cmp    %esi,%ebx
  8006ab:	73 21                	jae    8006ce <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	89 f0                	mov    %esi,%eax
  8006b2:	29 d8                	sub    %ebx,%eax
  8006b4:	50                   	push   %eax
  8006b5:	89 d8                	mov    %ebx,%eax
  8006b7:	03 45 0c             	add    0xc(%ebp),%eax
  8006ba:	50                   	push   %eax
  8006bb:	57                   	push   %edi
  8006bc:	e8 41 ff ff ff       	call   800602 <read>
		if (m < 0)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	85 c0                	test   %eax,%eax
  8006c6:	78 04                	js     8006cc <readn+0x3f>
			return m;
		if (m == 0)
  8006c8:	75 dd                	jne    8006a7 <readn+0x1a>
  8006ca:	eb 02                	jmp    8006ce <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006cc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006ce:	89 d8                	mov    %ebx,%eax
  8006d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d3:	5b                   	pop    %ebx
  8006d4:	5e                   	pop    %esi
  8006d5:	5f                   	pop    %edi
  8006d6:	5d                   	pop    %ebp
  8006d7:	c3                   	ret    

008006d8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006d8:	f3 0f 1e fb          	endbr32 
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	53                   	push   %ebx
  8006e0:	83 ec 1c             	sub    $0x1c,%esp
  8006e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	53                   	push   %ebx
  8006eb:	e8 8f fc ff ff       	call   80037f <fd_lookup>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	85 c0                	test   %eax,%eax
  8006f5:	78 3a                	js     800731 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006fd:	50                   	push   %eax
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800701:	ff 30                	pushl  (%eax)
  800703:	e8 cb fc ff ff       	call   8003d3 <dev_lookup>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	85 c0                	test   %eax,%eax
  80070d:	78 22                	js     800731 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80070f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800712:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800716:	74 1e                	je     800736 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	8b 52 0c             	mov    0xc(%edx),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	74 35                	je     800757 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	ff 75 10             	pushl  0x10(%ebp)
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	50                   	push   %eax
  80072c:	ff d2                	call   *%edx
  80072e:	83 c4 10             	add    $0x10,%esp
}
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800736:	a1 04 40 80 00       	mov    0x804004,%eax
  80073b:	8b 40 48             	mov    0x48(%eax),%eax
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	53                   	push   %ebx
  800742:	50                   	push   %eax
  800743:	68 95 1e 80 00       	push   $0x801e95
  800748:	e8 18 0a 00 00       	call   801165 <cprintf>
		return -E_INVAL;
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800755:	eb da                	jmp    800731 <write+0x59>
		return -E_NOT_SUPP;
  800757:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80075c:	eb d3                	jmp    800731 <write+0x59>

0080075e <seek>:

int
seek(int fdnum, off_t offset)
{
  80075e:	f3 0f 1e fb          	endbr32 
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800768:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	ff 75 08             	pushl  0x8(%ebp)
  80076f:	e8 0b fc ff ff       	call   80037f <fd_lookup>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	85 c0                	test   %eax,%eax
  800779:	78 0e                	js     800789 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80077b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800781:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80078b:	f3 0f 1e fb          	endbr32 
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	53                   	push   %ebx
  800793:	83 ec 1c             	sub    $0x1c,%esp
  800796:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800799:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80079c:	50                   	push   %eax
  80079d:	53                   	push   %ebx
  80079e:	e8 dc fb ff ff       	call   80037f <fd_lookup>
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	78 37                	js     8007e1 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	ff 30                	pushl  (%eax)
  8007b6:	e8 18 fc ff ff       	call   8003d3 <dev_lookup>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	78 1f                	js     8007e1 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007c9:	74 1b                	je     8007e6 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ce:	8b 52 18             	mov    0x18(%edx),%edx
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 32                	je     800807 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	ff d2                	call   *%edx
  8007de:	83 c4 10             	add    $0x10,%esp
}
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007e6:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007eb:	8b 40 48             	mov    0x48(%eax),%eax
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	50                   	push   %eax
  8007f3:	68 58 1e 80 00       	push   $0x801e58
  8007f8:	e8 68 09 00 00       	call   801165 <cprintf>
		return -E_INVAL;
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800805:	eb da                	jmp    8007e1 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800807:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80080c:	eb d3                	jmp    8007e1 <ftruncate+0x56>

0080080e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80080e:	f3 0f 1e fb          	endbr32 
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	83 ec 1c             	sub    $0x1c,%esp
  800819:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80081c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80081f:	50                   	push   %eax
  800820:	ff 75 08             	pushl  0x8(%ebp)
  800823:	e8 57 fb ff ff       	call   80037f <fd_lookup>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	85 c0                	test   %eax,%eax
  80082d:	78 4b                	js     80087a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800835:	50                   	push   %eax
  800836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800839:	ff 30                	pushl  (%eax)
  80083b:	e8 93 fb ff ff       	call   8003d3 <dev_lookup>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	85 c0                	test   %eax,%eax
  800845:	78 33                	js     80087a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80084e:	74 2f                	je     80087f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800850:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800853:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80085a:	00 00 00 
	stat->st_isdir = 0;
  80085d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800864:	00 00 00 
	stat->st_dev = dev;
  800867:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	ff 75 f0             	pushl  -0x10(%ebp)
  800874:	ff 50 14             	call   *0x14(%eax)
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087d:	c9                   	leave  
  80087e:	c3                   	ret    
		return -E_NOT_SUPP;
  80087f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800884:	eb f4                	jmp    80087a <fstat+0x6c>

00800886 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800886:	f3 0f 1e fb          	endbr32 
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	6a 00                	push   $0x0
  800894:	ff 75 08             	pushl  0x8(%ebp)
  800897:	e8 3a 02 00 00       	call   800ad6 <open>
  80089c:	89 c3                	mov    %eax,%ebx
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	85 c0                	test   %eax,%eax
  8008a3:	78 1b                	js     8008c0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	e8 5d ff ff ff       	call   80080e <fstat>
  8008b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8008b3:	89 1c 24             	mov    %ebx,(%esp)
  8008b6:	e8 fd fb ff ff       	call   8004b8 <close>
	return r;
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	89 f3                	mov    %esi,%ebx
}
  8008c0:	89 d8                	mov    %ebx,%eax
  8008c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	56                   	push   %esi
  8008cd:	53                   	push   %ebx
  8008ce:	89 c6                	mov    %eax,%esi
  8008d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008d9:	74 27                	je     800902 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008db:	6a 07                	push   $0x7
  8008dd:	68 00 50 80 00       	push   $0x805000
  8008e2:	56                   	push   %esi
  8008e3:	ff 35 00 40 80 00    	pushl  0x804000
  8008e9:	e8 c2 11 00 00       	call   801ab0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008ee:	83 c4 0c             	add    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	53                   	push   %ebx
  8008f4:	6a 00                	push   $0x0
  8008f6:	e8 48 11 00 00       	call   801a43 <ipc_recv>
}
  8008fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fe:	5b                   	pop    %ebx
  8008ff:	5e                   	pop    %esi
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800902:	83 ec 0c             	sub    $0xc,%esp
  800905:	6a 01                	push   $0x1
  800907:	e8 fc 11 00 00       	call   801b08 <ipc_find_env>
  80090c:	a3 00 40 80 00       	mov    %eax,0x804000
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	eb c5                	jmp    8008db <fsipc+0x12>

00800916 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 40 0c             	mov    0xc(%eax),%eax
  800926:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	b8 02 00 00 00       	mov    $0x2,%eax
  80093d:	e8 87 ff ff ff       	call   8008c9 <fsipc>
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <devfile_flush>:
{
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 40 0c             	mov    0xc(%eax),%eax
  800954:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	b8 06 00 00 00       	mov    $0x6,%eax
  800963:	e8 61 ff ff ff       	call   8008c9 <fsipc>
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <devfile_stat>:
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	53                   	push   %ebx
  800972:	83 ec 04             	sub    $0x4,%esp
  800975:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 40 0c             	mov    0xc(%eax),%eax
  80097e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
  800988:	b8 05 00 00 00       	mov    $0x5,%eax
  80098d:	e8 37 ff ff ff       	call   8008c9 <fsipc>
  800992:	85 c0                	test   %eax,%eax
  800994:	78 2c                	js     8009c2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	68 00 50 80 00       	push   $0x805000
  80099e:	53                   	push   %ebx
  80099f:	e8 2b 0d 00 00       	call   8016cf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009a4:	a1 80 50 80 00       	mov    0x805080,%eax
  8009a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009af:	a1 84 50 80 00       	mov    0x805084,%eax
  8009b4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <devfile_write>:
{
  8009c7:	f3 0f 1e fb          	endbr32 
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	83 ec 04             	sub    $0x4,%esp
  8009d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8009db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009e0:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009e6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8009ec:	77 30                	ja     800a1e <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8009ee:	83 ec 04             	sub    $0x4,%esp
  8009f1:	53                   	push   %ebx
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	68 08 50 80 00       	push   $0x805008
  8009fa:	e8 88 0e 00 00       	call   801887 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8009ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800a04:	b8 04 00 00 00       	mov    $0x4,%eax
  800a09:	e8 bb fe ff ff       	call   8008c9 <fsipc>
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	85 c0                	test   %eax,%eax
  800a13:	78 04                	js     800a19 <devfile_write+0x52>
	assert(r <= n);
  800a15:	39 d8                	cmp    %ebx,%eax
  800a17:	77 1e                	ja     800a37 <devfile_write+0x70>
}
  800a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a1e:	68 c4 1e 80 00       	push   $0x801ec4
  800a23:	68 f1 1e 80 00       	push   $0x801ef1
  800a28:	68 94 00 00 00       	push   $0x94
  800a2d:	68 06 1f 80 00       	push   $0x801f06
  800a32:	e8 47 06 00 00       	call   80107e <_panic>
	assert(r <= n);
  800a37:	68 11 1f 80 00       	push   $0x801f11
  800a3c:	68 f1 1e 80 00       	push   $0x801ef1
  800a41:	68 98 00 00 00       	push   $0x98
  800a46:	68 06 1f 80 00       	push   $0x801f06
  800a4b:	e8 2e 06 00 00       	call   80107e <_panic>

00800a50 <devfile_read>:
{
  800a50:	f3 0f 1e fb          	endbr32 
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a62:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a67:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a72:	b8 03 00 00 00       	mov    $0x3,%eax
  800a77:	e8 4d fe ff ff       	call   8008c9 <fsipc>
  800a7c:	89 c3                	mov    %eax,%ebx
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	78 1f                	js     800aa1 <devfile_read+0x51>
	assert(r <= n);
  800a82:	39 f0                	cmp    %esi,%eax
  800a84:	77 24                	ja     800aaa <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a86:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a8b:	7f 33                	jg     800ac0 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a8d:	83 ec 04             	sub    $0x4,%esp
  800a90:	50                   	push   %eax
  800a91:	68 00 50 80 00       	push   $0x805000
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	e8 e9 0d 00 00       	call   801887 <memmove>
	return r;
  800a9e:	83 c4 10             	add    $0x10,%esp
}
  800aa1:	89 d8                	mov    %ebx,%eax
  800aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    
	assert(r <= n);
  800aaa:	68 11 1f 80 00       	push   $0x801f11
  800aaf:	68 f1 1e 80 00       	push   $0x801ef1
  800ab4:	6a 7c                	push   $0x7c
  800ab6:	68 06 1f 80 00       	push   $0x801f06
  800abb:	e8 be 05 00 00       	call   80107e <_panic>
	assert(r <= PGSIZE);
  800ac0:	68 18 1f 80 00       	push   $0x801f18
  800ac5:	68 f1 1e 80 00       	push   $0x801ef1
  800aca:	6a 7d                	push   $0x7d
  800acc:	68 06 1f 80 00       	push   $0x801f06
  800ad1:	e8 a8 05 00 00       	call   80107e <_panic>

00800ad6 <open>:
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	83 ec 1c             	sub    $0x1c,%esp
  800ae2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ae5:	56                   	push   %esi
  800ae6:	e8 a1 0b 00 00       	call   80168c <strlen>
  800aeb:	83 c4 10             	add    $0x10,%esp
  800aee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800af3:	7f 6c                	jg     800b61 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800af5:	83 ec 0c             	sub    $0xc,%esp
  800af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800afb:	50                   	push   %eax
  800afc:	e8 28 f8 ff ff       	call   800329 <fd_alloc>
  800b01:	89 c3                	mov    %eax,%ebx
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	85 c0                	test   %eax,%eax
  800b08:	78 3c                	js     800b46 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	56                   	push   %esi
  800b0e:	68 00 50 80 00       	push   $0x805000
  800b13:	e8 b7 0b 00 00       	call   8016cf <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b23:	b8 01 00 00 00       	mov    $0x1,%eax
  800b28:	e8 9c fd ff ff       	call   8008c9 <fsipc>
  800b2d:	89 c3                	mov    %eax,%ebx
  800b2f:	83 c4 10             	add    $0x10,%esp
  800b32:	85 c0                	test   %eax,%eax
  800b34:	78 19                	js     800b4f <open+0x79>
	return fd2num(fd);
  800b36:	83 ec 0c             	sub    $0xc,%esp
  800b39:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3c:	e8 b5 f7 ff ff       	call   8002f6 <fd2num>
  800b41:	89 c3                	mov    %eax,%ebx
  800b43:	83 c4 10             	add    $0x10,%esp
}
  800b46:	89 d8                	mov    %ebx,%eax
  800b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4b:	5b                   	pop    %ebx
  800b4c:	5e                   	pop    %esi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    
		fd_close(fd, 0);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	6a 00                	push   $0x0
  800b54:	ff 75 f4             	pushl  -0xc(%ebp)
  800b57:	e8 d1 f8 ff ff       	call   80042d <fd_close>
		return r;
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	eb e5                	jmp    800b46 <open+0x70>
		return -E_BAD_PATH;
  800b61:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b66:	eb de                	jmp    800b46 <open+0x70>

00800b68 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	b8 08 00 00 00       	mov    $0x8,%eax
  800b7c:	e8 48 fd ff ff       	call   8008c9 <fsipc>
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b83:	f3 0f 1e fb          	endbr32 
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b8f:	83 ec 0c             	sub    $0xc,%esp
  800b92:	ff 75 08             	pushl  0x8(%ebp)
  800b95:	e8 70 f7 ff ff       	call   80030a <fd2data>
  800b9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b9c:	83 c4 08             	add    $0x8,%esp
  800b9f:	68 24 1f 80 00       	push   $0x801f24
  800ba4:	53                   	push   %ebx
  800ba5:	e8 25 0b 00 00       	call   8016cf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800baa:	8b 46 04             	mov    0x4(%esi),%eax
  800bad:	2b 06                	sub    (%esi),%eax
  800baf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bb5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bbc:	00 00 00 
	stat->st_dev = &devpipe;
  800bbf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bc6:	30 80 00 
	return 0;
}
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bd5:	f3 0f 1e fb          	endbr32 
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 0c             	sub    $0xc,%esp
  800be0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800be3:	53                   	push   %ebx
  800be4:	6a 00                	push   $0x0
  800be6:	e8 20 f6 ff ff       	call   80020b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800beb:	89 1c 24             	mov    %ebx,(%esp)
  800bee:	e8 17 f7 ff ff       	call   80030a <fd2data>
  800bf3:	83 c4 08             	add    $0x8,%esp
  800bf6:	50                   	push   %eax
  800bf7:	6a 00                	push   $0x0
  800bf9:	e8 0d f6 ff ff       	call   80020b <sys_page_unmap>
}
  800bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <_pipeisclosed>:
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 1c             	sub    $0x1c,%esp
  800c0c:	89 c7                	mov    %eax,%edi
  800c0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c10:	a1 04 40 80 00       	mov    0x804004,%eax
  800c15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	57                   	push   %edi
  800c1c:	e8 24 0f 00 00       	call   801b45 <pageref>
  800c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c24:	89 34 24             	mov    %esi,(%esp)
  800c27:	e8 19 0f 00 00       	call   801b45 <pageref>
		nn = thisenv->env_runs;
  800c2c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	39 cb                	cmp    %ecx,%ebx
  800c3a:	74 1b                	je     800c57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c3f:	75 cf                	jne    800c10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c41:	8b 42 58             	mov    0x58(%edx),%eax
  800c44:	6a 01                	push   $0x1
  800c46:	50                   	push   %eax
  800c47:	53                   	push   %ebx
  800c48:	68 2b 1f 80 00       	push   $0x801f2b
  800c4d:	e8 13 05 00 00       	call   801165 <cprintf>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	eb b9                	jmp    800c10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c5a:	0f 94 c0             	sete   %al
  800c5d:	0f b6 c0             	movzbl %al,%eax
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <devpipe_write>:
{
  800c68:	f3 0f 1e fb          	endbr32 
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 28             	sub    $0x28,%esp
  800c75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c78:	56                   	push   %esi
  800c79:	e8 8c f6 ff ff       	call   80030a <fd2data>
  800c7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	bf 00 00 00 00       	mov    $0x0,%edi
  800c88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c8b:	74 4f                	je     800cdc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c8d:	8b 43 04             	mov    0x4(%ebx),%eax
  800c90:	8b 0b                	mov    (%ebx),%ecx
  800c92:	8d 51 20             	lea    0x20(%ecx),%edx
  800c95:	39 d0                	cmp    %edx,%eax
  800c97:	72 14                	jb     800cad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800c99:	89 da                	mov    %ebx,%edx
  800c9b:	89 f0                	mov    %esi,%eax
  800c9d:	e8 61 ff ff ff       	call   800c03 <_pipeisclosed>
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	75 3b                	jne    800ce1 <devpipe_write+0x79>
			sys_yield();
  800ca6:	e8 e3 f4 ff ff       	call   80018e <sys_yield>
  800cab:	eb e0                	jmp    800c8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cb4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cb7:	89 c2                	mov    %eax,%edx
  800cb9:	c1 fa 1f             	sar    $0x1f,%edx
  800cbc:	89 d1                	mov    %edx,%ecx
  800cbe:	c1 e9 1b             	shr    $0x1b,%ecx
  800cc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cc4:	83 e2 1f             	and    $0x1f,%edx
  800cc7:	29 ca                	sub    %ecx,%edx
  800cc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ccd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cd1:	83 c0 01             	add    $0x1,%eax
  800cd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cd7:	83 c7 01             	add    $0x1,%edi
  800cda:	eb ac                	jmp    800c88 <devpipe_write+0x20>
	return i;
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	eb 05                	jmp    800ce6 <devpipe_write+0x7e>
				return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <devpipe_read>:
{
  800cee:	f3 0f 1e fb          	endbr32 
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 18             	sub    $0x18,%esp
  800cfb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800cfe:	57                   	push   %edi
  800cff:	e8 06 f6 ff ff       	call   80030a <fd2data>
  800d04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d06:	83 c4 10             	add    $0x10,%esp
  800d09:	be 00 00 00 00       	mov    $0x0,%esi
  800d0e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d11:	75 14                	jne    800d27 <devpipe_read+0x39>
	return i;
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	eb 02                	jmp    800d1a <devpipe_read+0x2c>
				return i;
  800d18:	89 f0                	mov    %esi,%eax
}
  800d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
			sys_yield();
  800d22:	e8 67 f4 ff ff       	call   80018e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d27:	8b 03                	mov    (%ebx),%eax
  800d29:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d2c:	75 18                	jne    800d46 <devpipe_read+0x58>
			if (i > 0)
  800d2e:	85 f6                	test   %esi,%esi
  800d30:	75 e6                	jne    800d18 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d32:	89 da                	mov    %ebx,%edx
  800d34:	89 f8                	mov    %edi,%eax
  800d36:	e8 c8 fe ff ff       	call   800c03 <_pipeisclosed>
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	74 e3                	je     800d22 <devpipe_read+0x34>
				return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	eb d4                	jmp    800d1a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d46:	99                   	cltd   
  800d47:	c1 ea 1b             	shr    $0x1b,%edx
  800d4a:	01 d0                	add    %edx,%eax
  800d4c:	83 e0 1f             	and    $0x1f,%eax
  800d4f:	29 d0                	sub    %edx,%eax
  800d51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d5f:	83 c6 01             	add    $0x1,%esi
  800d62:	eb aa                	jmp    800d0e <devpipe_read+0x20>

00800d64 <pipe>:
{
  800d64:	f3 0f 1e fb          	endbr32 
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d73:	50                   	push   %eax
  800d74:	e8 b0 f5 ff ff       	call   800329 <fd_alloc>
  800d79:	89 c3                	mov    %eax,%ebx
  800d7b:	83 c4 10             	add    $0x10,%esp
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	0f 88 23 01 00 00    	js     800ea9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	68 07 04 00 00       	push   $0x407
  800d8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d91:	6a 00                	push   $0x0
  800d93:	e8 21 f4 ff ff       	call   8001b9 <sys_page_alloc>
  800d98:	89 c3                	mov    %eax,%ebx
  800d9a:	83 c4 10             	add    $0x10,%esp
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	0f 88 04 01 00 00    	js     800ea9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dab:	50                   	push   %eax
  800dac:	e8 78 f5 ff ff       	call   800329 <fd_alloc>
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	85 c0                	test   %eax,%eax
  800db8:	0f 88 db 00 00 00    	js     800e99 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 07 04 00 00       	push   $0x407
  800dc6:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc9:	6a 00                	push   $0x0
  800dcb:	e8 e9 f3 ff ff       	call   8001b9 <sys_page_alloc>
  800dd0:	89 c3                	mov    %eax,%ebx
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	0f 88 bc 00 00 00    	js     800e99 <pipe+0x135>
	va = fd2data(fd0);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	ff 75 f4             	pushl  -0xc(%ebp)
  800de3:	e8 22 f5 ff ff       	call   80030a <fd2data>
  800de8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dea:	83 c4 0c             	add    $0xc,%esp
  800ded:	68 07 04 00 00       	push   $0x407
  800df2:	50                   	push   %eax
  800df3:	6a 00                	push   $0x0
  800df5:	e8 bf f3 ff ff       	call   8001b9 <sys_page_alloc>
  800dfa:	89 c3                	mov    %eax,%ebx
  800dfc:	83 c4 10             	add    $0x10,%esp
  800dff:	85 c0                	test   %eax,%eax
  800e01:	0f 88 82 00 00 00    	js     800e89 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e07:	83 ec 0c             	sub    $0xc,%esp
  800e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e0d:	e8 f8 f4 ff ff       	call   80030a <fd2data>
  800e12:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e19:	50                   	push   %eax
  800e1a:	6a 00                	push   $0x0
  800e1c:	56                   	push   %esi
  800e1d:	6a 00                	push   $0x0
  800e1f:	e8 bd f3 ff ff       	call   8001e1 <sys_page_map>
  800e24:	89 c3                	mov    %eax,%ebx
  800e26:	83 c4 20             	add    $0x20,%esp
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	78 4e                	js     800e7b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e2d:	a1 20 30 80 00       	mov    0x803020,%eax
  800e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e35:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e44:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e49:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	ff 75 f4             	pushl  -0xc(%ebp)
  800e56:	e8 9b f4 ff ff       	call   8002f6 <fd2num>
  800e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e60:	83 c4 04             	add    $0x4,%esp
  800e63:	ff 75 f0             	pushl  -0x10(%ebp)
  800e66:	e8 8b f4 ff ff       	call   8002f6 <fd2num>
  800e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e71:	83 c4 10             	add    $0x10,%esp
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	eb 2e                	jmp    800ea9 <pipe+0x145>
	sys_page_unmap(0, va);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	56                   	push   %esi
  800e7f:	6a 00                	push   $0x0
  800e81:	e8 85 f3 ff ff       	call   80020b <sys_page_unmap>
  800e86:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e8f:	6a 00                	push   $0x0
  800e91:	e8 75 f3 ff ff       	call   80020b <sys_page_unmap>
  800e96:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800e99:	83 ec 08             	sub    $0x8,%esp
  800e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9f:	6a 00                	push   $0x0
  800ea1:	e8 65 f3 ff ff       	call   80020b <sys_page_unmap>
  800ea6:	83 c4 10             	add    $0x10,%esp
}
  800ea9:	89 d8                	mov    %ebx,%eax
  800eab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <pipeisclosed>:
{
  800eb2:	f3 0f 1e fb          	endbr32 
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ebf:	50                   	push   %eax
  800ec0:	ff 75 08             	pushl  0x8(%ebp)
  800ec3:	e8 b7 f4 ff ff       	call   80037f <fd_lookup>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	78 18                	js     800ee7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed5:	e8 30 f4 ff ff       	call   80030a <fd2data>
  800eda:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edf:	e8 1f fd ff ff       	call   800c03 <_pipeisclosed>
  800ee4:	83 c4 10             	add    $0x10,%esp
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800ee9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef2:	c3                   	ret    

00800ef3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800ef3:	f3 0f 1e fb          	endbr32 
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800efd:	68 43 1f 80 00       	push   $0x801f43
  800f02:	ff 75 0c             	pushl  0xc(%ebp)
  800f05:	e8 c5 07 00 00       	call   8016cf <strcpy>
	return 0;
}
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <devcons_write>:
{
  800f11:	f3 0f 1e fb          	endbr32 
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f21:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f2c:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f2f:	73 31                	jae    800f62 <devcons_write+0x51>
		m = n - tot;
  800f31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f34:	29 f3                	sub    %esi,%ebx
  800f36:	83 fb 7f             	cmp    $0x7f,%ebx
  800f39:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f3e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	53                   	push   %ebx
  800f45:	89 f0                	mov    %esi,%eax
  800f47:	03 45 0c             	add    0xc(%ebp),%eax
  800f4a:	50                   	push   %eax
  800f4b:	57                   	push   %edi
  800f4c:	e8 36 09 00 00       	call   801887 <memmove>
		sys_cputs(buf, m);
  800f51:	83 c4 08             	add    $0x8,%esp
  800f54:	53                   	push   %ebx
  800f55:	57                   	push   %edi
  800f56:	e8 93 f1 ff ff       	call   8000ee <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f5b:	01 de                	add    %ebx,%esi
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	eb ca                	jmp    800f2c <devcons_write+0x1b>
}
  800f62:	89 f0                	mov    %esi,%eax
  800f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <devcons_read>:
{
  800f6c:	f3 0f 1e fb          	endbr32 
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	74 21                	je     800fa2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f81:	e8 92 f1 ff ff       	call   800118 <sys_cgetc>
  800f86:	85 c0                	test   %eax,%eax
  800f88:	75 07                	jne    800f91 <devcons_read+0x25>
		sys_yield();
  800f8a:	e8 ff f1 ff ff       	call   80018e <sys_yield>
  800f8f:	eb f0                	jmp    800f81 <devcons_read+0x15>
	if (c < 0)
  800f91:	78 0f                	js     800fa2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800f93:	83 f8 04             	cmp    $0x4,%eax
  800f96:	74 0c                	je     800fa4 <devcons_read+0x38>
	*(char*)vbuf = c;
  800f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9b:	88 02                	mov    %al,(%edx)
	return 1;
  800f9d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    
		return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	eb f7                	jmp    800fa2 <devcons_read+0x36>

00800fab <cputchar>:
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fbb:	6a 01                	push   $0x1
  800fbd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	e8 28 f1 ff ff       	call   8000ee <sys_cputs>
}
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <getchar>:
{
  800fcb:	f3 0f 1e fb          	endbr32 
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fd5:	6a 01                	push   $0x1
  800fd7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fda:	50                   	push   %eax
  800fdb:	6a 00                	push   $0x0
  800fdd:	e8 20 f6 ff ff       	call   800602 <read>
	if (r < 0)
  800fe2:	83 c4 10             	add    $0x10,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	78 06                	js     800fef <getchar+0x24>
	if (r < 1)
  800fe9:	74 06                	je     800ff1 <getchar+0x26>
	return c;
  800feb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    
		return -E_EOF;
  800ff1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800ff6:	eb f7                	jmp    800fef <getchar+0x24>

00800ff8 <iscons>:
{
  800ff8:	f3 0f 1e fb          	endbr32 
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801002:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801005:	50                   	push   %eax
  801006:	ff 75 08             	pushl  0x8(%ebp)
  801009:	e8 71 f3 ff ff       	call   80037f <fd_lookup>
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	78 11                	js     801026 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801018:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80101e:	39 10                	cmp    %edx,(%eax)
  801020:	0f 94 c0             	sete   %al
  801023:	0f b6 c0             	movzbl %al,%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <opencons>:
{
  801028:	f3 0f 1e fb          	endbr32 
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801032:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801035:	50                   	push   %eax
  801036:	e8 ee f2 ff ff       	call   800329 <fd_alloc>
  80103b:	83 c4 10             	add    $0x10,%esp
  80103e:	85 c0                	test   %eax,%eax
  801040:	78 3a                	js     80107c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	68 07 04 00 00       	push   $0x407
  80104a:	ff 75 f4             	pushl  -0xc(%ebp)
  80104d:	6a 00                	push   $0x0
  80104f:	e8 65 f1 ff ff       	call   8001b9 <sys_page_alloc>
  801054:	83 c4 10             	add    $0x10,%esp
  801057:	85 c0                	test   %eax,%eax
  801059:	78 21                	js     80107c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80105b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801064:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801069:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	50                   	push   %eax
  801074:	e8 7d f2 ff ff       	call   8002f6 <fd2num>
  801079:	83 c4 10             	add    $0x10,%esp
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80107e:	f3 0f 1e fb          	endbr32 
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801087:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80108a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801090:	e8 d1 f0 ff ff       	call   800166 <sys_getenvid>
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	ff 75 08             	pushl  0x8(%ebp)
  80109e:	56                   	push   %esi
  80109f:	50                   	push   %eax
  8010a0:	68 50 1f 80 00       	push   $0x801f50
  8010a5:	e8 bb 00 00 00       	call   801165 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010aa:	83 c4 18             	add    $0x18,%esp
  8010ad:	53                   	push   %ebx
  8010ae:	ff 75 10             	pushl  0x10(%ebp)
  8010b1:	e8 5a 00 00 00       	call   801110 <vcprintf>
	cprintf("\n");
  8010b6:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010bd:	e8 a3 00 00 00       	call   801165 <cprintf>
  8010c2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010c5:	cc                   	int3   
  8010c6:	eb fd                	jmp    8010c5 <_panic+0x47>

008010c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010c8:	f3 0f 1e fb          	endbr32 
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010d6:	8b 13                	mov    (%ebx),%edx
  8010d8:	8d 42 01             	lea    0x1(%edx),%eax
  8010db:	89 03                	mov    %eax,(%ebx)
  8010dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010e9:	74 09                	je     8010f4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010eb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8010ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	68 ff 00 00 00       	push   $0xff
  8010fc:	8d 43 08             	lea    0x8(%ebx),%eax
  8010ff:	50                   	push   %eax
  801100:	e8 e9 ef ff ff       	call   8000ee <sys_cputs>
		b->idx = 0;
  801105:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	eb db                	jmp    8010eb <putch+0x23>

00801110 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80111d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801124:	00 00 00 
	b.cnt = 0;
  801127:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80112e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	ff 75 08             	pushl  0x8(%ebp)
  801137:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80113d:	50                   	push   %eax
  80113e:	68 c8 10 80 00       	push   $0x8010c8
  801143:	e8 80 01 00 00       	call   8012c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801148:	83 c4 08             	add    $0x8,%esp
  80114b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801151:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801157:	50                   	push   %eax
  801158:	e8 91 ef ff ff       	call   8000ee <sys_cputs>

	return b.cnt;
}
  80115d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801165:	f3 0f 1e fb          	endbr32 
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80116f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801172:	50                   	push   %eax
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	e8 95 ff ff ff       	call   801110 <vcprintf>
	va_end(ap);

	return cnt;
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 1c             	sub    $0x1c,%esp
  801186:	89 c7                	mov    %eax,%edi
  801188:	89 d6                	mov    %edx,%esi
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	89 d1                	mov    %edx,%ecx
  801192:	89 c2                	mov    %eax,%edx
  801194:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801197:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011aa:	39 c2                	cmp    %eax,%edx
  8011ac:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011af:	72 3e                	jb     8011ef <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	ff 75 18             	pushl  0x18(%ebp)
  8011b7:	83 eb 01             	sub    $0x1,%ebx
  8011ba:	53                   	push   %ebx
  8011bb:	50                   	push   %eax
  8011bc:	83 ec 08             	sub    $0x8,%esp
  8011bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8011c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8011c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8011cb:	e8 c0 09 00 00       	call   801b90 <__udivdi3>
  8011d0:	83 c4 18             	add    $0x18,%esp
  8011d3:	52                   	push   %edx
  8011d4:	50                   	push   %eax
  8011d5:	89 f2                	mov    %esi,%edx
  8011d7:	89 f8                	mov    %edi,%eax
  8011d9:	e8 9f ff ff ff       	call   80117d <printnum>
  8011de:	83 c4 20             	add    $0x20,%esp
  8011e1:	eb 13                	jmp    8011f6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	56                   	push   %esi
  8011e7:	ff 75 18             	pushl  0x18(%ebp)
  8011ea:	ff d7                	call   *%edi
  8011ec:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8011ef:	83 eb 01             	sub    $0x1,%ebx
  8011f2:	85 db                	test   %ebx,%ebx
  8011f4:	7f ed                	jg     8011e3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	56                   	push   %esi
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801200:	ff 75 e0             	pushl  -0x20(%ebp)
  801203:	ff 75 dc             	pushl  -0x24(%ebp)
  801206:	ff 75 d8             	pushl  -0x28(%ebp)
  801209:	e8 92 0a 00 00       	call   801ca0 <__umoddi3>
  80120e:	83 c4 14             	add    $0x14,%esp
  801211:	0f be 80 73 1f 80 00 	movsbl 0x801f73(%eax),%eax
  801218:	50                   	push   %eax
  801219:	ff d7                	call   *%edi
}
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    

00801226 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801226:	83 fa 01             	cmp    $0x1,%edx
  801229:	7f 13                	jg     80123e <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  80122b:	85 d2                	test   %edx,%edx
  80122d:	74 1c                	je     80124b <getuint+0x25>
		return va_arg(*ap, unsigned long);
  80122f:	8b 10                	mov    (%eax),%edx
  801231:	8d 4a 04             	lea    0x4(%edx),%ecx
  801234:	89 08                	mov    %ecx,(%eax)
  801236:	8b 02                	mov    (%edx),%eax
  801238:	ba 00 00 00 00       	mov    $0x0,%edx
  80123d:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  80123e:	8b 10                	mov    (%eax),%edx
  801240:	8d 4a 08             	lea    0x8(%edx),%ecx
  801243:	89 08                	mov    %ecx,(%eax)
  801245:	8b 02                	mov    (%edx),%eax
  801247:	8b 52 04             	mov    0x4(%edx),%edx
  80124a:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80124b:	8b 10                	mov    (%eax),%edx
  80124d:	8d 4a 04             	lea    0x4(%edx),%ecx
  801250:	89 08                	mov    %ecx,(%eax)
  801252:	8b 02                	mov    (%edx),%eax
  801254:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801259:	c3                   	ret    

0080125a <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80125a:	83 fa 01             	cmp    $0x1,%edx
  80125d:	7f 0f                	jg     80126e <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  80125f:	85 d2                	test   %edx,%edx
  801261:	74 18                	je     80127b <getint+0x21>
		return va_arg(*ap, long);
  801263:	8b 10                	mov    (%eax),%edx
  801265:	8d 4a 04             	lea    0x4(%edx),%ecx
  801268:	89 08                	mov    %ecx,(%eax)
  80126a:	8b 02                	mov    (%edx),%eax
  80126c:	99                   	cltd   
  80126d:	c3                   	ret    
		return va_arg(*ap, long long);
  80126e:	8b 10                	mov    (%eax),%edx
  801270:	8d 4a 08             	lea    0x8(%edx),%ecx
  801273:	89 08                	mov    %ecx,(%eax)
  801275:	8b 02                	mov    (%edx),%eax
  801277:	8b 52 04             	mov    0x4(%edx),%edx
  80127a:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80127b:	8b 10                	mov    (%eax),%edx
  80127d:	8d 4a 04             	lea    0x4(%edx),%ecx
  801280:	89 08                	mov    %ecx,(%eax)
  801282:	8b 02                	mov    (%edx),%eax
  801284:	99                   	cltd   
}
  801285:	c3                   	ret    

00801286 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801286:	f3 0f 1e fb          	endbr32 
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801290:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801294:	8b 10                	mov    (%eax),%edx
  801296:	3b 50 04             	cmp    0x4(%eax),%edx
  801299:	73 0a                	jae    8012a5 <sprintputch+0x1f>
		*b->buf++ = ch;
  80129b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129e:	89 08                	mov    %ecx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	88 02                	mov    %al,(%edx)
}
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <printfmt>:
{
  8012a7:	f3 0f 1e fb          	endbr32 
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 10             	pushl  0x10(%ebp)
  8012b8:	ff 75 0c             	pushl  0xc(%ebp)
  8012bb:	ff 75 08             	pushl  0x8(%ebp)
  8012be:	e8 05 00 00 00       	call   8012c8 <vprintfmt>
}
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <vprintfmt>:
{
  8012c8:	f3 0f 1e fb          	endbr32 
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 2c             	sub    $0x2c,%esp
  8012d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012db:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012de:	e9 86 02 00 00       	jmp    801569 <vprintfmt+0x2a1>
		padc = ' ';
  8012e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8012ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8012f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801301:	8d 47 01             	lea    0x1(%edi),%eax
  801304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801307:	0f b6 17             	movzbl (%edi),%edx
  80130a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80130d:	3c 55                	cmp    $0x55,%al
  80130f:	0f 87 df 02 00 00    	ja     8015f4 <vprintfmt+0x32c>
  801315:	0f b6 c0             	movzbl %al,%eax
  801318:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  80131f:	00 
  801320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801323:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801327:	eb d8                	jmp    801301 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80132c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801330:	eb cf                	jmp    801301 <vprintfmt+0x39>
  801332:	0f b6 d2             	movzbl %dl,%edx
  801335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801340:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801343:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801347:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80134a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80134d:	83 f9 09             	cmp    $0x9,%ecx
  801350:	77 52                	ja     8013a4 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801352:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801355:	eb e9                	jmp    801340 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	8d 50 04             	lea    0x4(%eax),%edx
  80135d:	89 55 14             	mov    %edx,0x14(%ebp)
  801360:	8b 00                	mov    (%eax),%eax
  801362:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 93                	jns    801301 <vprintfmt+0x39>
				width = precision, precision = -1;
  80136e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801374:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80137b:	eb 84                	jmp    801301 <vprintfmt+0x39>
  80137d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801380:	85 c0                	test   %eax,%eax
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	0f 49 d0             	cmovns %eax,%edx
  80138a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80138d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801390:	e9 6c ff ff ff       	jmp    801301 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801398:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80139f:	e9 5d ff ff ff       	jmp    801301 <vprintfmt+0x39>
  8013a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013aa:	eb bc                	jmp    801368 <vprintfmt+0xa0>
			lflag++;
  8013ac:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013b2:	e9 4a ff ff ff       	jmp    801301 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ba:	8d 50 04             	lea    0x4(%eax),%edx
  8013bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	56                   	push   %esi
  8013c4:	ff 30                	pushl  (%eax)
  8013c6:	ff d3                	call   *%ebx
			break;
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	e9 96 01 00 00       	jmp    801566 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8d 50 04             	lea    0x4(%eax),%edx
  8013d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	99                   	cltd   
  8013dc:	31 d0                	xor    %edx,%eax
  8013de:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013e0:	83 f8 0f             	cmp    $0xf,%eax
  8013e3:	7f 20                	jg     801405 <vprintfmt+0x13d>
  8013e5:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8013ec:	85 d2                	test   %edx,%edx
  8013ee:	74 15                	je     801405 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8013f0:	52                   	push   %edx
  8013f1:	68 03 1f 80 00       	push   $0x801f03
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
  8013f8:	e8 aa fe ff ff       	call   8012a7 <printfmt>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	e9 61 01 00 00       	jmp    801566 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  801405:	50                   	push   %eax
  801406:	68 8b 1f 80 00       	push   $0x801f8b
  80140b:	56                   	push   %esi
  80140c:	53                   	push   %ebx
  80140d:	e8 95 fe ff ff       	call   8012a7 <printfmt>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	e9 4c 01 00 00       	jmp    801566 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	8d 50 04             	lea    0x4(%eax),%edx
  801420:	89 55 14             	mov    %edx,0x14(%ebp)
  801423:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  801425:	85 c9                	test   %ecx,%ecx
  801427:	b8 84 1f 80 00       	mov    $0x801f84,%eax
  80142c:	0f 45 c1             	cmovne %ecx,%eax
  80142f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801432:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801436:	7e 06                	jle    80143e <vprintfmt+0x176>
  801438:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80143c:	75 0d                	jne    80144b <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  80143e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801441:	89 c7                	mov    %eax,%edi
  801443:	03 45 e0             	add    -0x20(%ebp),%eax
  801446:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801449:	eb 57                	jmp    8014a2 <vprintfmt+0x1da>
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	ff 75 d8             	pushl  -0x28(%ebp)
  801451:	ff 75 cc             	pushl  -0x34(%ebp)
  801454:	e8 4f 02 00 00       	call   8016a8 <strnlen>
  801459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145c:	29 c2                	sub    %eax,%edx
  80145e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801461:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801464:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801468:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80146b:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80146d:	85 db                	test   %ebx,%ebx
  80146f:	7e 10                	jle    801481 <vprintfmt+0x1b9>
					putch(padc, putdat);
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	56                   	push   %esi
  801475:	57                   	push   %edi
  801476:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801479:	83 eb 01             	sub    $0x1,%ebx
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	eb ec                	jmp    80146d <vprintfmt+0x1a5>
  801481:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801484:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801487:	85 d2                	test   %edx,%edx
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	0f 49 c2             	cmovns %edx,%eax
  801491:	29 c2                	sub    %eax,%edx
  801493:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801496:	eb a6                	jmp    80143e <vprintfmt+0x176>
					putch(ch, putdat);
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	56                   	push   %esi
  80149c:	52                   	push   %edx
  80149d:	ff d3                	call   *%ebx
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014a7:	83 c7 01             	add    $0x1,%edi
  8014aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014ae:	0f be d0             	movsbl %al,%edx
  8014b1:	85 d2                	test   %edx,%edx
  8014b3:	74 42                	je     8014f7 <vprintfmt+0x22f>
  8014b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014b9:	78 06                	js     8014c1 <vprintfmt+0x1f9>
  8014bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014bf:	78 1e                	js     8014df <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014c5:	74 d1                	je     801498 <vprintfmt+0x1d0>
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	83 e8 20             	sub    $0x20,%eax
  8014cd:	83 f8 5e             	cmp    $0x5e,%eax
  8014d0:	76 c6                	jbe    801498 <vprintfmt+0x1d0>
					putch('?', putdat);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	56                   	push   %esi
  8014d6:	6a 3f                	push   $0x3f
  8014d8:	ff d3                	call   *%ebx
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	eb c3                	jmp    8014a2 <vprintfmt+0x1da>
  8014df:	89 cf                	mov    %ecx,%edi
  8014e1:	eb 0e                	jmp    8014f1 <vprintfmt+0x229>
				putch(' ', putdat);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	56                   	push   %esi
  8014e7:	6a 20                	push   $0x20
  8014e9:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8014eb:	83 ef 01             	sub    $0x1,%edi
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 ff                	test   %edi,%edi
  8014f3:	7f ee                	jg     8014e3 <vprintfmt+0x21b>
  8014f5:	eb 6f                	jmp    801566 <vprintfmt+0x29e>
  8014f7:	89 cf                	mov    %ecx,%edi
  8014f9:	eb f6                	jmp    8014f1 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  8014fb:	89 ca                	mov    %ecx,%edx
  8014fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801500:	e8 55 fd ff ff       	call   80125a <getint>
  801505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801508:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80150b:	85 d2                	test   %edx,%edx
  80150d:	78 0b                	js     80151a <vprintfmt+0x252>
			num = getint(&ap, lflag);
  80150f:	89 d1                	mov    %edx,%ecx
  801511:	89 c2                	mov    %eax,%edx
			base = 10;
  801513:	b8 0a 00 00 00       	mov    $0xa,%eax
  801518:	eb 32                	jmp    80154c <vprintfmt+0x284>
				putch('-', putdat);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	56                   	push   %esi
  80151e:	6a 2d                	push   $0x2d
  801520:	ff d3                	call   *%ebx
				num = -(long long) num;
  801522:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801525:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801528:	f7 da                	neg    %edx
  80152a:	83 d1 00             	adc    $0x0,%ecx
  80152d:	f7 d9                	neg    %ecx
  80152f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801532:	b8 0a 00 00 00       	mov    $0xa,%eax
  801537:	eb 13                	jmp    80154c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801539:	89 ca                	mov    %ecx,%edx
  80153b:	8d 45 14             	lea    0x14(%ebp),%eax
  80153e:	e8 e3 fc ff ff       	call   801226 <getuint>
  801543:	89 d1                	mov    %edx,%ecx
  801545:	89 c2                	mov    %eax,%edx
			base = 10;
  801547:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801553:	57                   	push   %edi
  801554:	ff 75 e0             	pushl  -0x20(%ebp)
  801557:	50                   	push   %eax
  801558:	51                   	push   %ecx
  801559:	52                   	push   %edx
  80155a:	89 f2                	mov    %esi,%edx
  80155c:	89 d8                	mov    %ebx,%eax
  80155e:	e8 1a fc ff ff       	call   80117d <printnum>
			break;
  801563:	83 c4 20             	add    $0x20,%esp
{
  801566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801569:	83 c7 01             	add    $0x1,%edi
  80156c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801570:	83 f8 25             	cmp    $0x25,%eax
  801573:	0f 84 6a fd ff ff    	je     8012e3 <vprintfmt+0x1b>
			if (ch == '\0')
  801579:	85 c0                	test   %eax,%eax
  80157b:	0f 84 93 00 00 00    	je     801614 <vprintfmt+0x34c>
			putch(ch, putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	56                   	push   %esi
  801585:	50                   	push   %eax
  801586:	ff d3                	call   *%ebx
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	eb dc                	jmp    801569 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80158d:	89 ca                	mov    %ecx,%edx
  80158f:	8d 45 14             	lea    0x14(%ebp),%eax
  801592:	e8 8f fc ff ff       	call   801226 <getuint>
  801597:	89 d1                	mov    %edx,%ecx
  801599:	89 c2                	mov    %eax,%edx
			base = 8;
  80159b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015a0:	eb aa                	jmp    80154c <vprintfmt+0x284>
			putch('0', putdat);
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	56                   	push   %esi
  8015a6:	6a 30                	push   $0x30
  8015a8:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015aa:	83 c4 08             	add    $0x8,%esp
  8015ad:	56                   	push   %esi
  8015ae:	6a 78                	push   $0x78
  8015b0:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b5:	8d 50 04             	lea    0x4(%eax),%edx
  8015b8:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015c2:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015c5:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015ca:	eb 80                	jmp    80154c <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015cc:	89 ca                	mov    %ecx,%edx
  8015ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8015d1:	e8 50 fc ff ff       	call   801226 <getuint>
  8015d6:	89 d1                	mov    %edx,%ecx
  8015d8:	89 c2                	mov    %eax,%edx
			base = 16;
  8015da:	b8 10 00 00 00       	mov    $0x10,%eax
  8015df:	e9 68 ff ff ff       	jmp    80154c <vprintfmt+0x284>
			putch(ch, putdat);
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	56                   	push   %esi
  8015e8:	6a 25                	push   $0x25
  8015ea:	ff d3                	call   *%ebx
			break;
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	e9 72 ff ff ff       	jmp    801566 <vprintfmt+0x29e>
			putch('%', putdat);
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	56                   	push   %esi
  8015f8:	6a 25                	push   $0x25
  8015fa:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	89 f8                	mov    %edi,%eax
  801601:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801605:	74 05                	je     80160c <vprintfmt+0x344>
  801607:	83 e8 01             	sub    $0x1,%eax
  80160a:	eb f5                	jmp    801601 <vprintfmt+0x339>
  80160c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80160f:	e9 52 ff ff ff       	jmp    801566 <vprintfmt+0x29e>
}
  801614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5f                   	pop    %edi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80161c:	f3 0f 1e fb          	endbr32 
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 18             	sub    $0x18,%esp
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80162c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80162f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801633:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80163d:	85 c0                	test   %eax,%eax
  80163f:	74 26                	je     801667 <vsnprintf+0x4b>
  801641:	85 d2                	test   %edx,%edx
  801643:	7e 22                	jle    801667 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801645:	ff 75 14             	pushl  0x14(%ebp)
  801648:	ff 75 10             	pushl  0x10(%ebp)
  80164b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80164e:	50                   	push   %eax
  80164f:	68 86 12 80 00       	push   $0x801286
  801654:	e8 6f fc ff ff       	call   8012c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801662:	83 c4 10             	add    $0x10,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    
		return -E_INVAL;
  801667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166c:	eb f7                	jmp    801665 <vsnprintf+0x49>

0080166e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80166e:	f3 0f 1e fb          	endbr32 
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801678:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80167b:	50                   	push   %eax
  80167c:	ff 75 10             	pushl  0x10(%ebp)
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	ff 75 08             	pushl  0x8(%ebp)
  801685:	e8 92 ff ff ff       	call   80161c <vsnprintf>
	va_end(ap);

	return rc;
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80168c:	f3 0f 1e fb          	endbr32 
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801696:	b8 00 00 00 00       	mov    $0x0,%eax
  80169b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80169f:	74 05                	je     8016a6 <strlen+0x1a>
		n++;
  8016a1:	83 c0 01             	add    $0x1,%eax
  8016a4:	eb f5                	jmp    80169b <strlen+0xf>
	return n;
}
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016a8:	f3 0f 1e fb          	endbr32 
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	39 d0                	cmp    %edx,%eax
  8016bc:	74 0d                	je     8016cb <strnlen+0x23>
  8016be:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016c2:	74 05                	je     8016c9 <strnlen+0x21>
		n++;
  8016c4:	83 c0 01             	add    $0x1,%eax
  8016c7:	eb f1                	jmp    8016ba <strnlen+0x12>
  8016c9:	89 c2                	mov    %eax,%edx
	return n;
}
  8016cb:	89 d0                	mov    %edx,%eax
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016cf:	f3 0f 1e fb          	endbr32 
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	53                   	push   %ebx
  8016d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016e6:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016e9:	83 c0 01             	add    $0x1,%eax
  8016ec:	84 d2                	test   %dl,%dl
  8016ee:	75 f2                	jne    8016e2 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8016f0:	89 c8                	mov    %ecx,%eax
  8016f2:	5b                   	pop    %ebx
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016f5:	f3 0f 1e fb          	endbr32 
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 10             	sub    $0x10,%esp
  801700:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801703:	53                   	push   %ebx
  801704:	e8 83 ff ff ff       	call   80168c <strlen>
  801709:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	01 d8                	add    %ebx,%eax
  801711:	50                   	push   %eax
  801712:	e8 b8 ff ff ff       	call   8016cf <strcpy>
	return dst;
}
  801717:	89 d8                	mov    %ebx,%eax
  801719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80171e:	f3 0f 1e fb          	endbr32 
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	56                   	push   %esi
  801726:	53                   	push   %ebx
  801727:	8b 75 08             	mov    0x8(%ebp),%esi
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	89 f3                	mov    %esi,%ebx
  80172f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801732:	89 f0                	mov    %esi,%eax
  801734:	39 d8                	cmp    %ebx,%eax
  801736:	74 11                	je     801749 <strncpy+0x2b>
		*dst++ = *src;
  801738:	83 c0 01             	add    $0x1,%eax
  80173b:	0f b6 0a             	movzbl (%edx),%ecx
  80173e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801741:	80 f9 01             	cmp    $0x1,%cl
  801744:	83 da ff             	sbb    $0xffffffff,%edx
  801747:	eb eb                	jmp    801734 <strncpy+0x16>
	}
	return ret;
}
  801749:	89 f0                	mov    %esi,%eax
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80174f:	f3 0f 1e fb          	endbr32 
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	8b 75 08             	mov    0x8(%ebp),%esi
  80175b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80175e:	8b 55 10             	mov    0x10(%ebp),%edx
  801761:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801763:	85 d2                	test   %edx,%edx
  801765:	74 21                	je     801788 <strlcpy+0x39>
  801767:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80176b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80176d:	39 c2                	cmp    %eax,%edx
  80176f:	74 14                	je     801785 <strlcpy+0x36>
  801771:	0f b6 19             	movzbl (%ecx),%ebx
  801774:	84 db                	test   %bl,%bl
  801776:	74 0b                	je     801783 <strlcpy+0x34>
			*dst++ = *src++;
  801778:	83 c1 01             	add    $0x1,%ecx
  80177b:	83 c2 01             	add    $0x1,%edx
  80177e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801781:	eb ea                	jmp    80176d <strlcpy+0x1e>
  801783:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801785:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801788:	29 f0                	sub    %esi,%eax
}
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    

0080178e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80178e:	f3 0f 1e fb          	endbr32 
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80179b:	0f b6 01             	movzbl (%ecx),%eax
  80179e:	84 c0                	test   %al,%al
  8017a0:	74 0c                	je     8017ae <strcmp+0x20>
  8017a2:	3a 02                	cmp    (%edx),%al
  8017a4:	75 08                	jne    8017ae <strcmp+0x20>
		p++, q++;
  8017a6:	83 c1 01             	add    $0x1,%ecx
  8017a9:	83 c2 01             	add    $0x1,%edx
  8017ac:	eb ed                	jmp    80179b <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017ae:	0f b6 c0             	movzbl %al,%eax
  8017b1:	0f b6 12             	movzbl (%edx),%edx
  8017b4:	29 d0                	sub    %edx,%eax
}
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017b8:	f3 0f 1e fb          	endbr32 
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017cb:	eb 06                	jmp    8017d3 <strncmp+0x1b>
		n--, p++, q++;
  8017cd:	83 c0 01             	add    $0x1,%eax
  8017d0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017d3:	39 d8                	cmp    %ebx,%eax
  8017d5:	74 16                	je     8017ed <strncmp+0x35>
  8017d7:	0f b6 08             	movzbl (%eax),%ecx
  8017da:	84 c9                	test   %cl,%cl
  8017dc:	74 04                	je     8017e2 <strncmp+0x2a>
  8017de:	3a 0a                	cmp    (%edx),%cl
  8017e0:	74 eb                	je     8017cd <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017e2:	0f b6 00             	movzbl (%eax),%eax
  8017e5:	0f b6 12             	movzbl (%edx),%edx
  8017e8:	29 d0                	sub    %edx,%eax
}
  8017ea:	5b                   	pop    %ebx
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
		return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb f6                	jmp    8017ea <strncmp+0x32>

008017f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f4:	f3 0f 1e fb          	endbr32 
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801802:	0f b6 10             	movzbl (%eax),%edx
  801805:	84 d2                	test   %dl,%dl
  801807:	74 09                	je     801812 <strchr+0x1e>
		if (*s == c)
  801809:	38 ca                	cmp    %cl,%dl
  80180b:	74 0a                	je     801817 <strchr+0x23>
	for (; *s; s++)
  80180d:	83 c0 01             	add    $0x1,%eax
  801810:	eb f0                	jmp    801802 <strchr+0xe>
			return (char *) s;
	return 0;
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    

00801819 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801819:	f3 0f 1e fb          	endbr32 
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801827:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80182a:	38 ca                	cmp    %cl,%dl
  80182c:	74 09                	je     801837 <strfind+0x1e>
  80182e:	84 d2                	test   %dl,%dl
  801830:	74 05                	je     801837 <strfind+0x1e>
	for (; *s; s++)
  801832:	83 c0 01             	add    $0x1,%eax
  801835:	eb f0                	jmp    801827 <strfind+0xe>
			break;
	return (char *) s;
}
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	57                   	push   %edi
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801849:	85 c9                	test   %ecx,%ecx
  80184b:	74 33                	je     801880 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80184d:	89 d0                	mov    %edx,%eax
  80184f:	09 c8                	or     %ecx,%eax
  801851:	a8 03                	test   $0x3,%al
  801853:	75 23                	jne    801878 <memset+0x3f>
		c &= 0xFF;
  801855:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801859:	89 d8                	mov    %ebx,%eax
  80185b:	c1 e0 08             	shl    $0x8,%eax
  80185e:	89 df                	mov    %ebx,%edi
  801860:	c1 e7 18             	shl    $0x18,%edi
  801863:	89 de                	mov    %ebx,%esi
  801865:	c1 e6 10             	shl    $0x10,%esi
  801868:	09 f7                	or     %esi,%edi
  80186a:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80186c:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80186f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801871:	89 d7                	mov    %edx,%edi
  801873:	fc                   	cld    
  801874:	f3 ab                	rep stos %eax,%es:(%edi)
  801876:	eb 08                	jmp    801880 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801878:	89 d7                	mov    %edx,%edi
  80187a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187d:	fc                   	cld    
  80187e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801880:	89 d0                	mov    %edx,%eax
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5f                   	pop    %edi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801887:	f3 0f 1e fb          	endbr32 
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	57                   	push   %edi
  80188f:	56                   	push   %esi
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 75 0c             	mov    0xc(%ebp),%esi
  801896:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801899:	39 c6                	cmp    %eax,%esi
  80189b:	73 32                	jae    8018cf <memmove+0x48>
  80189d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018a0:	39 c2                	cmp    %eax,%edx
  8018a2:	76 2b                	jbe    8018cf <memmove+0x48>
		s += n;
		d += n;
  8018a4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018a7:	89 fe                	mov    %edi,%esi
  8018a9:	09 ce                	or     %ecx,%esi
  8018ab:	09 d6                	or     %edx,%esi
  8018ad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018b3:	75 0e                	jne    8018c3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018b5:	83 ef 04             	sub    $0x4,%edi
  8018b8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018bb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018be:	fd                   	std    
  8018bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018c1:	eb 09                	jmp    8018cc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018c3:	83 ef 01             	sub    $0x1,%edi
  8018c6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018c9:	fd                   	std    
  8018ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018cc:	fc                   	cld    
  8018cd:	eb 1a                	jmp    8018e9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	09 ca                	or     %ecx,%edx
  8018d3:	09 f2                	or     %esi,%edx
  8018d5:	f6 c2 03             	test   $0x3,%dl
  8018d8:	75 0a                	jne    8018e4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018da:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018dd:	89 c7                	mov    %eax,%edi
  8018df:	fc                   	cld    
  8018e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018e2:	eb 05                	jmp    8018e9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018e4:	89 c7                	mov    %eax,%edi
  8018e6:	fc                   	cld    
  8018e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018e9:	5e                   	pop    %esi
  8018ea:	5f                   	pop    %edi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    

008018ed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018ed:	f3 0f 1e fb          	endbr32 
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8018f7:	ff 75 10             	pushl  0x10(%ebp)
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	ff 75 08             	pushl  0x8(%ebp)
  801900:	e8 82 ff ff ff       	call   801887 <memmove>
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801907:	f3 0f 1e fb          	endbr32 
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	89 c6                	mov    %eax,%esi
  801918:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80191b:	39 f0                	cmp    %esi,%eax
  80191d:	74 1c                	je     80193b <memcmp+0x34>
		if (*s1 != *s2)
  80191f:	0f b6 08             	movzbl (%eax),%ecx
  801922:	0f b6 1a             	movzbl (%edx),%ebx
  801925:	38 d9                	cmp    %bl,%cl
  801927:	75 08                	jne    801931 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801929:	83 c0 01             	add    $0x1,%eax
  80192c:	83 c2 01             	add    $0x1,%edx
  80192f:	eb ea                	jmp    80191b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801931:	0f b6 c1             	movzbl %cl,%eax
  801934:	0f b6 db             	movzbl %bl,%ebx
  801937:	29 d8                	sub    %ebx,%eax
  801939:	eb 05                	jmp    801940 <memcmp+0x39>
	}

	return 0;
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801944:	f3 0f 1e fb          	endbr32 
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801951:	89 c2                	mov    %eax,%edx
  801953:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801956:	39 d0                	cmp    %edx,%eax
  801958:	73 09                	jae    801963 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80195a:	38 08                	cmp    %cl,(%eax)
  80195c:	74 05                	je     801963 <memfind+0x1f>
	for (; s < ends; s++)
  80195e:	83 c0 01             	add    $0x1,%eax
  801961:	eb f3                	jmp    801956 <memfind+0x12>
			break;
	return (void *) s;
}
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801965:	f3 0f 1e fb          	endbr32 
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801972:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801975:	eb 03                	jmp    80197a <strtol+0x15>
		s++;
  801977:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80197a:	0f b6 01             	movzbl (%ecx),%eax
  80197d:	3c 20                	cmp    $0x20,%al
  80197f:	74 f6                	je     801977 <strtol+0x12>
  801981:	3c 09                	cmp    $0x9,%al
  801983:	74 f2                	je     801977 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801985:	3c 2b                	cmp    $0x2b,%al
  801987:	74 2a                	je     8019b3 <strtol+0x4e>
	int neg = 0;
  801989:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80198e:	3c 2d                	cmp    $0x2d,%al
  801990:	74 2b                	je     8019bd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801992:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801998:	75 0f                	jne    8019a9 <strtol+0x44>
  80199a:	80 39 30             	cmpb   $0x30,(%ecx)
  80199d:	74 28                	je     8019c7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80199f:	85 db                	test   %ebx,%ebx
  8019a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a6:	0f 44 d8             	cmove  %eax,%ebx
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019b1:	eb 46                	jmp    8019f9 <strtol+0x94>
		s++;
  8019b3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8019bb:	eb d5                	jmp    801992 <strtol+0x2d>
		s++, neg = 1;
  8019bd:	83 c1 01             	add    $0x1,%ecx
  8019c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019c5:	eb cb                	jmp    801992 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019cb:	74 0e                	je     8019db <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019cd:	85 db                	test   %ebx,%ebx
  8019cf:	75 d8                	jne    8019a9 <strtol+0x44>
		s++, base = 8;
  8019d1:	83 c1 01             	add    $0x1,%ecx
  8019d4:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019d9:	eb ce                	jmp    8019a9 <strtol+0x44>
		s += 2, base = 16;
  8019db:	83 c1 02             	add    $0x2,%ecx
  8019de:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019e3:	eb c4                	jmp    8019a9 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019e5:	0f be d2             	movsbl %dl,%edx
  8019e8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019eb:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019ee:	7d 3a                	jge    801a2a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019f0:	83 c1 01             	add    $0x1,%ecx
  8019f3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019f9:	0f b6 11             	movzbl (%ecx),%edx
  8019fc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8019ff:	89 f3                	mov    %esi,%ebx
  801a01:	80 fb 09             	cmp    $0x9,%bl
  801a04:	76 df                	jbe    8019e5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a06:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a09:	89 f3                	mov    %esi,%ebx
  801a0b:	80 fb 19             	cmp    $0x19,%bl
  801a0e:	77 08                	ja     801a18 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a10:	0f be d2             	movsbl %dl,%edx
  801a13:	83 ea 57             	sub    $0x57,%edx
  801a16:	eb d3                	jmp    8019eb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a18:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a1b:	89 f3                	mov    %esi,%ebx
  801a1d:	80 fb 19             	cmp    $0x19,%bl
  801a20:	77 08                	ja     801a2a <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a22:	0f be d2             	movsbl %dl,%edx
  801a25:	83 ea 37             	sub    $0x37,%edx
  801a28:	eb c1                	jmp    8019eb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2e:	74 05                	je     801a35 <strtol+0xd0>
		*endptr = (char *) s;
  801a30:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a33:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a35:	89 c2                	mov    %eax,%edx
  801a37:	f7 da                	neg    %edx
  801a39:	85 ff                	test   %edi,%edi
  801a3b:	0f 45 c2             	cmovne %edx,%eax
}
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5f                   	pop    %edi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a43:	f3 0f 1e fb          	endbr32 
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	8b 75 08             	mov    0x8(%ebp),%esi
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a55:	85 c0                	test   %eax,%eax
  801a57:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a5c:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	50                   	push   %eax
  801a63:	e8 68 e8 ff ff       	call   8002d0 <sys_ipc_recv>
	if (r < 0) {
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	78 2b                	js     801a9a <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a6f:	85 f6                	test   %esi,%esi
  801a71:	74 0a                	je     801a7d <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a73:	a1 04 40 80 00       	mov    0x804004,%eax
  801a78:	8b 40 74             	mov    0x74(%eax),%eax
  801a7b:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a7d:	85 db                	test   %ebx,%ebx
  801a7f:	74 0a                	je     801a8b <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a81:	a1 04 40 80 00       	mov    0x804004,%eax
  801a86:	8b 40 78             	mov    0x78(%eax),%eax
  801a89:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801a8b:	a1 04 40 80 00       	mov    0x804004,%eax
  801a90:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    
		if (from_env_store) {
  801a9a:	85 f6                	test   %esi,%esi
  801a9c:	74 06                	je     801aa4 <ipc_recv+0x61>
			*from_env_store = 0;
  801a9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801aa4:	85 db                	test   %ebx,%ebx
  801aa6:	74 eb                	je     801a93 <ipc_recv+0x50>
			*perm_store = 0;
  801aa8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801aae:	eb e3                	jmp    801a93 <ipc_recv+0x50>

00801ab0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ab0:	f3 0f 1e fb          	endbr32 
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	57                   	push   %edi
  801ab8:	56                   	push   %esi
  801ab9:	53                   	push   %ebx
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ac0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ac3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801ac6:	85 db                	test   %ebx,%ebx
  801ac8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801acd:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ad0:	ff 75 14             	pushl  0x14(%ebp)
  801ad3:	53                   	push   %ebx
  801ad4:	56                   	push   %esi
  801ad5:	57                   	push   %edi
  801ad6:	e8 cc e7 ff ff       	call   8002a7 <sys_ipc_try_send>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ae1:	75 07                	jne    801aea <ipc_send+0x3a>
		sys_yield();
  801ae3:	e8 a6 e6 ff ff       	call   80018e <sys_yield>
  801ae8:	eb e6                	jmp    801ad0 <ipc_send+0x20>
	}

	if (ret < 0) {
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 08                	js     801af6 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801af6:	50                   	push   %eax
  801af7:	68 7f 22 80 00       	push   $0x80227f
  801afc:	6a 48                	push   $0x48
  801afe:	68 9c 22 80 00       	push   $0x80229c
  801b03:	e8 76 f5 ff ff       	call   80107e <_panic>

00801b08 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b08:	f3 0f 1e fb          	endbr32 
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b17:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b1a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b20:	8b 52 50             	mov    0x50(%edx),%edx
  801b23:	39 ca                	cmp    %ecx,%edx
  801b25:	74 11                	je     801b38 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b27:	83 c0 01             	add    $0x1,%eax
  801b2a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b2f:	75 e6                	jne    801b17 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	eb 0b                	jmp    801b43 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b38:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b3b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b40:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b45:	f3 0f 1e fb          	endbr32 
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b4f:	89 c2                	mov    %eax,%edx
  801b51:	c1 ea 16             	shr    $0x16,%edx
  801b54:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b60:	f6 c1 01             	test   $0x1,%cl
  801b63:	74 1c                	je     801b81 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b65:	c1 e8 0c             	shr    $0xc,%eax
  801b68:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b6f:	a8 01                	test   $0x1,%al
  801b71:	74 0e                	je     801b81 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b73:	c1 e8 0c             	shr    $0xc,%eax
  801b76:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b7d:	ef 
  801b7e:	0f b7 d2             	movzwl %dx,%edx
}
  801b81:	89 d0                	mov    %edx,%eax
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    
  801b85:	66 90                	xchg   %ax,%ax
  801b87:	66 90                	xchg   %ax,%ax
  801b89:	66 90                	xchg   %ax,%ax
  801b8b:	66 90                	xchg   %ax,%ax
  801b8d:	66 90                	xchg   %ax,%ax
  801b8f:	90                   	nop

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
