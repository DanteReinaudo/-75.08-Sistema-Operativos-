TP2: Procesos de usuario
========================


env_alloc
---------

--> ¿Qué identificadores se asignan a los primeros 5 procesos creados? (Usar base hexadecimal.)

	El identificador asignado para el 1° proceso creado es: 0x00001000 = 4096 
	El identificador asignado para el 2° proceso creado es: 0x00001001 = 4097
	El identificador asignado para el 3° proceso creado es: 0x00001002 = 4098
	El identificador asignado para el 4° proceso creado es: 0x00001003 = 4099
	El identificador asignado para el 5° proceso creado es: 0x00001004 = 4100
	
	
--> Supongamos que al arrancar el kernel se lanzan NENV procesos a ejecución. A continuación se destruye el proceso asociado a envs[630] y   se lanza un proceso que cada segundo muere y se vuelve a lanzar (se destruye, y se vuelve a crear). ¿Qué identificadores tendrán esos procesos en las primeras cinco ejecuciones?


	1er env_id: 0x1276 = 4726
	2do env_id: 0x2276 = 8822
	3er env_id: 0x3276 = 12918
	4to env_id: 0x4276 = 17014
	5to env_id: 0x5276 = 21110
	

===========================================================================================================


env_init_percpu
---------------

--> ¿Cuántos bytes escribe la función lgdt, y dónde?
	
	La función lgdt('Load Global Descriptor Table Register'), ocupa 6 bytes ), y escribe sobre la direccion de memoria de la variable 	gdt_pd, seteando el registro gdtr. 
		 

-->¿Qué representan esos bytes?
	
	Esos 6 bytes representan: 
	  uint16_t: para límite, que es -->  (sizeof(gdt) -1) y 
	  uint32_t para base, que es --> dirección virtual de la gdt (Global Descriptor Table)

===========================================================================================================


env_pop_tf
----------

--> Dada la secuencia de instrucciones assembly en la función, describir qué contiene durante su ejecución:
	
	*el tope de la pila justo antes popal: reg_edi
	*el tope de la pila justo antes iret: trapframe
	*el tercer elemento de la pila justo antes de iret: tf_eip 


--> En la documentación de iret en [IA32-2A] se dice:
	"If the return is to another privilege level, the IRET instruction also pops the stack pointer and SS from the stack, before 		resuming program execution."
	¿Cómo determina la CPU (en x86) si hay un cambio de ring (nivel de privilegio)?
	
	 En campo de TrapFreme cs se guarda el nivel de privilegio en el que está actualmente (los dos bits menos significativos del
	registro). Entonces, si los bits menos significativos del registro %cs actual son distintos => hubo un cambio de ring.
	

===========================================================================================================


gdb_hello
---------

	1) Poner un breakpoint en env_pop_tf() y continuar la ejecución hasta allí.

		(gdb) b env_pop_tf
		Punto de interrupción 1 at 0xf0102f46: file kern/env.c, line 486.
		(gdb) c
		Continuando.
		Se asume que la arquitectura objetivo es i386
		=> 0xf0102f46 <env_pop_tf>:	endbr32 

		Breakpoint 1, env_pop_tf (tf=0xf01c7000) at kern/env.c:486
		486	{


	2) En QEMU, entrar en modo monitor (Ctrl-a c), y mostrar las cinco primeras líneas del comando info registers.

		(qemu) info registers
		EAX=003bc000 EBX=00010094 ECX=f03bc000 EDX=00000216
		ESI=00010094 EDI=00000000 EBP=f0118fd8 ESP=f0118fbc
		EIP=f0102f46 EFL=00000092 [--S-A--] CPL=0 II=0 A20=1 SMM=0 HLT=0
		ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
		CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]

	3) De vuelta a GDB, imprimir el valor del argumento tf:

		(gdb) p tf
		$1 = (struct Trapframe *) 0xf01c7000


	4) Imprimir, con x/Nx tf tantos enteros como haya en el struct Trapframe donde N = sizeof(Trapframe) / sizeof(int).

		(gdb) print sizeof(struct Trapframe) / sizeof(int)
		$2 = 17

		(gdb) x/17 tf
		   0xf01c7000:    add    %al,(%eax)
		   0xf01c7002:    add    %al,(%eax)
		   0xf01c7004:    add    %al,(%eax)
		   0xf01c7006:    add    %al,(%eax)
		   0xf01c7008:    add    %al,(%eax)
		   0xf01c700a:    add    %al,(%eax)
		   0xf01c700c:    add    %al,(%eax)
		   0xf01c700e:    add    %al,(%eax)
		   0xf01c7010:    add    %al,(%eax)
		   0xf01c7012:    add    %al,(%eax)
		   0xf01c7014:    add    %al,(%eax)
		   0xf01c7016:    add    %al,(%eax)
		   0xf01c7018:    add    %al,(%eax)
		   0xf01c701a:    add    %al,(%eax)
		   0xf01c701c:    add    %al,(%eax)
		   0xf01c701e:    add    %al,(%eax)
		   0xf01c7020:    and    (%eax),%eax

		(gdb) x/17x tf
		0xf01c7000:	0x00000000	0x00000000	0x00000000	0x00000000
		0xf01c7010:	0x00000000	0x00000000	0x00000000	0x00000000
		0xf01c7020:	0x00000023	0x00000023	0x00000000	0x00000000
		0xf01c7030:	0x00800020	0x0000001b	0x00000000	0xeebfe000
		0xf01c7040:	0x00000023



	5)Avanzar hasta justo después del movl ...,%esp, usando si M para ejecutar tantas instrucciones como sea necesario en un solo paso:

		(gdb) disas
		Dump of assembler code for function env_pop_tf:
		=> 0xf0102f46 <+0>:	endbr32 
		   0xf0102f4a <+4>:	push   %ebp
		   0xf0102f4b <+5>:	mov    %esp,%ebp
		   0xf0102f4d <+7>:	sub    $0xc,%esp
		   0xf0102f50 <+10>:	mov    0x8(%ebp),%esp
		   0xf0102f53 <+13>:	popa 
		   0xf0102f54 <+14>:	pop    %es
		   0xf0102f55 <+15>:	pop    %ds
		   0xf0102f56 <+16>:	add    $0x8,%esp
		   0xf0102f59 <+19>:	iret 
		   0xf0102f5a <+20>:	push   $0xf0105590
		   0xf0102f5f <+25>:	push   $0x1f0
		   0xf0102f64 <+30>:	push   $0xf010555a
		   0xf0102f69 <+35>:	call   0xf01000ad <_panic>
		End of assembler dump.


		(gdb) si
		=> 0xf0102f4a <env_pop_tf+4>:	push   %ebp
		0xf0102f4a	486	{
		(gdb) si
		=> 0xf0102f4b <env_pop_tf+5>:	mov    %esp,%ebp
		0xf0102f4b in env_pop_tf (tf=0xf0102fc4 <env_run+86>) at kern/env.c:486
		486	{
		(gdb) si
		=> 0xf0102f4d <env_pop_tf+7>:	sub    $0xc,%esp
		0xf0102f4d	486	{
		(gdb) si
		=> 0xf0102f50 <env_pop_tf+10>:	mov    0x8(%ebp),%esp
		env_pop_tf (tf=0x10094) at kern/env.c:487
		487		asm volatile("\tmovl %0,%%esp\n"
		(gdb) si
		=> 0xf0102f53 <env_pop_tf+13>:	popa   
		0xf0102f53 in env_pop_tf (tf=0x0) at kern/env.c:487
		487		asm volatile("\tmovl %0,%%esp\n"




	6)Comprobar, con x/Nx $sp que los contenidos son los mismos que tf (donde N es el tamaño de tf).

		(gdb) x/17x $sp
		0xf01c7000:	0x00000000	0x00000000	0x00000000	0x00000000
		0xf01c7010:	0x00000000	0x00000000	0x00000000	0x00000000
		0xf01c7020:	0x00000023	0x00000023	0x00000000	0x00000000
		0xf01c7030:	0x00800020	0x0000001b	0x00000000	0xeebfe000
		0xf01c7040:	0x00000023

		 Se puede observar que los contenidos son los mismos que tf.

	7)Describir cada uno de los valores. Para los valores no nulos, se debe indicar dónde se configuró inicialmente el valor, y qué 		representa.

		 Los valores hacen referencia los elementos definidos en el struct Trapframe en conjunto a los 8 registros que contiene el 		struct PushRegs. Dado que algunos valores del struct Trapframe son del tipo uin16_t, se realizara un padding por lo que 			apareceran como un solo registro. El struct Trapframe contiene 9 registros, en conjunto con los 8 registros del struct 			PushRegs, obtenemos los 17 enteros de 32 bits calculados anteriormente.

		 Los valores nulos son tf_err, tf_trapno, tf_eflags y los de PushRegs. 
		 Los valores no nulos seran tf_es, tf_ds, tf_cs, tf_ss y tf_esp y su valor se configuro incialmente en env alloc(). Ademas 		el registro tf_eip no sera nulo, y se sette en load_icode()


	8)Continuar hasta la instrucción iret, sin llegar a ejecutarla. Mostrar en este punto, de nuevo, las cinco primeras líneas de info 	registers en el monitor de QEMU. Explicar los cambios producidos.

		 Previo:
		(qemu) info registers
		EAX=003bc000 EBX=00010094 ECX=f03bc000 EDX=00000216
		ESI=00010094 EDI=00000000 EBP=f0118fd8 ESP=f0118fbc
		EIP=f0102f46 EFL=00000092 [--S-A--] CPL=0 II=0 A20=1 SMM=0 HLT=0
		ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
		CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]

		 Actual:
		(qemu) info registers
		EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
		ESI=00000000 EDI=00000000 EBP=00000000 ESP=f01c7030
		EIP=f0102f59 EFL=00000096 [--S-AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
		ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
		CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]

		 Debido a la instruccion popal, los valores de los registros de proposito general fueron actualizados a los valores del 			Trapframe.
		 Debido a la instruccion pop %%es, se actualiza el valor del registro ES.
		 Debido a la instruccion pop %%ds, se actualiza el valor del registro DS.
		 Debido a que se avanzaron unas lineas de codigo el instruction pointer se modifico y el registro EIP se modifico.


	9)Ejecutar la instrucción iret. En ese momento se ha realizado el cambio de contexto y los símbolos del kernel ya no son válidos.

		imprimir el valor del contador de programa con p $pc o p $eip
		cargar los símbolos de hello con el comando add-symbol-file, así:
		(gdb) add-symbol-file obj/user/hello 0x800020
		add symbol table from file "obj/user/hello" at
			.text_addr = 0x800020
		(y or n) y
		Reading symbols from obj/user/hello...
		volver a imprimir el valor del contador de programa
		Mostrar una última vez la salida de info registers en QEMU, y explicar los cambios producidos.

		(gdb) si
		=> 0xf0102f59 <env_pop_tf+19>:	iret   
		0xf0102f59	487		asm volatile("\tmovl %0,%%esp\n"
		(gdb) s
		=> 0x800020:	cmp    $0xeebfe000,%esp
		0x00800020 in ?? ()
		(gdb) p $pc
		$3 = (void (*)()) 0x800020
		(gdb) p $eip
		$4 = (void (*)()) 0x800020
		(gdb) add-symbol-fyle obj/user/hello 0x800020
		orden indefinida: «add-symbol-fyle». Intente con «help»
		(gdb) add-symbol-file obj/user/hello 0x800020
		add symbol table from file "obj/user/hello" at
			.text_addr = 0x800020
		(y or n) y
		Reading symbols from obj/user/hello...
		(gdb) p $pc
		$5 = (void (*)()) 0x800020 <_start>
		(gdb) p $eip
		$6 = (void (*)()) 0x800020 <_start>

		(qemu) info registers
		EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
		ESI=00000000 EDI=00000000 EBP=00000000 ESP=eebfe000
		EIP=00800020 EFL=00000002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
		ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
		CS =001b 00000000 ffffffff 00cffa00 DPL=3 CS32 [-R-]

		 Se actualizaron los registros EIP, CS, EFL Y SS a los valores indicados por el struct Trapframe.


	10)Poner un breakpoint temporal (tbreak, se aplica una sola vez) en la función syscall() y explicar qué ocurre justo tras ejecutar 	la instrucción int $0x30. Usar, de ser necesario, el monitor de QEMU.

		(gdb) tbreak syscall
		Punto de interrupción temporal 2 at 0x800a3e: syscall. (2 locations)
		(gdb) continue
		Continuando.

		=> 0x800a3e <syscall+17>:	mov    0x8(%ebp),%ecx

		Temporary breakpoint 2, syscall (num=0, check=-289415544, a1=4005551752, 
		    a2=13, a3=0, a4=0, a5=0) at lib/syscall.c:23
		23		asm volatile("int %1\n"
		(gdb) si
		=> 0x800a41 <syscall+20>:	mov    0xc(%ebp),%ebx
		0x00800a41	23		asm volatile("int %1\n"
		(gdb) si
		=> 0x800a44 <syscall+23>:	mov    0x10(%ebp),%edi
		0x00800a44	23		asm volatile("int %1\n"
		(gdb) si
		=> 0x800a47 <syscall+26>:	mov    0x14(%ebp),%esi
		0x00800a47	23		asm volatile("int %1\n"
		(gdb) si
		=> 0x800a4a <syscall+29>:	int    $0x30
		0x00800a4a	23		asm volatile("int %1\n"
		(gdb) s
		Se asume que la arquitectura objetivo es i8086
		[f000:e05b]    0xfe05b:	cmpw   $0xffc8,%cs:(%esi)
		0x0000e05b in ?? ()


		(qemu) info registers
		EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
		ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
		EIP=0000e05b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
		ES =0000 00000000 0000ffff 00009300
		CS =f000 000f0000 0000ffff 00009b00

		 Al querer ejecutar la instruccion int $0x30 se genera una interrupcion y el kernel se encarga de resolverla.



===========================================================================================================


kern_idt
--------

--> Cómo decidir si usar TRAPHANDLER o TRAPHANDLER_NOEC? ¿Qué pasaría si se usara solamente la primera?
	 
	 En nuestro caso, se utilizó TRAPHANDLER para los casos en los que se quiere devolver un error de retorno, automáticamente hace un 	push al stack del código de error, y TRAPHANDLER_NOEC se utilizó en los casos en que no se debía devolver un código de error. 
 	 Si no se utiliza este último, en donde la CPU no hace push deñ error habria un formato inválido.

 
--> ¿Qué cambia, en la invocación de handlers, el segundo parámetro (istrap) de la macro SETGATE? ¿Por qué se elegiría un comportamiento u otro durante un syscall?
	
	 Caso: interrupt gate => utilizamos como parámetro 0 => la CPU deshabilita las interrupciones cuando se está en modo kernel.
	 
	 Caso: trap gate      => utilizamos como parámetro 1 => la CPU no deshabilita las interrupciones cuando se está en modo kernel.
	 
	 Interrupt gate se usa para prevenir otras interrupciones durante el manejo de los handlers. Se elegiría durante un syscall,  		mediante un flag, para que se active hasta el final, ya que de esta manera se le puede dar el permiso de interrupción a los 
	handlers de otros errores.


--> Leer user/softint.c y ejecutarlo con make run-softint-nox. ¿Qué interrupción trata de generar? ¿Qué interrupción se genera? Si son diferentes a la que invoca el programa… ¿cuál es el mecanismo por el que ocurrió esto, y por qué motivos? ¿Qué modificarían en JOS para cambiar este comportamiento?


	Booting from Hard Disk..6828 decimal is 15254 octal!
	Physical memory: 131072K available, base = 640K, extended = 130432K
	check_page_alloc() succeeded!
	check_page() succeeded!
	check_kern_pgdir() succeeded!
	check_page_installed_pgdir() succeeded!
	[00000000] new env 00001000
	Incoming TRAP frame at 0xefffffbc
	TRAP frame at 0xf01c8000
	  edi  0x00000000
	  esi  0x00000000
	  ebp  0xeebfdff0
	  oesp 0xefffffdc
	  ebx  0x00000000
	  edx  0x00000000
	  ecx  0x00000000
	  eax  0x00000000
	  es   0x----0023
	  ds   0x----0023
	  trap 0x0000000d General Protection
	  err  0x00000072
	  eip  0x00800037
	  cs   0x----001b
	  flag 0x00000082
	  esp  0xeebfdfd4
	  ss   0x----0023
	[00001000] free env 00001000
	Destroyed the only environment - nothing more to do!
	Welcome to the JOS kernel monitor!

	 Al ejecutar el programa en lugar de invocarse un PageFault, se genera la interrupcion General Protection. Dado que al intentar 		llamar la interrupcion 14 (PageFault) en el programa softint.c estamos con privilegios de modo usuario, y que en el archivo trap.c 	se definio que esta interrupcion debia manejarse con un nivel de privilegio 0 (modo kernel), ocurre la excepcion General
	Protection(13). 



===========================================================================================================


evil_hello
----------

--> ¿En qué se diferencia el código de la versión en evilhello.c mostrada arriba?
	
	En la version nueva de evil hello se intenta acceder a la dirección 0xf010000c desde modo usuario... Una dirección que pertenece 
	al kernel, por lo que ocurre un pageFault.

--> ¿En qué cambia el comportamiento durante la ejecución? ¿Por qué? ¿Cuál es el mecanismo?
	
	En la versión original no se intenta acceder a una dirección desde modo usuario que solo se puede acceder desde modo kernel, por lo 	que no se genera un pageFault. En cambio, se le pasa la dirección al kernel para que este acceda dentro del handler de la syscall en 	cuestión. Por lo que el programa puede finalizar correctamente.

	 En la versión nueva de evil hello, sí se intenta acceder a memoria, que solo puede ser accedida desde modo kernel, desde modo 		usuario, lo que cause el pageFault.



--> Listar las direcciones de memoria que se acceden en ambos casos, y en qué ring se realizan. ¿Es esto un problema? ¿Por qué?

	-Evil hello word original:

		void
		umain(int argc, char **argv)
		{
			cprintf("hello, world\n");
			cprintf("i am environment %08x\n", thisenv->env_id);
		}

		Con el cual obtenemos la siguiente salida

		qemu-system-i386 -drive file=obj/kern/kernel.img,index=0,media=disk,format=raw -serial mon:stdio -gdb tcp:127.0.0.1:26000 			-D qemu.log  -d guest_errors
		6828 decimal is 15254 octal!
		Physical memory: 131072K available, base = 640K, extended = 130432K
		check_page_alloc() succeeded!
		check_page() succeeded!
		check_kern_pgdir() succeeded!
		check_page_installed_pgdir() succeeded!
		[00000000] new env 00001000
		Incoming TRAP frame at 0xefffffbc
		hello, world
		Incoming TRAP frame at 0xefffffbc
		Incoming TRAP frame at 0xefffffbc
		i am environment 00001000
		Incoming TRAP frame at 0xefffffbc
		[00001000] exiting gracefully
		[00001000] free env 00001000
		Destroyed the only environment - nothing more to do!
		Welcome to the JOS kernel monitor!



	-Evil hello versión nueva

		void
		umain(int argc, char **argv)
		{
		    char *entry = (char *) 0xf010000c;
		    char first = *entry;
		    sys_cputs(&first, 1);
		}


		Con el cual obtenemos la siguiente salida

		qemu-system-i386 -drive file=obj/kern/kernel.img,index=0,media=disk,format=raw -serial mon:stdio -gdb tcp:127.0.0.1:26000 -		D qemu.log  -d guest_errors
		6828 decimal is 15254 octal!
		Physical memory: 131072K available, base = 640K, extended = 130432K
		check_page_alloc() succeeded!
		check_page() succeeded!
		check_kern_pgdir() succeeded!
		check_page_installed_pgdir() succeeded!
		[00000000] new env 00001000
		Incoming TRAP frame at 0xefffffbc
		[00001000] user fault va f010000c ip 0080003d
		TRAP frame at 0xf01c8000
		  edi  0x00000000
		  esi  0x00000000
		  ebp  0xeebfdfd0
		  oesp 0xefffffdc
		  ebx  0x00000000
		  edx  0x00000000
		  ecx  0x00000000
		  eax  0x00000000
		  es   0x----0023
		  ds   0x----0023
		  trap 0x0000000e Page Fault
		  cr2  0xf010000c
		  err  0x00000005 [user, read, protection]
		  eip  0x0080003d
		  cs   0x----001b
		  flag 0x00000082
		  esp  0xeebfdfb0
		  ss   0x----0023
		[00001000] free env 00001000
		Destroyed the only environment - nothing more to do!
		Welcome to the JOS kernel monitor!


