
obj/user/faultregs.debug:     formato del fichero elf32-i386


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
  80002c:	e8 b8 05 00 00       	call   8005e9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 03 2a 80 00       	push   $0x802a03
  800049:	68 40 24 80 00       	push   $0x802440
  80004e:	e8 e9 06 00 00       	call   80073c <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 50 24 80 00       	push   $0x802450
  80005c:	68 54 24 80 00       	push   $0x802454
  800061:	e8 d6 06 00 00       	call   80073c <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 68 24 80 00       	push   $0x802468
  80007b:	e8 bc 06 00 00       	call   80073c <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 72 24 80 00       	push   $0x802472
  800093:	68 54 24 80 00       	push   $0x802454
  800098:	e8 9f 06 00 00       	call   80073c <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 68 24 80 00       	push   $0x802468
  8000b4:	e8 83 06 00 00       	call   80073c <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 76 24 80 00       	push   $0x802476
  8000cc:	68 54 24 80 00       	push   $0x802454
  8000d1:	e8 66 06 00 00       	call   80073c <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 68 24 80 00       	push   $0x802468
  8000ed:	e8 4a 06 00 00       	call   80073c <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 7a 24 80 00       	push   $0x80247a
  800105:	68 54 24 80 00       	push   $0x802454
  80010a:	e8 2d 06 00 00       	call   80073c <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 68 24 80 00       	push   $0x802468
  800126:	e8 11 06 00 00       	call   80073c <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 7e 24 80 00       	push   $0x80247e
  80013e:	68 54 24 80 00       	push   $0x802454
  800143:	e8 f4 05 00 00       	call   80073c <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 68 24 80 00       	push   $0x802468
  80015f:	e8 d8 05 00 00       	call   80073c <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 82 24 80 00       	push   $0x802482
  800177:	68 54 24 80 00       	push   $0x802454
  80017c:	e8 bb 05 00 00       	call   80073c <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 68 24 80 00       	push   $0x802468
  800198:	e8 9f 05 00 00       	call   80073c <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 86 24 80 00       	push   $0x802486
  8001b0:	68 54 24 80 00       	push   $0x802454
  8001b5:	e8 82 05 00 00       	call   80073c <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 68 24 80 00       	push   $0x802468
  8001d1:	e8 66 05 00 00       	call   80073c <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 8a 24 80 00       	push   $0x80248a
  8001e9:	68 54 24 80 00       	push   $0x802454
  8001ee:	e8 49 05 00 00       	call   80073c <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 68 24 80 00       	push   $0x802468
  80020a:	e8 2d 05 00 00       	call   80073c <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 8e 24 80 00       	push   $0x80248e
  800222:	68 54 24 80 00       	push   $0x802454
  800227:	e8 10 05 00 00       	call   80073c <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 68 24 80 00       	push   $0x802468
  800243:	e8 f4 04 00 00       	call   80073c <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 95 24 80 00       	push   $0x802495
  800253:	68 54 24 80 00       	push   $0x802454
  800258:	e8 df 04 00 00       	call   80073c <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 68 24 80 00       	push   $0x802468
  800274:	e8 c3 04 00 00       	call   80073c <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 99 24 80 00       	push   $0x802499
  800284:	e8 b3 04 00 00       	call   80073c <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 68 24 80 00       	push   $0x802468
  800294:	e8 a3 04 00 00       	call   80073c <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 64 24 80 00       	push   $0x802464
  8002a9:	e8 8e 04 00 00       	call   80073c <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 64 24 80 00       	push   $0x802464
  8002c3:	e8 74 04 00 00       	call   80073c <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 64 24 80 00       	push   $0x802464
  8002d8:	e8 5f 04 00 00       	call   80073c <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 64 24 80 00       	push   $0x802464
  8002ed:	e8 4a 04 00 00       	call   80073c <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 64 24 80 00       	push   $0x802464
  800302:	e8 35 04 00 00       	call   80073c <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 64 24 80 00       	push   $0x802464
  800317:	e8 20 04 00 00       	call   80073c <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 64 24 80 00       	push   $0x802464
  80032c:	e8 0b 04 00 00       	call   80073c <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 64 24 80 00       	push   $0x802464
  800341:	e8 f6 03 00 00       	call   80073c <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 64 24 80 00       	push   $0x802464
  800356:	e8 e1 03 00 00       	call   80073c <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 95 24 80 00       	push   $0x802495
  800366:	68 54 24 80 00       	push   $0x802454
  80036b:	e8 cc 03 00 00       	call   80073c <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 64 24 80 00       	push   $0x802464
  800387:	e8 b0 03 00 00       	call   80073c <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 99 24 80 00       	push   $0x802499
  800397:	e8 a0 03 00 00       	call   80073c <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 64 24 80 00       	push   $0x802464
  8003af:	e8 88 03 00 00       	call   80073c <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 64 24 80 00       	push   $0x802464
  8003c7:	e8 70 03 00 00       	call   80073c <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 99 24 80 00       	push   $0x802499
  8003d7:	e8 60 03 00 00       	call   80073c <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f9:	0f 85 a3 00 00 00    	jne    8004a2 <pgfault+0xbe>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003ff:	8b 50 08             	mov    0x8(%eax),%edx
  800402:	89 15 40 40 80 00    	mov    %edx,0x804040
  800408:	8b 50 0c             	mov    0xc(%eax),%edx
  80040b:	89 15 44 40 80 00    	mov    %edx,0x804044
  800411:	8b 50 10             	mov    0x10(%eax),%edx
  800414:	89 15 48 40 80 00    	mov    %edx,0x804048
  80041a:	8b 50 14             	mov    0x14(%eax),%edx
  80041d:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  800423:	8b 50 18             	mov    0x18(%eax),%edx
  800426:	89 15 50 40 80 00    	mov    %edx,0x804050
  80042c:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042f:	89 15 54 40 80 00    	mov    %edx,0x804054
  800435:	8b 50 20             	mov    0x20(%eax),%edx
  800438:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043e:	8b 50 24             	mov    0x24(%eax),%edx
  800441:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800447:	8b 50 28             	mov    0x28(%eax),%edx
  80044a:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  800450:	8b 50 2c             	mov    0x2c(%eax),%edx
  800453:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800459:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045f:	8b 40 30             	mov    0x30(%eax),%eax
  800462:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	68 bf 24 80 00       	push   $0x8024bf
  80046f:	68 cd 24 80 00       	push   $0x8024cd
  800474:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800479:	ba b8 24 80 00       	mov    $0x8024b8,%edx
  80047e:	b8 80 40 80 00       	mov    $0x804080,%eax
  800483:	e8 ab fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800488:	83 c4 0c             	add    $0xc,%esp
  80048b:	6a 07                	push   $0x7
  80048d:	68 00 00 40 00       	push   $0x400000
  800492:	6a 00                	push   $0x0
  800494:	e8 95 0c 00 00       	call   80112e <sys_page_alloc>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 c0                	test   %eax,%eax
  80049e:	78 1a                	js     8004ba <pgfault+0xd6>
		panic("sys_page_alloc: %e", r);
}
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	ff 70 28             	pushl  0x28(%eax)
  8004a8:	52                   	push   %edx
  8004a9:	68 00 25 80 00       	push   $0x802500
  8004ae:	6a 50                	push   $0x50
  8004b0:	68 a7 24 80 00       	push   $0x8024a7
  8004b5:	e8 9b 01 00 00       	call   800655 <_panic>
		panic("sys_page_alloc: %e", r);
  8004ba:	50                   	push   %eax
  8004bb:	68 d4 24 80 00       	push   $0x8024d4
  8004c0:	6a 5c                	push   $0x5c
  8004c2:	68 a7 24 80 00       	push   $0x8024a7
  8004c7:	e8 89 01 00 00       	call   800655 <_panic>

008004cc <umain>:

void
umain(int argc, char **argv)
{
  8004cc:	f3 0f 1e fb          	endbr32 
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004d6:	68 e4 03 80 00       	push   $0x8003e4
  8004db:	e8 8b 0d 00 00       	call   80126b <set_pgfault_handler>

	asm volatile(
  8004e0:	50                   	push   %eax
  8004e1:	9c                   	pushf  
  8004e2:	58                   	pop    %eax
  8004e3:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e8:	50                   	push   %eax
  8004e9:	9d                   	popf   
  8004ea:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004ef:	8d 05 2a 05 80 00    	lea    0x80052a,%eax
  8004f5:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004fa:	58                   	pop    %eax
  8004fb:	89 3d 80 40 80 00    	mov    %edi,0x804080
  800501:	89 35 84 40 80 00    	mov    %esi,0x804084
  800507:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  80050d:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  800513:	89 15 94 40 80 00    	mov    %edx,0x804094
  800519:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  80051f:	a3 9c 40 80 00       	mov    %eax,0x80409c
  800524:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  80052a:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800531:	00 00 00 
  800534:	89 3d 00 40 80 00    	mov    %edi,0x804000
  80053a:	89 35 04 40 80 00    	mov    %esi,0x804004
  800540:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  800546:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  80054c:	89 15 14 40 80 00    	mov    %edx,0x804014
  800552:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800558:	a3 1c 40 80 00       	mov    %eax,0x80401c
  80055d:	89 25 28 40 80 00    	mov    %esp,0x804028
  800563:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800569:	8b 35 84 40 80 00    	mov    0x804084,%esi
  80056f:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  800575:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  80057b:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800581:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  800587:	a1 9c 40 80 00       	mov    0x80409c,%eax
  80058c:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  800592:	50                   	push   %eax
  800593:	9c                   	pushf  
  800594:	58                   	pop    %eax
  800595:	a3 24 40 80 00       	mov    %eax,0x804024
  80059a:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  8005a5:	75 30                	jne    8005d7 <umain+0x10b>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  8005a7:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005ac:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	68 e7 24 80 00       	push   $0x8024e7
  8005b9:	68 f8 24 80 00       	push   $0x8024f8
  8005be:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005c3:	ba b8 24 80 00       	mov    $0x8024b8,%edx
  8005c8:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005cd:	e8 61 fa ff ff       	call   800033 <check_regs>
}
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005d7:	83 ec 0c             	sub    $0xc,%esp
  8005da:	68 34 25 80 00       	push   $0x802534
  8005df:	e8 58 01 00 00       	call   80073c <cprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb be                	jmp    8005a7 <umain+0xdb>

008005e9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e9:	f3 0f 1e fb          	endbr32 
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	56                   	push   %esi
  8005f1:	53                   	push   %ebx
  8005f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8005f8:	e8 de 0a 00 00       	call   8010db <sys_getenvid>
	if (id >= 0)
  8005fd:	85 c0                	test   %eax,%eax
  8005ff:	78 12                	js     800613 <libmain+0x2a>
		thisenv = &envs[ENVX(id)];
  800601:	25 ff 03 00 00       	and    $0x3ff,%eax
  800606:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800609:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060e:	a3 b0 40 80 00       	mov    %eax,0x8040b0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800613:	85 db                	test   %ebx,%ebx
  800615:	7e 07                	jle    80061e <libmain+0x35>
		binaryname = argv[0];
  800617:	8b 06                	mov    (%esi),%eax
  800619:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	56                   	push   %esi
  800622:	53                   	push   %ebx
  800623:	e8 a4 fe ff ff       	call   8004cc <umain>

	// exit gracefully
	exit();
  800628:	e8 0a 00 00 00       	call   800637 <exit>
}
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800633:	5b                   	pop    %ebx
  800634:	5e                   	pop    %esi
  800635:	5d                   	pop    %ebp
  800636:	c3                   	ret    

00800637 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800637:	f3 0f 1e fb          	endbr32 
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800641:	e8 bb 0e 00 00       	call   801501 <close_all>
	sys_env_destroy(0);
  800646:	83 ec 0c             	sub    $0xc,%esp
  800649:	6a 00                	push   $0x0
  80064b:	e8 65 0a 00 00       	call   8010b5 <sys_env_destroy>
}
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800655:	f3 0f 1e fb          	endbr32 
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80065e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800661:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800667:	e8 6f 0a 00 00       	call   8010db <sys_getenvid>
  80066c:	83 ec 0c             	sub    $0xc,%esp
  80066f:	ff 75 0c             	pushl  0xc(%ebp)
  800672:	ff 75 08             	pushl  0x8(%ebp)
  800675:	56                   	push   %esi
  800676:	50                   	push   %eax
  800677:	68 60 25 80 00       	push   $0x802560
  80067c:	e8 bb 00 00 00       	call   80073c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800681:	83 c4 18             	add    $0x18,%esp
  800684:	53                   	push   %ebx
  800685:	ff 75 10             	pushl  0x10(%ebp)
  800688:	e8 5a 00 00 00       	call   8006e7 <vcprintf>
	cprintf("\n");
  80068d:	c7 04 24 02 2a 80 00 	movl   $0x802a02,(%esp)
  800694:	e8 a3 00 00 00       	call   80073c <cprintf>
  800699:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80069c:	cc                   	int3   
  80069d:	eb fd                	jmp    80069c <_panic+0x47>

0080069f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80069f:	f3 0f 1e fb          	endbr32 
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	53                   	push   %ebx
  8006a7:	83 ec 04             	sub    $0x4,%esp
  8006aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006ad:	8b 13                	mov    (%ebx),%edx
  8006af:	8d 42 01             	lea    0x1(%edx),%eax
  8006b2:	89 03                	mov    %eax,(%ebx)
  8006b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c0:	74 09                	je     8006cb <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006c2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c9:	c9                   	leave  
  8006ca:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	68 ff 00 00 00       	push   $0xff
  8006d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8006d6:	50                   	push   %eax
  8006d7:	e8 87 09 00 00       	call   801063 <sys_cputs>
		b->idx = 0;
  8006dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	eb db                	jmp    8006c2 <putch+0x23>

008006e7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006e7:	f3 0f 1e fb          	endbr32 
  8006eb:	55                   	push   %ebp
  8006ec:	89 e5                	mov    %esp,%ebp
  8006ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006fb:	00 00 00 
	b.cnt = 0;
  8006fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800705:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 08             	pushl  0x8(%ebp)
  80070e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800714:	50                   	push   %eax
  800715:	68 9f 06 80 00       	push   $0x80069f
  80071a:	e8 80 01 00 00       	call   80089f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80071f:	83 c4 08             	add    $0x8,%esp
  800722:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800728:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80072e:	50                   	push   %eax
  80072f:	e8 2f 09 00 00       	call   801063 <sys_cputs>

	return b.cnt;
}
  800734:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80073c:	f3 0f 1e fb          	endbr32 
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800746:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800749:	50                   	push   %eax
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 95 ff ff ff       	call   8006e7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	57                   	push   %edi
  800758:	56                   	push   %esi
  800759:	53                   	push   %ebx
  80075a:	83 ec 1c             	sub    $0x1c,%esp
  80075d:	89 c7                	mov    %eax,%edi
  80075f:	89 d6                	mov    %edx,%esi
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	89 d1                	mov    %edx,%ecx
  800769:	89 c2                	mov    %eax,%edx
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800777:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800781:	39 c2                	cmp    %eax,%edx
  800783:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800786:	72 3e                	jb     8007c6 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800788:	83 ec 0c             	sub    $0xc,%esp
  80078b:	ff 75 18             	pushl  0x18(%ebp)
  80078e:	83 eb 01             	sub    $0x1,%ebx
  800791:	53                   	push   %ebx
  800792:	50                   	push   %eax
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 e4             	pushl  -0x1c(%ebp)
  800799:	ff 75 e0             	pushl  -0x20(%ebp)
  80079c:	ff 75 dc             	pushl  -0x24(%ebp)
  80079f:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a2:	e8 39 1a 00 00       	call   8021e0 <__udivdi3>
  8007a7:	83 c4 18             	add    $0x18,%esp
  8007aa:	52                   	push   %edx
  8007ab:	50                   	push   %eax
  8007ac:	89 f2                	mov    %esi,%edx
  8007ae:	89 f8                	mov    %edi,%eax
  8007b0:	e8 9f ff ff ff       	call   800754 <printnum>
  8007b5:	83 c4 20             	add    $0x20,%esp
  8007b8:	eb 13                	jmp    8007cd <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	56                   	push   %esi
  8007be:	ff 75 18             	pushl  0x18(%ebp)
  8007c1:	ff d7                	call   *%edi
  8007c3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007c6:	83 eb 01             	sub    $0x1,%ebx
  8007c9:	85 db                	test   %ebx,%ebx
  8007cb:	7f ed                	jg     8007ba <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	56                   	push   %esi
  8007d1:	83 ec 04             	sub    $0x4,%esp
  8007d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007da:	ff 75 dc             	pushl  -0x24(%ebp)
  8007dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e0:	e8 0b 1b 00 00       	call   8022f0 <__umoddi3>
  8007e5:	83 c4 14             	add    $0x14,%esp
  8007e8:	0f be 80 83 25 80 00 	movsbl 0x802583(%eax),%eax
  8007ef:	50                   	push   %eax
  8007f0:	ff d7                	call   *%edi
}
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5f                   	pop    %edi
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007fd:	83 fa 01             	cmp    $0x1,%edx
  800800:	7f 13                	jg     800815 <getuint+0x18>
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800802:	85 d2                	test   %edx,%edx
  800804:	74 1c                	je     800822 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  800806:	8b 10                	mov    (%eax),%edx
  800808:	8d 4a 04             	lea    0x4(%edx),%ecx
  80080b:	89 08                	mov    %ecx,(%eax)
  80080d:	8b 02                	mov    (%edx),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	c3                   	ret    
		return va_arg(*ap, unsigned long long);
  800815:	8b 10                	mov    (%eax),%edx
  800817:	8d 4a 08             	lea    0x8(%edx),%ecx
  80081a:	89 08                	mov    %ecx,(%eax)
  80081c:	8b 02                	mov    (%edx),%eax
  80081e:	8b 52 04             	mov    0x4(%edx),%edx
  800821:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  800822:	8b 10                	mov    (%eax),%edx
  800824:	8d 4a 04             	lea    0x4(%edx),%ecx
  800827:	89 08                	mov    %ecx,(%eax)
  800829:	8b 02                	mov    (%edx),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800830:	c3                   	ret    

00800831 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800831:	83 fa 01             	cmp    $0x1,%edx
  800834:	7f 0f                	jg     800845 <getint+0x14>
		return va_arg(*ap, long long);
	else if (lflag)
  800836:	85 d2                	test   %edx,%edx
  800838:	74 18                	je     800852 <getint+0x21>
		return va_arg(*ap, long);
  80083a:	8b 10                	mov    (%eax),%edx
  80083c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80083f:	89 08                	mov    %ecx,(%eax)
  800841:	8b 02                	mov    (%edx),%eax
  800843:	99                   	cltd   
  800844:	c3                   	ret    
		return va_arg(*ap, long long);
  800845:	8b 10                	mov    (%eax),%edx
  800847:	8d 4a 08             	lea    0x8(%edx),%ecx
  80084a:	89 08                	mov    %ecx,(%eax)
  80084c:	8b 02                	mov    (%edx),%eax
  80084e:	8b 52 04             	mov    0x4(%edx),%edx
  800851:	c3                   	ret    
	else
		return va_arg(*ap, int);
  800852:	8b 10                	mov    (%eax),%edx
  800854:	8d 4a 04             	lea    0x4(%edx),%ecx
  800857:	89 08                	mov    %ecx,(%eax)
  800859:	8b 02                	mov    (%edx),%eax
  80085b:	99                   	cltd   
}
  80085c:	c3                   	ret    

0080085d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80085d:	f3 0f 1e fb          	endbr32 
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800867:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80086b:	8b 10                	mov    (%eax),%edx
  80086d:	3b 50 04             	cmp    0x4(%eax),%edx
  800870:	73 0a                	jae    80087c <sprintputch+0x1f>
		*b->buf++ = ch;
  800872:	8d 4a 01             	lea    0x1(%edx),%ecx
  800875:	89 08                	mov    %ecx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	88 02                	mov    %al,(%edx)
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <printfmt>:
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800888:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80088b:	50                   	push   %eax
  80088c:	ff 75 10             	pushl  0x10(%ebp)
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 05 00 00 00       	call   80089f <vprintfmt>
}
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    

0080089f <vprintfmt>:
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	57                   	push   %edi
  8008a7:	56                   	push   %esi
  8008a8:	53                   	push   %ebx
  8008a9:	83 ec 2c             	sub    $0x2c,%esp
  8008ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008b2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008b5:	e9 86 02 00 00       	jmp    800b40 <vprintfmt+0x2a1>
		padc = ' ';
  8008ba:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8008be:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8008c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8008cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008d8:	8d 47 01             	lea    0x1(%edi),%eax
  8008db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008de:	0f b6 17             	movzbl (%edi),%edx
  8008e1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008e4:	3c 55                	cmp    $0x55,%al
  8008e6:	0f 87 df 02 00 00    	ja     800bcb <vprintfmt+0x32c>
  8008ec:	0f b6 c0             	movzbl %al,%eax
  8008ef:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  8008f6:	00 
  8008f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8008fa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8008fe:	eb d8                	jmp    8008d8 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800900:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800903:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800907:	eb cf                	jmp    8008d8 <vprintfmt+0x39>
  800909:	0f b6 d2             	movzbl %dl,%edx
  80090c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800917:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80091a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80091e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800921:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800924:	83 f9 09             	cmp    $0x9,%ecx
  800927:	77 52                	ja     80097b <vprintfmt+0xdc>
			for (precision = 0; ; ++fmt) {
  800929:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80092c:	eb e9                	jmp    800917 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	89 55 14             	mov    %edx,0x14(%ebp)
  800937:	8b 00                	mov    (%eax),%eax
  800939:	89 45 d8             	mov    %eax,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80093c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800943:	79 93                	jns    8008d8 <vprintfmt+0x39>
				width = precision, precision = -1;
  800945:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80094b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800952:	eb 84                	jmp    8008d8 <vprintfmt+0x39>
  800954:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800957:	85 c0                	test   %eax,%eax
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	0f 49 d0             	cmovns %eax,%edx
  800961:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800964:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800967:	e9 6c ff ff ff       	jmp    8008d8 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80096c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80096f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800976:	e9 5d ff ff ff       	jmp    8008d8 <vprintfmt+0x39>
  80097b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800981:	eb bc                	jmp    80093f <vprintfmt+0xa0>
			lflag++;
  800983:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800989:	e9 4a ff ff ff       	jmp    8008d8 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8d 50 04             	lea    0x4(%eax),%edx
  800994:	89 55 14             	mov    %edx,0x14(%ebp)
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	56                   	push   %esi
  80099b:	ff 30                	pushl  (%eax)
  80099d:	ff d3                	call   *%ebx
			break;
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	e9 96 01 00 00       	jmp    800b3d <vprintfmt+0x29e>
			err = va_arg(ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	99                   	cltd   
  8009b3:	31 d0                	xor    %edx,%eax
  8009b5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009b7:	83 f8 0f             	cmp    $0xf,%eax
  8009ba:	7f 20                	jg     8009dc <vprintfmt+0x13d>
  8009bc:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  8009c3:	85 d2                	test   %edx,%edx
  8009c5:	74 15                	je     8009dc <vprintfmt+0x13d>
				printfmt(putch, putdat, "%s", p);
  8009c7:	52                   	push   %edx
  8009c8:	68 9b 29 80 00       	push   $0x80299b
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	e8 aa fe ff ff       	call   80087e <printfmt>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	e9 61 01 00 00       	jmp    800b3d <vprintfmt+0x29e>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	50                   	push   %eax
  8009dd:	68 9b 25 80 00       	push   $0x80259b
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	e8 95 fe ff ff       	call   80087e <printfmt>
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	e9 4c 01 00 00       	jmp    800b3d <vprintfmt+0x29e>
			if ((p = va_arg(ap, char *)) == NULL)
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	8d 50 04             	lea    0x4(%eax),%edx
  8009f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8009fa:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8009fc:	85 c9                	test   %ecx,%ecx
  8009fe:	b8 94 25 80 00       	mov    $0x802594,%eax
  800a03:	0f 45 c1             	cmovne %ecx,%eax
  800a06:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0d:	7e 06                	jle    800a15 <vprintfmt+0x176>
  800a0f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a13:	75 0d                	jne    800a22 <vprintfmt+0x183>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a18:	89 c7                	mov    %eax,%edi
  800a1a:	03 45 e0             	add    -0x20(%ebp),%eax
  800a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a20:	eb 57                	jmp    800a79 <vprintfmt+0x1da>
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 d8             	pushl  -0x28(%ebp)
  800a28:	ff 75 cc             	pushl  -0x34(%ebp)
  800a2b:	e8 4f 02 00 00       	call   800c7f <strnlen>
  800a30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a33:	29 c2                	sub    %eax,%edx
  800a35:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a38:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a3b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  800a42:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800a44:	85 db                	test   %ebx,%ebx
  800a46:	7e 10                	jle    800a58 <vprintfmt+0x1b9>
					putch(padc, putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	56                   	push   %esi
  800a4c:	57                   	push   %edi
  800a4d:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a50:	83 eb 01             	sub    $0x1,%ebx
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	eb ec                	jmp    800a44 <vprintfmt+0x1a5>
  800a58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	0f 49 c2             	cmovns %edx,%eax
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a6d:	eb a6                	jmp    800a15 <vprintfmt+0x176>
					putch(ch, putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	56                   	push   %esi
  800a73:	52                   	push   %edx
  800a74:	ff d3                	call   *%ebx
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a7c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7e:	83 c7 01             	add    $0x1,%edi
  800a81:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a85:	0f be d0             	movsbl %al,%edx
  800a88:	85 d2                	test   %edx,%edx
  800a8a:	74 42                	je     800ace <vprintfmt+0x22f>
  800a8c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a90:	78 06                	js     800a98 <vprintfmt+0x1f9>
  800a92:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a96:	78 1e                	js     800ab6 <vprintfmt+0x217>
				if (altflag && (ch < ' ' || ch > '~'))
  800a98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a9c:	74 d1                	je     800a6f <vprintfmt+0x1d0>
  800a9e:	0f be c0             	movsbl %al,%eax
  800aa1:	83 e8 20             	sub    $0x20,%eax
  800aa4:	83 f8 5e             	cmp    $0x5e,%eax
  800aa7:	76 c6                	jbe    800a6f <vprintfmt+0x1d0>
					putch('?', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	56                   	push   %esi
  800aad:	6a 3f                	push   $0x3f
  800aaf:	ff d3                	call   *%ebx
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	eb c3                	jmp    800a79 <vprintfmt+0x1da>
  800ab6:	89 cf                	mov    %ecx,%edi
  800ab8:	eb 0e                	jmp    800ac8 <vprintfmt+0x229>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	56                   	push   %esi
  800abe:	6a 20                	push   $0x20
  800ac0:	ff d3                	call   *%ebx
			for (; width > 0; width--)
  800ac2:	83 ef 01             	sub    $0x1,%edi
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	85 ff                	test   %edi,%edi
  800aca:	7f ee                	jg     800aba <vprintfmt+0x21b>
  800acc:	eb 6f                	jmp    800b3d <vprintfmt+0x29e>
  800ace:	89 cf                	mov    %ecx,%edi
  800ad0:	eb f6                	jmp    800ac8 <vprintfmt+0x229>
			num = getint(&ap, lflag);
  800ad2:	89 ca                	mov    %ecx,%edx
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	e8 55 fd ff ff       	call   800831 <getint>
  800adc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800adf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800ae2:	85 d2                	test   %edx,%edx
  800ae4:	78 0b                	js     800af1 <vprintfmt+0x252>
			num = getint(&ap, lflag);
  800ae6:	89 d1                	mov    %edx,%ecx
  800ae8:	89 c2                	mov    %eax,%edx
			base = 10;
  800aea:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aef:	eb 32                	jmp    800b23 <vprintfmt+0x284>
				putch('-', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	56                   	push   %esi
  800af5:	6a 2d                	push   $0x2d
  800af7:	ff d3                	call   *%ebx
				num = -(long long) num;
  800af9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800afc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aff:	f7 da                	neg    %edx
  800b01:	83 d1 00             	adc    $0x0,%ecx
  800b04:	f7 d9                	neg    %ecx
  800b06:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0e:	eb 13                	jmp    800b23 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800b10:	89 ca                	mov    %ecx,%edx
  800b12:	8d 45 14             	lea    0x14(%ebp),%eax
  800b15:	e8 e3 fc ff ff       	call   8007fd <getuint>
  800b1a:	89 d1                	mov    %edx,%ecx
  800b1c:	89 c2                	mov    %eax,%edx
			base = 10;
  800b1e:	b8 0a 00 00 00       	mov    $0xa,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b23:	83 ec 0c             	sub    $0xc,%esp
  800b26:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800b2a:	57                   	push   %edi
  800b2b:	ff 75 e0             	pushl  -0x20(%ebp)
  800b2e:	50                   	push   %eax
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	89 f2                	mov    %esi,%edx
  800b33:	89 d8                	mov    %ebx,%eax
  800b35:	e8 1a fc ff ff       	call   800754 <printnum>
			break;
  800b3a:	83 c4 20             	add    $0x20,%esp
{
  800b3d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b40:	83 c7 01             	add    $0x1,%edi
  800b43:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b47:	83 f8 25             	cmp    $0x25,%eax
  800b4a:	0f 84 6a fd ff ff    	je     8008ba <vprintfmt+0x1b>
			if (ch == '\0')
  800b50:	85 c0                	test   %eax,%eax
  800b52:	0f 84 93 00 00 00    	je     800beb <vprintfmt+0x34c>
			putch(ch, putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	56                   	push   %esi
  800b5c:	50                   	push   %eax
  800b5d:	ff d3                	call   *%ebx
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	eb dc                	jmp    800b40 <vprintfmt+0x2a1>
			num = getuint(&ap, lflag);
  800b64:	89 ca                	mov    %ecx,%edx
  800b66:	8d 45 14             	lea    0x14(%ebp),%eax
  800b69:	e8 8f fc ff ff       	call   8007fd <getuint>
  800b6e:	89 d1                	mov    %edx,%ecx
  800b70:	89 c2                	mov    %eax,%edx
			base = 8;
  800b72:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800b77:	eb aa                	jmp    800b23 <vprintfmt+0x284>
			putch('0', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	56                   	push   %esi
  800b7d:	6a 30                	push   $0x30
  800b7f:	ff d3                	call   *%ebx
			putch('x', putdat);
  800b81:	83 c4 08             	add    $0x8,%esp
  800b84:	56                   	push   %esi
  800b85:	6a 78                	push   $0x78
  800b87:	ff d3                	call   *%ebx
				(uintptr_t) va_arg(ap, void *);
  800b89:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8c:	8d 50 04             	lea    0x4(%eax),%edx
  800b8f:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800b92:	8b 10                	mov    (%eax),%edx
  800b94:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b99:	83 c4 10             	add    $0x10,%esp
			base = 16;
  800b9c:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800ba1:	eb 80                	jmp    800b23 <vprintfmt+0x284>
			num = getuint(&ap, lflag);
  800ba3:	89 ca                	mov    %ecx,%edx
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	e8 50 fc ff ff       	call   8007fd <getuint>
  800bad:	89 d1                	mov    %edx,%ecx
  800baf:	89 c2                	mov    %eax,%edx
			base = 16;
  800bb1:	b8 10 00 00 00       	mov    $0x10,%eax
  800bb6:	e9 68 ff ff ff       	jmp    800b23 <vprintfmt+0x284>
			putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	56                   	push   %esi
  800bbf:	6a 25                	push   $0x25
  800bc1:	ff d3                	call   *%ebx
			break;
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	e9 72 ff ff ff       	jmp    800b3d <vprintfmt+0x29e>
			putch('%', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	56                   	push   %esi
  800bcf:	6a 25                	push   $0x25
  800bd1:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 f8                	mov    %edi,%eax
  800bd8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800bdc:	74 05                	je     800be3 <vprintfmt+0x344>
  800bde:	83 e8 01             	sub    $0x1,%eax
  800be1:	eb f5                	jmp    800bd8 <vprintfmt+0x339>
  800be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800be6:	e9 52 ff ff ff       	jmp    800b3d <vprintfmt+0x29e>
}
  800beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf3:	f3 0f 1e fb          	endbr32 
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 18             	sub    $0x18,%esp
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c06:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c0a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c14:	85 c0                	test   %eax,%eax
  800c16:	74 26                	je     800c3e <vsnprintf+0x4b>
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	7e 22                	jle    800c3e <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1c:	ff 75 14             	pushl  0x14(%ebp)
  800c1f:	ff 75 10             	pushl  0x10(%ebp)
  800c22:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c25:	50                   	push   %eax
  800c26:	68 5d 08 80 00       	push   $0x80085d
  800c2b:	e8 6f fc ff ff       	call   80089f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c39:	83 c4 10             	add    $0x10,%esp
}
  800c3c:	c9                   	leave  
  800c3d:	c3                   	ret    
		return -E_INVAL;
  800c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c43:	eb f7                	jmp    800c3c <vsnprintf+0x49>

00800c45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c45:	f3 0f 1e fb          	endbr32 
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c4f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c52:	50                   	push   %eax
  800c53:	ff 75 10             	pushl  0x10(%ebp)
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	ff 75 08             	pushl  0x8(%ebp)
  800c5c:	e8 92 ff ff ff       	call   800bf3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c72:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c76:	74 05                	je     800c7d <strlen+0x1a>
		n++;
  800c78:	83 c0 01             	add    $0x1,%eax
  800c7b:	eb f5                	jmp    800c72 <strlen+0xf>
	return n;
}
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c7f:	f3 0f 1e fb          	endbr32 
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	39 d0                	cmp    %edx,%eax
  800c93:	74 0d                	je     800ca2 <strnlen+0x23>
  800c95:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c99:	74 05                	je     800ca0 <strnlen+0x21>
		n++;
  800c9b:	83 c0 01             	add    $0x1,%eax
  800c9e:	eb f1                	jmp    800c91 <strnlen+0x12>
  800ca0:	89 c2                	mov    %eax,%edx
	return n;
}
  800ca2:	89 d0                	mov    %edx,%eax
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca6:	f3 0f 1e fb          	endbr32 
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	53                   	push   %ebx
  800cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800cbd:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800cc0:	83 c0 01             	add    $0x1,%eax
  800cc3:	84 d2                	test   %dl,%dl
  800cc5:	75 f2                	jne    800cb9 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800cc7:	89 c8                	mov    %ecx,%eax
  800cc9:	5b                   	pop    %ebx
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ccc:	f3 0f 1e fb          	endbr32 
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 10             	sub    $0x10,%esp
  800cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cda:	53                   	push   %ebx
  800cdb:	e8 83 ff ff ff       	call   800c63 <strlen>
  800ce0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ce3:	ff 75 0c             	pushl  0xc(%ebp)
  800ce6:	01 d8                	add    %ebx,%eax
  800ce8:	50                   	push   %eax
  800ce9:	e8 b8 ff ff ff       	call   800ca6 <strcpy>
	return dst;
}
  800cee:	89 d8                	mov    %ebx,%eax
  800cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cf5:	f3 0f 1e fb          	endbr32 
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
  800cfe:	8b 75 08             	mov    0x8(%ebp),%esi
  800d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d04:	89 f3                	mov    %esi,%ebx
  800d06:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d09:	89 f0                	mov    %esi,%eax
  800d0b:	39 d8                	cmp    %ebx,%eax
  800d0d:	74 11                	je     800d20 <strncpy+0x2b>
		*dst++ = *src;
  800d0f:	83 c0 01             	add    $0x1,%eax
  800d12:	0f b6 0a             	movzbl (%edx),%ecx
  800d15:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d18:	80 f9 01             	cmp    $0x1,%cl
  800d1b:	83 da ff             	sbb    $0xffffffff,%edx
  800d1e:	eb eb                	jmp    800d0b <strncpy+0x16>
	}
	return ret;
}
  800d20:	89 f0                	mov    %esi,%eax
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	8b 75 08             	mov    0x8(%ebp),%esi
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	8b 55 10             	mov    0x10(%ebp),%edx
  800d38:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d3a:	85 d2                	test   %edx,%edx
  800d3c:	74 21                	je     800d5f <strlcpy+0x39>
  800d3e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d42:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800d44:	39 c2                	cmp    %eax,%edx
  800d46:	74 14                	je     800d5c <strlcpy+0x36>
  800d48:	0f b6 19             	movzbl (%ecx),%ebx
  800d4b:	84 db                	test   %bl,%bl
  800d4d:	74 0b                	je     800d5a <strlcpy+0x34>
			*dst++ = *src++;
  800d4f:	83 c1 01             	add    $0x1,%ecx
  800d52:	83 c2 01             	add    $0x1,%edx
  800d55:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d58:	eb ea                	jmp    800d44 <strlcpy+0x1e>
  800d5a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800d5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5f:	29 f0                	sub    %esi,%eax
}
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d65:	f3 0f 1e fb          	endbr32 
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d72:	0f b6 01             	movzbl (%ecx),%eax
  800d75:	84 c0                	test   %al,%al
  800d77:	74 0c                	je     800d85 <strcmp+0x20>
  800d79:	3a 02                	cmp    (%edx),%al
  800d7b:	75 08                	jne    800d85 <strcmp+0x20>
		p++, q++;
  800d7d:	83 c1 01             	add    $0x1,%ecx
  800d80:	83 c2 01             	add    $0x1,%edx
  800d83:	eb ed                	jmp    800d72 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	0f b6 12             	movzbl (%edx),%edx
  800d8b:	29 d0                	sub    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d8f:	f3 0f 1e fb          	endbr32 
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	53                   	push   %ebx
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9d:	89 c3                	mov    %eax,%ebx
  800d9f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800da2:	eb 06                	jmp    800daa <strncmp+0x1b>
		n--, p++, q++;
  800da4:	83 c0 01             	add    $0x1,%eax
  800da7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800daa:	39 d8                	cmp    %ebx,%eax
  800dac:	74 16                	je     800dc4 <strncmp+0x35>
  800dae:	0f b6 08             	movzbl (%eax),%ecx
  800db1:	84 c9                	test   %cl,%cl
  800db3:	74 04                	je     800db9 <strncmp+0x2a>
  800db5:	3a 0a                	cmp    (%edx),%cl
  800db7:	74 eb                	je     800da4 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db9:	0f b6 00             	movzbl (%eax),%eax
  800dbc:	0f b6 12             	movzbl (%edx),%edx
  800dbf:	29 d0                	sub    %edx,%eax
}
  800dc1:	5b                   	pop    %ebx
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    
		return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc9:	eb f6                	jmp    800dc1 <strncmp+0x32>

00800dcb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dcb:	f3 0f 1e fb          	endbr32 
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dd9:	0f b6 10             	movzbl (%eax),%edx
  800ddc:	84 d2                	test   %dl,%dl
  800dde:	74 09                	je     800de9 <strchr+0x1e>
		if (*s == c)
  800de0:	38 ca                	cmp    %cl,%dl
  800de2:	74 0a                	je     800dee <strchr+0x23>
	for (; *s; s++)
  800de4:	83 c0 01             	add    $0x1,%eax
  800de7:	eb f0                	jmp    800dd9 <strchr+0xe>
			return (char *) s;
	return 0;
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800dfe:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e01:	38 ca                	cmp    %cl,%dl
  800e03:	74 09                	je     800e0e <strfind+0x1e>
  800e05:	84 d2                	test   %dl,%dl
  800e07:	74 05                	je     800e0e <strfind+0x1e>
	for (; *s; s++)
  800e09:	83 c0 01             	add    $0x1,%eax
  800e0c:	eb f0                	jmp    800dfe <strfind+0xe>
			break;
	return (char *) s;
}
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e10:	f3 0f 1e fb          	endbr32 
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800e20:	85 c9                	test   %ecx,%ecx
  800e22:	74 33                	je     800e57 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e24:	89 d0                	mov    %edx,%eax
  800e26:	09 c8                	or     %ecx,%eax
  800e28:	a8 03                	test   $0x3,%al
  800e2a:	75 23                	jne    800e4f <memset+0x3f>
		c &= 0xFF;
  800e2c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e30:	89 d8                	mov    %ebx,%eax
  800e32:	c1 e0 08             	shl    $0x8,%eax
  800e35:	89 df                	mov    %ebx,%edi
  800e37:	c1 e7 18             	shl    $0x18,%edi
  800e3a:	89 de                	mov    %ebx,%esi
  800e3c:	c1 e6 10             	shl    $0x10,%esi
  800e3f:	09 f7                	or     %esi,%edi
  800e41:	09 fb                	or     %edi,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800e43:	c1 e9 02             	shr    $0x2,%ecx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e46:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
  800e48:	89 d7                	mov    %edx,%edi
  800e4a:	fc                   	cld    
  800e4b:	f3 ab                	rep stos %eax,%es:(%edi)
  800e4d:	eb 08                	jmp    800e57 <memset+0x47>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e4f:	89 d7                	mov    %edx,%edi
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	fc                   	cld    
  800e55:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800e57:	89 d0                	mov    %edx,%eax
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e5e:	f3 0f 1e fb          	endbr32 
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e70:	39 c6                	cmp    %eax,%esi
  800e72:	73 32                	jae    800ea6 <memmove+0x48>
  800e74:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	76 2b                	jbe    800ea6 <memmove+0x48>
		s += n;
		d += n;
  800e7b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e7e:	89 fe                	mov    %edi,%esi
  800e80:	09 ce                	or     %ecx,%esi
  800e82:	09 d6                	or     %edx,%esi
  800e84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e8a:	75 0e                	jne    800e9a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e8c:	83 ef 04             	sub    $0x4,%edi
  800e8f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e92:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e95:	fd                   	std    
  800e96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e98:	eb 09                	jmp    800ea3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e9a:	83 ef 01             	sub    $0x1,%edi
  800e9d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ea0:	fd                   	std    
  800ea1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ea3:	fc                   	cld    
  800ea4:	eb 1a                	jmp    800ec0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ea6:	89 c2                	mov    %eax,%edx
  800ea8:	09 ca                	or     %ecx,%edx
  800eaa:	09 f2                	or     %esi,%edx
  800eac:	f6 c2 03             	test   $0x3,%dl
  800eaf:	75 0a                	jne    800ebb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800eb1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800eb4:	89 c7                	mov    %eax,%edi
  800eb6:	fc                   	cld    
  800eb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eb9:	eb 05                	jmp    800ec0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ebb:	89 c7                	mov    %eax,%edi
  800ebd:	fc                   	cld    
  800ebe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ec4:	f3 0f 1e fb          	endbr32 
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ece:	ff 75 10             	pushl  0x10(%ebp)
  800ed1:	ff 75 0c             	pushl  0xc(%ebp)
  800ed4:	ff 75 08             	pushl  0x8(%ebp)
  800ed7:	e8 82 ff ff ff       	call   800e5e <memmove>
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ede:	f3 0f 1e fb          	endbr32 
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eed:	89 c6                	mov    %eax,%esi
  800eef:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ef2:	39 f0                	cmp    %esi,%eax
  800ef4:	74 1c                	je     800f12 <memcmp+0x34>
		if (*s1 != *s2)
  800ef6:	0f b6 08             	movzbl (%eax),%ecx
  800ef9:	0f b6 1a             	movzbl (%edx),%ebx
  800efc:	38 d9                	cmp    %bl,%cl
  800efe:	75 08                	jne    800f08 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f00:	83 c0 01             	add    $0x1,%eax
  800f03:	83 c2 01             	add    $0x1,%edx
  800f06:	eb ea                	jmp    800ef2 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800f08:	0f b6 c1             	movzbl %cl,%eax
  800f0b:	0f b6 db             	movzbl %bl,%ebx
  800f0e:	29 d8                	sub    %ebx,%eax
  800f10:	eb 05                	jmp    800f17 <memcmp+0x39>
	}

	return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f1b:	f3 0f 1e fb          	endbr32 
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f28:	89 c2                	mov    %eax,%edx
  800f2a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f2d:	39 d0                	cmp    %edx,%eax
  800f2f:	73 09                	jae    800f3a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f31:	38 08                	cmp    %cl,(%eax)
  800f33:	74 05                	je     800f3a <memfind+0x1f>
	for (; s < ends; s++)
  800f35:	83 c0 01             	add    $0x1,%eax
  800f38:	eb f3                	jmp    800f2d <memfind+0x12>
			break;
	return (void *) s;
}
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f3c:	f3 0f 1e fb          	endbr32 
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4c:	eb 03                	jmp    800f51 <strtol+0x15>
		s++;
  800f4e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f51:	0f b6 01             	movzbl (%ecx),%eax
  800f54:	3c 20                	cmp    $0x20,%al
  800f56:	74 f6                	je     800f4e <strtol+0x12>
  800f58:	3c 09                	cmp    $0x9,%al
  800f5a:	74 f2                	je     800f4e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800f5c:	3c 2b                	cmp    $0x2b,%al
  800f5e:	74 2a                	je     800f8a <strtol+0x4e>
	int neg = 0;
  800f60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f65:	3c 2d                	cmp    $0x2d,%al
  800f67:	74 2b                	je     800f94 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f69:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f6f:	75 0f                	jne    800f80 <strtol+0x44>
  800f71:	80 39 30             	cmpb   $0x30,(%ecx)
  800f74:	74 28                	je     800f9e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f76:	85 db                	test   %ebx,%ebx
  800f78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7d:	0f 44 d8             	cmove  %eax,%ebx
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
  800f85:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f88:	eb 46                	jmp    800fd0 <strtol+0x94>
		s++;
  800f8a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  800f92:	eb d5                	jmp    800f69 <strtol+0x2d>
		s++, neg = 1;
  800f94:	83 c1 01             	add    $0x1,%ecx
  800f97:	bf 01 00 00 00       	mov    $0x1,%edi
  800f9c:	eb cb                	jmp    800f69 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fa2:	74 0e                	je     800fb2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	75 d8                	jne    800f80 <strtol+0x44>
		s++, base = 8;
  800fa8:	83 c1 01             	add    $0x1,%ecx
  800fab:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fb0:	eb ce                	jmp    800f80 <strtol+0x44>
		s += 2, base = 16;
  800fb2:	83 c1 02             	add    $0x2,%ecx
  800fb5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fba:	eb c4                	jmp    800f80 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800fbc:	0f be d2             	movsbl %dl,%edx
  800fbf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fc2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800fc5:	7d 3a                	jge    801001 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800fc7:	83 c1 01             	add    $0x1,%ecx
  800fca:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fce:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800fd0:	0f b6 11             	movzbl (%ecx),%edx
  800fd3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fd6:	89 f3                	mov    %esi,%ebx
  800fd8:	80 fb 09             	cmp    $0x9,%bl
  800fdb:	76 df                	jbe    800fbc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800fdd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fe0:	89 f3                	mov    %esi,%ebx
  800fe2:	80 fb 19             	cmp    $0x19,%bl
  800fe5:	77 08                	ja     800fef <strtol+0xb3>
			dig = *s - 'a' + 10;
  800fe7:	0f be d2             	movsbl %dl,%edx
  800fea:	83 ea 57             	sub    $0x57,%edx
  800fed:	eb d3                	jmp    800fc2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800fef:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ff2:	89 f3                	mov    %esi,%ebx
  800ff4:	80 fb 19             	cmp    $0x19,%bl
  800ff7:	77 08                	ja     801001 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ff9:	0f be d2             	movsbl %dl,%edx
  800ffc:	83 ea 37             	sub    $0x37,%edx
  800fff:	eb c1                	jmp    800fc2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	74 05                	je     80100c <strtol+0xd0>
		*endptr = (char *) s;
  801007:	8b 75 0c             	mov    0xc(%ebp),%esi
  80100a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80100c:	89 c2                	mov    %eax,%edx
  80100e:	f7 da                	neg    %edx
  801010:	85 ff                	test   %edi,%edi
  801012:	0f 45 c2             	cmovne %edx,%eax
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 1c             	sub    $0x1c,%esp
  801023:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801026:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801029:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801031:	8b 7d 10             	mov    0x10(%ebp),%edi
  801034:	8b 75 14             	mov    0x14(%ebp),%esi
  801037:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801039:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80103d:	74 04                	je     801043 <syscall+0x29>
  80103f:	85 c0                	test   %eax,%eax
  801041:	7f 08                	jg     80104b <syscall+0x31>
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	ff 75 e0             	pushl  -0x20(%ebp)
  801052:	68 7f 28 80 00       	push   $0x80287f
  801057:	6a 23                	push   $0x23
  801059:	68 9c 28 80 00       	push   $0x80289c
  80105e:	e8 f2 f5 ff ff       	call   800655 <_panic>

00801063 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801063:	f3 0f 1e fb          	endbr32 
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80106d:	6a 00                	push   $0x0
  80106f:	6a 00                	push   $0x0
  801071:	6a 00                	push   $0x0
  801073:	ff 75 0c             	pushl  0xc(%ebp)
  801076:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801079:	ba 00 00 00 00       	mov    $0x0,%edx
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
  801083:	e8 92 ff ff ff       	call   80101a <syscall>
}
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <sys_cgetc>:

int
sys_cgetc(void)
{
  80108d:	f3 0f 1e fb          	endbr32 
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801097:	6a 00                	push   $0x0
  801099:	6a 00                	push   $0x0
  80109b:	6a 00                	push   $0x0
  80109d:	6a 00                	push   $0x0
  80109f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8010ae:	e8 67 ff ff ff       	call   80101a <syscall>
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010b5:	f3 0f 1e fb          	endbr32 
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	ba 01 00 00 00       	mov    $0x1,%edx
  8010cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8010d4:	e8 41 ff ff ff       	call   80101a <syscall>
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010db:	f3 0f 1e fb          	endbr32 
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8010fc:	e8 19 ff ff ff       	call   80101a <syscall>
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <sys_yield>:

void
sys_yield(void)
{
  801103:	f3 0f 1e fb          	endbr32 
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80110d:	6a 00                	push   $0x0
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	b9 00 00 00 00       	mov    $0x0,%ecx
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801124:	e8 f1 fe ff ff       	call   80101a <syscall>
}
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    

0080112e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80112e:	f3 0f 1e fb          	endbr32 
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	ff 75 10             	pushl  0x10(%ebp)
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801145:	ba 01 00 00 00       	mov    $0x1,%edx
  80114a:	b8 04 00 00 00       	mov    $0x4,%eax
  80114f:	e8 c6 fe ff ff       	call   80101a <syscall>
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801156:	f3 0f 1e fb          	endbr32 
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  801160:	ff 75 18             	pushl  0x18(%ebp)
  801163:	ff 75 14             	pushl  0x14(%ebp)
  801166:	ff 75 10             	pushl  0x10(%ebp)
  801169:	ff 75 0c             	pushl  0xc(%ebp)
  80116c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116f:	ba 01 00 00 00       	mov    $0x1,%edx
  801174:	b8 05 00 00 00       	mov    $0x5,%eax
  801179:	e8 9c fe ff ff       	call   80101a <syscall>
}
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801196:	ba 01 00 00 00       	mov    $0x1,%edx
  80119b:	b8 06 00 00 00       	mov    $0x6,%eax
  8011a0:	e8 75 fe ff ff       	call   80101a <syscall>
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011a7:	f3 0f 1e fb          	endbr32 
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bd:	ba 01 00 00 00       	mov    $0x1,%edx
  8011c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8011c7:	e8 4e fe ff ff       	call   80101a <syscall>
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011ce:	f3 0f 1e fb          	endbr32 
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e4:	ba 01 00 00 00       	mov    $0x1,%edx
  8011e9:	b8 09 00 00 00       	mov    $0x9,%eax
  8011ee:	e8 27 fe ff ff       	call   80101a <syscall>
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011f5:	f3 0f 1e fb          	endbr32 
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120b:	ba 01 00 00 00       	mov    $0x1,%edx
  801210:	b8 0a 00 00 00       	mov    $0xa,%eax
  801215:	e8 00 fe ff ff       	call   80101a <syscall>
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80121c:	f3 0f 1e fb          	endbr32 
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801226:	6a 00                	push   $0x0
  801228:	ff 75 14             	pushl  0x14(%ebp)
  80122b:	ff 75 10             	pushl  0x10(%ebp)
  80122e:	ff 75 0c             	pushl  0xc(%ebp)
  801231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801234:	ba 00 00 00 00       	mov    $0x0,%edx
  801239:	b8 0c 00 00 00       	mov    $0xc,%eax
  80123e:	e8 d7 fd ff ff       	call   80101a <syscall>
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125a:	ba 01 00 00 00       	mov    $0x1,%edx
  80125f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801264:	e8 b1 fd ff ff       	call   80101a <syscall>
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801275:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  80127c:	74 0a                	je     801288 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler: %e", r);

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    
		r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P);
  801288:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80128d:	8b 40 48             	mov    0x48(%eax),%eax
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	6a 07                	push   $0x7
  801295:	68 00 f0 bf ee       	push   $0xeebff000
  80129a:	50                   	push   %eax
  80129b:	e8 8e fe ff ff       	call   80112e <sys_page_alloc>
		if (r!= 0)
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	75 2f                	jne    8012d6 <set_pgfault_handler+0x6b>
		r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8012a7:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8012ac:	8b 40 48             	mov    0x48(%eax),%eax
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	68 e8 12 80 00       	push   $0x8012e8
  8012b7:	50                   	push   %eax
  8012b8:	e8 38 ff ff ff       	call   8011f5 <sys_env_set_pgfault_upcall>
		if (r!= 0)
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 ba                	je     80127e <set_pgfault_handler+0x13>
			panic("set_pgfault_handler: %e", r);
  8012c4:	50                   	push   %eax
  8012c5:	68 aa 28 80 00       	push   $0x8028aa
  8012ca:	6a 26                	push   $0x26
  8012cc:	68 c2 28 80 00       	push   $0x8028c2
  8012d1:	e8 7f f3 ff ff       	call   800655 <_panic>
			panic("set_pgfault_handler: %e", r);
  8012d6:	50                   	push   %eax
  8012d7:	68 aa 28 80 00       	push   $0x8028aa
  8012dc:	6a 22                	push   $0x22
  8012de:	68 c2 28 80 00       	push   $0x8028c2
  8012e3:	e8 6d f3 ff ff       	call   800655 <_panic>

008012e8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8012e8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8012e9:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  8012ee:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8012f0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx
  8012f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx
  8012f7:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)
  8012fa:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx
  8012fe:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)
  801302:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801304:	83 c4 08             	add    $0x8,%esp
	popal
  801307:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
  801308:	83 c4 04             	add    $0x4,%esp
	popfl
  80130b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80130c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80130d:	c3                   	ret    

0080130e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80130e:	f3 0f 1e fb          	endbr32 
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	05 00 00 00 30       	add    $0x30000000,%eax
  80131d:	c1 e8 0c             	shr    $0xc,%eax
}
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801322:	f3 0f 1e fb          	endbr32 
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 da ff ff ff       	call   80130e <fd2num>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	c1 e0 0c             	shl    $0xc,%eax
  80133a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801341:	f3 0f 1e fb          	endbr32 
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	c1 ea 16             	shr    $0x16,%edx
  801352:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801359:	f6 c2 01             	test   $0x1,%dl
  80135c:	74 2d                	je     80138b <fd_alloc+0x4a>
  80135e:	89 c2                	mov    %eax,%edx
  801360:	c1 ea 0c             	shr    $0xc,%edx
  801363:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136a:	f6 c2 01             	test   $0x1,%dl
  80136d:	74 1c                	je     80138b <fd_alloc+0x4a>
  80136f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801374:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801379:	75 d2                	jne    80134d <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801384:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801389:	eb 0a                	jmp    801395 <fd_alloc+0x54>
			*fd_store = fd;
  80138b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801397:	f3 0f 1e fb          	endbr32 
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a1:	83 f8 1f             	cmp    $0x1f,%eax
  8013a4:	77 30                	ja     8013d6 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a6:	c1 e0 0c             	shl    $0xc,%eax
  8013a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ae:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013b4:	f6 c2 01             	test   $0x1,%dl
  8013b7:	74 24                	je     8013dd <fd_lookup+0x46>
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	c1 ea 0c             	shr    $0xc,%edx
  8013be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	74 1a                	je     8013e4 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	89 02                	mov    %eax,(%edx)
	return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    
		return -E_INVAL;
  8013d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013db:	eb f7                	jmp    8013d4 <fd_lookup+0x3d>
		return -E_INVAL;
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e2:	eb f0                	jmp    8013d4 <fd_lookup+0x3d>
  8013e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e9:	eb e9                	jmp    8013d4 <fd_lookup+0x3d>

008013eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013eb:	f3 0f 1e fb          	endbr32 
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f8:	ba 4c 29 80 00       	mov    $0x80294c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013fd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801402:	39 08                	cmp    %ecx,(%eax)
  801404:	74 33                	je     801439 <dev_lookup+0x4e>
  801406:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801409:	8b 02                	mov    (%edx),%eax
  80140b:	85 c0                	test   %eax,%eax
  80140d:	75 f3                	jne    801402 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80140f:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801414:	8b 40 48             	mov    0x48(%eax),%eax
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	51                   	push   %ecx
  80141b:	50                   	push   %eax
  80141c:	68 d0 28 80 00       	push   $0x8028d0
  801421:	e8 16 f3 ff ff       	call   80073c <cprintf>
	*dev = 0;
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    
			*dev = devtab[i];
  801439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80143e:	b8 00 00 00 00       	mov    $0x0,%eax
  801443:	eb f2                	jmp    801437 <dev_lookup+0x4c>

00801445 <fd_close>:
{
  801445:	f3 0f 1e fb          	endbr32 
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 28             	sub    $0x28,%esp
  801452:	8b 75 08             	mov    0x8(%ebp),%esi
  801455:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801458:	56                   	push   %esi
  801459:	e8 b0 fe ff ff       	call   80130e <fd2num>
  80145e:	83 c4 08             	add    $0x8,%esp
  801461:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801464:	52                   	push   %edx
  801465:	50                   	push   %eax
  801466:	e8 2c ff ff ff       	call   801397 <fd_lookup>
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 05                	js     801479 <fd_close+0x34>
	    || fd != fd2)
  801474:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801477:	74 16                	je     80148f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801479:	89 f8                	mov    %edi,%eax
  80147b:	84 c0                	test   %al,%al
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
  801482:	0f 44 d8             	cmove  %eax,%ebx
}
  801485:	89 d8                	mov    %ebx,%eax
  801487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148a:	5b                   	pop    %ebx
  80148b:	5e                   	pop    %esi
  80148c:	5f                   	pop    %edi
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	ff 36                	pushl  (%esi)
  801498:	e8 4e ff ff ff       	call   8013eb <dev_lookup>
  80149d:	89 c3                	mov    %eax,%ebx
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 1a                	js     8014c0 <fd_close+0x7b>
		if (dev->dev_close)
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	74 0b                	je     8014c0 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	56                   	push   %esi
  8014b9:	ff d0                	call   *%eax
  8014bb:	89 c3                	mov    %eax,%ebx
  8014bd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	56                   	push   %esi
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 b5 fc ff ff       	call   801180 <sys_page_unmap>
	return r;
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb b5                	jmp    801485 <fd_close+0x40>

008014d0 <close>:

int
close(int fdnum)
{
  8014d0:	f3 0f 1e fb          	endbr32 
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	ff 75 08             	pushl  0x8(%ebp)
  8014e1:	e8 b1 fe ff ff       	call   801397 <fd_lookup>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	79 02                	jns    8014ef <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    
		return fd_close(fd, 1);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	6a 01                	push   $0x1
  8014f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f7:	e8 49 ff ff ff       	call   801445 <fd_close>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	eb ec                	jmp    8014ed <close+0x1d>

00801501 <close_all>:

void
close_all(void)
{
  801501:	f3 0f 1e fb          	endbr32 
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	53                   	push   %ebx
  801509:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80150c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	53                   	push   %ebx
  801515:	e8 b6 ff ff ff       	call   8014d0 <close>
	for (i = 0; i < MAXFD; i++)
  80151a:	83 c3 01             	add    $0x1,%ebx
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	83 fb 20             	cmp    $0x20,%ebx
  801523:	75 ec                	jne    801511 <close_all+0x10>
}
  801525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152a:	f3 0f 1e fb          	endbr32 
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	57                   	push   %edi
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801537:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	ff 75 08             	pushl  0x8(%ebp)
  80153e:	e8 54 fe ff ff       	call   801397 <fd_lookup>
  801543:	89 c3                	mov    %eax,%ebx
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	0f 88 81 00 00 00    	js     8015d1 <dup+0xa7>
		return r;
	close(newfdnum);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	ff 75 0c             	pushl  0xc(%ebp)
  801556:	e8 75 ff ff ff       	call   8014d0 <close>

	newfd = INDEX2FD(newfdnum);
  80155b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80155e:	c1 e6 0c             	shl    $0xc,%esi
  801561:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801567:	83 c4 04             	add    $0x4,%esp
  80156a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156d:	e8 b0 fd ff ff       	call   801322 <fd2data>
  801572:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801574:	89 34 24             	mov    %esi,(%esp)
  801577:	e8 a6 fd ff ff       	call   801322 <fd2data>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801581:	89 d8                	mov    %ebx,%eax
  801583:	c1 e8 16             	shr    $0x16,%eax
  801586:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80158d:	a8 01                	test   $0x1,%al
  80158f:	74 11                	je     8015a2 <dup+0x78>
  801591:	89 d8                	mov    %ebx,%eax
  801593:	c1 e8 0c             	shr    $0xc,%eax
  801596:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80159d:	f6 c2 01             	test   $0x1,%dl
  8015a0:	75 39                	jne    8015db <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a5:	89 d0                	mov    %edx,%eax
  8015a7:	c1 e8 0c             	shr    $0xc,%eax
  8015aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b1:	83 ec 0c             	sub    $0xc,%esp
  8015b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b9:	50                   	push   %eax
  8015ba:	56                   	push   %esi
  8015bb:	6a 00                	push   $0x0
  8015bd:	52                   	push   %edx
  8015be:	6a 00                	push   $0x0
  8015c0:	e8 91 fb ff ff       	call   801156 <sys_page_map>
  8015c5:	89 c3                	mov    %eax,%ebx
  8015c7:	83 c4 20             	add    $0x20,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 31                	js     8015ff <dup+0xd5>
		goto err;

	return newfdnum;
  8015ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5f                   	pop    %edi
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ea:	50                   	push   %eax
  8015eb:	57                   	push   %edi
  8015ec:	6a 00                	push   $0x0
  8015ee:	53                   	push   %ebx
  8015ef:	6a 00                	push   $0x0
  8015f1:	e8 60 fb ff ff       	call   801156 <sys_page_map>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	83 c4 20             	add    $0x20,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	79 a3                	jns    8015a2 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	56                   	push   %esi
  801603:	6a 00                	push   $0x0
  801605:	e8 76 fb ff ff       	call   801180 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80160a:	83 c4 08             	add    $0x8,%esp
  80160d:	57                   	push   %edi
  80160e:	6a 00                	push   $0x0
  801610:	e8 6b fb ff ff       	call   801180 <sys_page_unmap>
	return r;
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	eb b7                	jmp    8015d1 <dup+0xa7>

0080161a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80161a:	f3 0f 1e fb          	endbr32 
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	53                   	push   %ebx
  801622:	83 ec 1c             	sub    $0x1c,%esp
  801625:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801628:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	53                   	push   %ebx
  80162d:	e8 65 fd ff ff       	call   801397 <fd_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 3f                	js     801678 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163f:	50                   	push   %eax
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	ff 30                	pushl  (%eax)
  801645:	e8 a1 fd ff ff       	call   8013eb <dev_lookup>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	78 27                	js     801678 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801651:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801654:	8b 42 08             	mov    0x8(%edx),%eax
  801657:	83 e0 03             	and    $0x3,%eax
  80165a:	83 f8 01             	cmp    $0x1,%eax
  80165d:	74 1e                	je     80167d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801662:	8b 40 08             	mov    0x8(%eax),%eax
  801665:	85 c0                	test   %eax,%eax
  801667:	74 35                	je     80169e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	ff 75 10             	pushl  0x10(%ebp)
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	52                   	push   %edx
  801673:	ff d0                	call   *%eax
  801675:	83 c4 10             	add    $0x10,%esp
}
  801678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80167d:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801682:	8b 40 48             	mov    0x48(%eax),%eax
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	53                   	push   %ebx
  801689:	50                   	push   %eax
  80168a:	68 11 29 80 00       	push   $0x802911
  80168f:	e8 a8 f0 ff ff       	call   80073c <cprintf>
		return -E_INVAL;
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169c:	eb da                	jmp    801678 <read+0x5e>
		return -E_NOT_SUPP;
  80169e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a3:	eb d3                	jmp    801678 <read+0x5e>

008016a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a5:	f3 0f 1e fb          	endbr32 
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	57                   	push   %edi
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016bd:	eb 02                	jmp    8016c1 <readn+0x1c>
  8016bf:	01 c3                	add    %eax,%ebx
  8016c1:	39 f3                	cmp    %esi,%ebx
  8016c3:	73 21                	jae    8016e6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	89 f0                	mov    %esi,%eax
  8016ca:	29 d8                	sub    %ebx,%eax
  8016cc:	50                   	push   %eax
  8016cd:	89 d8                	mov    %ebx,%eax
  8016cf:	03 45 0c             	add    0xc(%ebp),%eax
  8016d2:	50                   	push   %eax
  8016d3:	57                   	push   %edi
  8016d4:	e8 41 ff ff ff       	call   80161a <read>
		if (m < 0)
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 04                	js     8016e4 <readn+0x3f>
			return m;
		if (m == 0)
  8016e0:	75 dd                	jne    8016bf <readn+0x1a>
  8016e2:	eb 02                	jmp    8016e6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016e6:	89 d8                	mov    %ebx,%eax
  8016e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f0:	f3 0f 1e fb          	endbr32 
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 1c             	sub    $0x1c,%esp
  8016fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801701:	50                   	push   %eax
  801702:	53                   	push   %ebx
  801703:	e8 8f fc ff ff       	call   801397 <fd_lookup>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 3a                	js     801749 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	ff 30                	pushl  (%eax)
  80171b:	e8 cb fc ff ff       	call   8013eb <dev_lookup>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 22                	js     801749 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80172e:	74 1e                	je     80174e <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801733:	8b 52 0c             	mov    0xc(%edx),%edx
  801736:	85 d2                	test   %edx,%edx
  801738:	74 35                	je     80176f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	ff 75 10             	pushl  0x10(%ebp)
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	50                   	push   %eax
  801744:	ff d2                	call   *%edx
  801746:	83 c4 10             	add    $0x10,%esp
}
  801749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80174e:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801753:	8b 40 48             	mov    0x48(%eax),%eax
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	53                   	push   %ebx
  80175a:	50                   	push   %eax
  80175b:	68 2d 29 80 00       	push   $0x80292d
  801760:	e8 d7 ef ff ff       	call   80073c <cprintf>
		return -E_INVAL;
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176d:	eb da                	jmp    801749 <write+0x59>
		return -E_NOT_SUPP;
  80176f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801774:	eb d3                	jmp    801749 <write+0x59>

00801776 <seek>:

int
seek(int fdnum, off_t offset)
{
  801776:	f3 0f 1e fb          	endbr32 
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801780:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801783:	50                   	push   %eax
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 0b fc ff ff       	call   801397 <fd_lookup>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 0e                	js     8017a1 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a3:	f3 0f 1e fb          	endbr32 
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 1c             	sub    $0x1c,%esp
  8017ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b4:	50                   	push   %eax
  8017b5:	53                   	push   %ebx
  8017b6:	e8 dc fb ff ff       	call   801397 <fd_lookup>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 37                	js     8017f9 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c8:	50                   	push   %eax
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	ff 30                	pushl  (%eax)
  8017ce:	e8 18 fc ff ff       	call   8013eb <dev_lookup>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 1f                	js     8017f9 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e1:	74 1b                	je     8017fe <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e6:	8b 52 18             	mov    0x18(%edx),%edx
  8017e9:	85 d2                	test   %edx,%edx
  8017eb:	74 32                	je     80181f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	50                   	push   %eax
  8017f4:	ff d2                	call   *%edx
  8017f6:	83 c4 10             	add    $0x10,%esp
}
  8017f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017fe:	a1 b0 40 80 00       	mov    0x8040b0,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801803:	8b 40 48             	mov    0x48(%eax),%eax
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	53                   	push   %ebx
  80180a:	50                   	push   %eax
  80180b:	68 f0 28 80 00       	push   $0x8028f0
  801810:	e8 27 ef ff ff       	call   80073c <cprintf>
		return -E_INVAL;
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181d:	eb da                	jmp    8017f9 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80181f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801824:	eb d3                	jmp    8017f9 <ftruncate+0x56>

00801826 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 1c             	sub    $0x1c,%esp
  801831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 57 fb ff ff       	call   801397 <fd_lookup>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 4b                	js     801892 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184d:	50                   	push   %eax
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801851:	ff 30                	pushl  (%eax)
  801853:	e8 93 fb ff ff       	call   8013eb <dev_lookup>
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 33                	js     801892 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801866:	74 2f                	je     801897 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801868:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80186b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801872:	00 00 00 
	stat->st_isdir = 0;
  801875:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80187c:	00 00 00 
	stat->st_dev = dev;
  80187f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	53                   	push   %ebx
  801889:	ff 75 f0             	pushl  -0x10(%ebp)
  80188c:	ff 50 14             	call   *0x14(%eax)
  80188f:	83 c4 10             	add    $0x10,%esp
}
  801892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801895:	c9                   	leave  
  801896:	c3                   	ret    
		return -E_NOT_SUPP;
  801897:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189c:	eb f4                	jmp    801892 <fstat+0x6c>

0080189e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80189e:	f3 0f 1e fb          	endbr32 
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	e8 3a 02 00 00       	call   801aee <open>
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	78 1b                	js     8018d8 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	50                   	push   %eax
  8018c4:	e8 5d ff ff ff       	call   801826 <fstat>
  8018c9:	89 c6                	mov    %eax,%esi
	close(fd);
  8018cb:	89 1c 24             	mov    %ebx,(%esp)
  8018ce:	e8 fd fb ff ff       	call   8014d0 <close>
	return r;
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	89 f3                	mov    %esi,%ebx
}
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    

008018e1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	89 c6                	mov    %eax,%esi
  8018e8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ea:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  8018f1:	74 27                	je     80191a <fsipc+0x39>
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f3:	6a 07                	push   $0x7
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	56                   	push   %esi
  8018fb:	ff 35 ac 40 80 00    	pushl  0x8040ac
  801901:	e8 fd 07 00 00       	call   802103 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801906:	83 c4 0c             	add    $0xc,%esp
  801909:	6a 00                	push   $0x0
  80190b:	53                   	push   %ebx
  80190c:	6a 00                	push   $0x0
  80190e:	e8 83 07 00 00       	call   802096 <ipc_recv>
}
  801913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	6a 01                	push   $0x1
  80191f:	e8 37 08 00 00       	call   80215b <ipc_find_env>
  801924:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	eb c5                	jmp    8018f3 <fsipc+0x12>

0080192e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80192e:	f3 0f 1e fb          	endbr32 
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8b 40 0c             	mov    0xc(%eax),%eax
  80193e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801943:	8b 45 0c             	mov    0xc(%ebp),%eax
  801946:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80194b:	ba 00 00 00 00       	mov    $0x0,%edx
  801950:	b8 02 00 00 00       	mov    $0x2,%eax
  801955:	e8 87 ff ff ff       	call   8018e1 <fsipc>
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <devfile_flush>:
{
  80195c:	f3 0f 1e fb          	endbr32 
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8b 40 0c             	mov    0xc(%eax),%eax
  80196c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801971:	ba 00 00 00 00       	mov    $0x0,%edx
  801976:	b8 06 00 00 00       	mov    $0x6,%eax
  80197b:	e8 61 ff ff ff       	call   8018e1 <fsipc>
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <devfile_stat>:
{
  801982:	f3 0f 1e fb          	endbr32 
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	53                   	push   %ebx
  80198a:	83 ec 04             	sub    $0x4,%esp
  80198d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 40 0c             	mov    0xc(%eax),%eax
  801996:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a5:	e8 37 ff ff ff       	call   8018e1 <fsipc>
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 2c                	js     8019da <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	68 00 50 80 00       	push   $0x805000
  8019b6:	53                   	push   %ebx
  8019b7:	e8 ea f2 ff ff       	call   800ca6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019bc:	a1 80 50 80 00       	mov    0x805080,%eax
  8019c1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019c7:	a1 84 50 80 00       	mov    0x805084,%eax
  8019cc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devfile_write>:
{
  8019df:	f3 0f 1e fb          	endbr32 
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019f8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019fe:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a04:	77 30                	ja     801a36 <devfile_write+0x57>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	53                   	push   %ebx
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	68 08 50 80 00       	push   $0x805008
  801a12:	e8 47 f4 ff ff       	call   800e5e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a17:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1c:	b8 04 00 00 00       	mov    $0x4,%eax
  801a21:	e8 bb fe ff ff       	call   8018e1 <fsipc>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 04                	js     801a31 <devfile_write+0x52>
	assert(r <= n);
  801a2d:	39 d8                	cmp    %ebx,%eax
  801a2f:	77 1e                	ja     801a4f <devfile_write+0x70>
}
  801a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a36:	68 5c 29 80 00       	push   $0x80295c
  801a3b:	68 89 29 80 00       	push   $0x802989
  801a40:	68 94 00 00 00       	push   $0x94
  801a45:	68 9e 29 80 00       	push   $0x80299e
  801a4a:	e8 06 ec ff ff       	call   800655 <_panic>
	assert(r <= n);
  801a4f:	68 a9 29 80 00       	push   $0x8029a9
  801a54:	68 89 29 80 00       	push   $0x802989
  801a59:	68 98 00 00 00       	push   $0x98
  801a5e:	68 9e 29 80 00       	push   $0x80299e
  801a63:	e8 ed eb ff ff       	call   800655 <_panic>

00801a68 <devfile_read>:
{
  801a68:	f3 0f 1e fb          	endbr32 
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	56                   	push   %esi
  801a70:	53                   	push   %ebx
  801a71:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a7f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a85:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8a:	b8 03 00 00 00       	mov    $0x3,%eax
  801a8f:	e8 4d fe ff ff       	call   8018e1 <fsipc>
  801a94:	89 c3                	mov    %eax,%ebx
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 1f                	js     801ab9 <devfile_read+0x51>
	assert(r <= n);
  801a9a:	39 f0                	cmp    %esi,%eax
  801a9c:	77 24                	ja     801ac2 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa3:	7f 33                	jg     801ad8 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	50                   	push   %eax
  801aa9:	68 00 50 80 00       	push   $0x805000
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 a8 f3 ff ff       	call   800e5e <memmove>
	return r;
  801ab6:	83 c4 10             	add    $0x10,%esp
}
  801ab9:	89 d8                	mov    %ebx,%eax
  801abb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abe:	5b                   	pop    %ebx
  801abf:	5e                   	pop    %esi
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    
	assert(r <= n);
  801ac2:	68 a9 29 80 00       	push   $0x8029a9
  801ac7:	68 89 29 80 00       	push   $0x802989
  801acc:	6a 7c                	push   $0x7c
  801ace:	68 9e 29 80 00       	push   $0x80299e
  801ad3:	e8 7d eb ff ff       	call   800655 <_panic>
	assert(r <= PGSIZE);
  801ad8:	68 b0 29 80 00       	push   $0x8029b0
  801add:	68 89 29 80 00       	push   $0x802989
  801ae2:	6a 7d                	push   $0x7d
  801ae4:	68 9e 29 80 00       	push   $0x80299e
  801ae9:	e8 67 eb ff ff       	call   800655 <_panic>

00801aee <open>:
{
  801aee:	f3 0f 1e fb          	endbr32 
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	56                   	push   %esi
  801af6:	53                   	push   %ebx
  801af7:	83 ec 1c             	sub    $0x1c,%esp
  801afa:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801afd:	56                   	push   %esi
  801afe:	e8 60 f1 ff ff       	call   800c63 <strlen>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b0b:	7f 6c                	jg     801b79 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b13:	50                   	push   %eax
  801b14:	e8 28 f8 ff ff       	call   801341 <fd_alloc>
  801b19:	89 c3                	mov    %eax,%ebx
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 3c                	js     801b5e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b22:	83 ec 08             	sub    $0x8,%esp
  801b25:	56                   	push   %esi
  801b26:	68 00 50 80 00       	push   $0x805000
  801b2b:	e8 76 f1 ff ff       	call   800ca6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b33:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b40:	e8 9c fd ff ff       	call   8018e1 <fsipc>
  801b45:	89 c3                	mov    %eax,%ebx
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 19                	js     801b67 <open+0x79>
	return fd2num(fd);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	ff 75 f4             	pushl  -0xc(%ebp)
  801b54:	e8 b5 f7 ff ff       	call   80130e <fd2num>
  801b59:	89 c3                	mov    %eax,%ebx
  801b5b:	83 c4 10             	add    $0x10,%esp
}
  801b5e:	89 d8                	mov    %ebx,%eax
  801b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
		fd_close(fd, 0);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	6a 00                	push   $0x0
  801b6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6f:	e8 d1 f8 ff ff       	call   801445 <fd_close>
		return r;
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	eb e5                	jmp    801b5e <open+0x70>
		return -E_BAD_PATH;
  801b79:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b7e:	eb de                	jmp    801b5e <open+0x70>

00801b80 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b80:	f3 0f 1e fb          	endbr32 
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	b8 08 00 00 00       	mov    $0x8,%eax
  801b94:	e8 48 fd ff ff       	call   8018e1 <fsipc>
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b9b:	f3 0f 1e fb          	endbr32 
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	e8 70 f7 ff ff       	call   801322 <fd2data>
  801bb2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bb4:	83 c4 08             	add    $0x8,%esp
  801bb7:	68 bc 29 80 00       	push   $0x8029bc
  801bbc:	53                   	push   %ebx
  801bbd:	e8 e4 f0 ff ff       	call   800ca6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bc2:	8b 46 04             	mov    0x4(%esi),%eax
  801bc5:	2b 06                	sub    (%esi),%eax
  801bc7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bcd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd4:	00 00 00 
	stat->st_dev = &devpipe;
  801bd7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bde:	30 80 00 
	return 0;
}
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
  801be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    

00801bed <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bed:	f3 0f 1e fb          	endbr32 
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	53                   	push   %ebx
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bfb:	53                   	push   %ebx
  801bfc:	6a 00                	push   $0x0
  801bfe:	e8 7d f5 ff ff       	call   801180 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c03:	89 1c 24             	mov    %ebx,(%esp)
  801c06:	e8 17 f7 ff ff       	call   801322 <fd2data>
  801c0b:	83 c4 08             	add    $0x8,%esp
  801c0e:	50                   	push   %eax
  801c0f:	6a 00                	push   $0x0
  801c11:	e8 6a f5 ff ff       	call   801180 <sys_page_unmap>
}
  801c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <_pipeisclosed>:
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	57                   	push   %edi
  801c1f:	56                   	push   %esi
  801c20:	53                   	push   %ebx
  801c21:	83 ec 1c             	sub    $0x1c,%esp
  801c24:	89 c7                	mov    %eax,%edi
  801c26:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c28:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801c2d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	57                   	push   %edi
  801c34:	e8 5f 05 00 00       	call   802198 <pageref>
  801c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c3c:	89 34 24             	mov    %esi,(%esp)
  801c3f:	e8 54 05 00 00       	call   802198 <pageref>
		nn = thisenv->env_runs;
  801c44:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801c4a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	39 cb                	cmp    %ecx,%ebx
  801c52:	74 1b                	je     801c6f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c54:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c57:	75 cf                	jne    801c28 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c59:	8b 42 58             	mov    0x58(%edx),%eax
  801c5c:	6a 01                	push   $0x1
  801c5e:	50                   	push   %eax
  801c5f:	53                   	push   %ebx
  801c60:	68 c3 29 80 00       	push   $0x8029c3
  801c65:	e8 d2 ea ff ff       	call   80073c <cprintf>
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	eb b9                	jmp    801c28 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c6f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c72:	0f 94 c0             	sete   %al
  801c75:	0f b6 c0             	movzbl %al,%eax
}
  801c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <devpipe_write>:
{
  801c80:	f3 0f 1e fb          	endbr32 
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	57                   	push   %edi
  801c88:	56                   	push   %esi
  801c89:	53                   	push   %ebx
  801c8a:	83 ec 28             	sub    $0x28,%esp
  801c8d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c90:	56                   	push   %esi
  801c91:	e8 8c f6 ff ff       	call   801322 <fd2data>
  801c96:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ca3:	74 4f                	je     801cf4 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ca5:	8b 43 04             	mov    0x4(%ebx),%eax
  801ca8:	8b 0b                	mov    (%ebx),%ecx
  801caa:	8d 51 20             	lea    0x20(%ecx),%edx
  801cad:	39 d0                	cmp    %edx,%eax
  801caf:	72 14                	jb     801cc5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801cb1:	89 da                	mov    %ebx,%edx
  801cb3:	89 f0                	mov    %esi,%eax
  801cb5:	e8 61 ff ff ff       	call   801c1b <_pipeisclosed>
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	75 3b                	jne    801cf9 <devpipe_write+0x79>
			sys_yield();
  801cbe:	e8 40 f4 ff ff       	call   801103 <sys_yield>
  801cc3:	eb e0                	jmp    801ca5 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ccc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ccf:	89 c2                	mov    %eax,%edx
  801cd1:	c1 fa 1f             	sar    $0x1f,%edx
  801cd4:	89 d1                	mov    %edx,%ecx
  801cd6:	c1 e9 1b             	shr    $0x1b,%ecx
  801cd9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cdc:	83 e2 1f             	and    $0x1f,%edx
  801cdf:	29 ca                	sub    %ecx,%edx
  801ce1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ce5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ce9:	83 c0 01             	add    $0x1,%eax
  801cec:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cef:	83 c7 01             	add    $0x1,%edi
  801cf2:	eb ac                	jmp    801ca0 <devpipe_write+0x20>
	return i;
  801cf4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf7:	eb 05                	jmp    801cfe <devpipe_write+0x7e>
				return 0;
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5f                   	pop    %edi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <devpipe_read>:
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	57                   	push   %edi
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 18             	sub    $0x18,%esp
  801d13:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d16:	57                   	push   %edi
  801d17:	e8 06 f6 ff ff       	call   801322 <fd2data>
  801d1c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	be 00 00 00 00       	mov    $0x0,%esi
  801d26:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d29:	75 14                	jne    801d3f <devpipe_read+0x39>
	return i;
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	eb 02                	jmp    801d32 <devpipe_read+0x2c>
				return i;
  801d30:	89 f0                	mov    %esi,%eax
}
  801d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
			sys_yield();
  801d3a:	e8 c4 f3 ff ff       	call   801103 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d3f:	8b 03                	mov    (%ebx),%eax
  801d41:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d44:	75 18                	jne    801d5e <devpipe_read+0x58>
			if (i > 0)
  801d46:	85 f6                	test   %esi,%esi
  801d48:	75 e6                	jne    801d30 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d4a:	89 da                	mov    %ebx,%edx
  801d4c:	89 f8                	mov    %edi,%eax
  801d4e:	e8 c8 fe ff ff       	call   801c1b <_pipeisclosed>
  801d53:	85 c0                	test   %eax,%eax
  801d55:	74 e3                	je     801d3a <devpipe_read+0x34>
				return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	eb d4                	jmp    801d32 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d5e:	99                   	cltd   
  801d5f:	c1 ea 1b             	shr    $0x1b,%edx
  801d62:	01 d0                	add    %edx,%eax
  801d64:	83 e0 1f             	and    $0x1f,%eax
  801d67:	29 d0                	sub    %edx,%eax
  801d69:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d71:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d74:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d77:	83 c6 01             	add    $0x1,%esi
  801d7a:	eb aa                	jmp    801d26 <devpipe_read+0x20>

00801d7c <pipe>:
{
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8b:	50                   	push   %eax
  801d8c:	e8 b0 f5 ff ff       	call   801341 <fd_alloc>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	0f 88 23 01 00 00    	js     801ec1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 07 04 00 00       	push   $0x407
  801da6:	ff 75 f4             	pushl  -0xc(%ebp)
  801da9:	6a 00                	push   $0x0
  801dab:	e8 7e f3 ff ff       	call   80112e <sys_page_alloc>
  801db0:	89 c3                	mov    %eax,%ebx
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	85 c0                	test   %eax,%eax
  801db7:	0f 88 04 01 00 00    	js     801ec1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dc3:	50                   	push   %eax
  801dc4:	e8 78 f5 ff ff       	call   801341 <fd_alloc>
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	0f 88 db 00 00 00    	js     801eb1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	68 07 04 00 00       	push   $0x407
  801dde:	ff 75 f0             	pushl  -0x10(%ebp)
  801de1:	6a 00                	push   $0x0
  801de3:	e8 46 f3 ff ff       	call   80112e <sys_page_alloc>
  801de8:	89 c3                	mov    %eax,%ebx
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	85 c0                	test   %eax,%eax
  801def:	0f 88 bc 00 00 00    	js     801eb1 <pipe+0x135>
	va = fd2data(fd0);
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	e8 22 f5 ff ff       	call   801322 <fd2data>
  801e00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e02:	83 c4 0c             	add    $0xc,%esp
  801e05:	68 07 04 00 00       	push   $0x407
  801e0a:	50                   	push   %eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	e8 1c f3 ff ff       	call   80112e <sys_page_alloc>
  801e12:	89 c3                	mov    %eax,%ebx
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 88 82 00 00 00    	js     801ea1 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	ff 75 f0             	pushl  -0x10(%ebp)
  801e25:	e8 f8 f4 ff ff       	call   801322 <fd2data>
  801e2a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e31:	50                   	push   %eax
  801e32:	6a 00                	push   $0x0
  801e34:	56                   	push   %esi
  801e35:	6a 00                	push   $0x0
  801e37:	e8 1a f3 ff ff       	call   801156 <sys_page_map>
  801e3c:	89 c3                	mov    %eax,%ebx
  801e3e:	83 c4 20             	add    $0x20,%esp
  801e41:	85 c0                	test   %eax,%eax
  801e43:	78 4e                	js     801e93 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e45:	a1 20 30 80 00       	mov    0x803020,%eax
  801e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e52:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e61:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6e:	e8 9b f4 ff ff       	call   80130e <fd2num>
  801e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e76:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e78:	83 c4 04             	add    $0x4,%esp
  801e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7e:	e8 8b f4 ff ff       	call   80130e <fd2num>
  801e83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e86:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e91:	eb 2e                	jmp    801ec1 <pipe+0x145>
	sys_page_unmap(0, va);
  801e93:	83 ec 08             	sub    $0x8,%esp
  801e96:	56                   	push   %esi
  801e97:	6a 00                	push   $0x0
  801e99:	e8 e2 f2 ff ff       	call   801180 <sys_page_unmap>
  801e9e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ea1:	83 ec 08             	sub    $0x8,%esp
  801ea4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 d2 f2 ff ff       	call   801180 <sys_page_unmap>
  801eae:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb7:	6a 00                	push   $0x0
  801eb9:	e8 c2 f2 ff ff       	call   801180 <sys_page_unmap>
  801ebe:	83 c4 10             	add    $0x10,%esp
}
  801ec1:	89 d8                	mov    %ebx,%eax
  801ec3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5e                   	pop    %esi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <pipeisclosed>:
{
  801eca:	f3 0f 1e fb          	endbr32 
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	e8 b7 f4 ff ff       	call   801397 <fd_lookup>
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 18                	js     801eff <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	ff 75 f4             	pushl  -0xc(%ebp)
  801eed:	e8 30 f4 ff ff       	call   801322 <fd2data>
  801ef2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	e8 1f fd ff ff       	call   801c1b <_pipeisclosed>
  801efc:	83 c4 10             	add    $0x10,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f01:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0a:	c3                   	ret    

00801f0b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f0b:	f3 0f 1e fb          	endbr32 
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f15:	68 db 29 80 00       	push   $0x8029db
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	e8 84 ed ff ff       	call   800ca6 <strcpy>
	return 0;
}
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <devcons_write>:
{
  801f29:	f3 0f 1e fb          	endbr32 
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	57                   	push   %edi
  801f31:	56                   	push   %esi
  801f32:	53                   	push   %ebx
  801f33:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f39:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f3e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f44:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f47:	73 31                	jae    801f7a <devcons_write+0x51>
		m = n - tot;
  801f49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f4c:	29 f3                	sub    %esi,%ebx
  801f4e:	83 fb 7f             	cmp    $0x7f,%ebx
  801f51:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f56:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	53                   	push   %ebx
  801f5d:	89 f0                	mov    %esi,%eax
  801f5f:	03 45 0c             	add    0xc(%ebp),%eax
  801f62:	50                   	push   %eax
  801f63:	57                   	push   %edi
  801f64:	e8 f5 ee ff ff       	call   800e5e <memmove>
		sys_cputs(buf, m);
  801f69:	83 c4 08             	add    $0x8,%esp
  801f6c:	53                   	push   %ebx
  801f6d:	57                   	push   %edi
  801f6e:	e8 f0 f0 ff ff       	call   801063 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f73:	01 de                	add    %ebx,%esi
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	eb ca                	jmp    801f44 <devcons_write+0x1b>
}
  801f7a:	89 f0                	mov    %esi,%eax
  801f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <devcons_read>:
{
  801f84:	f3 0f 1e fb          	endbr32 
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f97:	74 21                	je     801fba <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f99:	e8 ef f0 ff ff       	call   80108d <sys_cgetc>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 07                	jne    801fa9 <devcons_read+0x25>
		sys_yield();
  801fa2:	e8 5c f1 ff ff       	call   801103 <sys_yield>
  801fa7:	eb f0                	jmp    801f99 <devcons_read+0x15>
	if (c < 0)
  801fa9:	78 0f                	js     801fba <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fab:	83 f8 04             	cmp    $0x4,%eax
  801fae:	74 0c                	je     801fbc <devcons_read+0x38>
	*(char*)vbuf = c;
  801fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb3:	88 02                	mov    %al,(%edx)
	return 1;
  801fb5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    
		return 0;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	eb f7                	jmp    801fba <devcons_read+0x36>

00801fc3 <cputchar>:
{
  801fc3:	f3 0f 1e fb          	endbr32 
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fd3:	6a 01                	push   $0x1
  801fd5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fd8:	50                   	push   %eax
  801fd9:	e8 85 f0 ff ff       	call   801063 <sys_cputs>
}
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <getchar>:
{
  801fe3:	f3 0f 1e fb          	endbr32 
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fed:	6a 01                	push   $0x1
  801fef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff2:	50                   	push   %eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	e8 20 f6 ff ff       	call   80161a <read>
	if (r < 0)
  801ffa:	83 c4 10             	add    $0x10,%esp
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	78 06                	js     802007 <getchar+0x24>
	if (r < 1)
  802001:	74 06                	je     802009 <getchar+0x26>
	return c;
  802003:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    
		return -E_EOF;
  802009:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80200e:	eb f7                	jmp    802007 <getchar+0x24>

00802010 <iscons>:
{
  802010:	f3 0f 1e fb          	endbr32 
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201d:	50                   	push   %eax
  80201e:	ff 75 08             	pushl  0x8(%ebp)
  802021:	e8 71 f3 ff ff       	call   801397 <fd_lookup>
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 11                	js     80203e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802036:	39 10                	cmp    %edx,(%eax)
  802038:	0f 94 c0             	sete   %al
  80203b:	0f b6 c0             	movzbl %al,%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <opencons>:
{
  802040:	f3 0f 1e fb          	endbr32 
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80204a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204d:	50                   	push   %eax
  80204e:	e8 ee f2 ff ff       	call   801341 <fd_alloc>
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	85 c0                	test   %eax,%eax
  802058:	78 3a                	js     802094 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	68 07 04 00 00       	push   $0x407
  802062:	ff 75 f4             	pushl  -0xc(%ebp)
  802065:	6a 00                	push   $0x0
  802067:	e8 c2 f0 ff ff       	call   80112e <sys_page_alloc>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 21                	js     802094 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80207c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	50                   	push   %eax
  80208c:	e8 7d f2 ff ff       	call   80130e <fd2num>
  802091:	83 c4 10             	add    $0x10,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802096:	f3 0f 1e fb          	endbr32 
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	8b 75 08             	mov    0x8(%ebp),%esi
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.

	if (pg == NULL)
		pg = (void *) UTOP;
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020af:	0f 44 c2             	cmove  %edx,%eax
	int r = sys_ipc_recv(pg);
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	50                   	push   %eax
  8020b6:	e8 8a f1 ff ff       	call   801245 <sys_ipc_recv>
	if (r < 0) {
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 2b                	js     8020ed <ipc_recv+0x57>
			*perm_store = 0;
		}
		return r;
	}

	if (from_env_store) {
  8020c2:	85 f6                	test   %esi,%esi
  8020c4:	74 0a                	je     8020d0 <ipc_recv+0x3a>
		*from_env_store = thisenv->env_ipc_from;
  8020c6:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8020cb:	8b 40 74             	mov    0x74(%eax),%eax
  8020ce:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store) {
  8020d0:	85 db                	test   %ebx,%ebx
  8020d2:	74 0a                	je     8020de <ipc_recv+0x48>
		*perm_store = thisenv->env_ipc_perm;
  8020d4:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8020d9:	8b 40 78             	mov    0x78(%eax),%eax
  8020dc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020de:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8020e3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5e                   	pop    %esi
  8020eb:	5d                   	pop    %ebp
  8020ec:	c3                   	ret    
		if (from_env_store) {
  8020ed:	85 f6                	test   %esi,%esi
  8020ef:	74 06                	je     8020f7 <ipc_recv+0x61>
			*from_env_store = 0;
  8020f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) {
  8020f7:	85 db                	test   %ebx,%ebx
  8020f9:	74 eb                	je     8020e6 <ipc_recv+0x50>
			*perm_store = 0;
  8020fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802101:	eb e3                	jmp    8020e6 <ipc_recv+0x50>

00802103 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802103:	f3 0f 1e fb          	endbr32 
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	57                   	push   %edi
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	8b 7d 08             	mov    0x8(%ebp),%edi
  802113:	8b 75 0c             	mov    0xc(%ebp),%esi
  802116:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) {
		pg = (void *) UTOP;
  802119:	85 db                	test   %ebx,%ebx
  80211b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802120:	0f 44 d8             	cmove  %eax,%ebx
	}

	int ret;
	while ((ret = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802123:	ff 75 14             	pushl  0x14(%ebp)
  802126:	53                   	push   %ebx
  802127:	56                   	push   %esi
  802128:	57                   	push   %edi
  802129:	e8 ee f0 ff ff       	call   80121c <sys_ipc_try_send>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802134:	75 07                	jne    80213d <ipc_send+0x3a>
		sys_yield();
  802136:	e8 c8 ef ff ff       	call   801103 <sys_yield>
  80213b:	eb e6                	jmp    802123 <ipc_send+0x20>
	}

	if (ret < 0) {
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 08                	js     802149 <ipc_send+0x46>
		panic("sys_ipc_try_send error: %d \n", ret);
	}
}
  802141:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802144:	5b                   	pop    %ebx
  802145:	5e                   	pop    %esi
  802146:	5f                   	pop    %edi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    
		panic("sys_ipc_try_send error: %d \n", ret);
  802149:	50                   	push   %eax
  80214a:	68 e7 29 80 00       	push   $0x8029e7
  80214f:	6a 48                	push   $0x48
  802151:	68 04 2a 80 00       	push   $0x802a04
  802156:	e8 fa e4 ff ff       	call   800655 <_panic>

0080215b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80215b:	f3 0f 1e fb          	endbr32 
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80216a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80216d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802173:	8b 52 50             	mov    0x50(%edx),%edx
  802176:	39 ca                	cmp    %ecx,%edx
  802178:	74 11                	je     80218b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80217a:	83 c0 01             	add    $0x1,%eax
  80217d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802182:	75 e6                	jne    80216a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
  802189:	eb 0b                	jmp    802196 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80218b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80218e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802193:	8b 40 48             	mov    0x48(%eax),%eax
}
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    

00802198 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802198:	f3 0f 1e fb          	endbr32 
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021a2:	89 c2                	mov    %eax,%edx
  8021a4:	c1 ea 16             	shr    $0x16,%edx
  8021a7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ae:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021b3:	f6 c1 01             	test   $0x1,%cl
  8021b6:	74 1c                	je     8021d4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021b8:	c1 e8 0c             	shr    $0xc,%eax
  8021bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021c2:	a8 01                	test   $0x1,%al
  8021c4:	74 0e                	je     8021d4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021c6:	c1 e8 0c             	shr    $0xc,%eax
  8021c9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021d0:	ef 
  8021d1:	0f b7 d2             	movzwl %dx,%edx
}
  8021d4:	89 d0                	mov    %edx,%eax
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    
  8021d8:	66 90                	xchg   %ax,%ax
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__udivdi3>:
  8021e0:	f3 0f 1e fb          	endbr32 
  8021e4:	55                   	push   %ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 1c             	sub    $0x1c,%esp
  8021eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021fb:	85 d2                	test   %edx,%edx
  8021fd:	75 19                	jne    802218 <__udivdi3+0x38>
  8021ff:	39 f3                	cmp    %esi,%ebx
  802201:	76 4d                	jbe    802250 <__udivdi3+0x70>
  802203:	31 ff                	xor    %edi,%edi
  802205:	89 e8                	mov    %ebp,%eax
  802207:	89 f2                	mov    %esi,%edx
  802209:	f7 f3                	div    %ebx
  80220b:	89 fa                	mov    %edi,%edx
  80220d:	83 c4 1c             	add    $0x1c,%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	76 14                	jbe    802230 <__udivdi3+0x50>
  80221c:	31 ff                	xor    %edi,%edi
  80221e:	31 c0                	xor    %eax,%eax
  802220:	89 fa                	mov    %edi,%edx
  802222:	83 c4 1c             	add    $0x1c,%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
  80222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802230:	0f bd fa             	bsr    %edx,%edi
  802233:	83 f7 1f             	xor    $0x1f,%edi
  802236:	75 48                	jne    802280 <__udivdi3+0xa0>
  802238:	39 f2                	cmp    %esi,%edx
  80223a:	72 06                	jb     802242 <__udivdi3+0x62>
  80223c:	31 c0                	xor    %eax,%eax
  80223e:	39 eb                	cmp    %ebp,%ebx
  802240:	77 de                	ja     802220 <__udivdi3+0x40>
  802242:	b8 01 00 00 00       	mov    $0x1,%eax
  802247:	eb d7                	jmp    802220 <__udivdi3+0x40>
  802249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802250:	89 d9                	mov    %ebx,%ecx
  802252:	85 db                	test   %ebx,%ebx
  802254:	75 0b                	jne    802261 <__udivdi3+0x81>
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f3                	div    %ebx
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	31 d2                	xor    %edx,%edx
  802263:	89 f0                	mov    %esi,%eax
  802265:	f7 f1                	div    %ecx
  802267:	89 c6                	mov    %eax,%esi
  802269:	89 e8                	mov    %ebp,%eax
  80226b:	89 f7                	mov    %esi,%edi
  80226d:	f7 f1                	div    %ecx
  80226f:	89 fa                	mov    %edi,%edx
  802271:	83 c4 1c             	add    $0x1c,%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5f                   	pop    %edi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 f9                	mov    %edi,%ecx
  802282:	b8 20 00 00 00       	mov    $0x20,%eax
  802287:	29 f8                	sub    %edi,%eax
  802289:	d3 e2                	shl    %cl,%edx
  80228b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	89 da                	mov    %ebx,%edx
  802293:	d3 ea                	shr    %cl,%edx
  802295:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802299:	09 d1                	or     %edx,%ecx
  80229b:	89 f2                	mov    %esi,%edx
  80229d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a1:	89 f9                	mov    %edi,%ecx
  8022a3:	d3 e3                	shl    %cl,%ebx
  8022a5:	89 c1                	mov    %eax,%ecx
  8022a7:	d3 ea                	shr    %cl,%edx
  8022a9:	89 f9                	mov    %edi,%ecx
  8022ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022af:	89 eb                	mov    %ebp,%ebx
  8022b1:	d3 e6                	shl    %cl,%esi
  8022b3:	89 c1                	mov    %eax,%ecx
  8022b5:	d3 eb                	shr    %cl,%ebx
  8022b7:	09 de                	or     %ebx,%esi
  8022b9:	89 f0                	mov    %esi,%eax
  8022bb:	f7 74 24 08          	divl   0x8(%esp)
  8022bf:	89 d6                	mov    %edx,%esi
  8022c1:	89 c3                	mov    %eax,%ebx
  8022c3:	f7 64 24 0c          	mull   0xc(%esp)
  8022c7:	39 d6                	cmp    %edx,%esi
  8022c9:	72 15                	jb     8022e0 <__udivdi3+0x100>
  8022cb:	89 f9                	mov    %edi,%ecx
  8022cd:	d3 e5                	shl    %cl,%ebp
  8022cf:	39 c5                	cmp    %eax,%ebp
  8022d1:	73 04                	jae    8022d7 <__udivdi3+0xf7>
  8022d3:	39 d6                	cmp    %edx,%esi
  8022d5:	74 09                	je     8022e0 <__udivdi3+0x100>
  8022d7:	89 d8                	mov    %ebx,%eax
  8022d9:	31 ff                	xor    %edi,%edi
  8022db:	e9 40 ff ff ff       	jmp    802220 <__udivdi3+0x40>
  8022e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022e3:	31 ff                	xor    %edi,%edi
  8022e5:	e9 36 ff ff ff       	jmp    802220 <__udivdi3+0x40>
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__umoddi3>:
  8022f0:	f3 0f 1e fb          	endbr32 
  8022f4:	55                   	push   %ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802303:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80230b:	85 c0                	test   %eax,%eax
  80230d:	75 19                	jne    802328 <__umoddi3+0x38>
  80230f:	39 df                	cmp    %ebx,%edi
  802311:	76 5d                	jbe    802370 <__umoddi3+0x80>
  802313:	89 f0                	mov    %esi,%eax
  802315:	89 da                	mov    %ebx,%edx
  802317:	f7 f7                	div    %edi
  802319:	89 d0                	mov    %edx,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	83 c4 1c             	add    $0x1c,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	89 f2                	mov    %esi,%edx
  80232a:	39 d8                	cmp    %ebx,%eax
  80232c:	76 12                	jbe    802340 <__umoddi3+0x50>
  80232e:	89 f0                	mov    %esi,%eax
  802330:	89 da                	mov    %ebx,%edx
  802332:	83 c4 1c             	add    $0x1c,%esp
  802335:	5b                   	pop    %ebx
  802336:	5e                   	pop    %esi
  802337:	5f                   	pop    %edi
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    
  80233a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802340:	0f bd e8             	bsr    %eax,%ebp
  802343:	83 f5 1f             	xor    $0x1f,%ebp
  802346:	75 50                	jne    802398 <__umoddi3+0xa8>
  802348:	39 d8                	cmp    %ebx,%eax
  80234a:	0f 82 e0 00 00 00    	jb     802430 <__umoddi3+0x140>
  802350:	89 d9                	mov    %ebx,%ecx
  802352:	39 f7                	cmp    %esi,%edi
  802354:	0f 86 d6 00 00 00    	jbe    802430 <__umoddi3+0x140>
  80235a:	89 d0                	mov    %edx,%eax
  80235c:	89 ca                	mov    %ecx,%edx
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 fd                	mov    %edi,%ebp
  802372:	85 ff                	test   %edi,%edi
  802374:	75 0b                	jne    802381 <__umoddi3+0x91>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f7                	div    %edi
  80237f:	89 c5                	mov    %eax,%ebp
  802381:	89 d8                	mov    %ebx,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f5                	div    %ebp
  802387:	89 f0                	mov    %esi,%eax
  802389:	f7 f5                	div    %ebp
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	31 d2                	xor    %edx,%edx
  80238f:	eb 8c                	jmp    80231d <__umoddi3+0x2d>
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	89 e9                	mov    %ebp,%ecx
  80239a:	ba 20 00 00 00       	mov    $0x20,%edx
  80239f:	29 ea                	sub    %ebp,%edx
  8023a1:	d3 e0                	shl    %cl,%eax
  8023a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023a7:	89 d1                	mov    %edx,%ecx
  8023a9:	89 f8                	mov    %edi,%eax
  8023ab:	d3 e8                	shr    %cl,%eax
  8023ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023b9:	09 c1                	or     %eax,%ecx
  8023bb:	89 d8                	mov    %ebx,%eax
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 e7                	shl    %cl,%edi
  8023c5:	89 d1                	mov    %edx,%ecx
  8023c7:	d3 e8                	shr    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023cf:	d3 e3                	shl    %cl,%ebx
  8023d1:	89 c7                	mov    %eax,%edi
  8023d3:	89 d1                	mov    %edx,%ecx
  8023d5:	89 f0                	mov    %esi,%eax
  8023d7:	d3 e8                	shr    %cl,%eax
  8023d9:	89 e9                	mov    %ebp,%ecx
  8023db:	89 fa                	mov    %edi,%edx
  8023dd:	d3 e6                	shl    %cl,%esi
  8023df:	09 d8                	or     %ebx,%eax
  8023e1:	f7 74 24 08          	divl   0x8(%esp)
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	89 f3                	mov    %esi,%ebx
  8023e9:	f7 64 24 0c          	mull   0xc(%esp)
  8023ed:	89 c6                	mov    %eax,%esi
  8023ef:	89 d7                	mov    %edx,%edi
  8023f1:	39 d1                	cmp    %edx,%ecx
  8023f3:	72 06                	jb     8023fb <__umoddi3+0x10b>
  8023f5:	75 10                	jne    802407 <__umoddi3+0x117>
  8023f7:	39 c3                	cmp    %eax,%ebx
  8023f9:	73 0c                	jae    802407 <__umoddi3+0x117>
  8023fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802403:	89 d7                	mov    %edx,%edi
  802405:	89 c6                	mov    %eax,%esi
  802407:	89 ca                	mov    %ecx,%edx
  802409:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80240e:	29 f3                	sub    %esi,%ebx
  802410:	19 fa                	sbb    %edi,%edx
  802412:	89 d0                	mov    %edx,%eax
  802414:	d3 e0                	shl    %cl,%eax
  802416:	89 e9                	mov    %ebp,%ecx
  802418:	d3 eb                	shr    %cl,%ebx
  80241a:	d3 ea                	shr    %cl,%edx
  80241c:	09 d8                	or     %ebx,%eax
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    
  802426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	29 fe                	sub    %edi,%esi
  802432:	19 c3                	sbb    %eax,%ebx
  802434:	89 f2                	mov    %esi,%edx
  802436:	89 d9                	mov    %ebx,%ecx
  802438:	e9 1d ff ff ff       	jmp    80235a <__umoddi3+0x6a>
