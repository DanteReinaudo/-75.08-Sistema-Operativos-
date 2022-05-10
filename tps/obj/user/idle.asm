
obj/user/idle.debug:     formato del fichero elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003d:	c7 05 00 30 80 00 00 	movl   $0x801e00,0x803000
  800044:	1e 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800047:	e8 57 01 00 00       	call   8001a3 <sys_yield>
  80004c:	eb f9                	jmp    800047 <umain+0x14>

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80005d:	e8 19 01 00 00       	call   80017b <sys_getenvid>
	if (id >= 0)
  800062:	85 c0                	test   %eax,%eax
  800064:	78 12                	js     800078 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x35>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	e8 a6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008d:	e8 0a 00 00 00       	call   80009c <exit>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	f3 0f 1e fb          	endbr32 
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 53 04 00 00       	call   8004fe <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 a0 00 00 00       	call   800155 <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
  8000c0:	83 ec 1c             	sub    $0x1c,%esp
  8000c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000c9:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000d1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000d4:	8b 75 14             	mov    0x14(%ebp),%esi
  8000d7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000dd:	74 04                	je     8000e3 <syscall+0x29>
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	7f 08                	jg     8000eb <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	50                   	push   %eax
  8000ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f2:	68 0f 1e 80 00       	push   $0x801e0f
  8000f7:	6a 23                	push   $0x23
  8000f9:	68 2c 1e 80 00       	push   $0x801e2c
  8000fe:	e8 90 0f 00 00       	call   801093 <_panic>

00800103 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800103:	f3 0f 1e fb          	endbr32 
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80010d:	6a 00                	push   $0x0
  80010f:	6a 00                	push   $0x0
  800111:	6a 00                	push   $0x0
  800113:	ff 75 0c             	pushl  0xc(%ebp)
  800116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
  80011e:	b8 00 00 00 00       	mov    $0x0,%eax
  800123:	e8 92 ff ff ff       	call   8000ba <syscall>
}
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    

0080012d <sys_cgetc>:

int
sys_cgetc(void)
{
  80012d:	f3 0f 1e fb          	endbr32 
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800137:	6a 00                	push   $0x0
  800139:	6a 00                	push   $0x0
  80013b:	6a 00                	push   $0x0
  80013d:	6a 00                	push   $0x0
  80013f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800144:	ba 00 00 00 00       	mov    $0x0,%edx
  800149:	b8 01 00 00 00       	mov    $0x1,%eax
  80014e:	e8 67 ff ff ff       	call   8000ba <syscall>
}
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80015f:	6a 00                	push   $0x0
  800161:	6a 00                	push   $0x0
  800163:	6a 00                	push   $0x0
  800165:	6a 00                	push   $0x0
  800167:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016a:	ba 01 00 00 00       	mov    $0x1,%edx
  80016f:	b8 03 00 00 00       	mov    $0x3,%eax
  800174:	e8 41 ff ff ff       	call   8000ba <syscall>
}
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80017b:	f3 0f 1e fb          	endbr32 
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800185:	6a 00                	push   $0x0
  800187:	6a 00                	push   $0x0
  800189:	6a 00                	push   $0x0
  80018b:	6a 00                	push   $0x0
  80018d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800192:	ba 00 00 00 00       	mov    $0x0,%edx
  800197:	b8 02 00 00 00       	mov    $0x2,%eax
  80019c:	e8 19 ff ff ff       	call   8000ba <syscall>
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <sys_yield>:

void
sys_yield(void)
{
  8001a3:	f3 0f 1e fb          	endbr32 
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001ad:	6a 00                	push   $0x0
  8001af:	6a 00                	push   $0x0
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 00                	push   $0x0
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c4:	e8 f1 fe ff ff       	call   8000ba <syscall>
}
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	c9                   	leave  
  8001cd:	c3                   	ret    

008001ce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001d8:	6a 00                	push   $0x0
  8001da:	6a 00                	push   $0x0
  8001dc:	ff 75 10             	pushl  0x10(%ebp)
  8001df:	ff 75 0c             	pushl  0xc(%ebp)
  8001e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e5:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ef:	e8 c6 fe ff ff       	call   8000ba <syscall>
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f6:	f3 0f 1e fb          	endbr32 
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800200:	ff 75 18             	pushl  0x18(%ebp)
  800203:	ff 75 14             	pushl  0x14(%ebp)
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020f:	ba 01 00 00 00       	mov    $0x1,%edx
  800214:	b8 05 00 00 00       	mov    $0x5,%eax
  800219:	e8 9c fe ff ff       	call   8000ba <syscall>
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800220:	f3 0f 1e fb          	endbr32 
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80022a:	6a 00                	push   $0x0
  80022c:	6a 00                	push   $0x0
  80022e:	6a 00                	push   $0x0
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800236:	ba 01 00 00 00       	mov    $0x1,%edx
  80023b:	b8 06 00 00 00       	mov    $0x6,%eax
  800240:	e8 75 fe ff ff       	call   8000ba <syscall>
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800247:	f3 0f 1e fb          	endbr32 
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800251:	6a 00                	push   $0x0
  800253:	6a 00                	push   $0x0
  800255:	6a 00                	push   $0x0
  800257:	ff 75 0c             	pushl  0xc(%ebp)
  80025a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025d:	ba 01 00 00 00       	mov    $0x1,%edx
  800262:	b8 08 00 00 00       	mov    $0x8,%eax
  800267:	e8 4e fe ff ff       	call   8000ba <syscall>
}
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026e:	f3 0f 1e fb          	endbr32 
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800278:	6a 00                	push   $0x0
  80027a:	6a 00                	push   $0x0
  80027c:	6a 00                	push   $0x0
  80027e:	ff 75 0c             	pushl  0xc(%ebp)
  800281:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800284:	ba 01 00 00 00       	mov    $0x1,%edx
  800289:	b8 09 00 00 00       	mov    $0x9,%eax
  80028e:	e8 27 fe ff ff       	call   8000ba <syscall>
}
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800295:	f3 0f 1e fb          	endbr32 
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80029f:	6a 00                	push   $0x0
  8002a1:	6a 00                	push   $0x0
  8002a3:	6a 00                	push   $0x0
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8002b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b5:	e8 00 fe ff ff       	call   8000ba <syscall>
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002bc:	f3 0f 1e fb          	endbr32 
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002c6:	6a 00                	push   $0x0
  8002c8:	ff 75 14             	pushl  0x14(%ebp)
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	ff 75 0c             	pushl  0xc(%ebp)
  8002d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002de:	e8 d7 fd ff ff       	call   8000ba <syscall>
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002e5:	f3 0f 1e fb          	endbr32 
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002ef:	6a 00                	push   $0x0
  8002f1:	6a 00                	push   $0x0
  8002f3:	6a 00                	push   $0x0
  8002f5:	6a 00                	push   $0x0
  8002f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ff:	b8 0d 00 00 00       	mov    $0xd,%eax
  800304:	e8 b1 fd ff ff       	call   8000ba <syscall>
}
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80030b:	f3 0f 1e fb          	endbr32 
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	05 00 00 00 30       	add    $0x30000000,%eax
  80031a:	c1 e8 0c             	shr    $0xc,%eax
}
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80031f:	f3 0f 1e fb          	endbr32 
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800329:	ff 75 08             	pushl  0x8(%ebp)
  80032c:	e8 da ff ff ff       	call   80030b <fd2num>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	c1 e0 0c             	shl    $0xc,%eax
  800337:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	c1 ea 16             	shr    $0x16,%edx
  80034f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800356:	f6 c2 01             	test   $0x1,%dl
  800359:	74 2d                	je     800388 <fd_alloc+0x4a>
  80035b:	89 c2                	mov    %eax,%edx
  80035d:	c1 ea 0c             	shr    $0xc,%edx
  800360:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800367:	f6 c2 01             	test   $0x1,%dl
  80036a:	74 1c                	je     800388 <fd_alloc+0x4a>
  80036c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800371:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800376:	75 d2                	jne    80034a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800381:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800386:	eb 0a                	jmp    800392 <fd_alloc+0x54>
			*fd_store = fd;
  800388:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80038b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800392:	5d                   	pop    %ebp
  800393:	c3                   	ret    

00800394 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800394:	f3 0f 1e fb          	endbr32 
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80039e:	83 f8 1f             	cmp    $0x1f,%eax
  8003a1:	77 30                	ja     8003d3 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003a3:	c1 e0 0c             	shl    $0xc,%eax
  8003a6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ab:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003b1:	f6 c2 01             	test   $0x1,%dl
  8003b4:	74 24                	je     8003da <fd_lookup+0x46>
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	c1 ea 0c             	shr    $0xc,%edx
  8003bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003c2:	f6 c2 01             	test   $0x1,%dl
  8003c5:	74 1a                	je     8003e1 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ca:	89 02                	mov    %eax,(%edx)
	return 0;
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    
		return -E_INVAL;
  8003d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003d8:	eb f7                	jmp    8003d1 <fd_lookup+0x3d>
		return -E_INVAL;
  8003da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003df:	eb f0                	jmp    8003d1 <fd_lookup+0x3d>
  8003e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003e6:	eb e9                	jmp    8003d1 <fd_lookup+0x3d>

008003e8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003e8:	f3 0f 1e fb          	endbr32 
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f5:	ba b8 1e 80 00       	mov    $0x801eb8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003fa:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8003ff:	39 08                	cmp    %ecx,(%eax)
  800401:	74 33                	je     800436 <dev_lookup+0x4e>
  800403:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800406:	8b 02                	mov    (%edx),%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	75 f3                	jne    8003ff <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80040c:	a1 04 40 80 00       	mov    0x804004,%eax
  800411:	8b 40 48             	mov    0x48(%eax),%eax
  800414:	83 ec 04             	sub    $0x4,%esp
  800417:	51                   	push   %ecx
  800418:	50                   	push   %eax
  800419:	68 3c 1e 80 00       	push   $0x801e3c
  80041e:	e8 57 0d 00 00       	call   80117a <cprintf>
	*dev = 0;
  800423:	8b 45 0c             	mov    0xc(%ebp),%eax
  800426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800434:	c9                   	leave  
  800435:	c3                   	ret    
			*dev = devtab[i];
  800436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800439:	89 01                	mov    %eax,(%ecx)
			return 0;
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	eb f2                	jmp    800434 <dev_lookup+0x4c>

00800442 <fd_close>:
{
  800442:	f3 0f 1e fb          	endbr32 
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	57                   	push   %edi
  80044a:	56                   	push   %esi
  80044b:	53                   	push   %ebx
  80044c:	83 ec 28             	sub    $0x28,%esp
  80044f:	8b 75 08             	mov    0x8(%ebp),%esi
  800452:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800455:	56                   	push   %esi
  800456:	e8 b0 fe ff ff       	call   80030b <fd2num>
  80045b:	83 c4 08             	add    $0x8,%esp
  80045e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800461:	52                   	push   %edx
  800462:	50                   	push   %eax
  800463:	e8 2c ff ff ff       	call   800394 <fd_lookup>
  800468:	89 c3                	mov    %eax,%ebx
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	85 c0                	test   %eax,%eax
  80046f:	78 05                	js     800476 <fd_close+0x34>
	    || fd != fd2)
  800471:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800474:	74 16                	je     80048c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800476:	89 f8                	mov    %edi,%eax
  800478:	84 c0                	test   %al,%al
  80047a:	b8 00 00 00 00       	mov    $0x0,%eax
  80047f:	0f 44 d8             	cmove  %eax,%ebx
}
  800482:	89 d8                	mov    %ebx,%eax
  800484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800487:	5b                   	pop    %ebx
  800488:	5e                   	pop    %esi
  800489:	5f                   	pop    %edi
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800492:	50                   	push   %eax
  800493:	ff 36                	pushl  (%esi)
  800495:	e8 4e ff ff ff       	call   8003e8 <dev_lookup>
  80049a:	89 c3                	mov    %eax,%ebx
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	78 1a                	js     8004bd <fd_close+0x7b>
		if (dev->dev_close)
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	74 0b                	je     8004bd <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	56                   	push   %esi
  8004b6:	ff d0                	call   *%eax
  8004b8:	89 c3                	mov    %eax,%ebx
  8004ba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	6a 00                	push   $0x0
  8004c3:	e8 58 fd ff ff       	call   800220 <sys_page_unmap>
	return r;
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	eb b5                	jmp    800482 <fd_close+0x40>

008004cd <close>:

int
close(int fdnum)
{
  8004cd:	f3 0f 1e fb          	endbr32 
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004da:	50                   	push   %eax
  8004db:	ff 75 08             	pushl  0x8(%ebp)
  8004de:	e8 b1 fe ff ff       	call   800394 <fd_lookup>
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	85 c0                	test   %eax,%eax
  8004e8:	79 02                	jns    8004ec <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    
		return fd_close(fd, 1);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	6a 01                	push   $0x1
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	e8 49 ff ff ff       	call   800442 <fd_close>
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	eb ec                	jmp    8004ea <close+0x1d>

008004fe <close_all>:

void
close_all(void)
{
  8004fe:	f3 0f 1e fb          	endbr32 
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	53                   	push   %ebx
  800506:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800509:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	53                   	push   %ebx
  800512:	e8 b6 ff ff ff       	call   8004cd <close>
	for (i = 0; i < MAXFD; i++)
  800517:	83 c3 01             	add    $0x1,%ebx
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	83 fb 20             	cmp    $0x20,%ebx
  800520:	75 ec                	jne    80050e <close_all+0x10>
}
  800522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800527:	f3 0f 1e fb          	endbr32 
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	57                   	push   %edi
  80052f:	56                   	push   %esi
  800530:	53                   	push   %ebx
  800531:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800534:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800537:	50                   	push   %eax
  800538:	ff 75 08             	pushl  0x8(%ebp)
  80053b:	e8 54 fe ff ff       	call   800394 <fd_lookup>
  800540:	89 c3                	mov    %eax,%ebx
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	85 c0                	test   %eax,%eax
  800547:	0f 88 81 00 00 00    	js     8005ce <dup+0xa7>
		return r;
	close(newfdnum);
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	e8 75 ff ff ff       	call   8004cd <close>

	newfd = INDEX2FD(newfdnum);
  800558:	8b 75 0c             	mov    0xc(%ebp),%esi
  80055b:	c1 e6 0c             	shl    $0xc,%esi
  80055e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800564:	83 c4 04             	add    $0x4,%esp
  800567:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056a:	e8 b0 fd ff ff       	call   80031f <fd2data>
  80056f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800571:	89 34 24             	mov    %esi,(%esp)
  800574:	e8 a6 fd ff ff       	call   80031f <fd2data>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80057e:	89 d8                	mov    %ebx,%eax
  800580:	c1 e8 16             	shr    $0x16,%eax
  800583:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80058a:	a8 01                	test   $0x1,%al
  80058c:	74 11                	je     80059f <dup+0x78>
  80058e:	89 d8                	mov    %ebx,%eax
  800590:	c1 e8 0c             	shr    $0xc,%eax
  800593:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80059a:	f6 c2 01             	test   $0x1,%dl
  80059d:	75 39                	jne    8005d8 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80059f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	c1 e8 0c             	shr    $0xc,%eax
  8005a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ae:	83 ec 0c             	sub    $0xc,%esp
  8005b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8005b6:	50                   	push   %eax
  8005b7:	56                   	push   %esi
  8005b8:	6a 00                	push   $0x0
  8005ba:	52                   	push   %edx
  8005bb:	6a 00                	push   $0x0
  8005bd:	e8 34 fc ff ff       	call   8001f6 <sys_page_map>
  8005c2:	89 c3                	mov    %eax,%ebx
  8005c4:	83 c4 20             	add    $0x20,%esp
  8005c7:	85 c0                	test   %eax,%eax
  8005c9:	78 31                	js     8005fc <dup+0xd5>
		goto err;

	return newfdnum;
  8005cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005ce:	89 d8                	mov    %ebx,%eax
  8005d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d3:	5b                   	pop    %ebx
  8005d4:	5e                   	pop    %esi
  8005d5:	5f                   	pop    %edi
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8005e7:	50                   	push   %eax
  8005e8:	57                   	push   %edi
  8005e9:	6a 00                	push   $0x0
  8005eb:	53                   	push   %ebx
  8005ec:	6a 00                	push   $0x0
  8005ee:	e8 03 fc ff ff       	call   8001f6 <sys_page_map>
  8005f3:	89 c3                	mov    %eax,%ebx
  8005f5:	83 c4 20             	add    $0x20,%esp
  8005f8:	85 c0                	test   %eax,%eax
  8005fa:	79 a3                	jns    80059f <dup+0x78>
	sys_page_unmap(0, newfd);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	56                   	push   %esi
  800600:	6a 00                	push   $0x0
  800602:	e8 19 fc ff ff       	call   800220 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800607:	83 c4 08             	add    $0x8,%esp
  80060a:	57                   	push   %edi
  80060b:	6a 00                	push   $0x0
  80060d:	e8 0e fc ff ff       	call   800220 <sys_page_unmap>
	return r;
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	eb b7                	jmp    8005ce <dup+0xa7>

00800617 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800617:	f3 0f 1e fb          	endbr32 
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	53                   	push   %ebx
  80061f:	83 ec 1c             	sub    $0x1c,%esp
  800622:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800625:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800628:	50                   	push   %eax
  800629:	53                   	push   %ebx
  80062a:	e8 65 fd ff ff       	call   800394 <fd_lookup>
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	85 c0                	test   %eax,%eax
  800634:	78 3f                	js     800675 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80063c:	50                   	push   %eax
  80063d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800640:	ff 30                	pushl  (%eax)
  800642:	e8 a1 fd ff ff       	call   8003e8 <dev_lookup>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	85 c0                	test   %eax,%eax
  80064c:	78 27                	js     800675 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80064e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800651:	8b 42 08             	mov    0x8(%edx),%eax
  800654:	83 e0 03             	and    $0x3,%eax
  800657:	83 f8 01             	cmp    $0x1,%eax
  80065a:	74 1e                	je     80067a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80065c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065f:	8b 40 08             	mov    0x8(%eax),%eax
  800662:	85 c0                	test   %eax,%eax
  800664:	74 35                	je     80069b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800666:	83 ec 04             	sub    $0x4,%esp
  800669:	ff 75 10             	pushl  0x10(%ebp)
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	52                   	push   %edx
  800670:	ff d0                	call   *%eax
  800672:	83 c4 10             	add    $0x10,%esp
}
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80067a:	a1 04 40 80 00       	mov    0x804004,%eax
  80067f:	8b 40 48             	mov    0x48(%eax),%eax
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	53                   	push   %ebx
  800686:	50                   	push   %eax
  800687:	68 7d 1e 80 00       	push   $0x801e7d
  80068c:	e8 e9 0a 00 00       	call   80117a <cprintf>
		return -E_INVAL;
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800699:	eb da                	jmp    800675 <read+0x5e>
		return -E_NOT_SUPP;
  80069b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006a0:	eb d3                	jmp    800675 <read+0x5e>

008006a2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006a2:	f3 0f 1e fb          	endbr32 
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	57                   	push   %edi
  8006aa:	56                   	push   %esi
  8006ab:	53                   	push   %ebx
  8006ac:	83 ec 0c             	sub    $0xc,%esp
  8006af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ba:	eb 02                	jmp    8006be <readn+0x1c>
  8006bc:	01 c3                	add    %eax,%ebx
  8006be:	39 f3                	cmp    %esi,%ebx
  8006c0:	73 21                	jae    8006e3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006c2:	83 ec 04             	sub    $0x4,%esp
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	29 d8                	sub    %ebx,%eax
  8006c9:	50                   	push   %eax
  8006ca:	89 d8                	mov    %ebx,%eax
  8006cc:	03 45 0c             	add    0xc(%ebp),%eax
  8006cf:	50                   	push   %eax
  8006d0:	57                   	push   %edi
  8006d1:	e8 41 ff ff ff       	call   800617 <read>
		if (m < 0)
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	85 c0                	test   %eax,%eax
  8006db:	78 04                	js     8006e1 <readn+0x3f>
			return m;
		if (m == 0)
  8006dd:	75 dd                	jne    8006bc <readn+0x1a>
  8006df:	eb 02                	jmp    8006e3 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006e3:	89 d8                	mov    %ebx,%eax
  8006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e8:	5b                   	pop    %ebx
  8006e9:	5e                   	pop    %esi
  8006ea:	5f                   	pop    %edi
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    

008006ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006ed:	f3 0f 1e fb          	endbr32 
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	53                   	push   %ebx
  8006f5:	83 ec 1c             	sub    $0x1c,%esp
  8006f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	53                   	push   %ebx
  800700:	e8 8f fc ff ff       	call   800394 <fd_lookup>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	85 c0                	test   %eax,%eax
  80070a:	78 3a                	js     800746 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800712:	50                   	push   %eax
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	ff 30                	pushl  (%eax)
  800718:	e8 cb fc ff ff       	call   8003e8 <dev_lookup>
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	85 c0                	test   %eax,%eax
  800722:	78 22                	js     800746 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800727:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80072b:	74 1e                	je     80074b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80072d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800730:	8b 52 0c             	mov    0xc(%edx),%edx
  800733:	85 d2                	test   %edx,%edx
  800735:	74 35                	je     80076c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800737:	83 ec 04             	sub    $0x4,%esp
  80073a:	ff 75 10             	pushl  0x10(%ebp)
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	50                   	push   %eax
  800741:	ff d2                	call   *%edx
  800743:	83 c4 10             	add    $0x10,%esp
}
  800746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800749:	c9                   	leave  
  80074a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80074b:	a1 04 40 80 00       	mov    0x804004,%eax
  800750:	8b 40 48             	mov    0x48(%eax),%eax
  800753:	83 ec 04             	sub    $0x4,%esp
  800756:	53                   	push   %ebx
  800757:	50                   	push   %eax
  800758:	68 99 1e 80 00       	push   $0x801e99
  80075d:	e8 18 0a 00 00       	call   80117a <cprintf>
		return -E_INVAL;
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076a:	eb da                	jmp    800746 <write+0x59>
		return -E_NOT_SUPP;
  80076c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800771:	eb d3                	jmp    800746 <write+0x59>

00800773 <seek>:

int
seek(int fdnum, off_t offset)
{
  800773:	f3 0f 1e fb          	endbr32 
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80077d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800780:	50                   	push   %eax
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	e8 0b fc ff ff       	call   800394 <fd_lookup>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	85 c0                	test   %eax,%eax
  80078e:	78 0e                	js     80079e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800790:	8b 55 0c             	mov    0xc(%ebp),%edx
  800793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800796:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007a0:	f3 0f 1e fb          	endbr32 
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 1c             	sub    $0x1c,%esp
  8007ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b1:	50                   	push   %eax
  8007b2:	53                   	push   %ebx
  8007b3:	e8 dc fb ff ff       	call   800394 <fd_lookup>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	78 37                	js     8007f6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c5:	50                   	push   %eax
  8007c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c9:	ff 30                	pushl  (%eax)
  8007cb:	e8 18 fc ff ff       	call   8003e8 <dev_lookup>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	78 1f                	js     8007f6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007de:	74 1b                	je     8007fb <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	8b 52 18             	mov    0x18(%edx),%edx
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	74 32                	je     80081c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	50                   	push   %eax
  8007f1:	ff d2                	call   *%edx
  8007f3:	83 c4 10             	add    $0x10,%esp
}
  8007f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007fb:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800800:	8b 40 48             	mov    0x48(%eax),%eax
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	53                   	push   %ebx
  800807:	50                   	push   %eax
  800808:	68 5c 1e 80 00       	push   $0x801e5c
  80080d:	e8 68 09 00 00       	call   80117a <cprintf>
		return -E_INVAL;
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081a:	eb da                	jmp    8007f6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80081c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800821:	eb d3                	jmp    8007f6 <ftruncate+0x56>

00800823 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800823:	f3 0f 1e fb          	endbr32 
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	83 ec 1c             	sub    $0x1c,%esp
  80082e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800831:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 57 fb ff ff       	call   800394 <fd_lookup>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	85 c0                	test   %eax,%eax
  800842:	78 4b                	js     80088f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084e:	ff 30                	pushl  (%eax)
  800850:	e8 93 fb ff ff       	call   8003e8 <dev_lookup>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	85 c0                	test   %eax,%eax
  80085a:	78 33                	js     80088f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800863:	74 2f                	je     800894 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800865:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800868:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80086f:	00 00 00 
	stat->st_isdir = 0;
  800872:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800879:	00 00 00 
	stat->st_dev = dev;
  80087c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	ff 75 f0             	pushl  -0x10(%ebp)
  800889:	ff 50 14             	call   *0x14(%eax)
  80088c:	83 c4 10             	add    $0x10,%esp
}
  80088f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800892:	c9                   	leave  
  800893:	c3                   	ret    
		return -E_NOT_SUPP;
  800894:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800899:	eb f4                	jmp    80088f <fstat+0x6c>

0080089b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80089b:	f3 0f 1e fb          	endbr32 
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	6a 00                	push   $0x0
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 3a 02 00 00       	call   800aeb <open>
  8008b1:	89 c3                	mov    %eax,%ebx
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	78 1b                	js     8008d5 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	50                   	push   %eax
  8008c1:	e8 5d ff ff ff       	call   800823 <fstat>
  8008c6:	89 c6                	mov    %eax,%esi
	close(fd);
  8008c8:	89 1c 24             	mov    %ebx,(%esp)
  8008cb:	e8 fd fb ff ff       	call   8004cd <close>
	return r;
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 f3                	mov    %esi,%ebx
}
  8008d5:	89 d8                	mov    %ebx,%eax
  8008d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	56                   	push   %esi
  8008e2:	53                   	push   %ebx
  8008e3:	89 c6                	mov    %eax,%esi
  8008e5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008e7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008ee:	74 27                	je     800917 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008f0:	6a 07                	push   $0x7
  8008f2:	68 00 50 80 00       	push   $0x805000
  8008f7:	56                   	push   %esi
  8008f8:	ff 35 00 40 80 00    	pushl  0x804000
  8008fe:	e8 c2 11 00 00       	call   801ac5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800903:	83 c4 0c             	add    $0xc,%esp
  800906:	6a 00                	push   $0x0
  800908:	53                   	push   %ebx
  800909:	6a 00                	push   $0x0
  80090b:	e8 48 11 00 00       	call   801a58 <ipc_recv>
}
  800910:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800917:	83 ec 0c             	sub    $0xc,%esp
  80091a:	6a 01                	push   $0x1
  80091c:	e8 fc 11 00 00       	call   801b1d <ipc_find_env>
  800921:	a3 00 40 80 00       	mov    %eax,0x804000
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	eb c5                	jmp    8008f0 <fsipc+0x12>

0080092b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80092b:	f3 0f 1e fb          	endbr32 
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 40 0c             	mov    0xc(%eax),%eax
  80093b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800948:	ba 00 00 00 00       	mov    $0x0,%edx
  80094d:	b8 02 00 00 00       	mov    $0x2,%eax
  800952:	e8 87 ff ff ff       	call   8008de <fsipc>
}
  800957:	c9                   	leave  
  800958:	c3                   	ret    

00800959 <devfile_flush>:
{
  800959:	f3 0f 1e fb          	endbr32 
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 40 0c             	mov    0xc(%eax),%eax
  800969:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	b8 06 00 00 00       	mov    $0x6,%eax
  800978:	e8 61 ff ff ff       	call   8008de <fsipc>
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <devfile_stat>:
{
  80097f:	f3 0f 1e fb          	endbr32 
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	53                   	push   %ebx
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 40 0c             	mov    0xc(%eax),%eax
  800993:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
  80099d:	b8 05 00 00 00       	mov    $0x5,%eax
  8009a2:	e8 37 ff ff ff       	call   8008de <fsipc>
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	78 2c                	js     8009d7 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	68 00 50 80 00       	push   $0x805000
  8009b3:	53                   	push   %ebx
  8009b4:	e8 2b 0d 00 00       	call   8016e4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009b9:	a1 80 50 80 00       	mov    0x805080,%eax
  8009be:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009c4:	a1 84 50 80 00       	mov    0x805084,%eax
  8009c9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <devfile_write>:
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8009f5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8009fb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a01:	77 30                	ja     800a33 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a03:	83 ec 04             	sub    $0x4,%esp
  800a06:	53                   	push   %ebx
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	68 08 50 80 00       	push   $0x805008
  800a0f:	e8 88 0e 00 00       	call   80189c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a14:	ba 00 00 00 00       	mov    $0x0,%edx
  800a19:	b8 04 00 00 00       	mov    $0x4,%eax
  800a1e:	e8 bb fe ff ff       	call   8008de <fsipc>
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	85 c0                	test   %eax,%eax
  800a28:	78 04                	js     800a2e <devfile_write+0x52>
	assert(r <= n);
  800a2a:	39 d8                	cmp    %ebx,%eax
  800a2c:	77 1e                	ja     800a4c <devfile_write+0x70>
}
  800a2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a33:	68 c8 1e 80 00       	push   $0x801ec8
  800a38:	68 f5 1e 80 00       	push   $0x801ef5
  800a3d:	68 94 00 00 00       	push   $0x94
  800a42:	68 0a 1f 80 00       	push   $0x801f0a
  800a47:	e8 47 06 00 00       	call   801093 <_panic>
	assert(r <= n);
  800a4c:	68 15 1f 80 00       	push   $0x801f15
  800a51:	68 f5 1e 80 00       	push   $0x801ef5
  800a56:	68 98 00 00 00       	push   $0x98
  800a5b:	68 0a 1f 80 00       	push   $0x801f0a
  800a60:	e8 2e 06 00 00       	call   801093 <_panic>

00800a65 <devfile_read>:
{
  800a65:	f3 0f 1e fb          	endbr32 
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	56                   	push   %esi
  800a6d:	53                   	push   %ebx
  800a6e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8b 40 0c             	mov    0xc(%eax),%eax
  800a77:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a7c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	e8 4d fe ff ff       	call   8008de <fsipc>
  800a91:	89 c3                	mov    %eax,%ebx
  800a93:	85 c0                	test   %eax,%eax
  800a95:	78 1f                	js     800ab6 <devfile_read+0x51>
	assert(r <= n);
  800a97:	39 f0                	cmp    %esi,%eax
  800a99:	77 24                	ja     800abf <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800a9b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa0:	7f 33                	jg     800ad5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	50                   	push   %eax
  800aa6:	68 00 50 80 00       	push   $0x805000
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	e8 e9 0d 00 00       	call   80189c <memmove>
	return r;
  800ab3:	83 c4 10             	add    $0x10,%esp
}
  800ab6:	89 d8                	mov    %ebx,%eax
  800ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    
	assert(r <= n);
  800abf:	68 15 1f 80 00       	push   $0x801f15
  800ac4:	68 f5 1e 80 00       	push   $0x801ef5
  800ac9:	6a 7c                	push   $0x7c
  800acb:	68 0a 1f 80 00       	push   $0x801f0a
  800ad0:	e8 be 05 00 00       	call   801093 <_panic>
	assert(r <= PGSIZE);
  800ad5:	68 1c 1f 80 00       	push   $0x801f1c
  800ada:	68 f5 1e 80 00       	push   $0x801ef5
  800adf:	6a 7d                	push   $0x7d
  800ae1:	68 0a 1f 80 00       	push   $0x801f0a
  800ae6:	e8 a8 05 00 00       	call   801093 <_panic>

00800aeb <open>:
{
  800aeb:	f3 0f 1e fb          	endbr32 
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 1c             	sub    $0x1c,%esp
  800af7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800afa:	56                   	push   %esi
  800afb:	e8 a1 0b 00 00       	call   8016a1 <strlen>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b08:	7f 6c                	jg     800b76 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b0a:	83 ec 0c             	sub    $0xc,%esp
  800b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 28 f8 ff ff       	call   80033e <fd_alloc>
  800b16:	89 c3                	mov    %eax,%ebx
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	85 c0                	test   %eax,%eax
  800b1d:	78 3c                	js     800b5b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	56                   	push   %esi
  800b23:	68 00 50 80 00       	push   $0x805000
  800b28:	e8 b7 0b 00 00       	call   8016e4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3d:	e8 9c fd ff ff       	call   8008de <fsipc>
  800b42:	89 c3                	mov    %eax,%ebx
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	85 c0                	test   %eax,%eax
  800b49:	78 19                	js     800b64 <open+0x79>
	return fd2num(fd);
  800b4b:	83 ec 0c             	sub    $0xc,%esp
  800b4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b51:	e8 b5 f7 ff ff       	call   80030b <fd2num>
  800b56:	89 c3                	mov    %eax,%ebx
  800b58:	83 c4 10             	add    $0x10,%esp
}
  800b5b:	89 d8                	mov    %ebx,%eax
  800b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    
		fd_close(fd, 0);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	6a 00                	push   $0x0
  800b69:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6c:	e8 d1 f8 ff ff       	call   800442 <fd_close>
		return r;
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	eb e5                	jmp    800b5b <open+0x70>
		return -E_BAD_PATH;
  800b76:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b7b:	eb de                	jmp    800b5b <open+0x70>

00800b7d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b7d:	f3 0f 1e fb          	endbr32 
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b91:	e8 48 fd ff ff       	call   8008de <fsipc>
}
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b98:	f3 0f 1e fb          	endbr32 
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ba4:	83 ec 0c             	sub    $0xc,%esp
  800ba7:	ff 75 08             	pushl  0x8(%ebp)
  800baa:	e8 70 f7 ff ff       	call   80031f <fd2data>
  800baf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb1:	83 c4 08             	add    $0x8,%esp
  800bb4:	68 28 1f 80 00       	push   $0x801f28
  800bb9:	53                   	push   %ebx
  800bba:	e8 25 0b 00 00       	call   8016e4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bbf:	8b 46 04             	mov    0x4(%esi),%eax
  800bc2:	2b 06                	sub    (%esi),%eax
  800bc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bca:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd1:	00 00 00 
	stat->st_dev = &devpipe;
  800bd4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bdb:	30 80 00 
	return 0;
}
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bea:	f3 0f 1e fb          	endbr32 
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	53                   	push   %ebx
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bf8:	53                   	push   %ebx
  800bf9:	6a 00                	push   $0x0
  800bfb:	e8 20 f6 ff ff       	call   800220 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c00:	89 1c 24             	mov    %ebx,(%esp)
  800c03:	e8 17 f7 ff ff       	call   80031f <fd2data>
  800c08:	83 c4 08             	add    $0x8,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 00                	push   $0x0
  800c0e:	e8 0d f6 ff ff       	call   800220 <sys_page_unmap>
}
  800c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <_pipeisclosed>:
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	57                   	push   %edi
  800c1c:	56                   	push   %esi
  800c1d:	53                   	push   %ebx
  800c1e:	83 ec 1c             	sub    $0x1c,%esp
  800c21:	89 c7                	mov    %eax,%edi
  800c23:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c25:	a1 04 40 80 00       	mov    0x804004,%eax
  800c2a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c2d:	83 ec 0c             	sub    $0xc,%esp
  800c30:	57                   	push   %edi
  800c31:	e8 24 0f 00 00       	call   801b5a <pageref>
  800c36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c39:	89 34 24             	mov    %esi,(%esp)
  800c3c:	e8 19 0f 00 00       	call   801b5a <pageref>
		nn = thisenv->env_runs;
  800c41:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c47:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	39 cb                	cmp    %ecx,%ebx
  800c4f:	74 1b                	je     800c6c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c51:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c54:	75 cf                	jne    800c25 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c56:	8b 42 58             	mov    0x58(%edx),%eax
  800c59:	6a 01                	push   $0x1
  800c5b:	50                   	push   %eax
  800c5c:	53                   	push   %ebx
  800c5d:	68 2f 1f 80 00       	push   $0x801f2f
  800c62:	e8 13 05 00 00       	call   80117a <cprintf>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	eb b9                	jmp    800c25 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c6c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c6f:	0f 94 c0             	sete   %al
  800c72:	0f b6 c0             	movzbl %al,%eax
}
  800c75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <devpipe_write>:
{
  800c7d:	f3 0f 1e fb          	endbr32 
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 28             	sub    $0x28,%esp
  800c8a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c8d:	56                   	push   %esi
  800c8e:	e8 8c f6 ff ff       	call   80031f <fd2data>
  800c93:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ca0:	74 4f                	je     800cf1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca2:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca5:	8b 0b                	mov    (%ebx),%ecx
  800ca7:	8d 51 20             	lea    0x20(%ecx),%edx
  800caa:	39 d0                	cmp    %edx,%eax
  800cac:	72 14                	jb     800cc2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cae:	89 da                	mov    %ebx,%edx
  800cb0:	89 f0                	mov    %esi,%eax
  800cb2:	e8 61 ff ff ff       	call   800c18 <_pipeisclosed>
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	75 3b                	jne    800cf6 <devpipe_write+0x79>
			sys_yield();
  800cbb:	e8 e3 f4 ff ff       	call   8001a3 <sys_yield>
  800cc0:	eb e0                	jmp    800ca2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	c1 fa 1f             	sar    $0x1f,%edx
  800cd1:	89 d1                	mov    %edx,%ecx
  800cd3:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd9:	83 e2 1f             	and    $0x1f,%edx
  800cdc:	29 ca                	sub    %ecx,%edx
  800cde:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce6:	83 c0 01             	add    $0x1,%eax
  800ce9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cec:	83 c7 01             	add    $0x1,%edi
  800cef:	eb ac                	jmp    800c9d <devpipe_write+0x20>
	return i;
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	eb 05                	jmp    800cfb <devpipe_write+0x7e>
				return 0;
  800cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <devpipe_read>:
{
  800d03:	f3 0f 1e fb          	endbr32 
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 18             	sub    $0x18,%esp
  800d10:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d13:	57                   	push   %edi
  800d14:	e8 06 f6 ff ff       	call   80031f <fd2data>
  800d19:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	be 00 00 00 00       	mov    $0x0,%esi
  800d23:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d26:	75 14                	jne    800d3c <devpipe_read+0x39>
	return i;
  800d28:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2b:	eb 02                	jmp    800d2f <devpipe_read+0x2c>
				return i;
  800d2d:	89 f0                	mov    %esi,%eax
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
			sys_yield();
  800d37:	e8 67 f4 ff ff       	call   8001a3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d3c:	8b 03                	mov    (%ebx),%eax
  800d3e:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d41:	75 18                	jne    800d5b <devpipe_read+0x58>
			if (i > 0)
  800d43:	85 f6                	test   %esi,%esi
  800d45:	75 e6                	jne    800d2d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d47:	89 da                	mov    %ebx,%edx
  800d49:	89 f8                	mov    %edi,%eax
  800d4b:	e8 c8 fe ff ff       	call   800c18 <_pipeisclosed>
  800d50:	85 c0                	test   %eax,%eax
  800d52:	74 e3                	je     800d37 <devpipe_read+0x34>
				return 0;
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
  800d59:	eb d4                	jmp    800d2f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d5b:	99                   	cltd   
  800d5c:	c1 ea 1b             	shr    $0x1b,%edx
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	83 e0 1f             	and    $0x1f,%eax
  800d64:	29 d0                	sub    %edx,%eax
  800d66:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d71:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d74:	83 c6 01             	add    $0x1,%esi
  800d77:	eb aa                	jmp    800d23 <devpipe_read+0x20>

00800d79 <pipe>:
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d88:	50                   	push   %eax
  800d89:	e8 b0 f5 ff ff       	call   80033e <fd_alloc>
  800d8e:	89 c3                	mov    %eax,%ebx
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	85 c0                	test   %eax,%eax
  800d95:	0f 88 23 01 00 00    	js     800ebe <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9b:	83 ec 04             	sub    $0x4,%esp
  800d9e:	68 07 04 00 00       	push   $0x407
  800da3:	ff 75 f4             	pushl  -0xc(%ebp)
  800da6:	6a 00                	push   $0x0
  800da8:	e8 21 f4 ff ff       	call   8001ce <sys_page_alloc>
  800dad:	89 c3                	mov    %eax,%ebx
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	85 c0                	test   %eax,%eax
  800db4:	0f 88 04 01 00 00    	js     800ebe <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc0:	50                   	push   %eax
  800dc1:	e8 78 f5 ff ff       	call   80033e <fd_alloc>
  800dc6:	89 c3                	mov    %eax,%ebx
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	0f 88 db 00 00 00    	js     800eae <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd3:	83 ec 04             	sub    $0x4,%esp
  800dd6:	68 07 04 00 00       	push   $0x407
  800ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dde:	6a 00                	push   $0x0
  800de0:	e8 e9 f3 ff ff       	call   8001ce <sys_page_alloc>
  800de5:	89 c3                	mov    %eax,%ebx
  800de7:	83 c4 10             	add    $0x10,%esp
  800dea:	85 c0                	test   %eax,%eax
  800dec:	0f 88 bc 00 00 00    	js     800eae <pipe+0x135>
	va = fd2data(fd0);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	ff 75 f4             	pushl  -0xc(%ebp)
  800df8:	e8 22 f5 ff ff       	call   80031f <fd2data>
  800dfd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dff:	83 c4 0c             	add    $0xc,%esp
  800e02:	68 07 04 00 00       	push   $0x407
  800e07:	50                   	push   %eax
  800e08:	6a 00                	push   $0x0
  800e0a:	e8 bf f3 ff ff       	call   8001ce <sys_page_alloc>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	0f 88 82 00 00 00    	js     800e9e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e22:	e8 f8 f4 ff ff       	call   80031f <fd2data>
  800e27:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e2e:	50                   	push   %eax
  800e2f:	6a 00                	push   $0x0
  800e31:	56                   	push   %esi
  800e32:	6a 00                	push   $0x0
  800e34:	e8 bd f3 ff ff       	call   8001f6 <sys_page_map>
  800e39:	89 c3                	mov    %eax,%ebx
  800e3b:	83 c4 20             	add    $0x20,%esp
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	78 4e                	js     800e90 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e42:	a1 20 30 80 00       	mov    0x803020,%eax
  800e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e59:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6b:	e8 9b f4 ff ff       	call   80030b <fd2num>
  800e70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e73:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e75:	83 c4 04             	add    $0x4,%esp
  800e78:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7b:	e8 8b f4 ff ff       	call   80030b <fd2num>
  800e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e83:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8e:	eb 2e                	jmp    800ebe <pipe+0x145>
	sys_page_unmap(0, va);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	56                   	push   %esi
  800e94:	6a 00                	push   $0x0
  800e96:	e8 85 f3 ff ff       	call   800220 <sys_page_unmap>
  800e9b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 75 f3 ff ff       	call   800220 <sys_page_unmap>
  800eab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb4:	6a 00                	push   $0x0
  800eb6:	e8 65 f3 ff ff       	call   800220 <sys_page_unmap>
  800ebb:	83 c4 10             	add    $0x10,%esp
}
  800ebe:	89 d8                	mov    %ebx,%eax
  800ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <pipeisclosed>:
{
  800ec7:	f3 0f 1e fb          	endbr32 
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed4:	50                   	push   %eax
  800ed5:	ff 75 08             	pushl  0x8(%ebp)
  800ed8:	e8 b7 f4 ff ff       	call   800394 <fd_lookup>
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	78 18                	js     800efc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  800eea:	e8 30 f4 ff ff       	call   80031f <fd2data>
  800eef:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef4:	e8 1f fd ff ff       	call   800c18 <_pipeisclosed>
  800ef9:	83 c4 10             	add    $0x10,%esp
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800efe:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
  800f07:	c3                   	ret    

00800f08 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f08:	f3 0f 1e fb          	endbr32 
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f12:	68 47 1f 80 00       	push   $0x801f47
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	e8 c5 07 00 00       	call   8016e4 <strcpy>
	return 0;
}
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <devcons_write>:
{
  800f26:	f3 0f 1e fb          	endbr32 
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f36:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f41:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f44:	73 31                	jae    800f77 <devcons_write+0x51>
		m = n - tot;
  800f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f49:	29 f3                	sub    %esi,%ebx
  800f4b:	83 fb 7f             	cmp    $0x7f,%ebx
  800f4e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f53:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	53                   	push   %ebx
  800f5a:	89 f0                	mov    %esi,%eax
  800f5c:	03 45 0c             	add    0xc(%ebp),%eax
  800f5f:	50                   	push   %eax
  800f60:	57                   	push   %edi
  800f61:	e8 36 09 00 00       	call   80189c <memmove>
		sys_cputs(buf, m);
  800f66:	83 c4 08             	add    $0x8,%esp
  800f69:	53                   	push   %ebx
  800f6a:	57                   	push   %edi
  800f6b:	e8 93 f1 ff ff       	call   800103 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f70:	01 de                	add    %ebx,%esi
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	eb ca                	jmp    800f41 <devcons_write+0x1b>
}
  800f77:	89 f0                	mov    %esi,%eax
  800f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <devcons_read>:
{
  800f81:	f3 0f 1e fb          	endbr32 
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	74 21                	je     800fb7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800f96:	e8 92 f1 ff ff       	call   80012d <sys_cgetc>
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	75 07                	jne    800fa6 <devcons_read+0x25>
		sys_yield();
  800f9f:	e8 ff f1 ff ff       	call   8001a3 <sys_yield>
  800fa4:	eb f0                	jmp    800f96 <devcons_read+0x15>
	if (c < 0)
  800fa6:	78 0f                	js     800fb7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fa8:	83 f8 04             	cmp    $0x4,%eax
  800fab:	74 0c                	je     800fb9 <devcons_read+0x38>
	*(char*)vbuf = c;
  800fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb0:	88 02                	mov    %al,(%edx)
	return 1;
  800fb2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    
		return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	eb f7                	jmp    800fb7 <devcons_read+0x36>

00800fc0 <cputchar>:
{
  800fc0:	f3 0f 1e fb          	endbr32 
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800fd0:	6a 01                	push   $0x1
  800fd2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fd5:	50                   	push   %eax
  800fd6:	e8 28 f1 ff ff       	call   800103 <sys_cputs>
}
  800fdb:	83 c4 10             	add    $0x10,%esp
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <getchar>:
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fea:	6a 01                	push   $0x1
  800fec:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fef:	50                   	push   %eax
  800ff0:	6a 00                	push   $0x0
  800ff2:	e8 20 f6 ff ff       	call   800617 <read>
	if (r < 0)
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	78 06                	js     801004 <getchar+0x24>
	if (r < 1)
  800ffe:	74 06                	je     801006 <getchar+0x26>
	return c;
  801000:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    
		return -E_EOF;
  801006:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80100b:	eb f7                	jmp    801004 <getchar+0x24>

0080100d <iscons>:
{
  80100d:	f3 0f 1e fb          	endbr32 
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801017:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101a:	50                   	push   %eax
  80101b:	ff 75 08             	pushl  0x8(%ebp)
  80101e:	e8 71 f3 ff ff       	call   800394 <fd_lookup>
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	78 11                	js     80103b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801033:	39 10                	cmp    %edx,(%eax)
  801035:	0f 94 c0             	sete   %al
  801038:	0f b6 c0             	movzbl %al,%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <opencons>:
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801047:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 ee f2 ff ff       	call   80033e <fd_alloc>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	85 c0                	test   %eax,%eax
  801055:	78 3a                	js     801091 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801057:	83 ec 04             	sub    $0x4,%esp
  80105a:	68 07 04 00 00       	push   $0x407
  80105f:	ff 75 f4             	pushl  -0xc(%ebp)
  801062:	6a 00                	push   $0x0
  801064:	e8 65 f1 ff ff       	call   8001ce <sys_page_alloc>
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 21                	js     801091 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801073:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801079:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80107b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	50                   	push   %eax
  801089:	e8 7d f2 ff ff       	call   80030b <fd2num>
  80108e:	83 c4 10             	add    $0x10,%esp
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801093:	f3 0f 1e fb          	endbr32 
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80109c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80109f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010a5:	e8 d1 f0 ff ff       	call   80017b <sys_getenvid>
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	ff 75 08             	pushl  0x8(%ebp)
  8010b3:	56                   	push   %esi
  8010b4:	50                   	push   %eax
  8010b5:	68 54 1f 80 00       	push   $0x801f54
  8010ba:	e8 bb 00 00 00       	call   80117a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010bf:	83 c4 18             	add    $0x18,%esp
  8010c2:	53                   	push   %ebx
  8010c3:	ff 75 10             	pushl  0x10(%ebp)
  8010c6:	e8 5a 00 00 00       	call   801125 <vcprintf>
	cprintf("\n");
  8010cb:	c7 04 24 9a 22 80 00 	movl   $0x80229a,(%esp)
  8010d2:	e8 a3 00 00 00       	call   80117a <cprintf>
  8010d7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010da:	cc                   	int3   
  8010db:	eb fd                	jmp    8010da <_panic+0x47>

008010dd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8010dd:	f3 0f 1e fb          	endbr32 
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 04             	sub    $0x4,%esp
  8010e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8010eb:	8b 13                	mov    (%ebx),%edx
  8010ed:	8d 42 01             	lea    0x1(%edx),%eax
  8010f0:	89 03                	mov    %eax,(%ebx)
  8010f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010fe:	74 09                	je     801109 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801100:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801107:	c9                   	leave  
  801108:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	68 ff 00 00 00       	push   $0xff
  801111:	8d 43 08             	lea    0x8(%ebx),%eax
  801114:	50                   	push   %eax
  801115:	e8 e9 ef ff ff       	call   800103 <sys_cputs>
		b->idx = 0;
  80111a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	eb db                	jmp    801100 <putch+0x23>

00801125 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801125:	f3 0f 1e fb          	endbr32 
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801132:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801139:	00 00 00 
	b.cnt = 0;
  80113c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801143:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801152:	50                   	push   %eax
  801153:	68 dd 10 80 00       	push   $0x8010dd
  801158:	e8 80 01 00 00       	call   8012dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80115d:	83 c4 08             	add    $0x8,%esp
  801160:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801166:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	e8 91 ef ff ff       	call   800103 <sys_cputs>

	return b.cnt;
}
  801172:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80117a:	f3 0f 1e fb          	endbr32 
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801184:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801187:	50                   	push   %eax
  801188:	ff 75 08             	pushl  0x8(%ebp)
  80118b:	e8 95 ff ff ff       	call   801125 <vcprintf>
	va_end(ap);

	return cnt;
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
  801198:	83 ec 1c             	sub    $0x1c,%esp
  80119b:	89 c7                	mov    %eax,%edi
  80119d:	89 d6                	mov    %edx,%esi
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a5:	89 d1                	mov    %edx,%ecx
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011bf:	39 c2                	cmp    %eax,%edx
  8011c1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011c4:	72 3e                	jb     801204 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	ff 75 18             	pushl  0x18(%ebp)
  8011cc:	83 eb 01             	sub    $0x1,%ebx
  8011cf:	53                   	push   %ebx
  8011d0:	50                   	push   %eax
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8011da:	ff 75 dc             	pushl  -0x24(%ebp)
  8011dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8011e0:	e8 bb 09 00 00       	call   801ba0 <__udivdi3>
  8011e5:	83 c4 18             	add    $0x18,%esp
  8011e8:	52                   	push   %edx
  8011e9:	50                   	push   %eax
  8011ea:	89 f2                	mov    %esi,%edx
  8011ec:	89 f8                	mov    %edi,%eax
  8011ee:	e8 9f ff ff ff       	call   801192 <printnum>
  8011f3:	83 c4 20             	add    $0x20,%esp
  8011f6:	eb 13                	jmp    80120b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	56                   	push   %esi
  8011fc:	ff 75 18             	pushl  0x18(%ebp)
  8011ff:	ff d7                	call   *%edi
  801201:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801204:	83 eb 01             	sub    $0x1,%ebx
  801207:	85 db                	test   %ebx,%ebx
  801209:	7f ed                	jg     8011f8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	56                   	push   %esi
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	ff 75 e4             	pushl  -0x1c(%ebp)
  801215:	ff 75 e0             	pushl  -0x20(%ebp)
  801218:	ff 75 dc             	pushl  -0x24(%ebp)
  80121b:	ff 75 d8             	pushl  -0x28(%ebp)
  80121e:	e8 8d 0a 00 00       	call   801cb0 <__umoddi3>
  801223:	83 c4 14             	add    $0x14,%esp
  801226:	0f be 80 77 1f 80 00 	movsbl 0x801f77(%eax),%eax
  80122d:	50                   	push   %eax
  80122e:	ff d7                	call   *%edi
}
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801236:	5b                   	pop    %ebx
  801237:	5e                   	pop    %esi
  801238:	5f                   	pop    %edi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80123b:	83 fa 01             	cmp    $0x1,%edx
  80123e:	7f 13                	jg     801253 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801240:	85 d2                	test   %edx,%edx
  801242:	74 1c                	je     801260 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801244:	8b 10                	mov    (%eax),%edx
  801246:	8d 4a 04             	lea    0x4(%edx),%ecx
  801249:	89 08                	mov    %ecx,(%eax)
  80124b:	8b 02                	mov    (%edx),%eax
  80124d:	ba 00 00 00 00       	mov    $0x0,%edx
  801252:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801253:	8b 10                	mov    (%eax),%edx
  801255:	8d 4a 08             	lea    0x8(%edx),%ecx
  801258:	89 08                	mov    %ecx,(%eax)
  80125a:	8b 02                	mov    (%edx),%eax
  80125c:	8b 52 04             	mov    0x4(%edx),%edx
  80125f:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801260:	8b 10                	mov    (%eax),%edx
  801262:	8d 4a 04             	lea    0x4(%edx),%ecx
  801265:	89 08                	mov    %ecx,(%eax)
  801267:	8b 02                	mov    (%edx),%eax
  801269:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80126e:	c3                   	ret    

0080126f <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80126f:	83 fa 01             	cmp    $0x1,%edx
  801272:	7f 0f                	jg     801283 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  801274:	85 d2                	test   %edx,%edx
  801276:	74 18                	je     801290 <getint+0x21>
		return va_arg(*ap, long);
  801278:	8b 10                	mov    (%eax),%edx
  80127a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80127d:	89 08                	mov    %ecx,(%eax)
  80127f:	8b 02                	mov    (%edx),%eax
  801281:	99                   	cltd   
  801282:	c3                   	ret    
		return va_arg(*ap, long long);
  801283:	8b 10                	mov    (%eax),%edx
  801285:	8d 4a 08             	lea    0x8(%edx),%ecx
  801288:	89 08                	mov    %ecx,(%eax)
  80128a:	8b 02                	mov    (%edx),%eax
  80128c:	8b 52 04             	mov    0x4(%edx),%edx
  80128f:	c3                   	ret    
	else
		return va_arg(*ap, int);
  801290:	8b 10                	mov    (%eax),%edx
  801292:	8d 4a 04             	lea    0x4(%edx),%ecx
  801295:	89 08                	mov    %ecx,(%eax)
  801297:	8b 02                	mov    (%edx),%eax
  801299:	99                   	cltd   
}
  80129a:	c3                   	ret    

0080129b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80129b:	f3 0f 1e fb          	endbr32 
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012a9:	8b 10                	mov    (%eax),%edx
  8012ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8012ae:	73 0a                	jae    8012ba <sprintputch+0x1f>
		*b->buf++ = ch;
  8012b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b3:	89 08                	mov    %ecx,(%eax)
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	88 02                	mov    %al,(%edx)
}
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <printfmt>:
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 10             	pushl  0x10(%ebp)
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 05 00 00 00       	call   8012dd <vprintfmt>
}
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <vprintfmt>:
{
  8012dd:	f3 0f 1e fb          	endbr32 
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	57                   	push   %edi
  8012e5:	56                   	push   %esi
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 2c             	sub    $0x2c,%esp
  8012ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8012f3:	e9 86 02 00 00       	jmp    80157e <vprintfmt+0x2a1>
		padc = ' ';
  8012f8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8012fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801303:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80130a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801311:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801316:	8d 47 01             	lea    0x1(%edi),%eax
  801319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80131c:	0f b6 17             	movzbl (%edi),%edx
  80131f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801322:	3c 55                	cmp    $0x55,%al
  801324:	0f 87 df 02 00 00    	ja     801609 <vprintfmt+0x32c>
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  801334:	00 
  801335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801338:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80133c:	eb d8                	jmp    801316 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80133e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801341:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801345:	eb cf                	jmp    801316 <vprintfmt+0x39>
  801347:	0f b6 d2             	movzbl %dl,%edx
  80134a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801355:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801358:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80135c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80135f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801362:	83 f9 09             	cmp    $0x9,%ecx
  801365:	77 52                	ja     8013b9 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801367:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80136a:	eb e9                	jmp    801355 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	8d 50 04             	lea    0x4(%eax),%edx
  801372:	89 55 14             	mov    %edx,0x14(%ebp)
  801375:	8b 00                	mov    (%eax),%eax
  801377:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80137a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80137d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801381:	79 93                	jns    801316 <vprintfmt+0x39>
				width = precision, precision = -1;
  801383:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801386:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801389:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801390:	eb 84                	jmp    801316 <vprintfmt+0x39>
  801392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801395:	85 c0                	test   %eax,%eax
  801397:	ba 00 00 00 00       	mov    $0x0,%edx
  80139c:	0f 49 d0             	cmovns %eax,%edx
  80139f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013a5:	e9 6c ff ff ff       	jmp    801316 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013ad:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013b4:	e9 5d ff ff ff       	jmp    801316 <vprintfmt+0x39>
  8013b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013bc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013bf:	eb bc                	jmp    80137d <vprintfmt+0xa0>
			lflag++;
  8013c1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013c7:	e9 4a ff ff ff       	jmp    801316 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	8d 50 04             	lea    0x4(%eax),%edx
  8013d2:	89 55 14             	mov    %edx,0x14(%ebp)
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	56                   	push   %esi
  8013d9:	ff 30                	pushl  (%eax)
  8013db:	ff d3                	call   *%ebx
			break;
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	e9 96 01 00 00       	jmp    80157b <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	8d 50 04             	lea    0x4(%eax),%edx
  8013eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8013ee:	8b 00                	mov    (%eax),%eax
  8013f0:	99                   	cltd   
  8013f1:	31 d0                	xor    %edx,%eax
  8013f3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013f5:	83 f8 0f             	cmp    $0xf,%eax
  8013f8:	7f 20                	jg     80141a <vprintfmt+0x13d>
  8013fa:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  801401:	85 d2                	test   %edx,%edx
  801403:	74 15                	je     80141a <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801405:	52                   	push   %edx
  801406:	68 07 1f 80 00       	push   $0x801f07
  80140b:	56                   	push   %esi
  80140c:	53                   	push   %ebx
  80140d:	e8 aa fe ff ff       	call   8012bc <printfmt>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	e9 61 01 00 00       	jmp    80157b <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80141a:	50                   	push   %eax
  80141b:	68 8f 1f 80 00       	push   $0x801f8f
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	e8 95 fe ff ff       	call   8012bc <printfmt>
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	e9 4c 01 00 00       	jmp    80157b <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80142f:	8b 45 14             	mov    0x14(%ebp),%eax
  801432:	8d 50 04             	lea    0x4(%eax),%edx
  801435:	89 55 14             	mov    %edx,0x14(%ebp)
  801438:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80143a:	85 c9                	test   %ecx,%ecx
  80143c:	b8 88 1f 80 00       	mov    $0x801f88,%eax
  801441:	0f 45 c1             	cmovne %ecx,%eax
  801444:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801447:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80144b:	7e 06                	jle    801453 <vprintfmt+0x176>
  80144d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801451:	75 0d                	jne    801460 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801453:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801456:	89 c7                	mov    %eax,%edi
  801458:	03 45 e0             	add    -0x20(%ebp),%eax
  80145b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80145e:	eb 57                	jmp    8014b7 <vprintfmt+0x1da>
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	ff 75 d8             	pushl  -0x28(%ebp)
  801466:	ff 75 cc             	pushl  -0x34(%ebp)
  801469:	e8 4f 02 00 00       	call   8016bd <strnlen>
  80146e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801471:	29 c2                	sub    %eax,%edx
  801473:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801476:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801479:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80147d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  801480:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  801482:	85 db                	test   %ebx,%ebx
  801484:	7e 10                	jle    801496 <vprintfmt+0x1b9>
					putch(padc, putdat);
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	56                   	push   %esi
  80148a:	57                   	push   %edi
  80148b:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80148e:	83 eb 01             	sub    $0x1,%ebx
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	eb ec                	jmp    801482 <vprintfmt+0x1a5>
  801496:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801499:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149c:	85 d2                	test   %edx,%edx
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a3:	0f 49 c2             	cmovns %edx,%eax
  8014a6:	29 c2                	sub    %eax,%edx
  8014a8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014ab:	eb a6                	jmp    801453 <vprintfmt+0x176>
					putch(ch, putdat);
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	56                   	push   %esi
  8014b1:	52                   	push   %edx
  8014b2:	ff d3                	call   *%ebx
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014ba:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014bc:	83 c7 01             	add    $0x1,%edi
  8014bf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014c3:	0f be d0             	movsbl %al,%edx
  8014c6:	85 d2                	test   %edx,%edx
  8014c8:	74 42                	je     80150c <vprintfmt+0x22f>
  8014ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014ce:	78 06                	js     8014d6 <vprintfmt+0x1f9>
  8014d0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014d4:	78 1e                	js     8014f4 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  8014d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014da:	74 d1                	je     8014ad <vprintfmt+0x1d0>
  8014dc:	0f be c0             	movsbl %al,%eax
  8014df:	83 e8 20             	sub    $0x20,%eax
  8014e2:	83 f8 5e             	cmp    $0x5e,%eax
  8014e5:	76 c6                	jbe    8014ad <vprintfmt+0x1d0>
					putch('?', putdat);
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	56                   	push   %esi
  8014eb:	6a 3f                	push   $0x3f
  8014ed:	ff d3                	call   *%ebx
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	eb c3                	jmp    8014b7 <vprintfmt+0x1da>
  8014f4:	89 cf                	mov    %ecx,%edi
  8014f6:	eb 0e                	jmp    801506 <vprintfmt+0x229>
				putch(' ', putdat);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	56                   	push   %esi
  8014fc:	6a 20                	push   $0x20
  8014fe:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  801500:	83 ef 01             	sub    $0x1,%edi
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 ff                	test   %edi,%edi
  801508:	7f ee                	jg     8014f8 <vprintfmt+0x21b>
  80150a:	eb 6f                	jmp    80157b <vprintfmt+0x29e>
  80150c:	89 cf                	mov    %ecx,%edi
  80150e:	eb f6                	jmp    801506 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801510:	89 ca                	mov    %ecx,%edx
  801512:	8d 45 14             	lea    0x14(%ebp),%eax
  801515:	e8 55 fd ff ff       	call   80126f <getint>
  80151a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80151d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801520:	85 d2                	test   %edx,%edx
  801522:	78 0b                	js     80152f <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801524:	89 d1                	mov    %edx,%ecx
  801526:	89 c2                	mov    %eax,%edx
			base = 10;
  801528:	b8 0a 00 00 00       	mov    $0xa,%eax
  80152d:	eb 32                	jmp    801561 <vprintfmt+0x284>
				putch('-', putdat);
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	56                   	push   %esi
  801533:	6a 2d                	push   $0x2d
  801535:	ff d3                	call   *%ebx
				num = -(long long) num;
  801537:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80153a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80153d:	f7 da                	neg    %edx
  80153f:	83 d1 00             	adc    $0x0,%ecx
  801542:	f7 d9                	neg    %ecx
  801544:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801547:	b8 0a 00 00 00       	mov    $0xa,%eax
  80154c:	eb 13                	jmp    801561 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80154e:	89 ca                	mov    %ecx,%edx
  801550:	8d 45 14             	lea    0x14(%ebp),%eax
  801553:	e8 e3 fc ff ff       	call   80123b <getuint>
  801558:	89 d1                	mov    %edx,%ecx
  80155a:	89 c2                	mov    %eax,%edx
			base = 10;
  80155c:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801568:	57                   	push   %edi
  801569:	ff 75 e0             	pushl  -0x20(%ebp)
  80156c:	50                   	push   %eax
  80156d:	51                   	push   %ecx
  80156e:	52                   	push   %edx
  80156f:	89 f2                	mov    %esi,%edx
  801571:	89 d8                	mov    %ebx,%eax
  801573:	e8 1a fc ff ff       	call   801192 <printnum>
			break;
  801578:	83 c4 20             	add    $0x20,%esp
{
  80157b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80157e:	83 c7 01             	add    $0x1,%edi
  801581:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801585:	83 f8 25             	cmp    $0x25,%eax
  801588:	0f 84 6a fd ff ff    	je     8012f8 <vprintfmt+0x1b>
			if (ch == '\0')
  80158e:	85 c0                	test   %eax,%eax
  801590:	0f 84 93 00 00 00    	je     801629 <vprintfmt+0x34c>
			putch(ch, putdat);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	56                   	push   %esi
  80159a:	50                   	push   %eax
  80159b:	ff d3                	call   *%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	eb dc                	jmp    80157e <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8015a2:	89 ca                	mov    %ecx,%edx
  8015a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8015a7:	e8 8f fc ff ff       	call   80123b <getuint>
  8015ac:	89 d1                	mov    %edx,%ecx
  8015ae:	89 c2                	mov    %eax,%edx
			base = 8;
  8015b0:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015b5:	eb aa                	jmp    801561 <vprintfmt+0x284>
			putch('0', putdat);
  8015b7:	83 ec 08             	sub    $0x8,%esp
  8015ba:	56                   	push   %esi
  8015bb:	6a 30                	push   $0x30
  8015bd:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015bf:	83 c4 08             	add    $0x8,%esp
  8015c2:	56                   	push   %esi
  8015c3:	6a 78                	push   $0x78
  8015c5:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8d 50 04             	lea    0x4(%eax),%edx
  8015cd:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  8015d0:	8b 10                	mov    (%eax),%edx
  8015d2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8015d7:	83 c4 10             	add    $0x10,%esp
			base = 16;
  8015da:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8015df:	eb 80                	jmp    801561 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  8015e1:	89 ca                	mov    %ecx,%edx
  8015e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8015e6:	e8 50 fc ff ff       	call   80123b <getuint>
  8015eb:	89 d1                	mov    %edx,%ecx
  8015ed:	89 c2                	mov    %eax,%edx
			base = 16;
  8015ef:	b8 10 00 00 00       	mov    $0x10,%eax
  8015f4:	e9 68 ff ff ff       	jmp    801561 <vprintfmt+0x284>
			putch(ch, putdat);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	56                   	push   %esi
  8015fd:	6a 25                	push   $0x25
  8015ff:	ff d3                	call   *%ebx
			break;
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	e9 72 ff ff ff       	jmp    80157b <vprintfmt+0x29e>
			putch('%', putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	56                   	push   %esi
  80160d:	6a 25                	push   $0x25
  80160f:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	89 f8                	mov    %edi,%eax
  801616:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80161a:	74 05                	je     801621 <vprintfmt+0x344>
  80161c:	83 e8 01             	sub    $0x1,%eax
  80161f:	eb f5                	jmp    801616 <vprintfmt+0x339>
  801621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801624:	e9 52 ff ff ff       	jmp    80157b <vprintfmt+0x29e>
}
  801629:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801631:	f3 0f 1e fb          	endbr32 
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 18             	sub    $0x18,%esp
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801641:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801644:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801648:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80164b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801652:	85 c0                	test   %eax,%eax
  801654:	74 26                	je     80167c <vsnprintf+0x4b>
  801656:	85 d2                	test   %edx,%edx
  801658:	7e 22                	jle    80167c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80165a:	ff 75 14             	pushl  0x14(%ebp)
  80165d:	ff 75 10             	pushl  0x10(%ebp)
  801660:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801663:	50                   	push   %eax
  801664:	68 9b 12 80 00       	push   $0x80129b
  801669:	e8 6f fc ff ff       	call   8012dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80166e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801671:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	83 c4 10             	add    $0x10,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
		return -E_INVAL;
  80167c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801681:	eb f7                	jmp    80167a <vsnprintf+0x49>

00801683 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801683:	f3 0f 1e fb          	endbr32 
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80168d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801690:	50                   	push   %eax
  801691:	ff 75 10             	pushl  0x10(%ebp)
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 92 ff ff ff       	call   801631 <vsnprintf>
	va_end(ap);

	return rc;
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016a1:	f3 0f 1e fb          	endbr32 
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016b4:	74 05                	je     8016bb <strlen+0x1a>
		n++;
  8016b6:	83 c0 01             	add    $0x1,%eax
  8016b9:	eb f5                	jmp    8016b0 <strlen+0xf>
	return n;
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016bd:	f3 0f 1e fb          	endbr32 
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	39 d0                	cmp    %edx,%eax
  8016d1:	74 0d                	je     8016e0 <strnlen+0x23>
  8016d3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016d7:	74 05                	je     8016de <strnlen+0x21>
		n++;
  8016d9:	83 c0 01             	add    $0x1,%eax
  8016dc:	eb f1                	jmp    8016cf <strnlen+0x12>
  8016de:	89 c2                	mov    %eax,%edx
	return n;
}
  8016e0:	89 d0                	mov    %edx,%eax
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    

008016e4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016e4:	f3 0f 1e fb          	endbr32 
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	53                   	push   %ebx
  8016ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8016fb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8016fe:	83 c0 01             	add    $0x1,%eax
  801701:	84 d2                	test   %dl,%dl
  801703:	75 f2                	jne    8016f7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801705:	89 c8                	mov    %ecx,%eax
  801707:	5b                   	pop    %ebx
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80170a:	f3 0f 1e fb          	endbr32 
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	53                   	push   %ebx
  801712:	83 ec 10             	sub    $0x10,%esp
  801715:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801718:	53                   	push   %ebx
  801719:	e8 83 ff ff ff       	call   8016a1 <strlen>
  80171e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	01 d8                	add    %ebx,%eax
  801726:	50                   	push   %eax
  801727:	e8 b8 ff ff ff       	call   8016e4 <strcpy>
	return dst;
}
  80172c:	89 d8                	mov    %ebx,%eax
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801733:	f3 0f 1e fb          	endbr32 
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
  80173c:	8b 75 08             	mov    0x8(%ebp),%esi
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	89 f3                	mov    %esi,%ebx
  801744:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801747:	89 f0                	mov    %esi,%eax
  801749:	39 d8                	cmp    %ebx,%eax
  80174b:	74 11                	je     80175e <strncpy+0x2b>
		*dst++ = *src;
  80174d:	83 c0 01             	add    $0x1,%eax
  801750:	0f b6 0a             	movzbl (%edx),%ecx
  801753:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801756:	80 f9 01             	cmp    $0x1,%cl
  801759:	83 da ff             	sbb    $0xffffffff,%edx
  80175c:	eb eb                	jmp    801749 <strncpy+0x16>
	}
	return ret;
}
  80175e:	89 f0                	mov    %esi,%eax
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801764:	f3 0f 1e fb          	endbr32 
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	8b 75 08             	mov    0x8(%ebp),%esi
  801770:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801773:	8b 55 10             	mov    0x10(%ebp),%edx
  801776:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801778:	85 d2                	test   %edx,%edx
  80177a:	74 21                	je     80179d <strlcpy+0x39>
  80177c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801780:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801782:	39 c2                	cmp    %eax,%edx
  801784:	74 14                	je     80179a <strlcpy+0x36>
  801786:	0f b6 19             	movzbl (%ecx),%ebx
  801789:	84 db                	test   %bl,%bl
  80178b:	74 0b                	je     801798 <strlcpy+0x34>
			*dst++ = *src++;
  80178d:	83 c1 01             	add    $0x1,%ecx
  801790:	83 c2 01             	add    $0x1,%edx
  801793:	88 5a ff             	mov    %bl,-0x1(%edx)
  801796:	eb ea                	jmp    801782 <strlcpy+0x1e>
  801798:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80179a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80179d:	29 f0                	sub    %esi,%eax
}
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017a3:	f3 0f 1e fb          	endbr32 
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017b0:	0f b6 01             	movzbl (%ecx),%eax
  8017b3:	84 c0                	test   %al,%al
  8017b5:	74 0c                	je     8017c3 <strcmp+0x20>
  8017b7:	3a 02                	cmp    (%edx),%al
  8017b9:	75 08                	jne    8017c3 <strcmp+0x20>
		p++, q++;
  8017bb:	83 c1 01             	add    $0x1,%ecx
  8017be:	83 c2 01             	add    $0x1,%edx
  8017c1:	eb ed                	jmp    8017b0 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c3:	0f b6 c0             	movzbl %al,%eax
  8017c6:	0f b6 12             	movzbl (%edx),%edx
  8017c9:	29 d0                	sub    %edx,%eax
}
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017cd:	f3 0f 1e fb          	endbr32 
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	53                   	push   %ebx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017db:	89 c3                	mov    %eax,%ebx
  8017dd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017e0:	eb 06                	jmp    8017e8 <strncmp+0x1b>
		n--, p++, q++;
  8017e2:	83 c0 01             	add    $0x1,%eax
  8017e5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017e8:	39 d8                	cmp    %ebx,%eax
  8017ea:	74 16                	je     801802 <strncmp+0x35>
  8017ec:	0f b6 08             	movzbl (%eax),%ecx
  8017ef:	84 c9                	test   %cl,%cl
  8017f1:	74 04                	je     8017f7 <strncmp+0x2a>
  8017f3:	3a 0a                	cmp    (%edx),%cl
  8017f5:	74 eb                	je     8017e2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017f7:	0f b6 00             	movzbl (%eax),%eax
  8017fa:	0f b6 12             	movzbl (%edx),%edx
  8017fd:	29 d0                	sub    %edx,%eax
}
  8017ff:	5b                   	pop    %ebx
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    
		return 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb f6                	jmp    8017ff <strncmp+0x32>

00801809 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801809:	f3 0f 1e fb          	endbr32 
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801817:	0f b6 10             	movzbl (%eax),%edx
  80181a:	84 d2                	test   %dl,%dl
  80181c:	74 09                	je     801827 <strchr+0x1e>
		if (*s == c)
  80181e:	38 ca                	cmp    %cl,%dl
  801820:	74 0a                	je     80182c <strchr+0x23>
	for (; *s; s++)
  801822:	83 c0 01             	add    $0x1,%eax
  801825:	eb f0                	jmp    801817 <strchr+0xe>
			return (char *) s;
	return 0;
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    

0080182e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80182e:	f3 0f 1e fb          	endbr32 
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80183c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80183f:	38 ca                	cmp    %cl,%dl
  801841:	74 09                	je     80184c <strfind+0x1e>
  801843:	84 d2                	test   %dl,%dl
  801845:	74 05                	je     80184c <strfind+0x1e>
	for (; *s; s++)
  801847:	83 c0 01             	add    $0x1,%eax
  80184a:	eb f0                	jmp    80183c <strfind+0xe>
			break;
	return (char *) s;
}
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    

0080184e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80184e:	f3 0f 1e fb          	endbr32 
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	57                   	push   %edi
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	8b 55 08             	mov    0x8(%ebp),%edx
  80185b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80185e:	85 c9                	test   %ecx,%ecx
  801860:	74 33                	je     801895 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801862:	89 d0                	mov    %edx,%eax
  801864:	09 c8                	or     %ecx,%eax
  801866:	a8 03                	test   $0x3,%al
  801868:	75 23                	jne    80188d <memset+0x3f>
		c &= 0xFF;
  80186a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80186e:	89 d8                	mov    %ebx,%eax
  801870:	c1 e0 08             	shl    $0x8,%eax
  801873:	89 df                	mov    %ebx,%edi
  801875:	c1 e7 18             	shl    $0x18,%edi
  801878:	89 de                	mov    %ebx,%esi
  80187a:	c1 e6 10             	shl    $0x10,%esi
  80187d:	09 f7                	or     %esi,%edi
  80187f:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801881:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801884:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  801886:	89 d7                	mov    %edx,%edi
  801888:	fc                   	cld    
  801889:	f3 ab                	rep stos %eax,%es:(%edi)
  80188b:	eb 08                	jmp    801895 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80188d:	89 d7                	mov    %edx,%edi
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	fc                   	cld    
  801893:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  801895:	89 d0                	mov    %edx,%eax
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5f                   	pop    %edi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80189c:	f3 0f 1e fb          	endbr32 
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018ae:	39 c6                	cmp    %eax,%esi
  8018b0:	73 32                	jae    8018e4 <memmove+0x48>
  8018b2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018b5:	39 c2                	cmp    %eax,%edx
  8018b7:	76 2b                	jbe    8018e4 <memmove+0x48>
		s += n;
		d += n;
  8018b9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018bc:	89 fe                	mov    %edi,%esi
  8018be:	09 ce                	or     %ecx,%esi
  8018c0:	09 d6                	or     %edx,%esi
  8018c2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018c8:	75 0e                	jne    8018d8 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018ca:	83 ef 04             	sub    $0x4,%edi
  8018cd:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018d0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018d3:	fd                   	std    
  8018d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018d6:	eb 09                	jmp    8018e1 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018d8:	83 ef 01             	sub    $0x1,%edi
  8018db:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018de:	fd                   	std    
  8018df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018e1:	fc                   	cld    
  8018e2:	eb 1a                	jmp    8018fe <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018e4:	89 c2                	mov    %eax,%edx
  8018e6:	09 ca                	or     %ecx,%edx
  8018e8:	09 f2                	or     %esi,%edx
  8018ea:	f6 c2 03             	test   $0x3,%dl
  8018ed:	75 0a                	jne    8018f9 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018ef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018f2:	89 c7                	mov    %eax,%edi
  8018f4:	fc                   	cld    
  8018f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018f7:	eb 05                	jmp    8018fe <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8018f9:	89 c7                	mov    %eax,%edi
  8018fb:	fc                   	cld    
  8018fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018fe:	5e                   	pop    %esi
  8018ff:	5f                   	pop    %edi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801902:	f3 0f 1e fb          	endbr32 
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 82 ff ff ff       	call   80189c <memmove>
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80191c:	f3 0f 1e fb          	endbr32 
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	89 c6                	mov    %eax,%esi
  80192d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801930:	39 f0                	cmp    %esi,%eax
  801932:	74 1c                	je     801950 <memcmp+0x34>
		if (*s1 != *s2)
  801934:	0f b6 08             	movzbl (%eax),%ecx
  801937:	0f b6 1a             	movzbl (%edx),%ebx
  80193a:	38 d9                	cmp    %bl,%cl
  80193c:	75 08                	jne    801946 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80193e:	83 c0 01             	add    $0x1,%eax
  801941:	83 c2 01             	add    $0x1,%edx
  801944:	eb ea                	jmp    801930 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801946:	0f b6 c1             	movzbl %cl,%eax
  801949:	0f b6 db             	movzbl %bl,%ebx
  80194c:	29 d8                	sub    %ebx,%eax
  80194e:	eb 05                	jmp    801955 <memcmp+0x39>
	}

	return 0;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801959:	f3 0f 1e fb          	endbr32 
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801966:	89 c2                	mov    %eax,%edx
  801968:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80196b:	39 d0                	cmp    %edx,%eax
  80196d:	73 09                	jae    801978 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196f:	38 08                	cmp    %cl,(%eax)
  801971:	74 05                	je     801978 <memfind+0x1f>
	for (; s < ends; s++)
  801973:	83 c0 01             	add    $0x1,%eax
  801976:	eb f3                	jmp    80196b <memfind+0x12>
			break;
	return (void *) s;
}
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80197a:	f3 0f 1e fb          	endbr32 
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801987:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80198a:	eb 03                	jmp    80198f <strtol+0x15>
		s++;
  80198c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80198f:	0f b6 01             	movzbl (%ecx),%eax
  801992:	3c 20                	cmp    $0x20,%al
  801994:	74 f6                	je     80198c <strtol+0x12>
  801996:	3c 09                	cmp    $0x9,%al
  801998:	74 f2                	je     80198c <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80199a:	3c 2b                	cmp    $0x2b,%al
  80199c:	74 2a                	je     8019c8 <strtol+0x4e>
	int neg = 0;
  80199e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8019a3:	3c 2d                	cmp    $0x2d,%al
  8019a5:	74 2b                	je     8019d2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019a7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019ad:	75 0f                	jne    8019be <strtol+0x44>
  8019af:	80 39 30             	cmpb   $0x30,(%ecx)
  8019b2:	74 28                	je     8019dc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019b4:	85 db                	test   %ebx,%ebx
  8019b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019bb:	0f 44 d8             	cmove  %eax,%ebx
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019c6:	eb 46                	jmp    801a0e <strtol+0x94>
		s++;
  8019c8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d0:	eb d5                	jmp    8019a7 <strtol+0x2d>
		s++, neg = 1;
  8019d2:	83 c1 01             	add    $0x1,%ecx
  8019d5:	bf 01 00 00 00       	mov    $0x1,%edi
  8019da:	eb cb                	jmp    8019a7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019dc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019e0:	74 0e                	je     8019f0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019e2:	85 db                	test   %ebx,%ebx
  8019e4:	75 d8                	jne    8019be <strtol+0x44>
		s++, base = 8;
  8019e6:	83 c1 01             	add    $0x1,%ecx
  8019e9:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019ee:	eb ce                	jmp    8019be <strtol+0x44>
		s += 2, base = 16;
  8019f0:	83 c1 02             	add    $0x2,%ecx
  8019f3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019f8:	eb c4                	jmp    8019be <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8019fa:	0f be d2             	movsbl %dl,%edx
  8019fd:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801a00:	3b 55 10             	cmp    0x10(%ebp),%edx
  801a03:	7d 3a                	jge    801a3f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801a05:	83 c1 01             	add    $0x1,%ecx
  801a08:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a0c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a0e:	0f b6 11             	movzbl (%ecx),%edx
  801a11:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a14:	89 f3                	mov    %esi,%ebx
  801a16:	80 fb 09             	cmp    $0x9,%bl
  801a19:	76 df                	jbe    8019fa <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a1b:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a1e:	89 f3                	mov    %esi,%ebx
  801a20:	80 fb 19             	cmp    $0x19,%bl
  801a23:	77 08                	ja     801a2d <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a25:	0f be d2             	movsbl %dl,%edx
  801a28:	83 ea 57             	sub    $0x57,%edx
  801a2b:	eb d3                	jmp    801a00 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a2d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a30:	89 f3                	mov    %esi,%ebx
  801a32:	80 fb 19             	cmp    $0x19,%bl
  801a35:	77 08                	ja     801a3f <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a37:	0f be d2             	movsbl %dl,%edx
  801a3a:	83 ea 37             	sub    $0x37,%edx
  801a3d:	eb c1                	jmp    801a00 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a43:	74 05                	je     801a4a <strtol+0xd0>
		*endptr = (char *) s;
  801a45:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a48:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a4a:	89 c2                	mov    %eax,%edx
  801a4c:	f7 da                	neg    %edx
  801a4e:	85 ff                	test   %edi,%edi
  801a50:	0f 45 c2             	cmovne %edx,%eax
}
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a58:	f3 0f 1e fb          	endbr32 
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
  801a61:	8b 75 08             	mov    0x8(%ebp),%esi
  801a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a71:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801a74:	83 ec 0c             	sub    $0xc,%esp
  801a77:	50                   	push   %eax
  801a78:	e8 68 e8 ff ff       	call   8002e5 <sys_ipc_recv>
	if (r < 0) {
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 2b                	js     801aaf <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801a84:	85 f6                	test   %esi,%esi
  801a86:	74 0a                	je     801a92 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801a88:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8d:	8b 40 74             	mov    0x74(%eax),%eax
  801a90:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801a92:	85 db                	test   %ebx,%ebx
  801a94:	74 0a                	je     801aa0 <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801a96:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9b:	8b 40 78             	mov    0x78(%eax),%eax
  801a9e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801aa0:	a1 04 40 80 00       	mov    0x804004,%eax
  801aa5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
		if (from_env_store) {
  801aaf:	85 f6                	test   %esi,%esi
  801ab1:	74 06                	je     801ab9 <ipc_recv+0x61>
			*from_env_store = 0;
  801ab3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801ab9:	85 db                	test   %ebx,%ebx
  801abb:	74 eb                	je     801aa8 <ipc_recv+0x50>
			*perm_store = 0;
  801abd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ac3:	eb e3                	jmp    801aa8 <ipc_recv+0x50>

00801ac5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ac5:	f3 0f 1e fb          	endbr32 
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	57                   	push   %edi
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ad8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801adb:	85 db                	test   %ebx,%ebx
  801add:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ae2:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801ae5:	ff 75 14             	pushl  0x14(%ebp)
  801ae8:	53                   	push   %ebx
  801ae9:	56                   	push   %esi
  801aea:	57                   	push   %edi
  801aeb:	e8 cc e7 ff ff       	call   8002bc <sys_ipc_try_send>
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801af6:	75 07                	jne    801aff <ipc_send+0x3a>
		sys_yield();
  801af8:	e8 a6 e6 ff ff       	call   8001a3 <sys_yield>
  801afd:	eb e6                	jmp    801ae5 <ipc_send+0x20>
	}

	if (ret < 0) {
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 08                	js     801b0b <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5f                   	pop    %edi
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801b0b:	50                   	push   %eax
  801b0c:	68 7f 22 80 00       	push   $0x80227f
  801b11:	6a 48                	push   $0x48
  801b13:	68 9c 22 80 00       	push   $0x80229c
  801b18:	e8 76 f5 ff ff       	call   801093 <_panic>

00801b1d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b1d:	f3 0f 1e fb          	endbr32 
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b27:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b2c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b2f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b35:	8b 52 50             	mov    0x50(%edx),%edx
  801b38:	39 ca                	cmp    %ecx,%edx
  801b3a:	74 11                	je     801b4d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801b3c:	83 c0 01             	add    $0x1,%eax
  801b3f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b44:	75 e6                	jne    801b2c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801b46:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4b:	eb 0b                	jmp    801b58 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801b4d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b50:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b55:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b5a:	f3 0f 1e fb          	endbr32 
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b64:	89 c2                	mov    %eax,%edx
  801b66:	c1 ea 16             	shr    $0x16,%edx
  801b69:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801b75:	f6 c1 01             	test   $0x1,%cl
  801b78:	74 1c                	je     801b96 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801b7a:	c1 e8 0c             	shr    $0xc,%eax
  801b7d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801b84:	a8 01                	test   $0x1,%al
  801b86:	74 0e                	je     801b96 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b88:	c1 e8 0c             	shr    $0xc,%eax
  801b8b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801b92:	ef 
  801b93:	0f b7 d2             	movzwl %dx,%edx
}
  801b96:	89 d0                	mov    %edx,%eax
  801b98:	5d                   	pop    %ebp
  801b99:	c3                   	ret    
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	66 90                	xchg   %ax,%ax
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
