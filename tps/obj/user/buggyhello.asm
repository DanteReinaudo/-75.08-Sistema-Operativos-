
obj/user/buggyhello.debug:     formato del fichero elf32-i386


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
  80002c:	e8 1a 00 00 00       	call   80004b <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  80003d:	6a 01                	push   $0x1
  80003f:	6a 01                	push   $0x1
  800041:	e8 ba 00 00 00       	call   800100 <sys_cputs>
}
  800046:	83 c4 10             	add    $0x10,%esp
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004b:	f3 0f 1e fb          	endbr32 
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800057:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80005a:	e8 19 01 00 00       	call   800178 <sys_getenvid>
	if (id >= 0)
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 12                	js     800075 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x35>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	e8 a9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008a:	e8 0a 00 00 00       	call   800099 <exit>
}
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800095:	5b                   	pop    %ebx
  800096:	5e                   	pop    %esi
  800097:	5d                   	pop    %ebp
  800098:	c3                   	ret    

00800099 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800099:	f3 0f 1e fb          	endbr32 
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a3:	e8 53 04 00 00       	call   8004fb <close_all>
	sys_env_destroy(0);
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	6a 00                	push   $0x0
  8000ad:	e8 a0 00 00 00       	call   800152 <sys_env_destroy>
}
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	83 ec 1c             	sub    $0x1c,%esp
  8000c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000c6:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000ce:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000d1:	8b 75 14             	mov    0x14(%ebp),%esi
  8000d4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000da:	74 04                	je     8000e0 <syscall+0x29>
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	7f 08                	jg     8000e8 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5f                   	pop    %edi
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8000ef:	68 0a 1e 80 00       	push   $0x801e0a
  8000f4:	6a 23                	push   $0x23
  8000f6:	68 27 1e 80 00       	push   $0x801e27
  8000fb:	e8 90 0f 00 00       	call   801090 <_panic>

00800100 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800100:	f3 0f 1e fb          	endbr32 
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80010a:	6a 00                	push   $0x0
  80010c:	6a 00                	push   $0x0
  80010e:	6a 00                	push   $0x0
  800110:	ff 75 0c             	pushl  0xc(%ebp)
  800113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800116:	ba 00 00 00 00       	mov    $0x0,%edx
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	e8 92 ff ff ff       	call   8000b7 <syscall>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <sys_cgetc>:

int
sys_cgetc(void)
{
  80012a:	f3 0f 1e fb          	endbr32 
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800134:	6a 00                	push   $0x0
  800136:	6a 00                	push   $0x0
  800138:	6a 00                	push   $0x0
  80013a:	6a 00                	push   $0x0
  80013c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 01 00 00 00       	mov    $0x1,%eax
  80014b:	e8 67 ff ff ff       	call   8000b7 <syscall>
}
  800150:	c9                   	leave  
  800151:	c3                   	ret    

00800152 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800152:	f3 0f 1e fb          	endbr32 
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80015c:	6a 00                	push   $0x0
  80015e:	6a 00                	push   $0x0
  800160:	6a 00                	push   $0x0
  800162:	6a 00                	push   $0x0
  800164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800167:	ba 01 00 00 00       	mov    $0x1,%edx
  80016c:	b8 03 00 00 00       	mov    $0x3,%eax
  800171:	e8 41 ff ff ff       	call   8000b7 <syscall>
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800182:	6a 00                	push   $0x0
  800184:	6a 00                	push   $0x0
  800186:	6a 00                	push   $0x0
  800188:	6a 00                	push   $0x0
  80018a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80018f:	ba 00 00 00 00       	mov    $0x0,%edx
  800194:	b8 02 00 00 00       	mov    $0x2,%eax
  800199:	e8 19 ff ff ff       	call   8000b7 <syscall>
}
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <sys_yield>:

void
sys_yield(void)
{
  8001a0:	f3 0f 1e fb          	endbr32 
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001aa:	6a 00                	push   $0x0
  8001ac:	6a 00                	push   $0x0
  8001ae:	6a 00                	push   $0x0
  8001b0:	6a 00                	push   $0x0
  8001b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bc:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c1:	e8 f1 fe ff ff       	call   8000b7 <syscall>
}
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001cb:	f3 0f 1e fb          	endbr32 
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001d5:	6a 00                	push   $0x0
  8001d7:	6a 00                	push   $0x0
  8001d9:	ff 75 10             	pushl  0x10(%ebp)
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e2:	ba 01 00 00 00       	mov    $0x1,%edx
  8001e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ec:	e8 c6 fe ff ff       	call   8000b7 <syscall>
}
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f3:	f3 0f 1e fb          	endbr32 
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	ff 75 14             	pushl  0x14(%ebp)
  800203:	ff 75 10             	pushl  0x10(%ebp)
  800206:	ff 75 0c             	pushl  0xc(%ebp)
  800209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020c:	ba 01 00 00 00       	mov    $0x1,%edx
  800211:	b8 05 00 00 00       	mov    $0x5,%eax
  800216:	e8 9c fe ff ff       	call   8000b7 <syscall>
}
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021d:	f3 0f 1e fb          	endbr32 
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800227:	6a 00                	push   $0x0
  800229:	6a 00                	push   $0x0
  80022b:	6a 00                	push   $0x0
  80022d:	ff 75 0c             	pushl  0xc(%ebp)
  800230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800233:	ba 01 00 00 00       	mov    $0x1,%edx
  800238:	b8 06 00 00 00       	mov    $0x6,%eax
  80023d:	e8 75 fe ff ff       	call   8000b7 <syscall>
}
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800244:	f3 0f 1e fb          	endbr32 
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80024e:	6a 00                	push   $0x0
  800250:	6a 00                	push   $0x0
  800252:	6a 00                	push   $0x0
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025a:	ba 01 00 00 00       	mov    $0x1,%edx
  80025f:	b8 08 00 00 00       	mov    $0x8,%eax
  800264:	e8 4e fe ff ff       	call   8000b7 <syscall>
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026b:	f3 0f 1e fb          	endbr32 
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800275:	6a 00                	push   $0x0
  800277:	6a 00                	push   $0x0
  800279:	6a 00                	push   $0x0
  80027b:	ff 75 0c             	pushl  0xc(%ebp)
  80027e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800281:	ba 01 00 00 00       	mov    $0x1,%edx
  800286:	b8 09 00 00 00       	mov    $0x9,%eax
  80028b:	e8 27 fe ff ff       	call   8000b7 <syscall>
}
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800292:	f3 0f 1e fb          	endbr32 
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80029c:	6a 00                	push   $0x0
  80029e:	6a 00                	push   $0x0
  8002a0:	6a 00                	push   $0x0
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a8:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b2:	e8 00 fe ff ff       	call   8000b7 <syscall>
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002b9:	f3 0f 1e fb          	endbr32 
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002c3:	6a 00                	push   $0x0
  8002c5:	ff 75 14             	pushl  0x14(%ebp)
  8002c8:	ff 75 10             	pushl  0x10(%ebp)
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d6:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002db:	e8 d7 fd ff ff       	call   8000b7 <syscall>
}
  8002e0:	c9                   	leave  
  8002e1:	c3                   	ret    

008002e2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002ec:	6a 00                	push   $0x0
  8002ee:	6a 00                	push   $0x0
  8002f0:	6a 00                	push   $0x0
  8002f2:	6a 00                	push   $0x0
  8002f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8002fc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800301:	e8 b1 fd ff ff       	call   8000b7 <syscall>
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800308:	f3 0f 1e fb          	endbr32 
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80030f:	8b 45 08             	mov    0x8(%ebp),%eax
  800312:	05 00 00 00 30       	add    $0x30000000,%eax
  800317:	c1 e8 0c             	shr    $0xc,%eax
}
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80031c:	f3 0f 1e fb          	endbr32 
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 da ff ff ff       	call   800308 <fd2num>
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	c1 e0 0c             	shl    $0xc,%eax
  800334:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80033b:	f3 0f 1e fb          	endbr32 
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800347:	89 c2                	mov    %eax,%edx
  800349:	c1 ea 16             	shr    $0x16,%edx
  80034c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800353:	f6 c2 01             	test   $0x1,%dl
  800356:	74 2d                	je     800385 <fd_alloc+0x4a>
  800358:	89 c2                	mov    %eax,%edx
  80035a:	c1 ea 0c             	shr    $0xc,%edx
  80035d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800364:	f6 c2 01             	test   $0x1,%dl
  800367:	74 1c                	je     800385 <fd_alloc+0x4a>
  800369:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80036e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800373:	75 d2                	jne    800347 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80037e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800383:	eb 0a                	jmp    80038f <fd_alloc+0x54>
			*fd_store = fd;
  800385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800388:	89 01                	mov    %eax,(%ecx)
			return 0;
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800391:	f3 0f 1e fb          	endbr32 
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80039b:	83 f8 1f             	cmp    $0x1f,%eax
  80039e:	77 30                	ja     8003d0 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003a0:	c1 e0 0c             	shl    $0xc,%eax
  8003a3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003a8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003ae:	f6 c2 01             	test   $0x1,%dl
  8003b1:	74 24                	je     8003d7 <fd_lookup+0x46>
  8003b3:	89 c2                	mov    %eax,%edx
  8003b5:	c1 ea 0c             	shr    $0xc,%edx
  8003b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003bf:	f6 c2 01             	test   $0x1,%dl
  8003c2:	74 1a                	je     8003de <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c7:	89 02                	mov    %eax,(%edx)
	return 0;
  8003c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ce:	5d                   	pop    %ebp
  8003cf:	c3                   	ret    
		return -E_INVAL;
  8003d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d5:	eb f7                	jmp    8003ce <fd_lookup+0x3d>
		return -E_INVAL;
  8003d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003dc:	eb f0                	jmp    8003ce <fd_lookup+0x3d>
  8003de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003e3:	eb e9                	jmp    8003ce <fd_lookup+0x3d>

008003e5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003e5:	f3 0f 1e fb          	endbr32 
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f2:	ba b4 1e 80 00       	mov    $0x801eb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003f7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003fc:	39 08                	cmp    %ecx,(%eax)
  8003fe:	74 33                	je     800433 <dev_lookup+0x4e>
  800400:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800403:	8b 02                	mov    (%edx),%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	75 f3                	jne    8003fc <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800409:	a1 04 40 80 00       	mov    0x804004,%eax
  80040e:	8b 40 48             	mov    0x48(%eax),%eax
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	51                   	push   %ecx
  800415:	50                   	push   %eax
  800416:	68 38 1e 80 00       	push   $0x801e38
  80041b:	e8 57 0d 00 00       	call   801177 <cprintf>
	*dev = 0;
  800420:	8b 45 0c             	mov    0xc(%ebp),%eax
  800423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800431:	c9                   	leave  
  800432:	c3                   	ret    
			*dev = devtab[i];
  800433:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800436:	89 01                	mov    %eax,(%ecx)
			return 0;
  800438:	b8 00 00 00 00       	mov    $0x0,%eax
  80043d:	eb f2                	jmp    800431 <dev_lookup+0x4c>

0080043f <fd_close>:
{
  80043f:	f3 0f 1e fb          	endbr32 
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	57                   	push   %edi
  800447:	56                   	push   %esi
  800448:	53                   	push   %ebx
  800449:	83 ec 28             	sub    $0x28,%esp
  80044c:	8b 75 08             	mov    0x8(%ebp),%esi
  80044f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800452:	56                   	push   %esi
  800453:	e8 b0 fe ff ff       	call   800308 <fd2num>
  800458:	83 c4 08             	add    $0x8,%esp
  80045b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80045e:	52                   	push   %edx
  80045f:	50                   	push   %eax
  800460:	e8 2c ff ff ff       	call   800391 <fd_lookup>
  800465:	89 c3                	mov    %eax,%ebx
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	85 c0                	test   %eax,%eax
  80046c:	78 05                	js     800473 <fd_close+0x34>
	    || fd != fd2)
  80046e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800471:	74 16                	je     800489 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800473:	89 f8                	mov    %edi,%eax
  800475:	84 c0                	test   %al,%al
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	0f 44 d8             	cmove  %eax,%ebx
}
  80047f:	89 d8                	mov    %ebx,%eax
  800481:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800484:	5b                   	pop    %ebx
  800485:	5e                   	pop    %esi
  800486:	5f                   	pop    %edi
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80048f:	50                   	push   %eax
  800490:	ff 36                	pushl  (%esi)
  800492:	e8 4e ff ff ff       	call   8003e5 <dev_lookup>
  800497:	89 c3                	mov    %eax,%ebx
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 c0                	test   %eax,%eax
  80049e:	78 1a                	js     8004ba <fd_close+0x7b>
		if (dev->dev_close)
  8004a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 0b                	je     8004ba <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	56                   	push   %esi
  8004b3:	ff d0                	call   *%eax
  8004b5:	89 c3                	mov    %eax,%ebx
  8004b7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	56                   	push   %esi
  8004be:	6a 00                	push   $0x0
  8004c0:	e8 58 fd ff ff       	call   80021d <sys_page_unmap>
	return r;
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	eb b5                	jmp    80047f <fd_close+0x40>

008004ca <close>:

int
close(int fdnum)
{
  8004ca:	f3 0f 1e fb          	endbr32 
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004d7:	50                   	push   %eax
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	e8 b1 fe ff ff       	call   800391 <fd_lookup>
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	79 02                	jns    8004e9 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    
		return fd_close(fd, 1);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	e8 49 ff ff ff       	call   80043f <fd_close>
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	eb ec                	jmp    8004e7 <close+0x1d>

008004fb <close_all>:

void
close_all(void)
{
  8004fb:	f3 0f 1e fb          	endbr32 
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	53                   	push   %ebx
  800503:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800506:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	53                   	push   %ebx
  80050f:	e8 b6 ff ff ff       	call   8004ca <close>
	for (i = 0; i < MAXFD; i++)
  800514:	83 c3 01             	add    $0x1,%ebx
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	83 fb 20             	cmp    $0x20,%ebx
  80051d:	75 ec                	jne    80050b <close_all+0x10>
}
  80051f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800524:	f3 0f 1e fb          	endbr32 
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	57                   	push   %edi
  80052c:	56                   	push   %esi
  80052d:	53                   	push   %ebx
  80052e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800531:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800534:	50                   	push   %eax
  800535:	ff 75 08             	pushl  0x8(%ebp)
  800538:	e8 54 fe ff ff       	call   800391 <fd_lookup>
  80053d:	89 c3                	mov    %eax,%ebx
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 c0                	test   %eax,%eax
  800544:	0f 88 81 00 00 00    	js     8005cb <dup+0xa7>
		return r;
	close(newfdnum);
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	ff 75 0c             	pushl  0xc(%ebp)
  800550:	e8 75 ff ff ff       	call   8004ca <close>

	newfd = INDEX2FD(newfdnum);
  800555:	8b 75 0c             	mov    0xc(%ebp),%esi
  800558:	c1 e6 0c             	shl    $0xc,%esi
  80055b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800561:	83 c4 04             	add    $0x4,%esp
  800564:	ff 75 e4             	pushl  -0x1c(%ebp)
  800567:	e8 b0 fd ff ff       	call   80031c <fd2data>
  80056c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80056e:	89 34 24             	mov    %esi,(%esp)
  800571:	e8 a6 fd ff ff       	call   80031c <fd2data>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80057b:	89 d8                	mov    %ebx,%eax
  80057d:	c1 e8 16             	shr    $0x16,%eax
  800580:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800587:	a8 01                	test   $0x1,%al
  800589:	74 11                	je     80059c <dup+0x78>
  80058b:	89 d8                	mov    %ebx,%eax
  80058d:	c1 e8 0c             	shr    $0xc,%eax
  800590:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800597:	f6 c2 01             	test   $0x1,%dl
  80059a:	75 39                	jne    8005d5 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80059c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80059f:	89 d0                	mov    %edx,%eax
  8005a1:	c1 e8 0c             	shr    $0xc,%eax
  8005a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ab:	83 ec 0c             	sub    $0xc,%esp
  8005ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8005b3:	50                   	push   %eax
  8005b4:	56                   	push   %esi
  8005b5:	6a 00                	push   $0x0
  8005b7:	52                   	push   %edx
  8005b8:	6a 00                	push   $0x0
  8005ba:	e8 34 fc ff ff       	call   8001f3 <sys_page_map>
  8005bf:	89 c3                	mov    %eax,%ebx
  8005c1:	83 c4 20             	add    $0x20,%esp
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	78 31                	js     8005f9 <dup+0xd5>
		goto err;

	return newfdnum;
  8005c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005cb:	89 d8                	mov    %ebx,%eax
  8005cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5f                   	pop    %edi
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005d5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005dc:	83 ec 0c             	sub    $0xc,%esp
  8005df:	25 07 0e 00 00       	and    $0xe07,%eax
  8005e4:	50                   	push   %eax
  8005e5:	57                   	push   %edi
  8005e6:	6a 00                	push   $0x0
  8005e8:	53                   	push   %ebx
  8005e9:	6a 00                	push   $0x0
  8005eb:	e8 03 fc ff ff       	call   8001f3 <sys_page_map>
  8005f0:	89 c3                	mov    %eax,%ebx
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	79 a3                	jns    80059c <dup+0x78>
	sys_page_unmap(0, newfd);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	56                   	push   %esi
  8005fd:	6a 00                	push   $0x0
  8005ff:	e8 19 fc ff ff       	call   80021d <sys_page_unmap>
	sys_page_unmap(0, nva);
  800604:	83 c4 08             	add    $0x8,%esp
  800607:	57                   	push   %edi
  800608:	6a 00                	push   $0x0
  80060a:	e8 0e fc ff ff       	call   80021d <sys_page_unmap>
	return r;
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	eb b7                	jmp    8005cb <dup+0xa7>

00800614 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800614:	f3 0f 1e fb          	endbr32 
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	53                   	push   %ebx
  80061c:	83 ec 1c             	sub    $0x1c,%esp
  80061f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800622:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	53                   	push   %ebx
  800627:	e8 65 fd ff ff       	call   800391 <fd_lookup>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	85 c0                	test   %eax,%eax
  800631:	78 3f                	js     800672 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800639:	50                   	push   %eax
  80063a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063d:	ff 30                	pushl  (%eax)
  80063f:	e8 a1 fd ff ff       	call   8003e5 <dev_lookup>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	85 c0                	test   %eax,%eax
  800649:	78 27                	js     800672 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80064e:	8b 42 08             	mov    0x8(%edx),%eax
  800651:	83 e0 03             	and    $0x3,%eax
  800654:	83 f8 01             	cmp    $0x1,%eax
  800657:	74 1e                	je     800677 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065c:	8b 40 08             	mov    0x8(%eax),%eax
  80065f:	85 c0                	test   %eax,%eax
  800661:	74 35                	je     800698 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	ff 75 10             	pushl  0x10(%ebp)
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	52                   	push   %edx
  80066d:	ff d0                	call   *%eax
  80066f:	83 c4 10             	add    $0x10,%esp
}
  800672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800675:	c9                   	leave  
  800676:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800677:	a1 04 40 80 00       	mov    0x804004,%eax
  80067c:	8b 40 48             	mov    0x48(%eax),%eax
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	53                   	push   %ebx
  800683:	50                   	push   %eax
  800684:	68 79 1e 80 00       	push   $0x801e79
  800689:	e8 e9 0a 00 00       	call   801177 <cprintf>
		return -E_INVAL;
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800696:	eb da                	jmp    800672 <read+0x5e>
		return -E_NOT_SUPP;
  800698:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80069d:	eb d3                	jmp    800672 <read+0x5e>

0080069f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80069f:	f3 0f 1e fb          	endbr32 
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	57                   	push   %edi
  8006a7:	56                   	push   %esi
  8006a8:	53                   	push   %ebx
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b7:	eb 02                	jmp    8006bb <readn+0x1c>
  8006b9:	01 c3                	add    %eax,%ebx
  8006bb:	39 f3                	cmp    %esi,%ebx
  8006bd:	73 21                	jae    8006e0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006bf:	83 ec 04             	sub    $0x4,%esp
  8006c2:	89 f0                	mov    %esi,%eax
  8006c4:	29 d8                	sub    %ebx,%eax
  8006c6:	50                   	push   %eax
  8006c7:	89 d8                	mov    %ebx,%eax
  8006c9:	03 45 0c             	add    0xc(%ebp),%eax
  8006cc:	50                   	push   %eax
  8006cd:	57                   	push   %edi
  8006ce:	e8 41 ff ff ff       	call   800614 <read>
		if (m < 0)
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	78 04                	js     8006de <readn+0x3f>
			return m;
		if (m == 0)
  8006da:	75 dd                	jne    8006b9 <readn+0x1a>
  8006dc:	eb 02                	jmp    8006e0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006e0:	89 d8                	mov    %ebx,%eax
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    

008006ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006ea:	f3 0f 1e fb          	endbr32 
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	53                   	push   %ebx
  8006f2:	83 ec 1c             	sub    $0x1c,%esp
  8006f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	53                   	push   %ebx
  8006fd:	e8 8f fc ff ff       	call   800391 <fd_lookup>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	85 c0                	test   %eax,%eax
  800707:	78 3a                	js     800743 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800713:	ff 30                	pushl  (%eax)
  800715:	e8 cb fc ff ff       	call   8003e5 <dev_lookup>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	85 c0                	test   %eax,%eax
  80071f:	78 22                	js     800743 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800724:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800728:	74 1e                	je     800748 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	8b 52 0c             	mov    0xc(%edx),%edx
  800730:	85 d2                	test   %edx,%edx
  800732:	74 35                	je     800769 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800734:	83 ec 04             	sub    $0x4,%esp
  800737:	ff 75 10             	pushl  0x10(%ebp)
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	50                   	push   %eax
  80073e:	ff d2                	call   *%edx
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800746:	c9                   	leave  
  800747:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800748:	a1 04 40 80 00       	mov    0x804004,%eax
  80074d:	8b 40 48             	mov    0x48(%eax),%eax
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	53                   	push   %ebx
  800754:	50                   	push   %eax
  800755:	68 95 1e 80 00       	push   $0x801e95
  80075a:	e8 18 0a 00 00       	call   801177 <cprintf>
		return -E_INVAL;
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800767:	eb da                	jmp    800743 <write+0x59>
		return -E_NOT_SUPP;
  800769:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80076e:	eb d3                	jmp    800743 <write+0x59>

00800770 <seek>:

int
seek(int fdnum, off_t offset)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80077a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	ff 75 08             	pushl  0x8(%ebp)
  800781:	e8 0b fc ff ff       	call   800391 <fd_lookup>
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	85 c0                	test   %eax,%eax
  80078b:	78 0e                	js     80079b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80078d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800793:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	53                   	push   %ebx
  8007a5:	83 ec 1c             	sub    $0x1c,%esp
  8007a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	53                   	push   %ebx
  8007b0:	e8 dc fb ff ff       	call   800391 <fd_lookup>
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	78 37                	js     8007f3 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	ff 30                	pushl  (%eax)
  8007c8:	e8 18 fc ff ff       	call   8003e5 <dev_lookup>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	78 1f                	js     8007f3 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007db:	74 1b                	je     8007f8 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e0:	8b 52 18             	mov    0x18(%edx),%edx
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	74 32                	je     800819 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	ff d2                	call   *%edx
  8007f0:	83 c4 10             	add    $0x10,%esp
}
  8007f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007f8:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007fd:	8b 40 48             	mov    0x48(%eax),%eax
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	53                   	push   %ebx
  800804:	50                   	push   %eax
  800805:	68 58 1e 80 00       	push   $0x801e58
  80080a:	e8 68 09 00 00       	call   801177 <cprintf>
		return -E_INVAL;
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800817:	eb da                	jmp    8007f3 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800819:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80081e:	eb d3                	jmp    8007f3 <ftruncate+0x56>

00800820 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	53                   	push   %ebx
  800828:	83 ec 1c             	sub    $0x1c,%esp
  80082b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80082e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800831:	50                   	push   %eax
  800832:	ff 75 08             	pushl  0x8(%ebp)
  800835:	e8 57 fb ff ff       	call   800391 <fd_lookup>
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	85 c0                	test   %eax,%eax
  80083f:	78 4b                	js     80088c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800847:	50                   	push   %eax
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084b:	ff 30                	pushl  (%eax)
  80084d:	e8 93 fb ff ff       	call   8003e5 <dev_lookup>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	85 c0                	test   %eax,%eax
  800857:	78 33                	js     80088c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800860:	74 2f                	je     800891 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800862:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800865:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80086c:	00 00 00 
	stat->st_isdir = 0;
  80086f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800876:	00 00 00 
	stat->st_dev = dev;
  800879:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	53                   	push   %ebx
  800883:	ff 75 f0             	pushl  -0x10(%ebp)
  800886:	ff 50 14             	call   *0x14(%eax)
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    
		return -E_NOT_SUPP;
  800891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800896:	eb f4                	jmp    80088c <fstat+0x6c>

00800898 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	56                   	push   %esi
  8008a0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	6a 00                	push   $0x0
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 3a 02 00 00       	call   800ae8 <open>
  8008ae:	89 c3                	mov    %eax,%ebx
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	78 1b                	js     8008d2 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	50                   	push   %eax
  8008be:	e8 5d ff ff ff       	call   800820 <fstat>
  8008c3:	89 c6                	mov    %eax,%esi
	close(fd);
  8008c5:	89 1c 24             	mov    %ebx,(%esp)
  8008c8:	e8 fd fb ff ff       	call   8004ca <close>
	return r;
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	89 f3                	mov    %esi,%ebx
}
  8008d2:	89 d8                	mov    %ebx,%eax
  8008d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d7:	5b                   	pop    %ebx
  8008d8:	5e                   	pop    %esi
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	89 c6                	mov    %eax,%esi
  8008e2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008e4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008eb:	74 27                	je     800914 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008ed:	6a 07                	push   $0x7
  8008ef:	68 00 50 80 00       	push   $0x805000
  8008f4:	56                   	push   %esi
  8008f5:	ff 35 00 40 80 00    	pushl  0x804000
  8008fb:	e8 c2 11 00 00       	call   801ac2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800900:	83 c4 0c             	add    $0xc,%esp
  800903:	6a 00                	push   $0x0
  800905:	53                   	push   %ebx
  800906:	6a 00                	push   $0x0
  800908:	e8 48 11 00 00       	call   801a55 <ipc_recv>
}
  80090d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	6a 01                	push   $0x1
  800919:	e8 fc 11 00 00       	call   801b1a <ipc_find_env>
  80091e:	a3 00 40 80 00       	mov    %eax,0x804000
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	eb c5                	jmp    8008ed <fsipc+0x12>

00800928 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800928:	f3 0f 1e fb          	endbr32 
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 40 0c             	mov    0xc(%eax),%eax
  800938:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800945:	ba 00 00 00 00       	mov    $0x0,%edx
  80094a:	b8 02 00 00 00       	mov    $0x2,%eax
  80094f:	e8 87 ff ff ff       	call   8008db <fsipc>
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <devfile_flush>:
{
  800956:	f3 0f 1e fb          	endbr32 
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 40 0c             	mov    0xc(%eax),%eax
  800966:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	b8 06 00 00 00       	mov    $0x6,%eax
  800975:	e8 61 ff ff ff       	call   8008db <fsipc>
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <devfile_stat>:
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	53                   	push   %ebx
  800984:	83 ec 04             	sub    $0x4,%esp
  800987:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 40 0c             	mov    0xc(%eax),%eax
  800990:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800995:	ba 00 00 00 00       	mov    $0x0,%edx
  80099a:	b8 05 00 00 00       	mov    $0x5,%eax
  80099f:	e8 37 ff ff ff       	call   8008db <fsipc>
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	78 2c                	js     8009d4 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	68 00 50 80 00       	push   $0x805000
  8009b0:	53                   	push   %ebx
  8009b1:	e8 2b 0d 00 00       	call   8016e1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009b6:	a1 80 50 80 00       	mov    0x805080,%eax
  8009bb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009c1:	a1 84 50 80 00       	mov    0x805084,%eax
  8009c6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <devfile_write>:
{
  8009d9:	f3 0f 1e fb          	endbr32 
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	53                   	push   %ebx
  8009e1:	83 ec 04             	sub    $0x4,%esp
  8009e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009f2:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009f8:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8009fe:	77 30                	ja     800a30 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a00:	83 ec 04             	sub    $0x4,%esp
  800a03:	53                   	push   %ebx
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	68 08 50 80 00       	push   $0x805008
  800a0c:	e8 88 0e 00 00       	call   801899 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a11:	ba 00 00 00 00       	mov    $0x0,%edx
  800a16:	b8 04 00 00 00       	mov    $0x4,%eax
  800a1b:	e8 bb fe ff ff       	call   8008db <fsipc>
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	85 c0                	test   %eax,%eax
  800a25:	78 04                	js     800a2b <devfile_write+0x52>
	assert(r <= n);
  800a27:	39 d8                	cmp    %ebx,%eax
  800a29:	77 1e                	ja     800a49 <devfile_write+0x70>
}
  800a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a30:	68 c4 1e 80 00       	push   $0x801ec4
  800a35:	68 f1 1e 80 00       	push   $0x801ef1
  800a3a:	68 94 00 00 00       	push   $0x94
  800a3f:	68 06 1f 80 00       	push   $0x801f06
  800a44:	e8 47 06 00 00       	call   801090 <_panic>
	assert(r <= n);
  800a49:	68 11 1f 80 00       	push   $0x801f11
  800a4e:	68 f1 1e 80 00       	push   $0x801ef1
  800a53:	68 98 00 00 00       	push   $0x98
  800a58:	68 06 1f 80 00       	push   $0x801f06
  800a5d:	e8 2e 06 00 00       	call   801090 <_panic>

00800a62 <devfile_read>:
{
  800a62:	f3 0f 1e fb          	endbr32 
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8b 40 0c             	mov    0xc(%eax),%eax
  800a74:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a79:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a84:	b8 03 00 00 00       	mov    $0x3,%eax
  800a89:	e8 4d fe ff ff       	call   8008db <fsipc>
  800a8e:	89 c3                	mov    %eax,%ebx
  800a90:	85 c0                	test   %eax,%eax
  800a92:	78 1f                	js     800ab3 <devfile_read+0x51>
	assert(r <= n);
  800a94:	39 f0                	cmp    %esi,%eax
  800a96:	77 24                	ja     800abc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a9d:	7f 33                	jg     800ad2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a9f:	83 ec 04             	sub    $0x4,%esp
  800aa2:	50                   	push   %eax
  800aa3:	68 00 50 80 00       	push   $0x805000
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	e8 e9 0d 00 00       	call   801899 <memmove>
	return r;
  800ab0:	83 c4 10             	add    $0x10,%esp
}
  800ab3:	89 d8                	mov    %ebx,%eax
  800ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ab8:	5b                   	pop    %ebx
  800ab9:	5e                   	pop    %esi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    
	assert(r <= n);
  800abc:	68 11 1f 80 00       	push   $0x801f11
  800ac1:	68 f1 1e 80 00       	push   $0x801ef1
  800ac6:	6a 7c                	push   $0x7c
  800ac8:	68 06 1f 80 00       	push   $0x801f06
  800acd:	e8 be 05 00 00       	call   801090 <_panic>
	assert(r <= PGSIZE);
  800ad2:	68 18 1f 80 00       	push   $0x801f18
  800ad7:	68 f1 1e 80 00       	push   $0x801ef1
  800adc:	6a 7d                	push   $0x7d
  800ade:	68 06 1f 80 00       	push   $0x801f06
  800ae3:	e8 a8 05 00 00       	call   801090 <_panic>

00800ae8 <open>:
{
  800ae8:	f3 0f 1e fb          	endbr32 
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	83 ec 1c             	sub    $0x1c,%esp
  800af4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800af7:	56                   	push   %esi
  800af8:	e8 a1 0b 00 00       	call   80169e <strlen>
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b05:	7f 6c                	jg     800b73 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b07:	83 ec 0c             	sub    $0xc,%esp
  800b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 28 f8 ff ff       	call   80033b <fd_alloc>
  800b13:	89 c3                	mov    %eax,%ebx
  800b15:	83 c4 10             	add    $0x10,%esp
  800b18:	85 c0                	test   %eax,%eax
  800b1a:	78 3c                	js     800b58 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	56                   	push   %esi
  800b20:	68 00 50 80 00       	push   $0x805000
  800b25:	e8 b7 0b 00 00       	call   8016e1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b35:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3a:	e8 9c fd ff ff       	call   8008db <fsipc>
  800b3f:	89 c3                	mov    %eax,%ebx
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	85 c0                	test   %eax,%eax
  800b46:	78 19                	js     800b61 <open+0x79>
	return fd2num(fd);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4e:	e8 b5 f7 ff ff       	call   800308 <fd2num>
  800b53:	89 c3                	mov    %eax,%ebx
  800b55:	83 c4 10             	add    $0x10,%esp
}
  800b58:	89 d8                	mov    %ebx,%eax
  800b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    
		fd_close(fd, 0);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	6a 00                	push   $0x0
  800b66:	ff 75 f4             	pushl  -0xc(%ebp)
  800b69:	e8 d1 f8 ff ff       	call   80043f <fd_close>
		return r;
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	eb e5                	jmp    800b58 <open+0x70>
		return -E_BAD_PATH;
  800b73:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b78:	eb de                	jmp    800b58 <open+0x70>

00800b7a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b7a:	f3 0f 1e fb          	endbr32 
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	b8 08 00 00 00       	mov    $0x8,%eax
  800b8e:	e8 48 fd ff ff       	call   8008db <fsipc>
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b95:	f3 0f 1e fb          	endbr32 
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba1:	83 ec 0c             	sub    $0xc,%esp
  800ba4:	ff 75 08             	pushl  0x8(%ebp)
  800ba7:	e8 70 f7 ff ff       	call   80031c <fd2data>
  800bac:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bae:	83 c4 08             	add    $0x8,%esp
  800bb1:	68 24 1f 80 00       	push   $0x801f24
  800bb6:	53                   	push   %ebx
  800bb7:	e8 25 0b 00 00       	call   8016e1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bbc:	8b 46 04             	mov    0x4(%esi),%eax
  800bbf:	2b 06                	sub    (%esi),%eax
  800bc1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bc7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bce:	00 00 00 
	stat->st_dev = &devpipe;
  800bd1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bd8:	30 80 00 
	return 0;
}
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
  800bf2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf5:	53                   	push   %ebx
  800bf6:	6a 00                	push   $0x0
  800bf8:	e8 20 f6 ff ff       	call   80021d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bfd:	89 1c 24             	mov    %ebx,(%esp)
  800c00:	e8 17 f7 ff ff       	call   80031c <fd2data>
  800c05:	83 c4 08             	add    $0x8,%esp
  800c08:	50                   	push   %eax
  800c09:	6a 00                	push   $0x0
  800c0b:	e8 0d f6 ff ff       	call   80021d <sys_page_unmap>
}
  800c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <_pipeisclosed>:
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	57                   	push   %edi
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
  800c1b:	83 ec 1c             	sub    $0x1c,%esp
  800c1e:	89 c7                	mov    %eax,%edi
  800c20:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c22:	a1 04 40 80 00       	mov    0x804004,%eax
  800c27:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c2a:	83 ec 0c             	sub    $0xc,%esp
  800c2d:	57                   	push   %edi
  800c2e:	e8 24 0f 00 00       	call   801b57 <pageref>
  800c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c36:	89 34 24             	mov    %esi,(%esp)
  800c39:	e8 19 0f 00 00       	call   801b57 <pageref>
		nn = thisenv->env_runs;
  800c3e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c44:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	39 cb                	cmp    %ecx,%ebx
  800c4c:	74 1b                	je     800c69 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c4e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c51:	75 cf                	jne    800c22 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c53:	8b 42 58             	mov    0x58(%edx),%eax
  800c56:	6a 01                	push   $0x1
  800c58:	50                   	push   %eax
  800c59:	53                   	push   %ebx
  800c5a:	68 2b 1f 80 00       	push   $0x801f2b
  800c5f:	e8 13 05 00 00       	call   801177 <cprintf>
  800c64:	83 c4 10             	add    $0x10,%esp
  800c67:	eb b9                	jmp    800c22 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c69:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6c:	0f 94 c0             	sete   %al
  800c6f:	0f b6 c0             	movzbl %al,%eax
}
  800c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <devpipe_write>:
{
  800c7a:	f3 0f 1e fb          	endbr32 
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 28             	sub    $0x28,%esp
  800c87:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c8a:	56                   	push   %esi
  800c8b:	e8 8c f6 ff ff       	call   80031c <fd2data>
  800c90:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c92:	83 c4 10             	add    $0x10,%esp
  800c95:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c9d:	74 4f                	je     800cee <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c9f:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca2:	8b 0b                	mov    (%ebx),%ecx
  800ca4:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca7:	39 d0                	cmp    %edx,%eax
  800ca9:	72 14                	jb     800cbf <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cab:	89 da                	mov    %ebx,%edx
  800cad:	89 f0                	mov    %esi,%eax
  800caf:	e8 61 ff ff ff       	call   800c15 <_pipeisclosed>
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	75 3b                	jne    800cf3 <devpipe_write+0x79>
			sys_yield();
  800cb8:	e8 e3 f4 ff ff       	call   8001a0 <sys_yield>
  800cbd:	eb e0                	jmp    800c9f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	c1 fa 1f             	sar    $0x1f,%edx
  800cce:	89 d1                	mov    %edx,%ecx
  800cd0:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd6:	83 e2 1f             	and    $0x1f,%edx
  800cd9:	29 ca                	sub    %ecx,%edx
  800cdb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cdf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce3:	83 c0 01             	add    $0x1,%eax
  800ce6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ce9:	83 c7 01             	add    $0x1,%edi
  800cec:	eb ac                	jmp    800c9a <devpipe_write+0x20>
	return i;
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	eb 05                	jmp    800cf8 <devpipe_write+0x7e>
				return 0;
  800cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <devpipe_read>:
{
  800d00:	f3 0f 1e fb          	endbr32 
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 18             	sub    $0x18,%esp
  800d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d10:	57                   	push   %edi
  800d11:	e8 06 f6 ff ff       	call   80031c <fd2data>
  800d16:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	be 00 00 00 00       	mov    $0x0,%esi
  800d20:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d23:	75 14                	jne    800d39 <devpipe_read+0x39>
	return i;
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	eb 02                	jmp    800d2c <devpipe_read+0x2c>
				return i;
  800d2a:	89 f0                	mov    %esi,%eax
}
  800d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    
			sys_yield();
  800d34:	e8 67 f4 ff ff       	call   8001a0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d39:	8b 03                	mov    (%ebx),%eax
  800d3b:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d3e:	75 18                	jne    800d58 <devpipe_read+0x58>
			if (i > 0)
  800d40:	85 f6                	test   %esi,%esi
  800d42:	75 e6                	jne    800d2a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d44:	89 da                	mov    %ebx,%edx
  800d46:	89 f8                	mov    %edi,%eax
  800d48:	e8 c8 fe ff ff       	call   800c15 <_pipeisclosed>
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	74 e3                	je     800d34 <devpipe_read+0x34>
				return 0;
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	eb d4                	jmp    800d2c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d58:	99                   	cltd   
  800d59:	c1 ea 1b             	shr    $0x1b,%edx
  800d5c:	01 d0                	add    %edx,%eax
  800d5e:	83 e0 1f             	and    $0x1f,%eax
  800d61:	29 d0                	sub    %edx,%eax
  800d63:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d6e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d71:	83 c6 01             	add    $0x1,%esi
  800d74:	eb aa                	jmp    800d20 <devpipe_read+0x20>

00800d76 <pipe>:
{
  800d76:	f3 0f 1e fb          	endbr32 
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d85:	50                   	push   %eax
  800d86:	e8 b0 f5 ff ff       	call   80033b <fd_alloc>
  800d8b:	89 c3                	mov    %eax,%ebx
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	85 c0                	test   %eax,%eax
  800d92:	0f 88 23 01 00 00    	js     800ebb <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d98:	83 ec 04             	sub    $0x4,%esp
  800d9b:	68 07 04 00 00       	push   $0x407
  800da0:	ff 75 f4             	pushl  -0xc(%ebp)
  800da3:	6a 00                	push   $0x0
  800da5:	e8 21 f4 ff ff       	call   8001cb <sys_page_alloc>
  800daa:	89 c3                	mov    %eax,%ebx
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	85 c0                	test   %eax,%eax
  800db1:	0f 88 04 01 00 00    	js     800ebb <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dbd:	50                   	push   %eax
  800dbe:	e8 78 f5 ff ff       	call   80033b <fd_alloc>
  800dc3:	89 c3                	mov    %eax,%ebx
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	0f 88 db 00 00 00    	js     800eab <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	68 07 04 00 00       	push   $0x407
  800dd8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ddb:	6a 00                	push   $0x0
  800ddd:	e8 e9 f3 ff ff       	call   8001cb <sys_page_alloc>
  800de2:	89 c3                	mov    %eax,%ebx
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	85 c0                	test   %eax,%eax
  800de9:	0f 88 bc 00 00 00    	js     800eab <pipe+0x135>
	va = fd2data(fd0);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	e8 22 f5 ff ff       	call   80031c <fd2data>
  800dfa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dfc:	83 c4 0c             	add    $0xc,%esp
  800dff:	68 07 04 00 00       	push   $0x407
  800e04:	50                   	push   %eax
  800e05:	6a 00                	push   $0x0
  800e07:	e8 bf f3 ff ff       	call   8001cb <sys_page_alloc>
  800e0c:	89 c3                	mov    %eax,%ebx
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	85 c0                	test   %eax,%eax
  800e13:	0f 88 82 00 00 00    	js     800e9b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e19:	83 ec 0c             	sub    $0xc,%esp
  800e1c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1f:	e8 f8 f4 ff ff       	call   80031c <fd2data>
  800e24:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e2b:	50                   	push   %eax
  800e2c:	6a 00                	push   $0x0
  800e2e:	56                   	push   %esi
  800e2f:	6a 00                	push   $0x0
  800e31:	e8 bd f3 ff ff       	call   8001f3 <sys_page_map>
  800e36:	89 c3                	mov    %eax,%ebx
  800e38:	83 c4 20             	add    $0x20,%esp
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	78 4e                	js     800e8d <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e3f:	a1 20 30 80 00       	mov    0x803020,%eax
  800e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e47:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e56:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	ff 75 f4             	pushl  -0xc(%ebp)
  800e68:	e8 9b f4 ff ff       	call   800308 <fd2num>
  800e6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e70:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e72:	83 c4 04             	add    $0x4,%esp
  800e75:	ff 75 f0             	pushl  -0x10(%ebp)
  800e78:	e8 8b f4 ff ff       	call   800308 <fd2num>
  800e7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e80:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	eb 2e                	jmp    800ebb <pipe+0x145>
	sys_page_unmap(0, va);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	56                   	push   %esi
  800e91:	6a 00                	push   $0x0
  800e93:	e8 85 f3 ff ff       	call   80021d <sys_page_unmap>
  800e98:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea1:	6a 00                	push   $0x0
  800ea3:	e8 75 f3 ff ff       	call   80021d <sys_page_unmap>
  800ea8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb1:	6a 00                	push   $0x0
  800eb3:	e8 65 f3 ff ff       	call   80021d <sys_page_unmap>
  800eb8:	83 c4 10             	add    $0x10,%esp
}
  800ebb:	89 d8                	mov    %ebx,%eax
  800ebd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <pipeisclosed>:
{
  800ec4:	f3 0f 1e fb          	endbr32 
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ece:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed1:	50                   	push   %eax
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 b7 f4 ff ff       	call   800391 <fd_lookup>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	78 18                	js     800ef9 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee7:	e8 30 f4 ff ff       	call   80031c <fd2data>
  800eec:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef1:	e8 1f fd ff ff       	call   800c15 <_pipeisclosed>
  800ef6:	83 c4 10             	add    $0x10,%esp
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800efb:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800eff:	b8 00 00 00 00       	mov    $0x0,%eax
  800f04:	c3                   	ret    

00800f05 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f05:	f3 0f 1e fb          	endbr32 
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f0f:	68 43 1f 80 00       	push   $0x801f43
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	e8 c5 07 00 00       	call   8016e1 <strcpy>
	return 0;
}
  800f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <devcons_write>:
{
  800f23:	f3 0f 1e fb          	endbr32 
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
  800f2d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f33:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f38:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f3e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f41:	73 31                	jae    800f74 <devcons_write+0x51>
		m = n - tot;
  800f43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f46:	29 f3                	sub    %esi,%ebx
  800f48:	83 fb 7f             	cmp    $0x7f,%ebx
  800f4b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f50:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f53:	83 ec 04             	sub    $0x4,%esp
  800f56:	53                   	push   %ebx
  800f57:	89 f0                	mov    %esi,%eax
  800f59:	03 45 0c             	add    0xc(%ebp),%eax
  800f5c:	50                   	push   %eax
  800f5d:	57                   	push   %edi
  800f5e:	e8 36 09 00 00       	call   801899 <memmove>
		sys_cputs(buf, m);
  800f63:	83 c4 08             	add    $0x8,%esp
  800f66:	53                   	push   %ebx
  800f67:	57                   	push   %edi
  800f68:	e8 93 f1 ff ff       	call   800100 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f6d:	01 de                	add    %ebx,%esi
  800f6f:	83 c4 10             	add    $0x10,%esp
  800f72:	eb ca                	jmp    800f3e <devcons_write+0x1b>
}
  800f74:	89 f0                	mov    %esi,%eax
  800f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <devcons_read>:
{
  800f7e:	f3 0f 1e fb          	endbr32 
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	74 21                	je     800fb4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f93:	e8 92 f1 ff ff       	call   80012a <sys_cgetc>
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	75 07                	jne    800fa3 <devcons_read+0x25>
		sys_yield();
  800f9c:	e8 ff f1 ff ff       	call   8001a0 <sys_yield>
  800fa1:	eb f0                	jmp    800f93 <devcons_read+0x15>
	if (c < 0)
  800fa3:	78 0f                	js     800fb4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fa5:	83 f8 04             	cmp    $0x4,%eax
  800fa8:	74 0c                	je     800fb6 <devcons_read+0x38>
	*(char*)vbuf = c;
  800faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fad:	88 02                	mov    %al,(%edx)
	return 1;
  800faf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    
		return 0;
  800fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbb:	eb f7                	jmp    800fb4 <devcons_read+0x36>

00800fbd <cputchar>:
{
  800fbd:	f3 0f 1e fb          	endbr32 
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fcd:	6a 01                	push   $0x1
  800fcf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	e8 28 f1 ff ff       	call   800100 <sys_cputs>
}
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <getchar>:
{
  800fdd:	f3 0f 1e fb          	endbr32 
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fe7:	6a 01                	push   $0x1
  800fe9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fec:	50                   	push   %eax
  800fed:	6a 00                	push   $0x0
  800fef:	e8 20 f6 ff ff       	call   800614 <read>
	if (r < 0)
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 06                	js     801001 <getchar+0x24>
	if (r < 1)
  800ffb:	74 06                	je     801003 <getchar+0x26>
	return c;
  800ffd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    
		return -E_EOF;
  801003:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801008:	eb f7                	jmp    801001 <getchar+0x24>

0080100a <iscons>:
{
  80100a:	f3 0f 1e fb          	endbr32 
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 71 f3 ff ff       	call   800391 <fd_lookup>
  801020:	83 c4 10             	add    $0x10,%esp
  801023:	85 c0                	test   %eax,%eax
  801025:	78 11                	js     801038 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801030:	39 10                	cmp    %edx,(%eax)
  801032:	0f 94 c0             	sete   %al
  801035:	0f b6 c0             	movzbl %al,%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <opencons>:
{
  80103a:	f3 0f 1e fb          	endbr32 
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801044:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801047:	50                   	push   %eax
  801048:	e8 ee f2 ff ff       	call   80033b <fd_alloc>
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	78 3a                	js     80108e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	68 07 04 00 00       	push   $0x407
  80105c:	ff 75 f4             	pushl  -0xc(%ebp)
  80105f:	6a 00                	push   $0x0
  801061:	e8 65 f1 ff ff       	call   8001cb <sys_page_alloc>
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	78 21                	js     80108e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801070:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801076:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	50                   	push   %eax
  801086:	e8 7d f2 ff ff       	call   800308 <fd2num>
  80108b:	83 c4 10             	add    $0x10,%esp
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801099:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80109c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010a2:	e8 d1 f0 ff ff       	call   800178 <sys_getenvid>
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	ff 75 0c             	pushl  0xc(%ebp)
  8010ad:	ff 75 08             	pushl  0x8(%ebp)
  8010b0:	56                   	push   %esi
  8010b1:	50                   	push   %eax
  8010b2:	68 50 1f 80 00       	push   $0x801f50
  8010b7:	e8 bb 00 00 00       	call   801177 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010bc:	83 c4 18             	add    $0x18,%esp
  8010bf:	53                   	push   %ebx
  8010c0:	ff 75 10             	pushl  0x10(%ebp)
  8010c3:	e8 5a 00 00 00       	call   801122 <vcprintf>
	cprintf("\n");
  8010c8:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010cf:	e8 a3 00 00 00       	call   801177 <cprintf>
  8010d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010d7:	cc                   	int3   
  8010d8:	eb fd                	jmp    8010d7 <_panic+0x47>

008010da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010da:	f3 0f 1e fb          	endbr32 
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010e8:	8b 13                	mov    (%ebx),%edx
  8010ea:	8d 42 01             	lea    0x1(%edx),%eax
  8010ed:	89 03                	mov    %eax,(%ebx)
  8010ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010fb:	74 09                	je     801106 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010fd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801104:	c9                   	leave  
  801105:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	68 ff 00 00 00       	push   $0xff
  80110e:	8d 43 08             	lea    0x8(%ebx),%eax
  801111:	50                   	push   %eax
  801112:	e8 e9 ef ff ff       	call   800100 <sys_cputs>
		b->idx = 0;
  801117:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	eb db                	jmp    8010fd <putch+0x23>

00801122 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801122:	f3 0f 1e fb          	endbr32 
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80112f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801136:	00 00 00 
	b.cnt = 0;
  801139:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801140:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	ff 75 08             	pushl  0x8(%ebp)
  801149:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80114f:	50                   	push   %eax
  801150:	68 da 10 80 00       	push   $0x8010da
  801155:	e8 80 01 00 00       	call   8012da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80115a:	83 c4 08             	add    $0x8,%esp
  80115d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801163:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	e8 91 ef ff ff       	call   800100 <sys_cputs>

	return b.cnt;
}
  80116f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801177:	f3 0f 1e fb          	endbr32 
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801181:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801184:	50                   	push   %eax
  801185:	ff 75 08             	pushl  0x8(%ebp)
  801188:	e8 95 ff ff ff       	call   801122 <vcprintf>
	va_end(ap);

	return cnt;
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	57                   	push   %edi
  801193:	56                   	push   %esi
  801194:	53                   	push   %ebx
  801195:	83 ec 1c             	sub    $0x1c,%esp
  801198:	89 c7                	mov    %eax,%edi
  80119a:	89 d6                	mov    %edx,%esi
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a2:	89 d1                	mov    %edx,%ecx
  8011a4:	89 c2                	mov    %eax,%edx
  8011a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011bc:	39 c2                	cmp    %eax,%edx
  8011be:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011c1:	72 3e                	jb     801201 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011c3:	83 ec 0c             	sub    $0xc,%esp
  8011c6:	ff 75 18             	pushl  0x18(%ebp)
  8011c9:	83 eb 01             	sub    $0x1,%ebx
  8011cc:	53                   	push   %ebx
  8011cd:	50                   	push   %eax
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8011d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8011da:	ff 75 d8             	pushl  -0x28(%ebp)
  8011dd:	e8 be 09 00 00       	call   801ba0 <__udivdi3>
  8011e2:	83 c4 18             	add    $0x18,%esp
  8011e5:	52                   	push   %edx
  8011e6:	50                   	push   %eax
  8011e7:	89 f2                	mov    %esi,%edx
  8011e9:	89 f8                	mov    %edi,%eax
  8011eb:	e8 9f ff ff ff       	call   80118f <printnum>
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	eb 13                	jmp    801208 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011f5:	83 ec 08             	sub    $0x8,%esp
  8011f8:	56                   	push   %esi
  8011f9:	ff 75 18             	pushl  0x18(%ebp)
  8011fc:	ff d7                	call   *%edi
  8011fe:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801201:	83 eb 01             	sub    $0x1,%ebx
  801204:	85 db                	test   %ebx,%ebx
  801206:	7f ed                	jg     8011f5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	56                   	push   %esi
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801212:	ff 75 e0             	pushl  -0x20(%ebp)
  801215:	ff 75 dc             	pushl  -0x24(%ebp)
  801218:	ff 75 d8             	pushl  -0x28(%ebp)
  80121b:	e8 90 0a 00 00       	call   801cb0 <__umoddi3>
  801220:	83 c4 14             	add    $0x14,%esp
  801223:	0f be 80 73 1f 80 00 	movsbl 0x801f73(%eax),%eax
  80122a:	50                   	push   %eax
  80122b:	ff d7                	call   *%edi
}
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801238:	83 fa 01             	cmp    $0x1,%edx
  80123b:	7f 13                	jg     801250 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  80123d:	85 d2                	test   %edx,%edx
  80123f:	74 1c                	je     80125d <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801241:	8b 10                	mov    (%eax),%edx
  801243:	8d 4a 04             	lea    0x4(%edx),%ecx
  801246:	89 08                	mov    %ecx,(%eax)
  801248:	8b 02                	mov    (%edx),%eax
  80124a:	ba 00 00 00 00       	mov    $0x0,%edx
  80124f:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801250:	8b 10                	mov    (%eax),%edx
  801252:	8d 4a 08             	lea    0x8(%edx),%ecx
  801255:	89 08                	mov    %ecx,(%eax)
  801257:	8b 02                	mov    (%edx),%eax
  801259:	8b 52 04             	mov    0x4(%edx),%edx
  80125c:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  80125d:	8b 10                	mov    (%eax),%edx
  80125f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801262:	89 08                	mov    %ecx,(%eax)
  801264:	8b 02                	mov    (%edx),%eax
  801266:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80126b:	c3                   	ret    

0080126c <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80126c:	83 fa 01             	cmp    $0x1,%edx
  80126f:	7f 0f                	jg     801280 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801271:	85 d2                	test   %edx,%edx
  801273:	74 18                	je     80128d <getint+0x21>
		return va_arg(*ap, long);
  801275:	8b 10                	mov    (%eax),%edx
  801277:	8d 4a 04             	lea    0x4(%edx),%ecx
  80127a:	89 08                	mov    %ecx,(%eax)
  80127c:	8b 02                	mov    (%edx),%eax
  80127e:	99                   	cltd   
  80127f:	c3                   	ret    
		return va_arg(*ap, long long);
  801280:	8b 10                	mov    (%eax),%edx
  801282:	8d 4a 08             	lea    0x8(%edx),%ecx
  801285:	89 08                	mov    %ecx,(%eax)
  801287:	8b 02                	mov    (%edx),%eax
  801289:	8b 52 04             	mov    0x4(%edx),%edx
  80128c:	c3                   	ret    
	else
		return va_arg(*ap, int);
  80128d:	8b 10                	mov    (%eax),%edx
  80128f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801292:	89 08                	mov    %ecx,(%eax)
  801294:	8b 02                	mov    (%edx),%eax
  801296:	99                   	cltd   
}
  801297:	c3                   	ret    

00801298 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801298:	f3 0f 1e fb          	endbr32 
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012a2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012a6:	8b 10                	mov    (%eax),%edx
  8012a8:	3b 50 04             	cmp    0x4(%eax),%edx
  8012ab:	73 0a                	jae    8012b7 <sprintputch+0x1f>
		*b->buf++ = ch;
  8012ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b0:	89 08                	mov    %ecx,(%eax)
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	88 02                	mov    %al,(%edx)
}
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <printfmt>:
{
  8012b9:	f3 0f 1e fb          	endbr32 
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012c3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012c6:	50                   	push   %eax
  8012c7:	ff 75 10             	pushl  0x10(%ebp)
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 05 00 00 00       	call   8012da <vprintfmt>
}
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <vprintfmt>:
{
  8012da:	f3 0f 1e fb          	endbr32 
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	57                   	push   %edi
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 2c             	sub    $0x2c,%esp
  8012e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012f0:	e9 86 02 00 00       	jmp    80157b <vprintfmt+0x2a1>
		padc = ' ';
  8012f5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012f9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801300:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801307:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80130e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801313:	8d 47 01             	lea    0x1(%edi),%eax
  801316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801319:	0f b6 17             	movzbl (%edi),%edx
  80131c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80131f:	3c 55                	cmp    $0x55,%al
  801321:	0f 87 df 02 00 00    	ja     801606 <vprintfmt+0x32c>
  801327:	0f b6 c0             	movzbl %al,%eax
  80132a:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801331:	00 
  801332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801335:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801339:	eb d8                	jmp    801313 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80133b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80133e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801342:	eb cf                	jmp    801313 <vprintfmt+0x39>
  801344:	0f b6 d2             	movzbl %dl,%edx
  801347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
  80134f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801352:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801355:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801359:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80135c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80135f:	83 f9 09             	cmp    $0x9,%ecx
  801362:	77 52                	ja     8013b6 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801364:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801367:	eb e9                	jmp    801352 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	8d 50 04             	lea    0x4(%eax),%edx
  80136f:	89 55 14             	mov    %edx,0x14(%ebp)
  801372:	8b 00                	mov    (%eax),%eax
  801374:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801377:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80137a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80137e:	79 93                	jns    801313 <vprintfmt+0x39>
				width = precision, precision = -1;
  801380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801383:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801386:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80138d:	eb 84                	jmp    801313 <vprintfmt+0x39>
  80138f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801392:	85 c0                	test   %eax,%eax
  801394:	ba 00 00 00 00       	mov    $0x0,%edx
  801399:	0f 49 d0             	cmovns %eax,%edx
  80139c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80139f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013a2:	e9 6c ff ff ff       	jmp    801313 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013aa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013b1:	e9 5d ff ff ff       	jmp    801313 <vprintfmt+0x39>
  8013b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013b9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013bc:	eb bc                	jmp    80137a <vprintfmt+0xa0>
			lflag++;
  8013be:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013c4:	e9 4a ff ff ff       	jmp    801313 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8d 50 04             	lea    0x4(%eax),%edx
  8013cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	56                   	push   %esi
  8013d6:	ff 30                	pushl  (%eax)
  8013d8:	ff d3                	call   *%ebx
			break;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	e9 96 01 00 00       	jmp    801578 <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e5:	8d 50 04             	lea    0x4(%eax),%edx
  8013e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	99                   	cltd   
  8013ee:	31 d0                	xor    %edx,%eax
  8013f0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013f2:	83 f8 0f             	cmp    $0xf,%eax
  8013f5:	7f 20                	jg     801417 <vprintfmt+0x13d>
  8013f7:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8013fe:	85 d2                	test   %edx,%edx
  801400:	74 15                	je     801417 <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801402:	52                   	push   %edx
  801403:	68 03 1f 80 00       	push   $0x801f03
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
  80140a:	e8 aa fe ff ff       	call   8012b9 <printfmt>
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	e9 61 01 00 00       	jmp    801578 <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  801417:	50                   	push   %eax
  801418:	68 8b 1f 80 00       	push   $0x801f8b
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	e8 95 fe ff ff       	call   8012b9 <printfmt>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	e9 4c 01 00 00       	jmp    801578 <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80142c:	8b 45 14             	mov    0x14(%ebp),%eax
  80142f:	8d 50 04             	lea    0x4(%eax),%edx
  801432:	89 55 14             	mov    %edx,0x14(%ebp)
  801435:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  801437:	85 c9                	test   %ecx,%ecx
  801439:	b8 84 1f 80 00       	mov    $0x801f84,%eax
  80143e:	0f 45 c1             	cmovne %ecx,%eax
  801441:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801448:	7e 06                	jle    801450 <vprintfmt+0x176>
  80144a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80144e:	75 0d                	jne    80145d <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801450:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801453:	89 c7                	mov    %eax,%edi
  801455:	03 45 e0             	add    -0x20(%ebp),%eax
  801458:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80145b:	eb 57                	jmp    8014b4 <vprintfmt+0x1da>
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 d8             	pushl  -0x28(%ebp)
  801463:	ff 75 cc             	pushl  -0x34(%ebp)
  801466:	e8 4f 02 00 00       	call   8016ba <strnlen>
  80146b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80146e:	29 c2                	sub    %eax,%edx
  801470:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801473:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801476:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80147a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80147d:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  80147f:	85 db                	test   %ebx,%ebx
  801481:	7e 10                	jle    801493 <vprintfmt+0x1b9>
					putch(padc, putdat);
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	56                   	push   %esi
  801487:	57                   	push   %edi
  801488:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80148b:	83 eb 01             	sub    $0x1,%ebx
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	eb ec                	jmp    80147f <vprintfmt+0x1a5>
  801493:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801496:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801499:	85 d2                	test   %edx,%edx
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a0:	0f 49 c2             	cmovns %edx,%eax
  8014a3:	29 c2                	sub    %eax,%edx
  8014a5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014a8:	eb a6                	jmp    801450 <vprintfmt+0x176>
					putch(ch, putdat);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	56                   	push   %esi
  8014ae:	52                   	push   %edx
  8014af:	ff d3                	call   *%ebx
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014b7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014b9:	83 c7 01             	add    $0x1,%edi
  8014bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014c0:	0f be d0             	movsbl %al,%edx
  8014c3:	85 d2                	test   %edx,%edx
  8014c5:	74 42                	je     801509 <vprintfmt+0x22f>
  8014c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014cb:	78 06                	js     8014d3 <vprintfmt+0x1f9>
  8014cd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014d1:	78 1e                	js     8014f1 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014d7:	74 d1                	je     8014aa <vprintfmt+0x1d0>
  8014d9:	0f be c0             	movsbl %al,%eax
  8014dc:	83 e8 20             	sub    $0x20,%eax
  8014df:	83 f8 5e             	cmp    $0x5e,%eax
  8014e2:	76 c6                	jbe    8014aa <vprintfmt+0x1d0>
					putch('?', putdat);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	56                   	push   %esi
  8014e8:	6a 3f                	push   $0x3f
  8014ea:	ff d3                	call   *%ebx
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	eb c3                	jmp    8014b4 <vprintfmt+0x1da>
  8014f1:	89 cf                	mov    %ecx,%edi
  8014f3:	eb 0e                	jmp    801503 <vprintfmt+0x229>
				putch(' ', putdat);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	56                   	push   %esi
  8014f9:	6a 20                	push   $0x20
  8014fb:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  8014fd:	83 ef 01             	sub    $0x1,%edi
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 ff                	test   %edi,%edi
  801505:	7f ee                	jg     8014f5 <vprintfmt+0x21b>
  801507:	eb 6f                	jmp    801578 <vprintfmt+0x29e>
  801509:	89 cf                	mov    %ecx,%edi
  80150b:	eb f6                	jmp    801503 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  80150d:	89 ca                	mov    %ecx,%edx
  80150f:	8d 45 14             	lea    0x14(%ebp),%eax
  801512:	e8 55 fd ff ff       	call   80126c <getint>
  801517:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80151a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80151d:	85 d2                	test   %edx,%edx
  80151f:	78 0b                	js     80152c <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801521:	89 d1                	mov    %edx,%ecx
  801523:	89 c2                	mov    %eax,%edx
			base = 10;
  801525:	b8 0a 00 00 00       	mov    $0xa,%eax
  80152a:	eb 32                	jmp    80155e <vprintfmt+0x284>
				putch('-', putdat);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	56                   	push   %esi
  801530:	6a 2d                	push   $0x2d
  801532:	ff d3                	call   *%ebx
				num = -(long long) num;
  801534:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801537:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80153a:	f7 da                	neg    %edx
  80153c:	83 d1 00             	adc    $0x0,%ecx
  80153f:	f7 d9                	neg    %ecx
  801541:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801544:	b8 0a 00 00 00       	mov    $0xa,%eax
  801549:	eb 13                	jmp    80155e <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80154b:	89 ca                	mov    %ecx,%edx
  80154d:	8d 45 14             	lea    0x14(%ebp),%eax
  801550:	e8 e3 fc ff ff       	call   801238 <getuint>
  801555:	89 d1                	mov    %edx,%ecx
  801557:	89 c2                	mov    %eax,%edx
			base = 10;
  801559:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801565:	57                   	push   %edi
  801566:	ff 75 e0             	pushl  -0x20(%ebp)
  801569:	50                   	push   %eax
  80156a:	51                   	push   %ecx
  80156b:	52                   	push   %edx
  80156c:	89 f2                	mov    %esi,%edx
  80156e:	89 d8                	mov    %ebx,%eax
  801570:	e8 1a fc ff ff       	call   80118f <printnum>
			break;
  801575:	83 c4 20             	add    $0x20,%esp
{
  801578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80157b:	83 c7 01             	add    $0x1,%edi
  80157e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801582:	83 f8 25             	cmp    $0x25,%eax
  801585:	0f 84 6a fd ff ff    	je     8012f5 <vprintfmt+0x1b>
			if (ch == '\0')
  80158b:	85 c0                	test   %eax,%eax
  80158d:	0f 84 93 00 00 00    	je     801626 <vprintfmt+0x34c>
			putch(ch, putdat);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	56                   	push   %esi
  801597:	50                   	push   %eax
  801598:	ff d3                	call   *%ebx
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	eb dc                	jmp    80157b <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  80159f:	89 ca                	mov    %ecx,%edx
  8015a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8015a4:	e8 8f fc ff ff       	call   801238 <getuint>
  8015a9:	89 d1                	mov    %edx,%ecx
  8015ab:	89 c2                	mov    %eax,%edx
			base = 8;
  8015ad:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015b2:	eb aa                	jmp    80155e <vprintfmt+0x284>
			putch('0', putdat);
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	56                   	push   %esi
  8015b8:	6a 30                	push   $0x30
  8015ba:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015bc:	83 c4 08             	add    $0x8,%esp
  8015bf:	56                   	push   %esi
  8015c0:	6a 78                	push   $0x78
  8015c2:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c7:	8d 50 04             	lea    0x4(%eax),%edx
  8015ca:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015cd:	8b 10                	mov    (%eax),%edx
  8015cf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015d4:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015d7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015dc:	eb 80                	jmp    80155e <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015de:	89 ca                	mov    %ecx,%edx
  8015e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8015e3:	e8 50 fc ff ff       	call   801238 <getuint>
  8015e8:	89 d1                	mov    %edx,%ecx
  8015ea:	89 c2                	mov    %eax,%edx
			base = 16;
  8015ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8015f1:	e9 68 ff ff ff       	jmp    80155e <vprintfmt+0x284>
			putch(ch, putdat);
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	56                   	push   %esi
  8015fa:	6a 25                	push   $0x25
  8015fc:	ff d3                	call   *%ebx
			break;
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	e9 72 ff ff ff       	jmp    801578 <vprintfmt+0x29e>
			putch('%', putdat);
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	56                   	push   %esi
  80160a:	6a 25                	push   $0x25
  80160c:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	89 f8                	mov    %edi,%eax
  801613:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801617:	74 05                	je     80161e <vprintfmt+0x344>
  801619:	83 e8 01             	sub    $0x1,%eax
  80161c:	eb f5                	jmp    801613 <vprintfmt+0x339>
  80161e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801621:	e9 52 ff ff ff       	jmp    801578 <vprintfmt+0x29e>
}
  801626:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5f                   	pop    %edi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80162e:	f3 0f 1e fb          	endbr32 
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80163e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801641:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801645:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801648:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 26                	je     801679 <vsnprintf+0x4b>
  801653:	85 d2                	test   %edx,%edx
  801655:	7e 22                	jle    801679 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801657:	ff 75 14             	pushl  0x14(%ebp)
  80165a:	ff 75 10             	pushl  0x10(%ebp)
  80165d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801660:	50                   	push   %eax
  801661:	68 98 12 80 00       	push   $0x801298
  801666:	e8 6f fc ff ff       	call   8012da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	83 c4 10             	add    $0x10,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    
		return -E_INVAL;
  801679:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167e:	eb f7                	jmp    801677 <vsnprintf+0x49>

00801680 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801680:	f3 0f 1e fb          	endbr32 
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80168a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80168d:	50                   	push   %eax
  80168e:	ff 75 10             	pushl  0x10(%ebp)
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	e8 92 ff ff ff       	call   80162e <vsnprintf>
	va_end(ap);

	return rc;
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80169e:	f3 0f 1e fb          	endbr32 
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ad:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016b1:	74 05                	je     8016b8 <strlen+0x1a>
		n++;
  8016b3:	83 c0 01             	add    $0x1,%eax
  8016b6:	eb f5                	jmp    8016ad <strlen+0xf>
	return n;
}
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ba:	f3 0f 1e fb          	endbr32 
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cc:	39 d0                	cmp    %edx,%eax
  8016ce:	74 0d                	je     8016dd <strnlen+0x23>
  8016d0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016d4:	74 05                	je     8016db <strnlen+0x21>
		n++;
  8016d6:	83 c0 01             	add    $0x1,%eax
  8016d9:	eb f1                	jmp    8016cc <strnlen+0x12>
  8016db:	89 c2                	mov    %eax,%edx
	return n;
}
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    

008016e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016e1:	f3 0f 1e fb          	endbr32 
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016f8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016fb:	83 c0 01             	add    $0x1,%eax
  8016fe:	84 d2                	test   %dl,%dl
  801700:	75 f2                	jne    8016f4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801702:	89 c8                	mov    %ecx,%eax
  801704:	5b                   	pop    %ebx
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801707:	f3 0f 1e fb          	endbr32 
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	53                   	push   %ebx
  80170f:	83 ec 10             	sub    $0x10,%esp
  801712:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801715:	53                   	push   %ebx
  801716:	e8 83 ff ff ff       	call   80169e <strlen>
  80171b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	01 d8                	add    %ebx,%eax
  801723:	50                   	push   %eax
  801724:	e8 b8 ff ff ff       	call   8016e1 <strcpy>
	return dst;
}
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801730:	f3 0f 1e fb          	endbr32 
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	8b 75 08             	mov    0x8(%ebp),%esi
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	89 f3                	mov    %esi,%ebx
  801741:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801744:	89 f0                	mov    %esi,%eax
  801746:	39 d8                	cmp    %ebx,%eax
  801748:	74 11                	je     80175b <strncpy+0x2b>
		*dst++ = *src;
  80174a:	83 c0 01             	add    $0x1,%eax
  80174d:	0f b6 0a             	movzbl (%edx),%ecx
  801750:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801753:	80 f9 01             	cmp    $0x1,%cl
  801756:	83 da ff             	sbb    $0xffffffff,%edx
  801759:	eb eb                	jmp    801746 <strncpy+0x16>
	}
	return ret;
}
  80175b:	89 f0                	mov    %esi,%eax
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801761:	f3 0f 1e fb          	endbr32 
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	8b 75 08             	mov    0x8(%ebp),%esi
  80176d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801770:	8b 55 10             	mov    0x10(%ebp),%edx
  801773:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801775:	85 d2                	test   %edx,%edx
  801777:	74 21                	je     80179a <strlcpy+0x39>
  801779:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80177d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80177f:	39 c2                	cmp    %eax,%edx
  801781:	74 14                	je     801797 <strlcpy+0x36>
  801783:	0f b6 19             	movzbl (%ecx),%ebx
  801786:	84 db                	test   %bl,%bl
  801788:	74 0b                	je     801795 <strlcpy+0x34>
			*dst++ = *src++;
  80178a:	83 c1 01             	add    $0x1,%ecx
  80178d:	83 c2 01             	add    $0x1,%edx
  801790:	88 5a ff             	mov    %bl,-0x1(%edx)
  801793:	eb ea                	jmp    80177f <strlcpy+0x1e>
  801795:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801797:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80179a:	29 f0                	sub    %esi,%eax
}
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017ad:	0f b6 01             	movzbl (%ecx),%eax
  8017b0:	84 c0                	test   %al,%al
  8017b2:	74 0c                	je     8017c0 <strcmp+0x20>
  8017b4:	3a 02                	cmp    (%edx),%al
  8017b6:	75 08                	jne    8017c0 <strcmp+0x20>
		p++, q++;
  8017b8:	83 c1 01             	add    $0x1,%ecx
  8017bb:	83 c2 01             	add    $0x1,%edx
  8017be:	eb ed                	jmp    8017ad <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c0:	0f b6 c0             	movzbl %al,%eax
  8017c3:	0f b6 12             	movzbl (%edx),%edx
  8017c6:	29 d0                	sub    %edx,%eax
}
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017ca:	f3 0f 1e fb          	endbr32 
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	53                   	push   %ebx
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017dd:	eb 06                	jmp    8017e5 <strncmp+0x1b>
		n--, p++, q++;
  8017df:	83 c0 01             	add    $0x1,%eax
  8017e2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017e5:	39 d8                	cmp    %ebx,%eax
  8017e7:	74 16                	je     8017ff <strncmp+0x35>
  8017e9:	0f b6 08             	movzbl (%eax),%ecx
  8017ec:	84 c9                	test   %cl,%cl
  8017ee:	74 04                	je     8017f4 <strncmp+0x2a>
  8017f0:	3a 0a                	cmp    (%edx),%cl
  8017f2:	74 eb                	je     8017df <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017f4:	0f b6 00             	movzbl (%eax),%eax
  8017f7:	0f b6 12             	movzbl (%edx),%edx
  8017fa:	29 d0                	sub    %edx,%eax
}
  8017fc:	5b                   	pop    %ebx
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    
		return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	eb f6                	jmp    8017fc <strncmp+0x32>

00801806 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801806:	f3 0f 1e fb          	endbr32 
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801814:	0f b6 10             	movzbl (%eax),%edx
  801817:	84 d2                	test   %dl,%dl
  801819:	74 09                	je     801824 <strchr+0x1e>
		if (*s == c)
  80181b:	38 ca                	cmp    %cl,%dl
  80181d:	74 0a                	je     801829 <strchr+0x23>
	for (; *s; s++)
  80181f:	83 c0 01             	add    $0x1,%eax
  801822:	eb f0                	jmp    801814 <strchr+0xe>
			return (char *) s;
	return 0;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

0080182b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801839:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80183c:	38 ca                	cmp    %cl,%dl
  80183e:	74 09                	je     801849 <strfind+0x1e>
  801840:	84 d2                	test   %dl,%dl
  801842:	74 05                	je     801849 <strfind+0x1e>
	for (; *s; s++)
  801844:	83 c0 01             	add    $0x1,%eax
  801847:	eb f0                	jmp    801839 <strfind+0xe>
			break;
	return (char *) s;
}
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80184b:	f3 0f 1e fb          	endbr32 
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	57                   	push   %edi
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	8b 55 08             	mov    0x8(%ebp),%edx
  801858:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80185b:	85 c9                	test   %ecx,%ecx
  80185d:	74 33                	je     801892 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80185f:	89 d0                	mov    %edx,%eax
  801861:	09 c8                	or     %ecx,%eax
  801863:	a8 03                	test   $0x3,%al
  801865:	75 23                	jne    80188a <memset+0x3f>
		c &= 0xFF;
  801867:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80186b:	89 d8                	mov    %ebx,%eax
  80186d:	c1 e0 08             	shl    $0x8,%eax
  801870:	89 df                	mov    %ebx,%edi
  801872:	c1 e7 18             	shl    $0x18,%edi
  801875:	89 de                	mov    %ebx,%esi
  801877:	c1 e6 10             	shl    $0x10,%esi
  80187a:	09 f7                	or     %esi,%edi
  80187c:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80187e:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801881:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801883:	89 d7                	mov    %edx,%edi
  801885:	fc                   	cld    
  801886:	f3 ab                	rep stos %eax,%es:(%edi)
  801888:	eb 08                	jmp    801892 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80188a:	89 d7                	mov    %edx,%edi
  80188c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188f:	fc                   	cld    
  801890:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801892:	89 d0                	mov    %edx,%eax
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801899:	f3 0f 1e fb          	endbr32 
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	57                   	push   %edi
  8018a1:	56                   	push   %esi
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018ab:	39 c6                	cmp    %eax,%esi
  8018ad:	73 32                	jae    8018e1 <memmove+0x48>
  8018af:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018b2:	39 c2                	cmp    %eax,%edx
  8018b4:	76 2b                	jbe    8018e1 <memmove+0x48>
		s += n;
		d += n;
  8018b6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018b9:	89 fe                	mov    %edi,%esi
  8018bb:	09 ce                	or     %ecx,%esi
  8018bd:	09 d6                	or     %edx,%esi
  8018bf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018c5:	75 0e                	jne    8018d5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018c7:	83 ef 04             	sub    $0x4,%edi
  8018ca:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018cd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018d0:	fd                   	std    
  8018d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018d3:	eb 09                	jmp    8018de <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018d5:	83 ef 01             	sub    $0x1,%edi
  8018d8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018db:	fd                   	std    
  8018dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018de:	fc                   	cld    
  8018df:	eb 1a                	jmp    8018fb <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018e1:	89 c2                	mov    %eax,%edx
  8018e3:	09 ca                	or     %ecx,%edx
  8018e5:	09 f2                	or     %esi,%edx
  8018e7:	f6 c2 03             	test   $0x3,%dl
  8018ea:	75 0a                	jne    8018f6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018ec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018ef:	89 c7                	mov    %eax,%edi
  8018f1:	fc                   	cld    
  8018f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018f4:	eb 05                	jmp    8018fb <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018f6:	89 c7                	mov    %eax,%edi
  8018f8:	fc                   	cld    
  8018f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018fb:	5e                   	pop    %esi
  8018fc:	5f                   	pop    %edi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018ff:	f3 0f 1e fb          	endbr32 
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801909:	ff 75 10             	pushl  0x10(%ebp)
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	e8 82 ff ff ff       	call   801899 <memmove>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801919:	f3 0f 1e fb          	endbr32 
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	89 c6                	mov    %eax,%esi
  80192a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80192d:	39 f0                	cmp    %esi,%eax
  80192f:	74 1c                	je     80194d <memcmp+0x34>
		if (*s1 != *s2)
  801931:	0f b6 08             	movzbl (%eax),%ecx
  801934:	0f b6 1a             	movzbl (%edx),%ebx
  801937:	38 d9                	cmp    %bl,%cl
  801939:	75 08                	jne    801943 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80193b:	83 c0 01             	add    $0x1,%eax
  80193e:	83 c2 01             	add    $0x1,%edx
  801941:	eb ea                	jmp    80192d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801943:	0f b6 c1             	movzbl %cl,%eax
  801946:	0f b6 db             	movzbl %bl,%ebx
  801949:	29 d8                	sub    %ebx,%eax
  80194b:	eb 05                	jmp    801952 <memcmp+0x39>
	}

	return 0;
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801956:	f3 0f 1e fb          	endbr32 
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801963:	89 c2                	mov    %eax,%edx
  801965:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801968:	39 d0                	cmp    %edx,%eax
  80196a:	73 09                	jae    801975 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196c:	38 08                	cmp    %cl,(%eax)
  80196e:	74 05                	je     801975 <memfind+0x1f>
	for (; s < ends; s++)
  801970:	83 c0 01             	add    $0x1,%eax
  801973:	eb f3                	jmp    801968 <memfind+0x12>
			break;
	return (void *) s;
}
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801977:	f3 0f 1e fb          	endbr32 
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	57                   	push   %edi
  80197f:	56                   	push   %esi
  801980:	53                   	push   %ebx
  801981:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801984:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801987:	eb 03                	jmp    80198c <strtol+0x15>
		s++;
  801989:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80198c:	0f b6 01             	movzbl (%ecx),%eax
  80198f:	3c 20                	cmp    $0x20,%al
  801991:	74 f6                	je     801989 <strtol+0x12>
  801993:	3c 09                	cmp    $0x9,%al
  801995:	74 f2                	je     801989 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801997:	3c 2b                	cmp    $0x2b,%al
  801999:	74 2a                	je     8019c5 <strtol+0x4e>
	int neg = 0;
  80199b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8019a0:	3c 2d                	cmp    $0x2d,%al
  8019a2:	74 2b                	je     8019cf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019a4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019aa:	75 0f                	jne    8019bb <strtol+0x44>
  8019ac:	80 39 30             	cmpb   $0x30,(%ecx)
  8019af:	74 28                	je     8019d9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019b1:	85 db                	test   %ebx,%ebx
  8019b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b8:	0f 44 d8             	cmove  %eax,%ebx
  8019bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019c3:	eb 46                	jmp    801a0b <strtol+0x94>
		s++;
  8019c5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8019cd:	eb d5                	jmp    8019a4 <strtol+0x2d>
		s++, neg = 1;
  8019cf:	83 c1 01             	add    $0x1,%ecx
  8019d2:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d7:	eb cb                	jmp    8019a4 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019dd:	74 0e                	je     8019ed <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019df:	85 db                	test   %ebx,%ebx
  8019e1:	75 d8                	jne    8019bb <strtol+0x44>
		s++, base = 8;
  8019e3:	83 c1 01             	add    $0x1,%ecx
  8019e6:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019eb:	eb ce                	jmp    8019bb <strtol+0x44>
		s += 2, base = 16;
  8019ed:	83 c1 02             	add    $0x2,%ecx
  8019f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019f5:	eb c4                	jmp    8019bb <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019f7:	0f be d2             	movsbl %dl,%edx
  8019fa:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019fd:	3b 55 10             	cmp    0x10(%ebp),%edx
  801a00:	7d 3a                	jge    801a3c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801a02:	83 c1 01             	add    $0x1,%ecx
  801a05:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a09:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a0b:	0f b6 11             	movzbl (%ecx),%edx
  801a0e:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a11:	89 f3                	mov    %esi,%ebx
  801a13:	80 fb 09             	cmp    $0x9,%bl
  801a16:	76 df                	jbe    8019f7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a18:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a1b:	89 f3                	mov    %esi,%ebx
  801a1d:	80 fb 19             	cmp    $0x19,%bl
  801a20:	77 08                	ja     801a2a <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a22:	0f be d2             	movsbl %dl,%edx
  801a25:	83 ea 57             	sub    $0x57,%edx
  801a28:	eb d3                	jmp    8019fd <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a2a:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a2d:	89 f3                	mov    %esi,%ebx
  801a2f:	80 fb 19             	cmp    $0x19,%bl
  801a32:	77 08                	ja     801a3c <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a34:	0f be d2             	movsbl %dl,%edx
  801a37:	83 ea 37             	sub    $0x37,%edx
  801a3a:	eb c1                	jmp    8019fd <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a40:	74 05                	je     801a47 <strtol+0xd0>
		*endptr = (char *) s;
  801a42:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a45:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a47:	89 c2                	mov    %eax,%edx
  801a49:	f7 da                	neg    %edx
  801a4b:	85 ff                	test   %edi,%edi
  801a4d:	0f 45 c2             	cmovne %edx,%eax
}
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    

00801a55 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a55:	f3 0f 1e fb          	endbr32 
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a67:	85 c0                	test   %eax,%eax
  801a69:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a6e:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a71:	83 ec 0c             	sub    $0xc,%esp
  801a74:	50                   	push   %eax
  801a75:	e8 68 e8 ff ff       	call   8002e2 <sys_ipc_recv>
	if (r < 0) {
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 2b                	js     801aac <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a81:	85 f6                	test   %esi,%esi
  801a83:	74 0a                	je     801a8f <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a85:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8a:	8b 40 74             	mov    0x74(%eax),%eax
  801a8d:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a8f:	85 db                	test   %ebx,%ebx
  801a91:	74 0a                	je     801a9d <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a93:	a1 04 40 80 00       	mov    0x804004,%eax
  801a98:	8b 40 78             	mov    0x78(%eax),%eax
  801a9b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801a9d:	a1 04 40 80 00       	mov    0x804004,%eax
  801aa2:	8b 40 70             	mov    0x70(%eax),%eax
}
  801aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
		if (from_env_store) {
  801aac:	85 f6                	test   %esi,%esi
  801aae:	74 06                	je     801ab6 <ipc_recv+0x61>
			*from_env_store = 0;
  801ab0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801ab6:	85 db                	test   %ebx,%ebx
  801ab8:	74 eb                	je     801aa5 <ipc_recv+0x50>
			*perm_store = 0;
  801aba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ac0:	eb e3                	jmp    801aa5 <ipc_recv+0x50>

00801ac2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ac2:	f3 0f 1e fb          	endbr32 
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	57                   	push   %edi
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ad2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801ad8:	85 db                	test   %ebx,%ebx
  801ada:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801adf:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ae2:	ff 75 14             	pushl  0x14(%ebp)
  801ae5:	53                   	push   %ebx
  801ae6:	56                   	push   %esi
  801ae7:	57                   	push   %edi
  801ae8:	e8 cc e7 ff ff       	call   8002b9 <sys_ipc_try_send>
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801af3:	75 07                	jne    801afc <ipc_send+0x3a>
		sys_yield();
  801af5:	e8 a6 e6 ff ff       	call   8001a0 <sys_yield>
  801afa:	eb e6                	jmp    801ae2 <ipc_send+0x20>
	}

	if (ret < 0) {
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 08                	js     801b08 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b08:	50                   	push   %eax
  801b09:	68 7f 22 80 00       	push   $0x80227f
  801b0e:	6a 48                	push   $0x48
  801b10:	68 9c 22 80 00       	push   $0x80229c
  801b15:	e8 76 f5 ff ff       	call   801090 <_panic>

00801b1a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b1a:	f3 0f 1e fb          	endbr32 
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b29:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b2c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b32:	8b 52 50             	mov    0x50(%edx),%edx
  801b35:	39 ca                	cmp    %ecx,%edx
  801b37:	74 11                	je     801b4a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b39:	83 c0 01             	add    $0x1,%eax
  801b3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b41:	75 e6                	jne    801b29 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	eb 0b                	jmp    801b55 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b52:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    

00801b57 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b57:	f3 0f 1e fb          	endbr32 
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b61:	89 c2                	mov    %eax,%edx
  801b63:	c1 ea 16             	shr    $0x16,%edx
  801b66:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b6d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b72:	f6 c1 01             	test   $0x1,%cl
  801b75:	74 1c                	je     801b93 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b77:	c1 e8 0c             	shr    $0xc,%eax
  801b7a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b81:	a8 01                	test   $0x1,%al
  801b83:	74 0e                	je     801b93 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b85:	c1 e8 0c             	shr    $0xc,%eax
  801b88:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b8f:	ef 
  801b90:	0f b7 d2             	movzwl %dx,%edx
}
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
  801b97:	66 90                	xchg   %ax,%ax
  801b99:	66 90                	xchg   %ax,%ax
  801b9b:	66 90                	xchg   %ax,%ax
  801b9d:	66 90                	xchg   %ax,%ax
  801b9f:	90                   	nop

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
