
obj/user/faultnostack.debug:     formato del fichero elf32-i386


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
  80002c:	e8 27 00 00 00       	call   800058 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003d:	68 15 03 80 00       	push   $0x800315
  800042:	6a 00                	push   $0x0
  800044:	e8 56 02 00 00       	call   80029f <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800049:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800050:	00 00 00 
}
  800053:	83 c4 10             	add    $0x10,%esp
  800056:	c9                   	leave  
  800057:	c3                   	ret    

00800058 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800058:	f3 0f 1e fb          	endbr32 
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800067:	e8 19 01 00 00       	call   800185 <sys_getenvid>
	if (id >= 0)
  80006c:	85 c0                	test   %eax,%eax
  80006e:	78 12                	js     800082 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x35>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	f3 0f 1e fb          	endbr32 
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b0:	e8 79 04 00 00       	call   80052e <close_all>
	sys_env_destroy(0);
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	6a 00                	push   $0x0
  8000ba:	e8 a0 00 00 00       	call   80015f <sys_env_destroy>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
  8000ca:	83 ec 1c             	sub    $0x1c,%esp
  8000cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000d3:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000db:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000de:	8b 75 14             	mov    0x14(%ebp),%esi
  8000e1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e7:	74 04                	je     8000ed <syscall+0x29>
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	7f 08                	jg     8000f5 <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  8000ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5e                   	pop    %esi
  8000f2:	5f                   	pop    %edi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	50                   	push   %eax
  8000f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fc:	68 ca 1e 80 00       	push   $0x801eca
  800101:	6a 23                	push   $0x23
  800103:	68 e7 1e 80 00       	push   $0x801ee7
  800108:	e8 b6 0f 00 00       	call   8010c3 <_panic>

0080010d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80010d:	f3 0f 1e fb          	endbr32 
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800117:	6a 00                	push   $0x0
  800119:	6a 00                	push   $0x0
  80011b:	6a 00                	push   $0x0
  80011d:	ff 75 0c             	pushl  0xc(%ebp)
  800120:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800123:	ba 00 00 00 00       	mov    $0x0,%edx
  800128:	b8 00 00 00 00       	mov    $0x0,%eax
  80012d:	e8 92 ff ff ff       	call   8000c4 <syscall>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	c9                   	leave  
  800136:	c3                   	ret    

00800137 <sys_cgetc>:

int
sys_cgetc(void)
{
  800137:	f3 0f 1e fb          	endbr32 
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800141:	6a 00                	push   $0x0
  800143:	6a 00                	push   $0x0
  800145:	6a 00                	push   $0x0
  800147:	6a 00                	push   $0x0
  800149:	b9 00 00 00 00       	mov    $0x0,%ecx
  80014e:	ba 00 00 00 00       	mov    $0x0,%edx
  800153:	b8 01 00 00 00       	mov    $0x1,%eax
  800158:	e8 67 ff ff ff       	call   8000c4 <syscall>
}
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80015f:	f3 0f 1e fb          	endbr32 
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800169:	6a 00                	push   $0x0
  80016b:	6a 00                	push   $0x0
  80016d:	6a 00                	push   $0x0
  80016f:	6a 00                	push   $0x0
  800171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800174:	ba 01 00 00 00       	mov    $0x1,%edx
  800179:	b8 03 00 00 00       	mov    $0x3,%eax
  80017e:	e8 41 ff ff ff       	call   8000c4 <syscall>
}
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800185:	f3 0f 1e fb          	endbr32 
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80018f:	6a 00                	push   $0x0
  800191:	6a 00                	push   $0x0
  800193:	6a 00                	push   $0x0
  800195:	6a 00                	push   $0x0
  800197:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019c:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a1:	b8 02 00 00 00       	mov    $0x2,%eax
  8001a6:	e8 19 ff ff ff       	call   8000c4 <syscall>
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <sys_yield>:

void
sys_yield(void)
{
  8001ad:	f3 0f 1e fb          	endbr32 
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001b7:	6a 00                	push   $0x0
  8001b9:	6a 00                	push   $0x0
  8001bb:	6a 00                	push   $0x0
  8001bd:	6a 00                	push   $0x0
  8001bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001ce:	e8 f1 fe ff ff       	call   8000c4 <syscall>
}
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d8:	f3 0f 1e fb          	endbr32 
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001e2:	6a 00                	push   $0x0
  8001e4:	6a 00                	push   $0x0
  8001e6:	ff 75 10             	pushl  0x10(%ebp)
  8001e9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8001f9:	e8 c6 fe ff ff       	call   8000c4 <syscall>
}
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800200:	f3 0f 1e fb          	endbr32 
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80020a:	ff 75 18             	pushl  0x18(%ebp)
  80020d:	ff 75 14             	pushl  0x14(%ebp)
  800210:	ff 75 10             	pushl  0x10(%ebp)
  800213:	ff 75 0c             	pushl  0xc(%ebp)
  800216:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800219:	ba 01 00 00 00       	mov    $0x1,%edx
  80021e:	b8 05 00 00 00       	mov    $0x5,%eax
  800223:	e8 9c fe ff ff       	call   8000c4 <syscall>
}
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80022a:	f3 0f 1e fb          	endbr32 
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800234:	6a 00                	push   $0x0
  800236:	6a 00                	push   $0x0
  800238:	6a 00                	push   $0x0
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800240:	ba 01 00 00 00       	mov    $0x1,%edx
  800245:	b8 06 00 00 00       	mov    $0x6,%eax
  80024a:	e8 75 fe ff ff       	call   8000c4 <syscall>
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800251:	f3 0f 1e fb          	endbr32 
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80025b:	6a 00                	push   $0x0
  80025d:	6a 00                	push   $0x0
  80025f:	6a 00                	push   $0x0
  800261:	ff 75 0c             	pushl  0xc(%ebp)
  800264:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800267:	ba 01 00 00 00       	mov    $0x1,%edx
  80026c:	b8 08 00 00 00       	mov    $0x8,%eax
  800271:	e8 4e fe ff ff       	call   8000c4 <syscall>
}
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800278:	f3 0f 1e fb          	endbr32 
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800282:	6a 00                	push   $0x0
  800284:	6a 00                	push   $0x0
  800286:	6a 00                	push   $0x0
  800288:	ff 75 0c             	pushl  0xc(%ebp)
  80028b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028e:	ba 01 00 00 00       	mov    $0x1,%edx
  800293:	b8 09 00 00 00       	mov    $0x9,%eax
  800298:	e8 27 fe ff ff       	call   8000c4 <syscall>
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029f:	f3 0f 1e fb          	endbr32 
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8002a9:	6a 00                	push   $0x0
  8002ab:	6a 00                	push   $0x0
  8002ad:	6a 00                	push   $0x0
  8002af:	ff 75 0c             	pushl  0xc(%ebp)
  8002b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b5:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002bf:	e8 00 fe ff ff       	call   8000c4 <syscall>
}
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c6:	f3 0f 1e fb          	endbr32 
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002d0:	6a 00                	push   $0x0
  8002d2:	ff 75 14             	pushl  0x14(%ebp)
  8002d5:	ff 75 10             	pushl  0x10(%ebp)
  8002d8:	ff 75 0c             	pushl  0xc(%ebp)
  8002db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002de:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e8:	e8 d7 fd ff ff       	call   8000c4 <syscall>
}
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002f9:	6a 00                	push   $0x0
  8002fb:	6a 00                	push   $0x0
  8002fd:	6a 00                	push   $0x0
  8002ff:	6a 00                	push   $0x0
  800301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800304:	ba 01 00 00 00       	mov    $0x1,%edx
  800309:	b8 0d 00 00 00       	mov    $0xd,%eax
  80030e:	e8 b1 fd ff ff       	call   8000c4 <syscall>
}
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800315:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800316:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80031b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80031d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  800320:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  800324:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  800327:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  80032b:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  80032f:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800331:	83 c4 08             	add    $0x8,%esp
	popal
  800334:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  800335:	83 c4 04             	add    $0x4,%esp
	popfl
  800338:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800339:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80033a:	c3                   	ret    

0080033b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80033b:	f3 0f 1e fb          	endbr32 
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	05 00 00 00 30       	add    $0x30000000,%eax
  80034a:	c1 e8 0c             	shr    $0xc,%eax
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80034f:	f3 0f 1e fb          	endbr32 
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800359:	ff 75 08             	pushl  0x8(%ebp)
  80035c:	e8 da ff ff ff       	call   80033b <fd2num>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	c1 e0 0c             	shl    $0xc,%eax
  800367:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80036e:	f3 0f 1e fb          	endbr32 
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80037a:	89 c2                	mov    %eax,%edx
  80037c:	c1 ea 16             	shr    $0x16,%edx
  80037f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800386:	f6 c2 01             	test   $0x1,%dl
  800389:	74 2d                	je     8003b8 <fd_alloc+0x4a>
  80038b:	89 c2                	mov    %eax,%edx
  80038d:	c1 ea 0c             	shr    $0xc,%edx
  800390:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800397:	f6 c2 01             	test   $0x1,%dl
  80039a:	74 1c                	je     8003b8 <fd_alloc+0x4a>
  80039c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003a1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003a6:	75 d2                	jne    80037a <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003b1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003b6:	eb 0a                	jmp    8003c2 <fd_alloc+0x54>
			*fd_store = fd;
  8003b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003bb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003c4:	f3 0f 1e fb          	endbr32 
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003ce:	83 f8 1f             	cmp    $0x1f,%eax
  8003d1:	77 30                	ja     800403 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003d3:	c1 e0 0c             	shl    $0xc,%eax
  8003d6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003db:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003e1:	f6 c2 01             	test   $0x1,%dl
  8003e4:	74 24                	je     80040a <fd_lookup+0x46>
  8003e6:	89 c2                	mov    %eax,%edx
  8003e8:	c1 ea 0c             	shr    $0xc,%edx
  8003eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f2:	f6 c2 01             	test   $0x1,%dl
  8003f5:	74 1a                	je     800411 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fa:	89 02                	mov    %eax,(%edx)
	return 0;
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800401:	5d                   	pop    %ebp
  800402:	c3                   	ret    
		return -E_INVAL;
  800403:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800408:	eb f7                	jmp    800401 <fd_lookup+0x3d>
		return -E_INVAL;
  80040a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80040f:	eb f0                	jmp    800401 <fd_lookup+0x3d>
  800411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800416:	eb e9                	jmp    800401 <fd_lookup+0x3d>

00800418 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800418:	f3 0f 1e fb          	endbr32 
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800425:	ba 74 1f 80 00       	mov    $0x801f74,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80042a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80042f:	39 08                	cmp    %ecx,(%eax)
  800431:	74 33                	je     800466 <dev_lookup+0x4e>
  800433:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800436:	8b 02                	mov    (%edx),%eax
  800438:	85 c0                	test   %eax,%eax
  80043a:	75 f3                	jne    80042f <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80043c:	a1 04 40 80 00       	mov    0x804004,%eax
  800441:	8b 40 48             	mov    0x48(%eax),%eax
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	51                   	push   %ecx
  800448:	50                   	push   %eax
  800449:	68 f8 1e 80 00       	push   $0x801ef8
  80044e:	e8 57 0d 00 00       	call   8011aa <cprintf>
	*dev = 0;
  800453:	8b 45 0c             	mov    0xc(%ebp),%eax
  800456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800464:	c9                   	leave  
  800465:	c3                   	ret    
			*dev = devtab[i];
  800466:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800469:	89 01                	mov    %eax,(%ecx)
			return 0;
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	eb f2                	jmp    800464 <dev_lookup+0x4c>

00800472 <fd_close>:
{
  800472:	f3 0f 1e fb          	endbr32 
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	57                   	push   %edi
  80047a:	56                   	push   %esi
  80047b:	53                   	push   %ebx
  80047c:	83 ec 28             	sub    $0x28,%esp
  80047f:	8b 75 08             	mov    0x8(%ebp),%esi
  800482:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800485:	56                   	push   %esi
  800486:	e8 b0 fe ff ff       	call   80033b <fd2num>
  80048b:	83 c4 08             	add    $0x8,%esp
  80048e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800491:	52                   	push   %edx
  800492:	50                   	push   %eax
  800493:	e8 2c ff ff ff       	call   8003c4 <fd_lookup>
  800498:	89 c3                	mov    %eax,%ebx
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	85 c0                	test   %eax,%eax
  80049f:	78 05                	js     8004a6 <fd_close+0x34>
	    || fd != fd2)
  8004a1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004a4:	74 16                	je     8004bc <fd_close+0x4a>
		return (must_exist ? r : 0);
  8004a6:	89 f8                	mov    %edi,%eax
  8004a8:	84 c0                	test   %al,%al
  8004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004af:	0f 44 d8             	cmove  %eax,%ebx
}
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b7:	5b                   	pop    %ebx
  8004b8:	5e                   	pop    %esi
  8004b9:	5f                   	pop    %edi
  8004ba:	5d                   	pop    %ebp
  8004bb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	ff 36                	pushl  (%esi)
  8004c5:	e8 4e ff ff ff       	call   800418 <dev_lookup>
  8004ca:	89 c3                	mov    %eax,%ebx
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	78 1a                	js     8004ed <fd_close+0x7b>
		if (dev->dev_close)
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	74 0b                	je     8004ed <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	56                   	push   %esi
  8004e6:	ff d0                	call   *%eax
  8004e8:	89 c3                	mov    %eax,%ebx
  8004ea:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	56                   	push   %esi
  8004f1:	6a 00                	push   $0x0
  8004f3:	e8 32 fd ff ff       	call   80022a <sys_page_unmap>
	return r;
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	eb b5                	jmp    8004b2 <fd_close+0x40>

008004fd <close>:

int
close(int fdnum)
{
  8004fd:	f3 0f 1e fb          	endbr32 
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800507:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80050a:	50                   	push   %eax
  80050b:	ff 75 08             	pushl  0x8(%ebp)
  80050e:	e8 b1 fe ff ff       	call   8003c4 <fd_lookup>
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	85 c0                	test   %eax,%eax
  800518:	79 02                	jns    80051c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    
		return fd_close(fd, 1);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	6a 01                	push   $0x1
  800521:	ff 75 f4             	pushl  -0xc(%ebp)
  800524:	e8 49 ff ff ff       	call   800472 <fd_close>
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb ec                	jmp    80051a <close+0x1d>

0080052e <close_all>:

void
close_all(void)
{
  80052e:	f3 0f 1e fb          	endbr32 
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	53                   	push   %ebx
  800536:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800539:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	53                   	push   %ebx
  800542:	e8 b6 ff ff ff       	call   8004fd <close>
	for (i = 0; i < MAXFD; i++)
  800547:	83 c3 01             	add    $0x1,%ebx
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	83 fb 20             	cmp    $0x20,%ebx
  800550:	75 ec                	jne    80053e <close_all+0x10>
}
  800552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800557:	f3 0f 1e fb          	endbr32 
  80055b:	55                   	push   %ebp
  80055c:	89 e5                	mov    %esp,%ebp
  80055e:	57                   	push   %edi
  80055f:	56                   	push   %esi
  800560:	53                   	push   %ebx
  800561:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800564:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800567:	50                   	push   %eax
  800568:	ff 75 08             	pushl  0x8(%ebp)
  80056b:	e8 54 fe ff ff       	call   8003c4 <fd_lookup>
  800570:	89 c3                	mov    %eax,%ebx
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	85 c0                	test   %eax,%eax
  800577:	0f 88 81 00 00 00    	js     8005fe <dup+0xa7>
		return r;
	close(newfdnum);
  80057d:	83 ec 0c             	sub    $0xc,%esp
  800580:	ff 75 0c             	pushl  0xc(%ebp)
  800583:	e8 75 ff ff ff       	call   8004fd <close>

	newfd = INDEX2FD(newfdnum);
  800588:	8b 75 0c             	mov    0xc(%ebp),%esi
  80058b:	c1 e6 0c             	shl    $0xc,%esi
  80058e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800594:	83 c4 04             	add    $0x4,%esp
  800597:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059a:	e8 b0 fd ff ff       	call   80034f <fd2data>
  80059f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005a1:	89 34 24             	mov    %esi,(%esp)
  8005a4:	e8 a6 fd ff ff       	call   80034f <fd2data>
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005ae:	89 d8                	mov    %ebx,%eax
  8005b0:	c1 e8 16             	shr    $0x16,%eax
  8005b3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005ba:	a8 01                	test   $0x1,%al
  8005bc:	74 11                	je     8005cf <dup+0x78>
  8005be:	89 d8                	mov    %ebx,%eax
  8005c0:	c1 e8 0c             	shr    $0xc,%eax
  8005c3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005ca:	f6 c2 01             	test   $0x1,%dl
  8005cd:	75 39                	jne    800608 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	c1 e8 0c             	shr    $0xc,%eax
  8005d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8005e6:	50                   	push   %eax
  8005e7:	56                   	push   %esi
  8005e8:	6a 00                	push   $0x0
  8005ea:	52                   	push   %edx
  8005eb:	6a 00                	push   $0x0
  8005ed:	e8 0e fc ff ff       	call   800200 <sys_page_map>
  8005f2:	89 c3                	mov    %eax,%ebx
  8005f4:	83 c4 20             	add    $0x20,%esp
  8005f7:	85 c0                	test   %eax,%eax
  8005f9:	78 31                	js     80062c <dup+0xd5>
		goto err;

	return newfdnum;
  8005fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005fe:	89 d8                	mov    %ebx,%eax
  800600:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800603:	5b                   	pop    %ebx
  800604:	5e                   	pop    %esi
  800605:	5f                   	pop    %edi
  800606:	5d                   	pop    %ebp
  800607:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800608:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	25 07 0e 00 00       	and    $0xe07,%eax
  800617:	50                   	push   %eax
  800618:	57                   	push   %edi
  800619:	6a 00                	push   $0x0
  80061b:	53                   	push   %ebx
  80061c:	6a 00                	push   $0x0
  80061e:	e8 dd fb ff ff       	call   800200 <sys_page_map>
  800623:	89 c3                	mov    %eax,%ebx
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	85 c0                	test   %eax,%eax
  80062a:	79 a3                	jns    8005cf <dup+0x78>
	sys_page_unmap(0, newfd);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	56                   	push   %esi
  800630:	6a 00                	push   $0x0
  800632:	e8 f3 fb ff ff       	call   80022a <sys_page_unmap>
	sys_page_unmap(0, nva);
  800637:	83 c4 08             	add    $0x8,%esp
  80063a:	57                   	push   %edi
  80063b:	6a 00                	push   $0x0
  80063d:	e8 e8 fb ff ff       	call   80022a <sys_page_unmap>
	return r;
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	eb b7                	jmp    8005fe <dup+0xa7>

00800647 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800647:	f3 0f 1e fb          	endbr32 
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	53                   	push   %ebx
  80064f:	83 ec 1c             	sub    $0x1c,%esp
  800652:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800655:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800658:	50                   	push   %eax
  800659:	53                   	push   %ebx
  80065a:	e8 65 fd ff ff       	call   8003c4 <fd_lookup>
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	85 c0                	test   %eax,%eax
  800664:	78 3f                	js     8006a5 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80066c:	50                   	push   %eax
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	ff 30                	pushl  (%eax)
  800672:	e8 a1 fd ff ff       	call   800418 <dev_lookup>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	85 c0                	test   %eax,%eax
  80067c:	78 27                	js     8006a5 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80067e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800681:	8b 42 08             	mov    0x8(%edx),%eax
  800684:	83 e0 03             	and    $0x3,%eax
  800687:	83 f8 01             	cmp    $0x1,%eax
  80068a:	74 1e                	je     8006aa <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068f:	8b 40 08             	mov    0x8(%eax),%eax
  800692:	85 c0                	test   %eax,%eax
  800694:	74 35                	je     8006cb <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	ff 75 10             	pushl  0x10(%ebp)
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	52                   	push   %edx
  8006a0:	ff d0                	call   *%eax
  8006a2:	83 c4 10             	add    $0x10,%esp
}
  8006a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006aa:	a1 04 40 80 00       	mov    0x804004,%eax
  8006af:	8b 40 48             	mov    0x48(%eax),%eax
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	50                   	push   %eax
  8006b7:	68 39 1f 80 00       	push   $0x801f39
  8006bc:	e8 e9 0a 00 00       	call   8011aa <cprintf>
		return -E_INVAL;
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c9:	eb da                	jmp    8006a5 <read+0x5e>
		return -E_NOT_SUPP;
  8006cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d0:	eb d3                	jmp    8006a5 <read+0x5e>

008006d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006d2:	f3 0f 1e fb          	endbr32 
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	57                   	push   %edi
  8006da:	56                   	push   %esi
  8006db:	53                   	push   %ebx
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ea:	eb 02                	jmp    8006ee <readn+0x1c>
  8006ec:	01 c3                	add    %eax,%ebx
  8006ee:	39 f3                	cmp    %esi,%ebx
  8006f0:	73 21                	jae    800713 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	89 f0                	mov    %esi,%eax
  8006f7:	29 d8                	sub    %ebx,%eax
  8006f9:	50                   	push   %eax
  8006fa:	89 d8                	mov    %ebx,%eax
  8006fc:	03 45 0c             	add    0xc(%ebp),%eax
  8006ff:	50                   	push   %eax
  800700:	57                   	push   %edi
  800701:	e8 41 ff ff ff       	call   800647 <read>
		if (m < 0)
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	85 c0                	test   %eax,%eax
  80070b:	78 04                	js     800711 <readn+0x3f>
			return m;
		if (m == 0)
  80070d:	75 dd                	jne    8006ec <readn+0x1a>
  80070f:	eb 02                	jmp    800713 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800711:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800713:	89 d8                	mov    %ebx,%eax
  800715:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800718:	5b                   	pop    %ebx
  800719:	5e                   	pop    %esi
  80071a:	5f                   	pop    %edi
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    

0080071d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071d:	f3 0f 1e fb          	endbr32 
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
  800724:	53                   	push   %ebx
  800725:	83 ec 1c             	sub    $0x1c,%esp
  800728:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80072b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80072e:	50                   	push   %eax
  80072f:	53                   	push   %ebx
  800730:	e8 8f fc ff ff       	call   8003c4 <fd_lookup>
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	85 c0                	test   %eax,%eax
  80073a:	78 3a                	js     800776 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800742:	50                   	push   %eax
  800743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800746:	ff 30                	pushl  (%eax)
  800748:	e8 cb fc ff ff       	call   800418 <dev_lookup>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	85 c0                	test   %eax,%eax
  800752:	78 22                	js     800776 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800757:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80075b:	74 1e                	je     80077b <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800760:	8b 52 0c             	mov    0xc(%edx),%edx
  800763:	85 d2                	test   %edx,%edx
  800765:	74 35                	je     80079c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	ff 75 10             	pushl  0x10(%ebp)
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	50                   	push   %eax
  800771:	ff d2                	call   *%edx
  800773:	83 c4 10             	add    $0x10,%esp
}
  800776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800779:	c9                   	leave  
  80077a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80077b:	a1 04 40 80 00       	mov    0x804004,%eax
  800780:	8b 40 48             	mov    0x48(%eax),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	53                   	push   %ebx
  800787:	50                   	push   %eax
  800788:	68 55 1f 80 00       	push   $0x801f55
  80078d:	e8 18 0a 00 00       	call   8011aa <cprintf>
		return -E_INVAL;
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079a:	eb da                	jmp    800776 <write+0x59>
		return -E_NOT_SUPP;
  80079c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a1:	eb d3                	jmp    800776 <write+0x59>

008007a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a3:	f3 0f 1e fb          	endbr32 
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 0b fc ff ff       	call   8003c4 <fd_lookup>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	85 c0                	test   %eax,%eax
  8007be:	78 0e                	js     8007ce <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8007c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d0:	f3 0f 1e fb          	endbr32 
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	53                   	push   %ebx
  8007d8:	83 ec 1c             	sub    $0x1c,%esp
  8007db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	53                   	push   %ebx
  8007e3:	e8 dc fb ff ff       	call   8003c4 <fd_lookup>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	78 37                	js     800826 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f5:	50                   	push   %eax
  8007f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f9:	ff 30                	pushl  (%eax)
  8007fb:	e8 18 fc ff ff       	call   800418 <dev_lookup>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	85 c0                	test   %eax,%eax
  800805:	78 1f                	js     800826 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80080e:	74 1b                	je     80082b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800813:	8b 52 18             	mov    0x18(%edx),%edx
  800816:	85 d2                	test   %edx,%edx
  800818:	74 32                	je     80084c <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	50                   	push   %eax
  800821:	ff d2                	call   *%edx
  800823:	83 c4 10             	add    $0x10,%esp
}
  800826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800829:	c9                   	leave  
  80082a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800830:	8b 40 48             	mov    0x48(%eax),%eax
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	53                   	push   %ebx
  800837:	50                   	push   %eax
  800838:	68 18 1f 80 00       	push   $0x801f18
  80083d:	e8 68 09 00 00       	call   8011aa <cprintf>
		return -E_INVAL;
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084a:	eb da                	jmp    800826 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80084c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800851:	eb d3                	jmp    800826 <ftruncate+0x56>

00800853 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800853:	f3 0f 1e fb          	endbr32 
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	83 ec 1c             	sub    $0x1c,%esp
  80085e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800864:	50                   	push   %eax
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 57 fb ff ff       	call   8003c4 <fd_lookup>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	85 c0                	test   %eax,%eax
  800872:	78 4b                	js     8008bf <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087a:	50                   	push   %eax
  80087b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087e:	ff 30                	pushl  (%eax)
  800880:	e8 93 fb ff ff       	call   800418 <dev_lookup>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	85 c0                	test   %eax,%eax
  80088a:	78 33                	js     8008bf <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80088c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800893:	74 2f                	je     8008c4 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800895:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800898:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089f:	00 00 00 
	stat->st_isdir = 0;
  8008a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a9:	00 00 00 
	stat->st_dev = dev;
  8008ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b9:	ff 50 14             	call   *0x14(%eax)
  8008bc:	83 c4 10             	add    $0x10,%esp
}
  8008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8008c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c9:	eb f4                	jmp    8008bf <fstat+0x6c>

008008cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008cb:	f3 0f 1e fb          	endbr32 
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	6a 00                	push   $0x0
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 3a 02 00 00       	call   800b1b <open>
  8008e1:	89 c3                	mov    %eax,%ebx
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	78 1b                	js     800905 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	50                   	push   %eax
  8008f1:	e8 5d ff ff ff       	call   800853 <fstat>
  8008f6:	89 c6                	mov    %eax,%esi
	close(fd);
  8008f8:	89 1c 24             	mov    %ebx,(%esp)
  8008fb:	e8 fd fb ff ff       	call   8004fd <close>
	return r;
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	89 f3                	mov    %esi,%ebx
}
  800905:	89 d8                	mov    %ebx,%eax
  800907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	56                   	push   %esi
  800912:	53                   	push   %ebx
  800913:	89 c6                	mov    %eax,%esi
  800915:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800917:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80091e:	74 27                	je     800947 <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800920:	6a 07                	push   $0x7
  800922:	68 00 50 80 00       	push   $0x805000
  800927:	56                   	push   %esi
  800928:	ff 35 00 40 80 00    	pushl  0x804000
  80092e:	e8 3f 12 00 00       	call   801b72 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800933:	83 c4 0c             	add    $0xc,%esp
  800936:	6a 00                	push   $0x0
  800938:	53                   	push   %ebx
  800939:	6a 00                	push   $0x0
  80093b:	e8 c5 11 00 00       	call   801b05 <ipc_recv>
}
  800940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800943:	5b                   	pop    %ebx
  800944:	5e                   	pop    %esi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800947:	83 ec 0c             	sub    $0xc,%esp
  80094a:	6a 01                	push   $0x1
  80094c:	e8 79 12 00 00       	call   801bca <ipc_find_env>
  800951:	a3 00 40 80 00       	mov    %eax,0x804000
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	eb c5                	jmp    800920 <fsipc+0x12>

0080095b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80095b:	f3 0f 1e fb          	endbr32 
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 40 0c             	mov    0xc(%eax),%eax
  80096b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	b8 02 00 00 00       	mov    $0x2,%eax
  800982:	e8 87 ff ff ff       	call   80090e <fsipc>
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <devfile_flush>:
{
  800989:	f3 0f 1e fb          	endbr32 
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 40 0c             	mov    0xc(%eax),%eax
  800999:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	b8 06 00 00 00       	mov    $0x6,%eax
  8009a8:	e8 61 ff ff ff       	call   80090e <fsipc>
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <devfile_stat>:
{
  8009af:	f3 0f 1e fb          	endbr32 
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	53                   	push   %ebx
  8009b7:	83 ec 04             	sub    $0x4,%esp
  8009ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8009c3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8009d2:	e8 37 ff ff ff       	call   80090e <fsipc>
  8009d7:	85 c0                	test   %eax,%eax
  8009d9:	78 2c                	js     800a07 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	68 00 50 80 00       	push   $0x805000
  8009e3:	53                   	push   %ebx
  8009e4:	e8 2b 0d 00 00       	call   801714 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009e9:	a1 80 50 80 00       	mov    0x805080,%eax
  8009ee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009f4:	a1 84 50 80 00       	mov    0x805084,%eax
  8009f9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ff:	83 c4 10             	add    $0x10,%esp
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <devfile_write>:
{
  800a0c:	f3 0f 1e fb          	endbr32 
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	53                   	push   %ebx
  800a14:	83 ec 04             	sub    $0x4,%esp
  800a17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a20:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  800a25:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a2b:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800a31:	77 30                	ja     800a63 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  800a33:	83 ec 04             	sub    $0x4,%esp
  800a36:	53                   	push   %ebx
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	68 08 50 80 00       	push   $0x805008
  800a3f:	e8 88 0e 00 00       	call   8018cc <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a44:	ba 00 00 00 00       	mov    $0x0,%edx
  800a49:	b8 04 00 00 00       	mov    $0x4,%eax
  800a4e:	e8 bb fe ff ff       	call   80090e <fsipc>
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	85 c0                	test   %eax,%eax
  800a58:	78 04                	js     800a5e <devfile_write+0x52>
	assert(r <= n);
  800a5a:	39 d8                	cmp    %ebx,%eax
  800a5c:	77 1e                	ja     800a7c <devfile_write+0x70>
}
  800a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  800a63:	68 84 1f 80 00       	push   $0x801f84
  800a68:	68 b1 1f 80 00       	push   $0x801fb1
  800a6d:	68 94 00 00 00       	push   $0x94
  800a72:	68 c6 1f 80 00       	push   $0x801fc6
  800a77:	e8 47 06 00 00       	call   8010c3 <_panic>
	assert(r <= n);
  800a7c:	68 d1 1f 80 00       	push   $0x801fd1
  800a81:	68 b1 1f 80 00       	push   $0x801fb1
  800a86:	68 98 00 00 00       	push   $0x98
  800a8b:	68 c6 1f 80 00       	push   $0x801fc6
  800a90:	e8 2e 06 00 00       	call   8010c3 <_panic>

00800a95 <devfile_read>:
{
  800a95:	f3 0f 1e fb          	endbr32 
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800aac:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab7:	b8 03 00 00 00       	mov    $0x3,%eax
  800abc:	e8 4d fe ff ff       	call   80090e <fsipc>
  800ac1:	89 c3                	mov    %eax,%ebx
  800ac3:	85 c0                	test   %eax,%eax
  800ac5:	78 1f                	js     800ae6 <devfile_read+0x51>
	assert(r <= n);
  800ac7:	39 f0                	cmp    %esi,%eax
  800ac9:	77 24                	ja     800aef <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800acb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad0:	7f 33                	jg     800b05 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 00 50 80 00       	push   $0x805000
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	e8 e9 0d 00 00       	call   8018cc <memmove>
	return r;
  800ae3:	83 c4 10             	add    $0x10,%esp
}
  800ae6:	89 d8                	mov    %ebx,%eax
  800ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    
	assert(r <= n);
  800aef:	68 d1 1f 80 00       	push   $0x801fd1
  800af4:	68 b1 1f 80 00       	push   $0x801fb1
  800af9:	6a 7c                	push   $0x7c
  800afb:	68 c6 1f 80 00       	push   $0x801fc6
  800b00:	e8 be 05 00 00       	call   8010c3 <_panic>
	assert(r <= PGSIZE);
  800b05:	68 d8 1f 80 00       	push   $0x801fd8
  800b0a:	68 b1 1f 80 00       	push   $0x801fb1
  800b0f:	6a 7d                	push   $0x7d
  800b11:	68 c6 1f 80 00       	push   $0x801fc6
  800b16:	e8 a8 05 00 00       	call   8010c3 <_panic>

00800b1b <open>:
{
  800b1b:	f3 0f 1e fb          	endbr32 
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	83 ec 1c             	sub    $0x1c,%esp
  800b27:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b2a:	56                   	push   %esi
  800b2b:	e8 a1 0b 00 00       	call   8016d1 <strlen>
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b38:	7f 6c                	jg     800ba6 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b3a:	83 ec 0c             	sub    $0xc,%esp
  800b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b40:	50                   	push   %eax
  800b41:	e8 28 f8 ff ff       	call   80036e <fd_alloc>
  800b46:	89 c3                	mov    %eax,%ebx
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	85 c0                	test   %eax,%eax
  800b4d:	78 3c                	js     800b8b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	56                   	push   %esi
  800b53:	68 00 50 80 00       	push   $0x805000
  800b58:	e8 b7 0b 00 00       	call   801714 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b68:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6d:	e8 9c fd ff ff       	call   80090e <fsipc>
  800b72:	89 c3                	mov    %eax,%ebx
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	85 c0                	test   %eax,%eax
  800b79:	78 19                	js     800b94 <open+0x79>
	return fd2num(fd);
  800b7b:	83 ec 0c             	sub    $0xc,%esp
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	e8 b5 f7 ff ff       	call   80033b <fd2num>
  800b86:	89 c3                	mov    %eax,%ebx
  800b88:	83 c4 10             	add    $0x10,%esp
}
  800b8b:	89 d8                	mov    %ebx,%eax
  800b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		fd_close(fd, 0);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	6a 00                	push   $0x0
  800b99:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9c:	e8 d1 f8 ff ff       	call   800472 <fd_close>
		return r;
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	eb e5                	jmp    800b8b <open+0x70>
		return -E_BAD_PATH;
  800ba6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bab:	eb de                	jmp    800b8b <open+0x70>

00800bad <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bad:	f3 0f 1e fb          	endbr32 
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	b8 08 00 00 00       	mov    $0x8,%eax
  800bc1:	e8 48 fd ff ff       	call   80090e <fsipc>
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bc8:	f3 0f 1e fb          	endbr32 
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 70 f7 ff ff       	call   80034f <fd2data>
  800bdf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800be1:	83 c4 08             	add    $0x8,%esp
  800be4:	68 e4 1f 80 00       	push   $0x801fe4
  800be9:	53                   	push   %ebx
  800bea:	e8 25 0b 00 00       	call   801714 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bef:	8b 46 04             	mov    0x4(%esi),%eax
  800bf2:	2b 06                	sub    (%esi),%eax
  800bf4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bfa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c01:	00 00 00 
	stat->st_dev = &devpipe;
  800c04:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c0b:	30 80 00 
	return 0;
}
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c1a:	f3 0f 1e fb          	endbr32 
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c28:	53                   	push   %ebx
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 fa f5 ff ff       	call   80022a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c30:	89 1c 24             	mov    %ebx,(%esp)
  800c33:	e8 17 f7 ff ff       	call   80034f <fd2data>
  800c38:	83 c4 08             	add    $0x8,%esp
  800c3b:	50                   	push   %eax
  800c3c:	6a 00                	push   $0x0
  800c3e:	e8 e7 f5 ff ff       	call   80022a <sys_page_unmap>
}
  800c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <_pipeisclosed>:
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
  800c4e:	83 ec 1c             	sub    $0x1c,%esp
  800c51:	89 c7                	mov    %eax,%edi
  800c53:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c55:	a1 04 40 80 00       	mov    0x804004,%eax
  800c5a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c5d:	83 ec 0c             	sub    $0xc,%esp
  800c60:	57                   	push   %edi
  800c61:	e8 a1 0f 00 00       	call   801c07 <pageref>
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	89 34 24             	mov    %esi,(%esp)
  800c6c:	e8 96 0f 00 00       	call   801c07 <pageref>
		nn = thisenv->env_runs;
  800c71:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c77:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	39 cb                	cmp    %ecx,%ebx
  800c7f:	74 1b                	je     800c9c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c81:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c84:	75 cf                	jne    800c55 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c86:	8b 42 58             	mov    0x58(%edx),%eax
  800c89:	6a 01                	push   $0x1
  800c8b:	50                   	push   %eax
  800c8c:	53                   	push   %ebx
  800c8d:	68 eb 1f 80 00       	push   $0x801feb
  800c92:	e8 13 05 00 00       	call   8011aa <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	eb b9                	jmp    800c55 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c9c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c9f:	0f 94 c0             	sete   %al
  800ca2:	0f b6 c0             	movzbl %al,%eax
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <devpipe_write>:
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 28             	sub    $0x28,%esp
  800cba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800cbd:	56                   	push   %esi
  800cbe:	e8 8c f6 ff ff       	call   80034f <fd2data>
  800cc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cc5:	83 c4 10             	add    $0x10,%esp
  800cc8:	bf 00 00 00 00       	mov    $0x0,%edi
  800ccd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800cd0:	74 4f                	je     800d21 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800cd2:	8b 43 04             	mov    0x4(%ebx),%eax
  800cd5:	8b 0b                	mov    (%ebx),%ecx
  800cd7:	8d 51 20             	lea    0x20(%ecx),%edx
  800cda:	39 d0                	cmp    %edx,%eax
  800cdc:	72 14                	jb     800cf2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800cde:	89 da                	mov    %ebx,%edx
  800ce0:	89 f0                	mov    %esi,%eax
  800ce2:	e8 61 ff ff ff       	call   800c48 <_pipeisclosed>
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 3b                	jne    800d26 <devpipe_write+0x79>
			sys_yield();
  800ceb:	e8 bd f4 ff ff       	call   8001ad <sys_yield>
  800cf0:	eb e0                	jmp    800cd2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cf9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cfc:	89 c2                	mov    %eax,%edx
  800cfe:	c1 fa 1f             	sar    $0x1f,%edx
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	c1 e9 1b             	shr    $0x1b,%ecx
  800d06:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d09:	83 e2 1f             	and    $0x1f,%edx
  800d0c:	29 ca                	sub    %ecx,%edx
  800d0e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d12:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d1c:	83 c7 01             	add    $0x1,%edi
  800d1f:	eb ac                	jmp    800ccd <devpipe_write+0x20>
	return i;
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	eb 05                	jmp    800d2b <devpipe_write+0x7e>
				return 0;
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <devpipe_read>:
{
  800d33:	f3 0f 1e fb          	endbr32 
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 18             	sub    $0x18,%esp
  800d40:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d43:	57                   	push   %edi
  800d44:	e8 06 f6 ff ff       	call   80034f <fd2data>
  800d49:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d4b:	83 c4 10             	add    $0x10,%esp
  800d4e:	be 00 00 00 00       	mov    $0x0,%esi
  800d53:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d56:	75 14                	jne    800d6c <devpipe_read+0x39>
	return i;
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	eb 02                	jmp    800d5f <devpipe_read+0x2c>
				return i;
  800d5d:	89 f0                	mov    %esi,%eax
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
			sys_yield();
  800d67:	e8 41 f4 ff ff       	call   8001ad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d6c:	8b 03                	mov    (%ebx),%eax
  800d6e:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d71:	75 18                	jne    800d8b <devpipe_read+0x58>
			if (i > 0)
  800d73:	85 f6                	test   %esi,%esi
  800d75:	75 e6                	jne    800d5d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800d77:	89 da                	mov    %ebx,%edx
  800d79:	89 f8                	mov    %edi,%eax
  800d7b:	e8 c8 fe ff ff       	call   800c48 <_pipeisclosed>
  800d80:	85 c0                	test   %eax,%eax
  800d82:	74 e3                	je     800d67 <devpipe_read+0x34>
				return 0;
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
  800d89:	eb d4                	jmp    800d5f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d8b:	99                   	cltd   
  800d8c:	c1 ea 1b             	shr    $0x1b,%edx
  800d8f:	01 d0                	add    %edx,%eax
  800d91:	83 e0 1f             	and    $0x1f,%eax
  800d94:	29 d0                	sub    %edx,%eax
  800d96:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800da1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800da4:	83 c6 01             	add    $0x1,%esi
  800da7:	eb aa                	jmp    800d53 <devpipe_read+0x20>

00800da9 <pipe>:
{
  800da9:	f3 0f 1e fb          	endbr32 
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800db8:	50                   	push   %eax
  800db9:	e8 b0 f5 ff ff       	call   80036e <fd_alloc>
  800dbe:	89 c3                	mov    %eax,%ebx
  800dc0:	83 c4 10             	add    $0x10,%esp
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	0f 88 23 01 00 00    	js     800eee <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	68 07 04 00 00       	push   $0x407
  800dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd6:	6a 00                	push   $0x0
  800dd8:	e8 fb f3 ff ff       	call   8001d8 <sys_page_alloc>
  800ddd:	89 c3                	mov    %eax,%ebx
  800ddf:	83 c4 10             	add    $0x10,%esp
  800de2:	85 c0                	test   %eax,%eax
  800de4:	0f 88 04 01 00 00    	js     800eee <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800df0:	50                   	push   %eax
  800df1:	e8 78 f5 ff ff       	call   80036e <fd_alloc>
  800df6:	89 c3                	mov    %eax,%ebx
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	0f 88 db 00 00 00    	js     800ede <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 07 04 00 00       	push   $0x407
  800e0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e0e:	6a 00                	push   $0x0
  800e10:	e8 c3 f3 ff ff       	call   8001d8 <sys_page_alloc>
  800e15:	89 c3                	mov    %eax,%ebx
  800e17:	83 c4 10             	add    $0x10,%esp
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	0f 88 bc 00 00 00    	js     800ede <pipe+0x135>
	va = fd2data(fd0);
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	ff 75 f4             	pushl  -0xc(%ebp)
  800e28:	e8 22 f5 ff ff       	call   80034f <fd2data>
  800e2d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e2f:	83 c4 0c             	add    $0xc,%esp
  800e32:	68 07 04 00 00       	push   $0x407
  800e37:	50                   	push   %eax
  800e38:	6a 00                	push   $0x0
  800e3a:	e8 99 f3 ff ff       	call   8001d8 <sys_page_alloc>
  800e3f:	89 c3                	mov    %eax,%ebx
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	85 c0                	test   %eax,%eax
  800e46:	0f 88 82 00 00 00    	js     800ece <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e52:	e8 f8 f4 ff ff       	call   80034f <fd2data>
  800e57:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e5e:	50                   	push   %eax
  800e5f:	6a 00                	push   $0x0
  800e61:	56                   	push   %esi
  800e62:	6a 00                	push   $0x0
  800e64:	e8 97 f3 ff ff       	call   800200 <sys_page_map>
  800e69:	89 c3                	mov    %eax,%ebx
  800e6b:	83 c4 20             	add    $0x20,%esp
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	78 4e                	js     800ec0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800e72:	a1 20 30 80 00       	mov    0x803020,%eax
  800e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e89:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9b:	e8 9b f4 ff ff       	call   80033b <fd2num>
  800ea0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ea5:	83 c4 04             	add    $0x4,%esp
  800ea8:	ff 75 f0             	pushl  -0x10(%ebp)
  800eab:	e8 8b f4 ff ff       	call   80033b <fd2num>
  800eb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebe:	eb 2e                	jmp    800eee <pipe+0x145>
	sys_page_unmap(0, va);
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	56                   	push   %esi
  800ec4:	6a 00                	push   $0x0
  800ec6:	e8 5f f3 ff ff       	call   80022a <sys_page_unmap>
  800ecb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800ece:	83 ec 08             	sub    $0x8,%esp
  800ed1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed4:	6a 00                	push   $0x0
  800ed6:	e8 4f f3 ff ff       	call   80022a <sys_page_unmap>
  800edb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ede:	83 ec 08             	sub    $0x8,%esp
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	6a 00                	push   $0x0
  800ee6:	e8 3f f3 ff ff       	call   80022a <sys_page_unmap>
  800eeb:	83 c4 10             	add    $0x10,%esp
}
  800eee:	89 d8                	mov    %ebx,%eax
  800ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <pipeisclosed>:
{
  800ef7:	f3 0f 1e fb          	endbr32 
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f04:	50                   	push   %eax
  800f05:	ff 75 08             	pushl  0x8(%ebp)
  800f08:	e8 b7 f4 ff ff       	call   8003c4 <fd_lookup>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	78 18                	js     800f2c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1a:	e8 30 f4 ff ff       	call   80034f <fd2data>
  800f1f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f24:	e8 1f fd ff ff       	call   800c48 <_pipeisclosed>
  800f29:	83 c4 10             	add    $0x10,%esp
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f2e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
  800f37:	c3                   	ret    

00800f38 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f38:	f3 0f 1e fb          	endbr32 
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f42:	68 03 20 80 00       	push   $0x802003
  800f47:	ff 75 0c             	pushl  0xc(%ebp)
  800f4a:	e8 c5 07 00 00       	call   801714 <strcpy>
	return 0;
}
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <devcons_write>:
{
  800f56:	f3 0f 1e fb          	endbr32 
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800f66:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800f6b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f71:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f74:	73 31                	jae    800fa7 <devcons_write+0x51>
		m = n - tot;
  800f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f79:	29 f3                	sub    %esi,%ebx
  800f7b:	83 fb 7f             	cmp    $0x7f,%ebx
  800f7e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f83:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	53                   	push   %ebx
  800f8a:	89 f0                	mov    %esi,%eax
  800f8c:	03 45 0c             	add    0xc(%ebp),%eax
  800f8f:	50                   	push   %eax
  800f90:	57                   	push   %edi
  800f91:	e8 36 09 00 00       	call   8018cc <memmove>
		sys_cputs(buf, m);
  800f96:	83 c4 08             	add    $0x8,%esp
  800f99:	53                   	push   %ebx
  800f9a:	57                   	push   %edi
  800f9b:	e8 6d f1 ff ff       	call   80010d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fa0:	01 de                	add    %ebx,%esi
  800fa2:	83 c4 10             	add    $0x10,%esp
  800fa5:	eb ca                	jmp    800f71 <devcons_write+0x1b>
}
  800fa7:	89 f0                	mov    %esi,%eax
  800fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <devcons_read>:
{
  800fb1:	f3 0f 1e fb          	endbr32 
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	74 21                	je     800fe7 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800fc6:	e8 6c f1 ff ff       	call   800137 <sys_cgetc>
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	75 07                	jne    800fd6 <devcons_read+0x25>
		sys_yield();
  800fcf:	e8 d9 f1 ff ff       	call   8001ad <sys_yield>
  800fd4:	eb f0                	jmp    800fc6 <devcons_read+0x15>
	if (c < 0)
  800fd6:	78 0f                	js     800fe7 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800fd8:	83 f8 04             	cmp    $0x4,%eax
  800fdb:	74 0c                	je     800fe9 <devcons_read+0x38>
	*(char*)vbuf = c;
  800fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe0:	88 02                	mov    %al,(%edx)
	return 1;
  800fe2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    
		return 0;
  800fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fee:	eb f7                	jmp    800fe7 <devcons_read+0x36>

00800ff0 <cputchar>:
{
  800ff0:	f3 0f 1e fb          	endbr32 
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801000:	6a 01                	push   $0x1
  801002:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801005:	50                   	push   %eax
  801006:	e8 02 f1 ff ff       	call   80010d <sys_cputs>
}
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <getchar>:
{
  801010:	f3 0f 1e fb          	endbr32 
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80101a:	6a 01                	push   $0x1
  80101c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	6a 00                	push   $0x0
  801022:	e8 20 f6 ff ff       	call   800647 <read>
	if (r < 0)
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 06                	js     801034 <getchar+0x24>
	if (r < 1)
  80102e:	74 06                	je     801036 <getchar+0x26>
	return c;
  801030:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    
		return -E_EOF;
  801036:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80103b:	eb f7                	jmp    801034 <getchar+0x24>

0080103d <iscons>:
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801047:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	ff 75 08             	pushl  0x8(%ebp)
  80104e:	e8 71 f3 ff ff       	call   8003c4 <fd_lookup>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	85 c0                	test   %eax,%eax
  801058:	78 11                	js     80106b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801063:	39 10                	cmp    %edx,(%eax)
  801065:	0f 94 c0             	sete   %al
  801068:	0f b6 c0             	movzbl %al,%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <opencons>:
{
  80106d:	f3 0f 1e fb          	endbr32 
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801077:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	e8 ee f2 ff ff       	call   80036e <fd_alloc>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	78 3a                	js     8010c1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801087:	83 ec 04             	sub    $0x4,%esp
  80108a:	68 07 04 00 00       	push   $0x407
  80108f:	ff 75 f4             	pushl  -0xc(%ebp)
  801092:	6a 00                	push   $0x0
  801094:	e8 3f f1 ff ff       	call   8001d8 <sys_page_alloc>
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 21                	js     8010c1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010a9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	50                   	push   %eax
  8010b9:	e8 7d f2 ff ff       	call   80033b <fd2num>
  8010be:	83 c4 10             	add    $0x10,%esp
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010c3:	f3 0f 1e fb          	endbr32 
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8010cc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8010cf:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8010d5:	e8 ab f0 ff ff       	call   800185 <sys_getenvid>
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	56                   	push   %esi
  8010e4:	50                   	push   %eax
  8010e5:	68 10 20 80 00       	push   $0x802010
  8010ea:	e8 bb 00 00 00       	call   8011aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8010ef:	83 c4 18             	add    $0x18,%esp
  8010f2:	53                   	push   %ebx
  8010f3:	ff 75 10             	pushl  0x10(%ebp)
  8010f6:	e8 5a 00 00 00       	call   801155 <vcprintf>
	cprintf("\n");
  8010fb:	c7 04 24 80 23 80 00 	movl   $0x802380,(%esp)
  801102:	e8 a3 00 00 00       	call   8011aa <cprintf>
  801107:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80110a:	cc                   	int3   
  80110b:	eb fd                	jmp    80110a <_panic+0x47>

0080110d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80110d:	f3 0f 1e fb          	endbr32 
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	53                   	push   %ebx
  801115:	83 ec 04             	sub    $0x4,%esp
  801118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80111b:	8b 13                	mov    (%ebx),%edx
  80111d:	8d 42 01             	lea    0x1(%edx),%eax
  801120:	89 03                	mov    %eax,(%ebx)
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801125:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801129:	3d ff 00 00 00       	cmp    $0xff,%eax
  80112e:	74 09                	je     801139 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801130:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801137:	c9                   	leave  
  801138:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	68 ff 00 00 00       	push   $0xff
  801141:	8d 43 08             	lea    0x8(%ebx),%eax
  801144:	50                   	push   %eax
  801145:	e8 c3 ef ff ff       	call   80010d <sys_cputs>
		b->idx = 0;
  80114a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	eb db                	jmp    801130 <putch+0x23>

00801155 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801155:	f3 0f 1e fb          	endbr32 
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801169:	00 00 00 
	b.cnt = 0;
  80116c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	ff 75 08             	pushl  0x8(%ebp)
  80117c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	68 0d 11 80 00       	push   $0x80110d
  801188:	e8 80 01 00 00       	call   80130d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80118d:	83 c4 08             	add    $0x8,%esp
  801190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80119c:	50                   	push   %eax
  80119d:	e8 6b ef ff ff       	call   80010d <sys_cputs>

	return b.cnt;
}
  8011a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011aa:	f3 0f 1e fb          	endbr32 
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011b7:	50                   	push   %eax
  8011b8:	ff 75 08             	pushl  0x8(%ebp)
  8011bb:	e8 95 ff ff ff       	call   801155 <vcprintf>
	va_end(ap);

	return cnt;
}
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    

008011c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 1c             	sub    $0x1c,%esp
  8011cb:	89 c7                	mov    %eax,%edi
  8011cd:	89 d6                	mov    %edx,%esi
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8011df:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011ef:	39 c2                	cmp    %eax,%edx
  8011f1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8011f4:	72 3e                	jb     801234 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	ff 75 18             	pushl  0x18(%ebp)
  8011fc:	83 eb 01             	sub    $0x1,%ebx
  8011ff:	53                   	push   %ebx
  801200:	50                   	push   %eax
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	ff 75 e4             	pushl  -0x1c(%ebp)
  801207:	ff 75 e0             	pushl  -0x20(%ebp)
  80120a:	ff 75 dc             	pushl  -0x24(%ebp)
  80120d:	ff 75 d8             	pushl  -0x28(%ebp)
  801210:	e8 3b 0a 00 00       	call   801c50 <__udivdi3>
  801215:	83 c4 18             	add    $0x18,%esp
  801218:	52                   	push   %edx
  801219:	50                   	push   %eax
  80121a:	89 f2                	mov    %esi,%edx
  80121c:	89 f8                	mov    %edi,%eax
  80121e:	e8 9f ff ff ff       	call   8011c2 <printnum>
  801223:	83 c4 20             	add    $0x20,%esp
  801226:	eb 13                	jmp    80123b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801228:	83 ec 08             	sub    $0x8,%esp
  80122b:	56                   	push   %esi
  80122c:	ff 75 18             	pushl  0x18(%ebp)
  80122f:	ff d7                	call   *%edi
  801231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801234:	83 eb 01             	sub    $0x1,%ebx
  801237:	85 db                	test   %ebx,%ebx
  801239:	7f ed                	jg     801228 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	56                   	push   %esi
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	ff 75 e4             	pushl  -0x1c(%ebp)
  801245:	ff 75 e0             	pushl  -0x20(%ebp)
  801248:	ff 75 dc             	pushl  -0x24(%ebp)
  80124b:	ff 75 d8             	pushl  -0x28(%ebp)
  80124e:	e8 0d 0b 00 00       	call   801d60 <__umoddi3>
  801253:	83 c4 14             	add    $0x14,%esp
  801256:	0f be 80 33 20 80 00 	movsbl 0x802033(%eax),%eax
  80125d:	50                   	push   %eax
  80125e:	ff d7                	call   *%edi
}
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80126b:	83 fa 01             	cmp    $0x1,%edx
  80126e:	7f 13                	jg     801283 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  801270:	85 d2                	test   %edx,%edx
  801272:	74 1c                	je     801290 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  801274:	8b 10                	mov    (%eax),%edx
  801276:	8d 4a 04             	lea    0x4(%edx),%ecx
  801279:	89 08                	mov    %ecx,(%eax)
  80127b:	8b 02                	mov    (%edx),%eax
  80127d:	ba 00 00 00 00       	mov    $0x0,%edx
  801282:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  801283:	8b 10                	mov    (%eax),%edx
  801285:	8d 4a 08             	lea    0x8(%edx),%ecx
  801288:	89 08                	mov    %ecx,(%eax)
  80128a:	8b 02                	mov    (%edx),%eax
  80128c:	8b 52 04             	mov    0x4(%edx),%edx
  80128f:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  801290:	8b 10                	mov    (%eax),%edx
  801292:	8d 4a 04             	lea    0x4(%edx),%ecx
  801295:	89 08                	mov    %ecx,(%eax)
  801297:	8b 02                	mov    (%edx),%eax
  801299:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80129e:	c3                   	ret    

0080129f <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80129f:	83 fa 01             	cmp    $0x1,%edx
  8012a2:	7f 0f                	jg     8012b3 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  8012a4:	85 d2                	test   %edx,%edx
  8012a6:	74 18                	je     8012c0 <getint+0x21>
		return va_arg(*ap, long);
  8012a8:	8b 10                	mov    (%eax),%edx
  8012aa:	8d 4a 04             	lea    0x4(%edx),%ecx
  8012ad:	89 08                	mov    %ecx,(%eax)
  8012af:	8b 02                	mov    (%edx),%eax
  8012b1:	99                   	cltd   
  8012b2:	c3                   	ret    
		return va_arg(*ap, long long);
  8012b3:	8b 10                	mov    (%eax),%edx
  8012b5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8012b8:	89 08                	mov    %ecx,(%eax)
  8012ba:	8b 02                	mov    (%edx),%eax
  8012bc:	8b 52 04             	mov    0x4(%edx),%edx
  8012bf:	c3                   	ret    
	else
		return va_arg(*ap, int);
  8012c0:	8b 10                	mov    (%eax),%edx
  8012c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8012c5:	89 08                	mov    %ecx,(%eax)
  8012c7:	8b 02                	mov    (%edx),%eax
  8012c9:	99                   	cltd   
}
  8012ca:	c3                   	ret    

008012cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012cb:	f3 0f 1e fb          	endbr32 
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012d9:	8b 10                	mov    (%eax),%edx
  8012db:	3b 50 04             	cmp    0x4(%eax),%edx
  8012de:	73 0a                	jae    8012ea <sprintputch+0x1f>
		*b->buf++ = ch;
  8012e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e3:	89 08                	mov    %ecx,(%eax)
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	88 02                	mov    %al,(%edx)
}
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <printfmt>:
{
  8012ec:	f3 0f 1e fb          	endbr32 
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012f6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012f9:	50                   	push   %eax
  8012fa:	ff 75 10             	pushl  0x10(%ebp)
  8012fd:	ff 75 0c             	pushl  0xc(%ebp)
  801300:	ff 75 08             	pushl  0x8(%ebp)
  801303:	e8 05 00 00 00       	call   80130d <vprintfmt>
}
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <vprintfmt>:
{
  80130d:	f3 0f 1e fb          	endbr32 
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	57                   	push   %edi
  801315:	56                   	push   %esi
  801316:	53                   	push   %ebx
  801317:	83 ec 2c             	sub    $0x2c,%esp
  80131a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80131d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801320:	8b 7d 10             	mov    0x10(%ebp),%edi
  801323:	e9 86 02 00 00       	jmp    8015ae <vprintfmt+0x2a1>
		padc = ' ';
  801328:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80132c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801333:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80133a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801341:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801346:	8d 47 01             	lea    0x1(%edi),%eax
  801349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80134c:	0f b6 17             	movzbl (%edi),%edx
  80134f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801352:	3c 55                	cmp    $0x55,%al
  801354:	0f 87 df 02 00 00    	ja     801639 <vprintfmt+0x32c>
  80135a:	0f b6 c0             	movzbl %al,%eax
  80135d:	3e ff 24 85 80 21 80 	notrack jmp *0x802180(,%eax,4)
  801364:	00 
  801365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801368:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80136c:	eb d8                	jmp    801346 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80136e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801371:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801375:	eb cf                	jmp    801346 <vprintfmt+0x39>
  801377:	0f b6 d2             	movzbl %dl,%edx
  80137a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801385:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801388:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80138c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80138f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801392:	83 f9 09             	cmp    $0x9,%ecx
  801395:	77 52                	ja     8013e9 <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  801397:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80139a:	eb e9                	jmp    801385 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80139c:	8b 45 14             	mov    0x14(%ebp),%eax
  80139f:	8d 50 04             	lea    0x4(%eax),%edx
  8013a2:	89 55 14             	mov    %edx,0x14(%ebp)
  8013a5:	8b 00                	mov    (%eax),%eax
  8013a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b1:	79 93                	jns    801346 <vprintfmt+0x39>
				width = precision, precision = -1;
  8013b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8013c0:	eb 84                	jmp    801346 <vprintfmt+0x39>
  8013c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cc:	0f 49 d0             	cmovns %eax,%edx
  8013cf:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013d5:	e9 6c ff ff ff       	jmp    801346 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013dd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013e4:	e9 5d ff ff ff       	jmp    801346 <vprintfmt+0x39>
  8013e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013ef:	eb bc                	jmp    8013ad <vprintfmt+0xa0>
			lflag++;
  8013f1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013f7:	e9 4a ff ff ff       	jmp    801346 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ff:	8d 50 04             	lea    0x4(%eax),%edx
  801402:	89 55 14             	mov    %edx,0x14(%ebp)
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	56                   	push   %esi
  801409:	ff 30                	pushl  (%eax)
  80140b:	ff d3                	call   *%ebx
			break;
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	e9 96 01 00 00       	jmp    8015ab <vprintfmt+0x29e>
			err = va_arg(ap, int);
  801415:	8b 45 14             	mov    0x14(%ebp),%eax
  801418:	8d 50 04             	lea    0x4(%eax),%edx
  80141b:	89 55 14             	mov    %edx,0x14(%ebp)
  80141e:	8b 00                	mov    (%eax),%eax
  801420:	99                   	cltd   
  801421:	31 d0                	xor    %edx,%eax
  801423:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801425:	83 f8 0f             	cmp    $0xf,%eax
  801428:	7f 20                	jg     80144a <vprintfmt+0x13d>
  80142a:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  801431:	85 d2                	test   %edx,%edx
  801433:	74 15                	je     80144a <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  801435:	52                   	push   %edx
  801436:	68 c3 1f 80 00       	push   $0x801fc3
  80143b:	56                   	push   %esi
  80143c:	53                   	push   %ebx
  80143d:	e8 aa fe ff ff       	call   8012ec <printfmt>
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	e9 61 01 00 00       	jmp    8015ab <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  80144a:	50                   	push   %eax
  80144b:	68 4b 20 80 00       	push   $0x80204b
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	e8 95 fe ff ff       	call   8012ec <printfmt>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	e9 4c 01 00 00       	jmp    8015ab <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8d 50 04             	lea    0x4(%eax),%edx
  801465:	89 55 14             	mov    %edx,0x14(%ebp)
  801468:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80146a:	85 c9                	test   %ecx,%ecx
  80146c:	b8 44 20 80 00       	mov    $0x802044,%eax
  801471:	0f 45 c1             	cmovne %ecx,%eax
  801474:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80147b:	7e 06                	jle    801483 <vprintfmt+0x176>
  80147d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801481:	75 0d                	jne    801490 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  801483:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801486:	89 c7                	mov    %eax,%edi
  801488:	03 45 e0             	add    -0x20(%ebp),%eax
  80148b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80148e:	eb 57                	jmp    8014e7 <vprintfmt+0x1da>
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	ff 75 d8             	pushl  -0x28(%ebp)
  801496:	ff 75 cc             	pushl  -0x34(%ebp)
  801499:	e8 4f 02 00 00       	call   8016ed <strnlen>
  80149e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014a1:	29 c2                	sub    %eax,%edx
  8014a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014a6:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014a9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8014ad:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8014b0:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b2:	85 db                	test   %ebx,%ebx
  8014b4:	7e 10                	jle    8014c6 <vprintfmt+0x1b9>
					putch(padc, putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	56                   	push   %esi
  8014ba:	57                   	push   %edi
  8014bb:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8014be:	83 eb 01             	sub    $0x1,%ebx
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	eb ec                	jmp    8014b2 <vprintfmt+0x1a5>
  8014c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014cc:	85 d2                	test   %edx,%edx
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	0f 49 c2             	cmovns %edx,%eax
  8014d6:	29 c2                	sub    %eax,%edx
  8014d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014db:	eb a6                	jmp    801483 <vprintfmt+0x176>
					putch(ch, putdat);
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	56                   	push   %esi
  8014e1:	52                   	push   %edx
  8014e2:	ff d3                	call   *%ebx
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014ea:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ec:	83 c7 01             	add    $0x1,%edi
  8014ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014f3:	0f be d0             	movsbl %al,%edx
  8014f6:	85 d2                	test   %edx,%edx
  8014f8:	74 42                	je     80153c <vprintfmt+0x22f>
  8014fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014fe:	78 06                	js     801506 <vprintfmt+0x1f9>
  801500:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801504:	78 1e                	js     801524 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  801506:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80150a:	74 d1                	je     8014dd <vprintfmt+0x1d0>
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	83 e8 20             	sub    $0x20,%eax
  801512:	83 f8 5e             	cmp    $0x5e,%eax
  801515:	76 c6                	jbe    8014dd <vprintfmt+0x1d0>
					putch('?', putdat);
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	56                   	push   %esi
  80151b:	6a 3f                	push   $0x3f
  80151d:	ff d3                	call   *%ebx
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	eb c3                	jmp    8014e7 <vprintfmt+0x1da>
  801524:	89 cf                	mov    %ecx,%edi
  801526:	eb 0e                	jmp    801536 <vprintfmt+0x229>
				putch(' ', putdat);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	56                   	push   %esi
  80152c:	6a 20                	push   $0x20
  80152e:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  801530:	83 ef 01             	sub    $0x1,%edi
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 ff                	test   %edi,%edi
  801538:	7f ee                	jg     801528 <vprintfmt+0x21b>
  80153a:	eb 6f                	jmp    8015ab <vprintfmt+0x29e>
  80153c:	89 cf                	mov    %ecx,%edi
  80153e:	eb f6                	jmp    801536 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  801540:	89 ca                	mov    %ecx,%edx
  801542:	8d 45 14             	lea    0x14(%ebp),%eax
  801545:	e8 55 fd ff ff       	call   80129f <getint>
  80154a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80154d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801550:	85 d2                	test   %edx,%edx
  801552:	78 0b                	js     80155f <vprintfmt+0x252>
			num = getint(&ap, lflag);
  801554:	89 d1                	mov    %edx,%ecx
  801556:	89 c2                	mov    %eax,%edx
			base = 10;
  801558:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155d:	eb 32                	jmp    801591 <vprintfmt+0x284>
				putch('-', putdat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	56                   	push   %esi
  801563:	6a 2d                	push   $0x2d
  801565:	ff d3                	call   *%ebx
				num = -(long long) num;
  801567:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80156a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80156d:	f7 da                	neg    %edx
  80156f:	83 d1 00             	adc    $0x0,%ecx
  801572:	f7 d9                	neg    %ecx
  801574:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801577:	b8 0a 00 00 00       	mov    $0xa,%eax
  80157c:	eb 13                	jmp    801591 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  80157e:	89 ca                	mov    %ecx,%edx
  801580:	8d 45 14             	lea    0x14(%ebp),%eax
  801583:	e8 e3 fc ff ff       	call   80126b <getuint>
  801588:	89 d1                	mov    %edx,%ecx
  80158a:	89 c2                	mov    %eax,%edx
			base = 10;
  80158c:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801598:	57                   	push   %edi
  801599:	ff 75 e0             	pushl  -0x20(%ebp)
  80159c:	50                   	push   %eax
  80159d:	51                   	push   %ecx
  80159e:	52                   	push   %edx
  80159f:	89 f2                	mov    %esi,%edx
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	e8 1a fc ff ff       	call   8011c2 <printnum>
			break;
  8015a8:	83 c4 20             	add    $0x20,%esp
{
  8015ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015ae:	83 c7 01             	add    $0x1,%edi
  8015b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8015b5:	83 f8 25             	cmp    $0x25,%eax
  8015b8:	0f 84 6a fd ff ff    	je     801328 <vprintfmt+0x1b>
			if (ch == '\0')
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	0f 84 93 00 00 00    	je     801659 <vprintfmt+0x34c>
			putch(ch, putdat);
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	56                   	push   %esi
  8015ca:	50                   	push   %eax
  8015cb:	ff d3                	call   *%ebx
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	eb dc                	jmp    8015ae <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  8015d2:	89 ca                	mov    %ecx,%edx
  8015d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8015d7:	e8 8f fc ff ff       	call   80126b <getuint>
  8015dc:	89 d1                	mov    %edx,%ecx
  8015de:	89 c2                	mov    %eax,%edx
			base = 8;
  8015e0:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8015e5:	eb aa                	jmp    801591 <vprintfmt+0x284>
			putch('0', putdat);
  8015e7:	83 ec 08             	sub    $0x8,%esp
  8015ea:	56                   	push   %esi
  8015eb:	6a 30                	push   $0x30
  8015ed:	ff d3                	call   *%ebx
			putch('x', putdat);
  8015ef:	83 c4 08             	add    $0x8,%esp
  8015f2:	56                   	push   %esi
  8015f3:	6a 78                	push   $0x78
  8015f5:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  8015f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fa:	8d 50 04             	lea    0x4(%eax),%edx
  8015fd:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  801600:	8b 10                	mov    (%eax),%edx
  801602:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801607:	83 c4 10             	add    $0x10,%esp
			base = 16;
  80160a:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80160f:	eb 80                	jmp    801591 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  801611:	89 ca                	mov    %ecx,%edx
  801613:	8d 45 14             	lea    0x14(%ebp),%eax
  801616:	e8 50 fc ff ff       	call   80126b <getuint>
  80161b:	89 d1                	mov    %edx,%ecx
  80161d:	89 c2                	mov    %eax,%edx
			base = 16;
  80161f:	b8 10 00 00 00       	mov    $0x10,%eax
  801624:	e9 68 ff ff ff       	jmp    801591 <vprintfmt+0x284>
			putch(ch, putdat);
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	56                   	push   %esi
  80162d:	6a 25                	push   $0x25
  80162f:	ff d3                	call   *%ebx
			break;
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	e9 72 ff ff ff       	jmp    8015ab <vprintfmt+0x29e>
			putch('%', putdat);
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	56                   	push   %esi
  80163d:	6a 25                	push   $0x25
  80163f:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	89 f8                	mov    %edi,%eax
  801646:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80164a:	74 05                	je     801651 <vprintfmt+0x344>
  80164c:	83 e8 01             	sub    $0x1,%eax
  80164f:	eb f5                	jmp    801646 <vprintfmt+0x339>
  801651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801654:	e9 52 ff ff ff       	jmp    8015ab <vprintfmt+0x29e>
}
  801659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    

00801661 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801661:	f3 0f 1e fb          	endbr32 
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 18             	sub    $0x18,%esp
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801671:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801674:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801678:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80167b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801682:	85 c0                	test   %eax,%eax
  801684:	74 26                	je     8016ac <vsnprintf+0x4b>
  801686:	85 d2                	test   %edx,%edx
  801688:	7e 22                	jle    8016ac <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80168a:	ff 75 14             	pushl  0x14(%ebp)
  80168d:	ff 75 10             	pushl  0x10(%ebp)
  801690:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801693:	50                   	push   %eax
  801694:	68 cb 12 80 00       	push   $0x8012cb
  801699:	e8 6f fc ff ff       	call   80130d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	83 c4 10             	add    $0x10,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    
		return -E_INVAL;
  8016ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b1:	eb f7                	jmp    8016aa <vsnprintf+0x49>

008016b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016b3:	f3 0f 1e fb          	endbr32 
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8016bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	e8 92 ff ff ff       	call   801661 <vsnprintf>
	va_end(ap);

	return rc;
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016d1:	f3 0f 1e fb          	endbr32 
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016e4:	74 05                	je     8016eb <strlen+0x1a>
		n++;
  8016e6:	83 c0 01             	add    $0x1,%eax
  8016e9:	eb f5                	jmp    8016e0 <strlen+0xf>
	return n;
}
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ed:	f3 0f 1e fb          	endbr32 
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	39 d0                	cmp    %edx,%eax
  801701:	74 0d                	je     801710 <strnlen+0x23>
  801703:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801707:	74 05                	je     80170e <strnlen+0x21>
		n++;
  801709:	83 c0 01             	add    $0x1,%eax
  80170c:	eb f1                	jmp    8016ff <strnlen+0x12>
  80170e:	89 c2                	mov    %eax,%edx
	return n;
}
  801710:	89 d0                	mov    %edx,%eax
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801714:	f3 0f 1e fb          	endbr32 
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	53                   	push   %ebx
  80171c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80172b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80172e:	83 c0 01             	add    $0x1,%eax
  801731:	84 d2                	test   %dl,%dl
  801733:	75 f2                	jne    801727 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801735:	89 c8                	mov    %ecx,%eax
  801737:	5b                   	pop    %ebx
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80173a:	f3 0f 1e fb          	endbr32 
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 10             	sub    $0x10,%esp
  801745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801748:	53                   	push   %ebx
  801749:	e8 83 ff ff ff       	call   8016d1 <strlen>
  80174e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	01 d8                	add    %ebx,%eax
  801756:	50                   	push   %eax
  801757:	e8 b8 ff ff ff       	call   801714 <strcpy>
	return dst;
}
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801763:	f3 0f 1e fb          	endbr32 
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 75 08             	mov    0x8(%ebp),%esi
  80176f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801772:	89 f3                	mov    %esi,%ebx
  801774:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801777:	89 f0                	mov    %esi,%eax
  801779:	39 d8                	cmp    %ebx,%eax
  80177b:	74 11                	je     80178e <strncpy+0x2b>
		*dst++ = *src;
  80177d:	83 c0 01             	add    $0x1,%eax
  801780:	0f b6 0a             	movzbl (%edx),%ecx
  801783:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801786:	80 f9 01             	cmp    $0x1,%cl
  801789:	83 da ff             	sbb    $0xffffffff,%edx
  80178c:	eb eb                	jmp    801779 <strncpy+0x16>
	}
	return ret;
}
  80178e:	89 f0                	mov    %esi,%eax
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801794:	f3 0f 1e fb          	endbr32 
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
  80179d:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8017a6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8017a8:	85 d2                	test   %edx,%edx
  8017aa:	74 21                	je     8017cd <strlcpy+0x39>
  8017ac:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8017b0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8017b2:	39 c2                	cmp    %eax,%edx
  8017b4:	74 14                	je     8017ca <strlcpy+0x36>
  8017b6:	0f b6 19             	movzbl (%ecx),%ebx
  8017b9:	84 db                	test   %bl,%bl
  8017bb:	74 0b                	je     8017c8 <strlcpy+0x34>
			*dst++ = *src++;
  8017bd:	83 c1 01             	add    $0x1,%ecx
  8017c0:	83 c2 01             	add    $0x1,%edx
  8017c3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8017c6:	eb ea                	jmp    8017b2 <strlcpy+0x1e>
  8017c8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8017ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8017cd:	29 f0                	sub    %esi,%eax
}
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017d3:	f3 0f 1e fb          	endbr32 
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017e0:	0f b6 01             	movzbl (%ecx),%eax
  8017e3:	84 c0                	test   %al,%al
  8017e5:	74 0c                	je     8017f3 <strcmp+0x20>
  8017e7:	3a 02                	cmp    (%edx),%al
  8017e9:	75 08                	jne    8017f3 <strcmp+0x20>
		p++, q++;
  8017eb:	83 c1 01             	add    $0x1,%ecx
  8017ee:	83 c2 01             	add    $0x1,%edx
  8017f1:	eb ed                	jmp    8017e0 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017f3:	0f b6 c0             	movzbl %al,%eax
  8017f6:	0f b6 12             	movzbl (%edx),%edx
  8017f9:	29 d0                	sub    %edx,%eax
}
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017fd:	f3 0f 1e fb          	endbr32 
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801810:	eb 06                	jmp    801818 <strncmp+0x1b>
		n--, p++, q++;
  801812:	83 c0 01             	add    $0x1,%eax
  801815:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801818:	39 d8                	cmp    %ebx,%eax
  80181a:	74 16                	je     801832 <strncmp+0x35>
  80181c:	0f b6 08             	movzbl (%eax),%ecx
  80181f:	84 c9                	test   %cl,%cl
  801821:	74 04                	je     801827 <strncmp+0x2a>
  801823:	3a 0a                	cmp    (%edx),%cl
  801825:	74 eb                	je     801812 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801827:	0f b6 00             	movzbl (%eax),%eax
  80182a:	0f b6 12             	movzbl (%edx),%edx
  80182d:	29 d0                	sub    %edx,%eax
}
  80182f:	5b                   	pop    %ebx
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    
		return 0;
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	eb f6                	jmp    80182f <strncmp+0x32>

00801839 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801847:	0f b6 10             	movzbl (%eax),%edx
  80184a:	84 d2                	test   %dl,%dl
  80184c:	74 09                	je     801857 <strchr+0x1e>
		if (*s == c)
  80184e:	38 ca                	cmp    %cl,%dl
  801850:	74 0a                	je     80185c <strchr+0x23>
	for (; *s; s++)
  801852:	83 c0 01             	add    $0x1,%eax
  801855:	eb f0                	jmp    801847 <strchr+0xe>
			return (char *) s;
	return 0;
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80185e:	f3 0f 1e fb          	endbr32 
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80186c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80186f:	38 ca                	cmp    %cl,%dl
  801871:	74 09                	je     80187c <strfind+0x1e>
  801873:	84 d2                	test   %dl,%dl
  801875:	74 05                	je     80187c <strfind+0x1e>
	for (; *s; s++)
  801877:	83 c0 01             	add    $0x1,%eax
  80187a:	eb f0                	jmp    80186c <strfind+0xe>
			break;
	return (char *) s;
}
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    

0080187e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80187e:	f3 0f 1e fb          	endbr32 
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	57                   	push   %edi
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	8b 55 08             	mov    0x8(%ebp),%edx
  80188b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80188e:	85 c9                	test   %ecx,%ecx
  801890:	74 33                	je     8018c5 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801892:	89 d0                	mov    %edx,%eax
  801894:	09 c8                	or     %ecx,%eax
  801896:	a8 03                	test   $0x3,%al
  801898:	75 23                	jne    8018bd <memset+0x3f>
		c &= 0xFF;
  80189a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	c1 e0 08             	shl    $0x8,%eax
  8018a3:	89 df                	mov    %ebx,%edi
  8018a5:	c1 e7 18             	shl    $0x18,%edi
  8018a8:	89 de                	mov    %ebx,%esi
  8018aa:	c1 e6 10             	shl    $0x10,%esi
  8018ad:	09 f7                	or     %esi,%edi
  8018af:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8018b1:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8018b4:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  8018b6:	89 d7                	mov    %edx,%edi
  8018b8:	fc                   	cld    
  8018b9:	f3 ab                	rep stos %eax,%es:(%edi)
  8018bb:	eb 08                	jmp    8018c5 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8018bd:	89 d7                	mov    %edx,%edi
  8018bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c2:	fc                   	cld    
  8018c3:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8018c5:	89 d0                	mov    %edx,%eax
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    

008018cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8018cc:	f3 0f 1e fb          	endbr32 
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	57                   	push   %edi
  8018d4:	56                   	push   %esi
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018de:	39 c6                	cmp    %eax,%esi
  8018e0:	73 32                	jae    801914 <memmove+0x48>
  8018e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018e5:	39 c2                	cmp    %eax,%edx
  8018e7:	76 2b                	jbe    801914 <memmove+0x48>
		s += n;
		d += n;
  8018e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ec:	89 fe                	mov    %edi,%esi
  8018ee:	09 ce                	or     %ecx,%esi
  8018f0:	09 d6                	or     %edx,%esi
  8018f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018f8:	75 0e                	jne    801908 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018fa:	83 ef 04             	sub    $0x4,%edi
  8018fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  801900:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801903:	fd                   	std    
  801904:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801906:	eb 09                	jmp    801911 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801908:	83 ef 01             	sub    $0x1,%edi
  80190b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80190e:	fd                   	std    
  80190f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801911:	fc                   	cld    
  801912:	eb 1a                	jmp    80192e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801914:	89 c2                	mov    %eax,%edx
  801916:	09 ca                	or     %ecx,%edx
  801918:	09 f2                	or     %esi,%edx
  80191a:	f6 c2 03             	test   $0x3,%dl
  80191d:	75 0a                	jne    801929 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80191f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801922:	89 c7                	mov    %eax,%edi
  801924:	fc                   	cld    
  801925:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801927:	eb 05                	jmp    80192e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801929:	89 c7                	mov    %eax,%edi
  80192b:	fc                   	cld    
  80192c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80192e:	5e                   	pop    %esi
  80192f:	5f                   	pop    %edi
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    

00801932 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801932:	f3 0f 1e fb          	endbr32 
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80193c:	ff 75 10             	pushl  0x10(%ebp)
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	e8 82 ff ff ff       	call   8018cc <memmove>
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80194c:	f3 0f 1e fb          	endbr32 
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	89 c6                	mov    %eax,%esi
  80195d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801960:	39 f0                	cmp    %esi,%eax
  801962:	74 1c                	je     801980 <memcmp+0x34>
		if (*s1 != *s2)
  801964:	0f b6 08             	movzbl (%eax),%ecx
  801967:	0f b6 1a             	movzbl (%edx),%ebx
  80196a:	38 d9                	cmp    %bl,%cl
  80196c:	75 08                	jne    801976 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80196e:	83 c0 01             	add    $0x1,%eax
  801971:	83 c2 01             	add    $0x1,%edx
  801974:	eb ea                	jmp    801960 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801976:	0f b6 c1             	movzbl %cl,%eax
  801979:	0f b6 db             	movzbl %bl,%ebx
  80197c:	29 d8                	sub    %ebx,%eax
  80197e:	eb 05                	jmp    801985 <memcmp+0x39>
	}

	return 0;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801989:	f3 0f 1e fb          	endbr32 
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801996:	89 c2                	mov    %eax,%edx
  801998:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80199b:	39 d0                	cmp    %edx,%eax
  80199d:	73 09                	jae    8019a8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80199f:	38 08                	cmp    %cl,(%eax)
  8019a1:	74 05                	je     8019a8 <memfind+0x1f>
	for (; s < ends; s++)
  8019a3:	83 c0 01             	add    $0x1,%eax
  8019a6:	eb f3                	jmp    80199b <memfind+0x12>
			break;
	return (void *) s;
}
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019aa:	f3 0f 1e fb          	endbr32 
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ba:	eb 03                	jmp    8019bf <strtol+0x15>
		s++;
  8019bc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8019bf:	0f b6 01             	movzbl (%ecx),%eax
  8019c2:	3c 20                	cmp    $0x20,%al
  8019c4:	74 f6                	je     8019bc <strtol+0x12>
  8019c6:	3c 09                	cmp    $0x9,%al
  8019c8:	74 f2                	je     8019bc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8019ca:	3c 2b                	cmp    $0x2b,%al
  8019cc:	74 2a                	je     8019f8 <strtol+0x4e>
	int neg = 0;
  8019ce:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8019d3:	3c 2d                	cmp    $0x2d,%al
  8019d5:	74 2b                	je     801a02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8019dd:	75 0f                	jne    8019ee <strtol+0x44>
  8019df:	80 39 30             	cmpb   $0x30,(%ecx)
  8019e2:	74 28                	je     801a0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019e4:	85 db                	test   %ebx,%ebx
  8019e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019eb:	0f 44 d8             	cmove  %eax,%ebx
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019f6:	eb 46                	jmp    801a3e <strtol+0x94>
		s++;
  8019f8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801a00:	eb d5                	jmp    8019d7 <strtol+0x2d>
		s++, neg = 1;
  801a02:	83 c1 01             	add    $0x1,%ecx
  801a05:	bf 01 00 00 00       	mov    $0x1,%edi
  801a0a:	eb cb                	jmp    8019d7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801a10:	74 0e                	je     801a20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801a12:	85 db                	test   %ebx,%ebx
  801a14:	75 d8                	jne    8019ee <strtol+0x44>
		s++, base = 8;
  801a16:	83 c1 01             	add    $0x1,%ecx
  801a19:	bb 08 00 00 00       	mov    $0x8,%ebx
  801a1e:	eb ce                	jmp    8019ee <strtol+0x44>
		s += 2, base = 16;
  801a20:	83 c1 02             	add    $0x2,%ecx
  801a23:	bb 10 00 00 00       	mov    $0x10,%ebx
  801a28:	eb c4                	jmp    8019ee <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801a2a:	0f be d2             	movsbl %dl,%edx
  801a2d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801a30:	3b 55 10             	cmp    0x10(%ebp),%edx
  801a33:	7d 3a                	jge    801a6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801a35:	83 c1 01             	add    $0x1,%ecx
  801a38:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a3e:	0f b6 11             	movzbl (%ecx),%edx
  801a41:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a44:	89 f3                	mov    %esi,%ebx
  801a46:	80 fb 09             	cmp    $0x9,%bl
  801a49:	76 df                	jbe    801a2a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801a4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  801a4e:	89 f3                	mov    %esi,%ebx
  801a50:	80 fb 19             	cmp    $0x19,%bl
  801a53:	77 08                	ja     801a5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  801a55:	0f be d2             	movsbl %dl,%edx
  801a58:	83 ea 57             	sub    $0x57,%edx
  801a5b:	eb d3                	jmp    801a30 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801a5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a60:	89 f3                	mov    %esi,%ebx
  801a62:	80 fb 19             	cmp    $0x19,%bl
  801a65:	77 08                	ja     801a6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a67:	0f be d2             	movsbl %dl,%edx
  801a6a:	83 ea 37             	sub    $0x37,%edx
  801a6d:	eb c1                	jmp    801a30 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a73:	74 05                	je     801a7a <strtol+0xd0>
		*endptr = (char *) s;
  801a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a7a:	89 c2                	mov    %eax,%edx
  801a7c:	f7 da                	neg    %edx
  801a7e:	85 ff                	test   %edi,%edi
  801a80:	0f 45 c2             	cmovne %edx,%eax
}
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a88:	f3 0f 1e fb          	endbr32 
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801a92:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801a99:	74 0a                	je     801aa5 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  801aa5:	a1 04 40 80 00       	mov    0x804004,%eax
  801aaa:	8b 40 48             	mov    0x48(%eax),%eax
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	6a 07                	push   $0x7
  801ab2:	68 00 f0 bf ee       	push   $0xeebff000
  801ab7:	50                   	push   %eax
  801ab8:	e8 1b e7 ff ff       	call   8001d8 <sys_page_alloc>
		if (r!= 0)
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	75 2f                	jne    801af3 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801ac4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac9:	8b 40 48             	mov    0x48(%eax),%eax
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	68 15 03 80 00       	push   $0x800315
  801ad4:	50                   	push   %eax
  801ad5:	e8 c5 e7 ff ff       	call   80029f <sys_env_set_pgfault_upcall>
		if (r!= 0)
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	74 ba                	je     801a9b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  801ae1:	50                   	push   %eax
  801ae2:	68 3f 23 80 00       	push   $0x80233f
  801ae7:	6a 26                	push   $0x26
  801ae9:	68 57 23 80 00       	push   $0x802357
  801aee:	e8 d0 f5 ff ff       	call   8010c3 <_panic>
			panic("set_pgfault_handler: %e", r);
  801af3:	50                   	push   %eax
  801af4:	68 3f 23 80 00       	push   $0x80233f
  801af9:	6a 22                	push   $0x22
  801afb:	68 57 23 80 00       	push   $0x802357
  801b00:	e8 be f5 ff ff       	call   8010c3 <_panic>

00801b05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b05:	f3 0f 1e fb          	endbr32 
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	8b 75 08             	mov    0x8(%ebp),%esi
  801b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  801b17:	85 c0                	test   %eax,%eax
  801b19:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b1e:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	50                   	push   %eax
  801b25:	e8 c5 e7 ff ff       	call   8002ef <sys_ipc_recv>
	if (r < 0) {
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 2b                	js     801b5c <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  801b31:	85 f6                	test   %esi,%esi
  801b33:	74 0a                	je     801b3f <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  801b35:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3a:	8b 40 74             	mov    0x74(%eax),%eax
  801b3d:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  801b3f:	85 db                	test   %ebx,%ebx
  801b41:	74 0a                	je     801b4d <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  801b43:	a1 04 40 80 00       	mov    0x804004,%eax
  801b48:	8b 40 78             	mov    0x78(%eax),%eax
  801b4b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801b4d:	a1 04 40 80 00       	mov    0x804004,%eax
  801b52:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
		if (from_env_store) {
  801b5c:	85 f6                	test   %esi,%esi
  801b5e:	74 06                	je     801b66 <ipc_recv+0x61>
			*from_env_store = 0;
  801b60:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  801b66:	85 db                	test   %ebx,%ebx
  801b68:	74 eb                	je     801b55 <ipc_recv+0x50>
			*perm_store = 0;
  801b6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b70:	eb e3                	jmp    801b55 <ipc_recv+0x50>

00801b72 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b72:	f3 0f 1e fb          	endbr32 
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	57                   	push   %edi
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b82:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  801b88:	85 db                	test   %ebx,%ebx
  801b8a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b8f:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	53                   	push   %ebx
  801b96:	56                   	push   %esi
  801b97:	57                   	push   %edi
  801b98:	e8 29 e7 ff ff       	call   8002c6 <sys_ipc_try_send>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ba3:	75 07                	jne    801bac <ipc_send+0x3a>
		sys_yield();
  801ba5:	e8 03 e6 ff ff       	call   8001ad <sys_yield>
  801baa:	eb e6                	jmp    801b92 <ipc_send+0x20>
	}

	if (ret < 0) {
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 08                	js     801bb8 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  801bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  801bb8:	50                   	push   %eax
  801bb9:	68 65 23 80 00       	push   $0x802365
  801bbe:	6a 48                	push   $0x48
  801bc0:	68 82 23 80 00       	push   $0x802382
  801bc5:	e8 f9 f4 ff ff       	call   8010c3 <_panic>

00801bca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bca:	f3 0f 1e fb          	endbr32 
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bd9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bdc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801be2:	8b 52 50             	mov    0x50(%edx),%edx
  801be5:	39 ca                	cmp    %ecx,%edx
  801be7:	74 11                	je     801bfa <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801be9:	83 c0 01             	add    $0x1,%eax
  801bec:	3d 00 04 00 00       	cmp    $0x400,%eax
  801bf1:	75 e6                	jne    801bd9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	eb 0b                	jmp    801c05 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801bfa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bfd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c02:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    

00801c07 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c07:	f3 0f 1e fb          	endbr32 
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c11:	89 c2                	mov    %eax,%edx
  801c13:	c1 ea 16             	shr    $0x16,%edx
  801c16:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c1d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c22:	f6 c1 01             	test   $0x1,%cl
  801c25:	74 1c                	je     801c43 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c27:	c1 e8 0c             	shr    $0xc,%eax
  801c2a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c31:	a8 01                	test   $0x1,%al
  801c33:	74 0e                	je     801c43 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c35:	c1 e8 0c             	shr    $0xc,%eax
  801c38:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c3f:	ef 
  801c40:	0f b7 d2             	movzwl %dx,%edx
}
  801c43:	89 d0                	mov    %edx,%eax
  801c45:	5d                   	pop    %ebp
  801c46:	c3                   	ret    
  801c47:	66 90                	xchg   %ax,%ax
  801c49:	66 90                	xchg   %ax,%ax
  801c4b:	66 90                	xchg   %ax,%ax
  801c4d:	66 90                	xchg   %ax,%ax
  801c4f:	90                   	nop

00801c50 <__udivdi3>:
  801c50:	f3 0f 1e fb          	endbr32 
  801c54:	55                   	push   %ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c6b:	85 d2                	test   %edx,%edx
  801c6d:	75 19                	jne    801c88 <__udivdi3+0x38>
  801c6f:	39 f3                	cmp    %esi,%ebx
  801c71:	76 4d                	jbe    801cc0 <__udivdi3+0x70>
  801c73:	31 ff                	xor    %edi,%edi
  801c75:	89 e8                	mov    %ebp,%eax
  801c77:	89 f2                	mov    %esi,%edx
  801c79:	f7 f3                	div    %ebx
  801c7b:	89 fa                	mov    %edi,%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	39 f2                	cmp    %esi,%edx
  801c8a:	76 14                	jbe    801ca0 <__udivdi3+0x50>
  801c8c:	31 ff                	xor    %edi,%edi
  801c8e:	31 c0                	xor    %eax,%eax
  801c90:	89 fa                	mov    %edi,%edx
  801c92:	83 c4 1c             	add    $0x1c,%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
  801c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ca0:	0f bd fa             	bsr    %edx,%edi
  801ca3:	83 f7 1f             	xor    $0x1f,%edi
  801ca6:	75 48                	jne    801cf0 <__udivdi3+0xa0>
  801ca8:	39 f2                	cmp    %esi,%edx
  801caa:	72 06                	jb     801cb2 <__udivdi3+0x62>
  801cac:	31 c0                	xor    %eax,%eax
  801cae:	39 eb                	cmp    %ebp,%ebx
  801cb0:	77 de                	ja     801c90 <__udivdi3+0x40>
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	eb d7                	jmp    801c90 <__udivdi3+0x40>
  801cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cc0:	89 d9                	mov    %ebx,%ecx
  801cc2:	85 db                	test   %ebx,%ebx
  801cc4:	75 0b                	jne    801cd1 <__udivdi3+0x81>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	f7 f3                	div    %ebx
  801ccf:	89 c1                	mov    %eax,%ecx
  801cd1:	31 d2                	xor    %edx,%edx
  801cd3:	89 f0                	mov    %esi,%eax
  801cd5:	f7 f1                	div    %ecx
  801cd7:	89 c6                	mov    %eax,%esi
  801cd9:	89 e8                	mov    %ebp,%eax
  801cdb:	89 f7                	mov    %esi,%edi
  801cdd:	f7 f1                	div    %ecx
  801cdf:	89 fa                	mov    %edi,%edx
  801ce1:	83 c4 1c             	add    $0x1c,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5f                   	pop    %edi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	89 f9                	mov    %edi,%ecx
  801cf2:	b8 20 00 00 00       	mov    $0x20,%eax
  801cf7:	29 f8                	sub    %edi,%eax
  801cf9:	d3 e2                	shl    %cl,%edx
  801cfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cff:	89 c1                	mov    %eax,%ecx
  801d01:	89 da                	mov    %ebx,%edx
  801d03:	d3 ea                	shr    %cl,%edx
  801d05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d09:	09 d1                	or     %edx,%ecx
  801d0b:	89 f2                	mov    %esi,%edx
  801d0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d11:	89 f9                	mov    %edi,%ecx
  801d13:	d3 e3                	shl    %cl,%ebx
  801d15:	89 c1                	mov    %eax,%ecx
  801d17:	d3 ea                	shr    %cl,%edx
  801d19:	89 f9                	mov    %edi,%ecx
  801d1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d1f:	89 eb                	mov    %ebp,%ebx
  801d21:	d3 e6                	shl    %cl,%esi
  801d23:	89 c1                	mov    %eax,%ecx
  801d25:	d3 eb                	shr    %cl,%ebx
  801d27:	09 de                	or     %ebx,%esi
  801d29:	89 f0                	mov    %esi,%eax
  801d2b:	f7 74 24 08          	divl   0x8(%esp)
  801d2f:	89 d6                	mov    %edx,%esi
  801d31:	89 c3                	mov    %eax,%ebx
  801d33:	f7 64 24 0c          	mull   0xc(%esp)
  801d37:	39 d6                	cmp    %edx,%esi
  801d39:	72 15                	jb     801d50 <__udivdi3+0x100>
  801d3b:	89 f9                	mov    %edi,%ecx
  801d3d:	d3 e5                	shl    %cl,%ebp
  801d3f:	39 c5                	cmp    %eax,%ebp
  801d41:	73 04                	jae    801d47 <__udivdi3+0xf7>
  801d43:	39 d6                	cmp    %edx,%esi
  801d45:	74 09                	je     801d50 <__udivdi3+0x100>
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	31 ff                	xor    %edi,%edi
  801d4b:	e9 40 ff ff ff       	jmp    801c90 <__udivdi3+0x40>
  801d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	e9 36 ff ff ff       	jmp    801c90 <__udivdi3+0x40>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	66 90                	xchg   %ax,%ax
  801d5e:	66 90                	xchg   %ax,%ax

00801d60 <__umoddi3>:
  801d60:	f3 0f 1e fb          	endbr32 
  801d64:	55                   	push   %ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 1c             	sub    $0x1c,%esp
  801d6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d73:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	75 19                	jne    801d98 <__umoddi3+0x38>
  801d7f:	39 df                	cmp    %ebx,%edi
  801d81:	76 5d                	jbe    801de0 <__umoddi3+0x80>
  801d83:	89 f0                	mov    %esi,%eax
  801d85:	89 da                	mov    %ebx,%edx
  801d87:	f7 f7                	div    %edi
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	31 d2                	xor    %edx,%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	89 f2                	mov    %esi,%edx
  801d9a:	39 d8                	cmp    %ebx,%eax
  801d9c:	76 12                	jbe    801db0 <__umoddi3+0x50>
  801d9e:	89 f0                	mov    %esi,%eax
  801da0:	89 da                	mov    %ebx,%edx
  801da2:	83 c4 1c             	add    $0x1c,%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
  801daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801db0:	0f bd e8             	bsr    %eax,%ebp
  801db3:	83 f5 1f             	xor    $0x1f,%ebp
  801db6:	75 50                	jne    801e08 <__umoddi3+0xa8>
  801db8:	39 d8                	cmp    %ebx,%eax
  801dba:	0f 82 e0 00 00 00    	jb     801ea0 <__umoddi3+0x140>
  801dc0:	89 d9                	mov    %ebx,%ecx
  801dc2:	39 f7                	cmp    %esi,%edi
  801dc4:	0f 86 d6 00 00 00    	jbe    801ea0 <__umoddi3+0x140>
  801dca:	89 d0                	mov    %edx,%eax
  801dcc:	89 ca                	mov    %ecx,%edx
  801dce:	83 c4 1c             	add    $0x1c,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
  801dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ddd:	8d 76 00             	lea    0x0(%esi),%esi
  801de0:	89 fd                	mov    %edi,%ebp
  801de2:	85 ff                	test   %edi,%edi
  801de4:	75 0b                	jne    801df1 <__umoddi3+0x91>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f7                	div    %edi
  801def:	89 c5                	mov    %eax,%ebp
  801df1:	89 d8                	mov    %ebx,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f5                	div    %ebp
  801df7:	89 f0                	mov    %esi,%eax
  801df9:	f7 f5                	div    %ebp
  801dfb:	89 d0                	mov    %edx,%eax
  801dfd:	31 d2                	xor    %edx,%edx
  801dff:	eb 8c                	jmp    801d8d <__umoddi3+0x2d>
  801e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e08:	89 e9                	mov    %ebp,%ecx
  801e0a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e0f:	29 ea                	sub    %ebp,%edx
  801e11:	d3 e0                	shl    %cl,%eax
  801e13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e17:	89 d1                	mov    %edx,%ecx
  801e19:	89 f8                	mov    %edi,%eax
  801e1b:	d3 e8                	shr    %cl,%eax
  801e1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e21:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e25:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e29:	09 c1                	or     %eax,%ecx
  801e2b:	89 d8                	mov    %ebx,%eax
  801e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 e7                	shl    %cl,%edi
  801e35:	89 d1                	mov    %edx,%ecx
  801e37:	d3 e8                	shr    %cl,%eax
  801e39:	89 e9                	mov    %ebp,%ecx
  801e3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e3f:	d3 e3                	shl    %cl,%ebx
  801e41:	89 c7                	mov    %eax,%edi
  801e43:	89 d1                	mov    %edx,%ecx
  801e45:	89 f0                	mov    %esi,%eax
  801e47:	d3 e8                	shr    %cl,%eax
  801e49:	89 e9                	mov    %ebp,%ecx
  801e4b:	89 fa                	mov    %edi,%edx
  801e4d:	d3 e6                	shl    %cl,%esi
  801e4f:	09 d8                	or     %ebx,%eax
  801e51:	f7 74 24 08          	divl   0x8(%esp)
  801e55:	89 d1                	mov    %edx,%ecx
  801e57:	89 f3                	mov    %esi,%ebx
  801e59:	f7 64 24 0c          	mull   0xc(%esp)
  801e5d:	89 c6                	mov    %eax,%esi
  801e5f:	89 d7                	mov    %edx,%edi
  801e61:	39 d1                	cmp    %edx,%ecx
  801e63:	72 06                	jb     801e6b <__umoddi3+0x10b>
  801e65:	75 10                	jne    801e77 <__umoddi3+0x117>
  801e67:	39 c3                	cmp    %eax,%ebx
  801e69:	73 0c                	jae    801e77 <__umoddi3+0x117>
  801e6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801e6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801e73:	89 d7                	mov    %edx,%edi
  801e75:	89 c6                	mov    %eax,%esi
  801e77:	89 ca                	mov    %ecx,%edx
  801e79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e7e:	29 f3                	sub    %esi,%ebx
  801e80:	19 fa                	sbb    %edi,%edx
  801e82:	89 d0                	mov    %edx,%eax
  801e84:	d3 e0                	shl    %cl,%eax
  801e86:	89 e9                	mov    %ebp,%ecx
  801e88:	d3 eb                	shr    %cl,%ebx
  801e8a:	d3 ea                	shr    %cl,%edx
  801e8c:	09 d8                	or     %ebx,%eax
  801e8e:	83 c4 1c             	add    $0x1c,%esp
  801e91:	5b                   	pop    %ebx
  801e92:	5e                   	pop    %esi
  801e93:	5f                   	pop    %edi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    
  801e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	29 fe                	sub    %edi,%esi
  801ea2:	19 c3                	sbb    %eax,%ebx
  801ea4:	89 f2                	mov    %esi,%edx
  801ea6:	89 d9                	mov    %ebx,%ecx
  801ea8:	e9 1d ff ff ff       	jmp    801dca <__umoddi3+0x6a>
