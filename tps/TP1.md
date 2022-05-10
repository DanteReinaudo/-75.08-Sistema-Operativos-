TP1: Memoria virtual en JOS
===========================

boot_alloc_pos
--------------

--> 1) Un cálculo manual de la primera dirección de memoria que devolverá boot_alloc() tras el arranque. Se puede calcular a partir del binario compilado (obj/kern/kernel), usando los comandos readelf y/o nm y operaciones matemáticas.

    La primera direccion de memoria que devuelva boot_alloc() tras el arranque sera la direccion del end, estas es la direccion donde finaliza el kernel. Cabe destacar que no devuelve exactamente esa direccion sino que la redondea para que sea multiplo de 4k. La direccion del end es : f0118950 que redondeado a 4096 seria f0119000.
	

--> 2) Una sesión de GDB en la que, poniendo un breakpoint en la función boot_alloc(), se muestre el valor devuelto en esa primera llamada, usando el comando GDB finish.

Reading symbols from obj/kern/kernel...
Remote debugging using 127.0.0.1:26000
aviso: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
0x0000fff0 in ?? ()
(gdb) b boot_alloc
Punto de interrupción 1 at 0xf0100b29: file kern/pmap.c, line 89.
(gdb) n
No se pueden encontrar límites en la función actual
(gdb) step
No se pueden encontrar límites en la función actual
(gdb) finish
"finish" not meaningful in the outermost frame.
(gdb) continue
Continuando.
Se asume que la arquitectura objetivo es i386
=> 0xf0100b29 <boot_alloc>:	push   %ebp

Breakpoint 1, boot_alloc (n=65684) at kern/pmap.c:89
89	{
(gdb) n
=> 0xf0100b30 <boot_alloc+7>:	cmpl   $0x0,0xf0117538
98		if (!nextfree) {
(gdb) n
=> 0xf0100b7c <boot_alloc+83>:	mov    $0xf011994f,%eax
100			nextfree = ROUNDUP((char *) end, PGSIZE);
(gdb) n
=> 0xf0100b39 <boot_alloc+16>:	mov    0xf0117538,%esi
109		result = nextfree;
(gdb) p nextfree
$1 = 0xf0119000 ""
(gdb) p &end
$2 = (<data variable, no debug info> *) 0xf0118950



=======================================================================================================================================


page_alloc
----------

--> Responder: ¿en qué se diferencia page2pa() de page2kva()?

	Principalmente, en que page2pa() devuelve la dirección física de struct PageInfo y page2kva() devuelve su dirección virtual.

=======================================================================================================================================


map_region_large
----------------

--> ¿cuánta memoria se ahorró de este modo? (en KiB)

	Se ahorran 4KB, ya que con large_pages los 1024 punteros que tenemos a la page table se ahorran.


--> ¿es una cantidad fija, o depende de la memoria física de la computadora?

	Como el tamaño de la página no va a cambiar, estamos frente a una cantidad fija de memoria (4KB), sea cual sea la cantidad total de memoria fija. 

=======================================================================================================================================
