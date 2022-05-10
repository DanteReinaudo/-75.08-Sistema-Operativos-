TP3: Multitarea con desalojo
============================


env_return
---------

--> al terminar un proceso su función umain() ¿dónde retoma la ejecución el kernel? Describir la secuencia de llamadas desde que termina umain() hasta que el kernel dispone del proceso.

	La funcion umain() es llamada por la funcion libmain() la cual se encuentra dentro del archivo lib/entry.S. Esta funcion se encarga de configurar la variable thisenv y el nombre del binario previo a realizar la llamada de umain(). Una vez el proceso termina con su funcion umain(), la ejecucion retorna a libmain(), quien luego llama a exit() para que el kernel disponga el proceso.

--> ¿en qué cambia la función env_destroy() en este TP, respecto al TP anterior?

	Dado a que en el TP anterior, no se contaba con multiples procesos, no era necesario realizar ninguna validacion, simplemente se liberaba el proceso. Ahora, ya que el proceso puede estar corriendo en otro CPU, es necesario verificar si el proceso esta corriendo y en que CPU. Si el proceso se encuentra corriendo, y no es el proceso actual de esta CPU, se cambia su estado a ENV_DYING, convirtiendose en un proceso zombie, el cual se liberara la proxima vez que el kernel tome el control. En otro caso, el proceso es liberado y si el proceso se encontraba corriendo en la CPU actual, se actualiza el currenv a NULL, y se llama a sched_yield().

===========================================================================================================


sys_yield
---------

--> Leer y estudiar el código del programa user/yield.c. Cambiar la función i386_init() para lanzar tres instancias de dicho programa, y mostrar y explicar la salida de make qemu-nox.
	    
	check_page_free_list() succeeded!
	check_page_alloc() succeeded!
	check_page() succeeded!
	check_kern_pgdir() succeeded!
	check_page_free_list() succeeded!
	check_page_installed_pgdir() succeeded!
	SMP: CPU 0 found 1 CPU(s)
	enabled interrupts: 1 2
	[00000000] new env 00001000
	[00000000] new env 00001001
	[00000000] new env 00001002
	Hello, I am environment 00001000.
	Hello, I am environment 00001001.
	Hello, I am environment 00001002.
	Back in environment 00001000, iteration 0.
	Back in environment 00001001, iteration 0.
	Back in environment 00001002, iteration 0.
	Back in environment 00001000, iteration 1.
	Back in environment 00001001, iteration 1.
	Back in environment 00001002, iteration 1.
	Back in environment 00001000, iteration 2.
	Back in environment 00001001, iteration 2.
	Back in environment 00001002, iteration 2.
	Back in environment 00001000, iteration 3.
	Back in environment 00001001, iteration 3.
	Back in environment 00001002, iteration 3.
	Back in environment 00001000, iteration 4.
	All done in environment 00001000.
	[00001000] exiting gracefully
	[00001000] free env 00001000
	Back in environment 00001001, iteration 4.
	All done in environment 00001001.
	[00001001] exiting gracefully
	[00001001] free env 00001001
	Back in environment 00001002, iteration 4.
	All done in environment 00001002.
	[00001002] exiting gracefully
	[00001002] free env 00001002
	No runnable environments in the system!
	Welcome to the JOS kernel monitor!
	Type 'help' for a list of commands.

	Se crean los tres procesos y por  cada iteracion de la funcion umain un proceso se desaloja, dado que sched_yield utiliza Round  Robin como politica de planificacion. Comienza el primer proceso 00001000, este es desalojado y pasa a ejecutarse el segundo 	 proceso 00001001, se ejecuta y se desaloja, pasa a ejecutarse el proceso 00001002, es desalojado y vuelve a ejecutarse el primer 	 proceso. Se itera 5 veces cada proceso y termina la ejecucion.

===========================================================================================================

envid2env
---------

--> ¿Qué ocurre en JOS si un proceso llama a sys_env_destroy(0)?.
    
    El llamado a sys_env_destroy(0), en primer lugar, la syscall traduce el envid en un struct Env* con la funcion envid2env. Al llamar a envid2env(0), se devuelve el proceso actual, es decir el curenv. Luego se realiza env_destroy() por lo que se estaria destruyendo el proceso actual. 

===========================================================================================================

dumbfork
---------

--> Si una página no es modificable en el padre ¿lo es en el hijo? En otras palabras: ¿se preserva, en el hijo, el flag de solo-lectura en las páginas copiadas?

	En el hijo no se preserva el flag de solo-lectura de las paginas copiadas, ya que dentro de la funcion duppage, se hace un llamado a la la funcion sys_page_alloc() con los permisos PTE_P|PTE_U|PTE_W. De esta manera sin importar los permisos originales, estos son reemplazados por los flags PTE_P|PTE_U|PTE_W

--> Mostrar, con código en espacio de usuario, cómo podría dumbfork() verificar si una dirección en el padre es de solo lectura, de tal manera que pudiera pasar como tercer parámetro a duppage() un booleano llamado readonly que indicase si la página es modificable o no:

	En el siguiente fragmento de código podemos saber si una dirección de memoria es modificable por el proceso o no:

	pde_t pde = uvpd[PDX(addr)];

	// Verificamos bit de presencia de la page table.
	if (pde & PTE_P) {
	  // Obtenemos el PTE
	  pte_t pte = uvpt[PGNUM(addr)];

	  // Verificamos bit de presencia de la página
	  if (pte & PTE_P) {
	    if (pte & PTE_W) {
	      // Modificable por el usuario
	    } else {
	      // No modificable por el usuario
	    }
	...

--> Supongamos que se desea actualizar el código de duppage() para tener en cuenta el argumento readonly: si este es verdadero, la página copiada no debe ser modificable en el hijo. Es fácil hacerlo realizando una última llamada a sys_page_map() para eliminar el flag PTE_W en el hijo, cuando corresponda:

	void duppage(envid_t dstenv, void *addr, bool readonly) {
	    // Código original (simplificado): tres llamadas al sistema.
	    sys_page_alloc(dstenv, addr, PTE_P | PTE_U | PTE_W);
	    sys_page_map(dstenv, addr, 0, UTEMP, PTE_P | PTE_U | PTE_W);

	    memmove(UTEMP, addr, PGSIZE);
	    sys_page_unmap(0, UTEMP);

	    // Código nuevo: una llamada al sistema adicional para solo-lectura.
	    if (readonly) {
		sys_page_map(dstenv, addr, dstenv, addr, PTE_P | PTE_U);
	    }
	}

	Esta versión del código, no obstante, incrementa las llamadas al sistema que realiza duppage() de tres, a cuatro. Se pide mostrar una versión en el que se implemente la misma funcionalidad readonly, pero sin usar en ningún caso más de tres llamadas al sistema.

	void duppage(envid_t dstenv, void *addr, bool readonly) {
	    // Código original (simplificado): tres llamadas al sistema.
	    sys_page_alloc(dstenv, addr, PTE_P | PTE_U | PTE_W);
	    int flags =  PTE_P | PTE_U | PTE_W
	    if (readonly) {
		flags = PTE_P | PTE_U   
	    }
	    sys_page_map(dstenv, addr, 0, UTEMP, flags);

	    memmove(UTEMP, addr, PGSIZE);
	    sys_page_unmap(0, UTEMP);

	}
	
===========================================================================================================


multicore_init
------------

--> ¿Qué código copia, y a dónde, la siguiente línea de la función boot_aps()?

     memmove(code, mpentry_start, mpentry_end - mpentry_start);

	Podemos clasificar a los CPUs en dos tipos: BSP (bootstrap procesors) responsables de bootear el sistema operativo,y APs (application procesors) activados por el BSP una vez que el sistema operativo esta inicializado. Una vez, inicializado el sistema operativo, el CPU BSP, invoca la funcion boot_aps(), que inicializa los APs. Esta linea, es ejecutada por la BSP, y se encarga de copiar codigo que se utilizara como entry-point para los CPUs tipo APs. Se copiara el codigo de mpentry.S a la memoria apuntada por code, las variables mpentry-start y mpentry_end, sirven para determinar el tamaño del codigo a copiar.


--> ¿Para qué se usa la variable global mpentry_kstack? ¿Qué ocurriría si el espacio para este stack se reservara en el archivo kern/mpentry.S, de manera similar a bootstack en el archivo kern/entry.S?

	La variable global mpentry_kstack es un puntero al kernel stack del proximo cpu a inicializar, se usa para poder cambiar dinamicamente el valor del puntero al stack del core que se esta booteando.
	El espacio para ese stack no puede reservarse en el archivo kern/mpentry.S, de manera similar al bootsack en el archivo kern/entry.S, ya que los stacks de cada core apuntarian a la misma direccion de memoria.

--> En el archivo kern/mpentry.S se puede leer:

     # We cannot use kern_pgdir yet because we are still
     # running at a low EIP.
     movl $(RELOC(entry_pgdir)), %eax
¿Qué valor tendrá el registro %eip cuando se ejecute esa línea?
Responder con redondeo a 12 bits, justificando desde qué región de memoria se está ejecutando este código.

	El registro %eip, apunta a la direccion fisica 0x7000 la cual redondeada a 12 bits es 0x7000, esto se debe que la linea pertenece al entry point de un Apllication procesor, dicho coidgo fue mapeado a la direccion MPENDTRY_PADDR en boot_aps(). 
===========================================================================================================

ipc_recv
------------

--> Una vez implementada la función, resolver este ejercicio:
Un proceso podría intentar enviar el valor númerico -E_INVAL vía ipc_send(). ¿Cómo es posible distinguir si es un error, o no?

	envid_t src = -1;
	int r = ipc_recv(&src, 0, NULL);

	if (r < 0)
	  if (/* ??? */)
	    puts("Hubo error.");
	  else
	    puts("Valor negativo correcto.")
	    
	    
    El wrapper ipc_recv fue llamado con un valor de from_env_store distinto de NULL, por lo que de fallar la syscall dicho valor será puesto a cero. Entonces el código para diferenciar un error de un valor negativo enviado podría ser:

se puede corroborar que el src es distinto a 0 porque si fuese 0 quiere decir que hubo algún error en la syscall.
===========================================================================================================


sys_ipc_try_send
------------

--> Se pide ahora explicar cómo se podría implementar una función sys_ipc_send() (con los mismos parámetros que sys_ipc_try_send()) que sea bloqueante, es decir, que si un proceso A la usa para enviar un mensaje a B, pero B no está esperando un mensaje, el proceso A sea puesto en estado ENV_NOT_RUNNABLE, y despertado una vez B llame a ipc_recv() (cuya firma no debe ser cambiada).

  
  Es posible que surjan varias alternativas de implementación; para cada una, indicar:
    - qué cambios se necesitan en struct Env para la implementación (campos nuevos, y su tipo; campos cambiados, o eliminados, si los hay)
    - qué asignaciones de campos se harían en sys_ipc_send()
    - qué código se añadiría en sys_ipc_recv()
	
	
	Para implementar una función sys_ipc_send(), con los mismos parámetros originales, pero que sea bloqueante, lo que se pordría hacer 	es cambiar su estado a "ENV_NOT_RUNNABLE", para luego llamar a sys_yield(), en vez de devolver "-E_IPC_NOT_RECV". Para el proceso B, 	necesitamos saber la fuente del mensaje, y lo que se puede usar es "thisenv->env_ipc_from", pasando este env a la syscall 	 	"sys_ipc_recv", obviamente debemos modificarla para que pueda recibirlo,  y así se pueda hallar el entorno de la fuente y que  		despierte a B.


--> Responder, para cada diseño propuesto:
    - ¿existe posibilidad de deadlock?
    Dado que ahora la syscall es bloqueante, puede existir la posibilidad de deadlock, ya que se cumple la condicion necesaria de hold-and-wait, donde un proceso se queda bloqueado acaparando un recurso y no lo suelta hasta que se cumpla cierta condicion. 
    
    
===========================================================================================================


