/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(thn_divide, T_DIVIDE)
TRAPHANDLER_NOEC(thn_debug, T_DEBUG)
TRAPHANDLER_NOEC(thn_nmi, T_NMI)
TRAPHANDLER_NOEC(thn_brkpt, T_BRKPT)
TRAPHANDLER_NOEC(thn_oflow, T_OFLOW)
TRAPHANDLER_NOEC(thn_bound, T_BOUND)
TRAPHANDLER_NOEC(thn_illop, T_ILLOP)
TRAPHANDLER_NOEC(thn_device, T_DEVICE)
TRAPHANDLER_NOEC(thn_fperr, T_FPERR)
TRAPHANDLER_NOEC(thn_mchk, T_MCHK)
TRAPHANDLER_NOEC(thn_simderr, T_SIMDERR)
TRAPHANDLER_NOEC(thn_syscall, T_SYSCALL)
TRAPHANDLER_NOEC(thn_irq_timer, IRQ_OFFSET + IRQ_TIMER)
TRAPHANDLER(th_dblflt, T_DBLFLT)
TRAPHANDLER(th_tss, T_TSS)
TRAPHANDLER(th_segnp, T_SEGNP)
TRAPHANDLER(th_stack, T_STACK)
TRAPHANDLER(th_gpflt, T_GPFLT)
TRAPHANDLER(th_pgflt, T_PGFLT)
TRAPHANDLER(th_align, T_ALIGN)


/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
	pushl %es
	pushal
	movw $GD_KD, %ax
	movw %ax, %ds
	movw %ax, %es
	pushl %esp
	call trap
