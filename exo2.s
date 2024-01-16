	.file	"exo2.c"
	.text
	.p2align 4
	.type	testSum._omp_fn.0, @function
testSum._omp_fn.0:
.LFB44:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	8(%rbp), %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %ecx
	jl	.L2
.L7:
	imull	%eax, %ecx
	addl	%ecx, %edx
	leal	(%rax,%rdx), %r8d
	cmpl	%r8d, %edx
	jge	.L1
	leal	-1(%rax), %ecx
	movq	0(%rbp), %r9
	cmpl	$2, %ecx
	jbe	.L4
	movl	%eax, %edi
	movslq	%edx, %rcx
	movaps	.LC0(%rip), %xmm1
	shrl	$2, %edi
	leaq	(%r9,%rcx,4), %rsi
	xorl	%ecx, %ecx
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L5:
	movups	(%rsi,%rcx), %xmm0
	mulps	%xmm1, %xmm0
	movups	%xmm0, (%rsi,%rcx)
	addq	$16, %rcx
	cmpq	%rdi, %rcx
	jne	.L5
	movl	%eax, %ecx
	andl	$-4, %ecx
	addl	%ecx, %edx
	cmpl	%ecx, %eax
	je	.L1
.L4:
	movslq	%edx, %rax
	movss	.LC1(%rip), %xmm0
	leaq	(%r9,%rax,4), %rax
	movss	(%rax), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, (%rax)
	leal	1(%rdx), %eax
	cmpl	%eax, %r8d
	jle	.L1
	cltq
	addl	$2, %edx
	leaq	(%r9,%rax,4), %rax
	movss	(%rax), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, (%rax)
	cmpl	%edx, %r8d
	jle	.L1
	movslq	%edx, %rdx
	leaq	(%r9,%rdx,4), %rax
	mulss	(%rax), %xmm0
	movss	%xmm0, (%rax)
.L1:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L2:
	.cfi_restore_state
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L7
	.cfi_endproc
.LFE44:
	.size	testSum._omp_fn.0, .-testSum._omp_fn.0
	.p2align 4
	.type	test2._omp_fn.0, @function
test2._omp_fn.0:
.LFB45:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	movl	8(%rbp), %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %ecx
	jl	.L12
.L15:
	imull	%eax, %ecx
	addl	%ecx, %edx
	leal	(%rax,%rdx), %ecx
	cmpl	%ecx, %edx
	jge	.L11
	movq	0(%rbp), %rcx
	movslq	%edx, %rdx
	subl	$1, %eax
	leaq	(%rcx,%rdx,4), %rbx
	addq	%rax, %rdx
	leaq	4(%rcx,%rdx,4), %rbp
	.p2align 4,,10
	.p2align 3
.L14:
	movss	(%rbx), %xmm0
	addq	$4, %rbx
	call	logf@PLT
	movss	%xmm0, 12(%rsp)
	movss	-4(%rbx), %xmm0
	call	cosf@PLT
	movss	12(%rsp), %xmm1
	mulss	.LC1(%rip), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, -4(%rbx)
	cmpq	%rbp, %rbx
	jne	.L14
.L11:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L12:
	.cfi_restore_state
	addl	$1, %eax
	xorl	%edx, %edx
	jmp	.L15
	.cfi_endproc
.LFE45:
	.size	test2._omp_fn.0, .-test2._omp_fn.0
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"ERROR:\tArguments must be non-zero positive integers"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC3:
	.string	"\t\tBad argument index: %d\n"
	.text
	.p2align 4
	.globl	getArgumentValueInt
	.type	getArgumentValueInt, @function
getArgumentValueInt:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	$10, %edx
	movl	%edi, %r12d
	movq	%rsi, %rdi
	xorl	%esi, %esi
	call	strtol@PLT
	testl	%eax, %eax
	jle	.L21
	popq	%r12
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$1, %edi
	movl	%r12d, %edx
	xorl	%eax, %eax
	leaq	.LC3(%rip), %rsi
	call	__printf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE40:
	.size	getArgumentValueInt, .-getArgumentValueInt
	.p2align 4
	.globl	fillArrayWithRandomValues
	.type	fillArrayWithRandomValues, @function
fillArrayWithRandomValues:
.LFB41:
	.cfi_startproc
	endbr64
	testl	%esi, %esi
	jle	.L27
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	-1(%rsi), %eax
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	leaq	4(%rdi,%rax,4), %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	.p2align 4,,10
	.p2align 3
.L24:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$4, %rbp
	movslq	%eax, %rcx
	movq	%rcx, %rax
	movq	%rcx, %rdx
	salq	$30, %rax
	sarl	$31, %edx
	addq	%rcx, %rax
	sarq	$61, %rax
	subl	%edx, %eax
	cvtsi2ssl	%eax, %xmm0
	subss	.LC4(%rip), %xmm0
	mulss	.LC5(%rip), %xmm0
	movss	%xmm0, -4(%rbp)
	cmpq	%rbx, %rbp
	jne	.L24
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L27:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE41:
	.size	fillArrayWithRandomValues, .-fillArrayWithRandomValues
	.section	.rodata.str1.1
.LC7:
	.string	"%lf;%lf;"
	.text
	.p2align 4
	.globl	testSum
	.type	testSum, @function
testSum:
.LFB42:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movl	%esi, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$48, %rsp
	.cfi_def_cfa_offset 96
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	call	omp_get_wtime@PLT
	movsd	%xmm0, (%rsp)
	testl	%r13d, %r13d
	jle	.L31
	leal	-1(%r13), %ebp
	cmpl	$2, %ebp
	jbe	.L40
	movl	%r13d, %edx
	movaps	.LC0(%rip), %xmm1
	movq	%r12, %rax
	shrl	$2, %edx
	salq	$4, %rdx
	addq	%r12, %rdx
	.p2align 4,,10
	.p2align 3
.L33:
	movups	(%rax), %xmm0
	addq	$16, %rax
	mulps	%xmm1, %xmm0
	movups	%xmm0, -16(%rax)
	cmpq	%rdx, %rax
	jne	.L33
	movl	%r13d, %eax
	andl	$-4, %eax
	testb	$3, %r13b
	je	.L34
.L32:
	movslq	%eax, %rdx
	movss	.LC1(%rip), %xmm0
	leaq	(%r12,%rdx,4), %rdx
	movss	(%rdx), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, (%rdx)
	leal	1(%rax), %edx
	cmpl	%edx, %r13d
	jle	.L34
	movslq	%edx, %rdx
	addl	$2, %eax
	leaq	(%r12,%rdx,4), %rdx
	movss	(%rdx), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, (%rdx)
	cmpl	%eax, %r13d
	jle	.L34
	cltq
	leaq	(%r12,%rax,4), %rax
	mulss	(%rax), %xmm0
	movss	%xmm0, (%rax)
.L34:
	call	omp_get_wtime@PLT
	subsd	(%rsp), %xmm0
	movl	%ebp, %ebp
	movq	%r12, %rbx
	leaq	4(%r12,%rbp,4), %rbp
	movq	%r12, %r14
	movsd	%xmm0, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L35:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$4, %r14
	movslq	%eax, %rcx
	movq	%rcx, %rax
	movq	%rcx, %rdx
	salq	$30, %rax
	sarl	$31, %edx
	addq	%rcx, %rax
	sarq	$61, %rax
	subl	%edx, %eax
	cvtsi2ssl	%eax, %xmm0
	subss	.LC4(%rip), %xmm0
	mulss	.LC5(%rip), %xmm0
	movss	%xmm0, -4(%r14)
	cmpq	%rbp, %r14
	jne	.L35
	call	omp_get_wtime@PLT
	leaq	16(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	testSum._omp_fn.0(%rip), %rdi
	movsd	%xmm0, (%rsp)
	movl	%r13d, 24(%rsp)
	movq	%r12, 16(%rsp)
	call	GOMP_parallel@PLT
	call	omp_get_wtime@PLT
	movapd	%xmm0, %xmm2
	subsd	(%rsp), %xmm2
	movsd	%xmm2, (%rsp)
	.p2align 4,,10
	.p2align 3
.L37:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$4, %rbx
	movslq	%eax, %rcx
	movq	%rcx, %rax
	movq	%rcx, %rdx
	salq	$30, %rax
	sarl	$31, %edx
	addq	%rcx, %rax
	sarq	$61, %rax
	subl	%edx, %eax
	cvtsi2ssl	%eax, %xmm0
	subss	.LC4(%rip), %xmm0
	mulss	.LC5(%rip), %xmm0
	movss	%xmm0, -4(%rbx)
	cmpq	%rbp, %rbx
	jne	.L37
.L38:
	movsd	8(%rsp), %xmm0
	movl	$1, %edi
	movl	$2, %eax
	movsd	.LC6(%rip), %xmm1
	leaq	.LC7(%rip), %rsi
	mulsd	%xmm1, %xmm0
	mulsd	(%rsp), %xmm1
	call	__printf_chk@PLT
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L47
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L31:
	.cfi_restore_state
	call	omp_get_wtime@PLT
	subsd	(%rsp), %xmm0
	movsd	%xmm0, 8(%rsp)
	call	omp_get_wtime@PLT
	leaq	16(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	testSum._omp_fn.0(%rip), %rdi
	movsd	%xmm0, (%rsp)
	movl	%r13d, 24(%rsp)
	movq	%r12, 16(%rsp)
	call	GOMP_parallel@PLT
	call	omp_get_wtime@PLT
	movapd	%xmm0, %xmm6
	subsd	(%rsp), %xmm6
	movsd	%xmm6, (%rsp)
	jmp	.L38
.L40:
	xorl	%eax, %eax
	jmp	.L32
.L47:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE42:
	.size	testSum, .-testSum
	.section	.rodata.str1.1
.LC8:
	.string	"%lf;%lf\n"
	.text
	.p2align 4
	.globl	test2
	.type	test2, @function
test2:
.LFB43:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movl	%esi, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$48, %rsp
	.cfi_def_cfa_offset 96
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	call	omp_get_wtime@PLT
	movsd	%xmm0, 8(%rsp)
	testl	%r13d, %r13d
	jle	.L49
	leal	-1(%r13), %eax
	movq	%r12, %rbx
	movq	%r12, %r14
	leaq	4(%r12,%rax,4), %rbp
	.p2align 4,,10
	.p2align 3
.L50:
	movss	(%r14), %xmm0
	addq	$4, %r14
	call	logf@PLT
	movss	%xmm0, (%rsp)
	movss	-4(%r14), %xmm0
	call	cosf@PLT
	movss	(%rsp), %xmm1
	mulss	.LC1(%rip), %xmm1
	mulss	%xmm0, %xmm1
	movss	%xmm1, -4(%r14)
	cmpq	%rbp, %r14
	jne	.L50
	call	omp_get_wtime@PLT
	subsd	8(%rsp), %xmm0
	movq	%r12, %r14
	movsd	%xmm0, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L52:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$4, %r14
	movslq	%eax, %rcx
	movq	%rcx, %rax
	movq	%rcx, %rdx
	salq	$30, %rax
	sarl	$31, %edx
	addq	%rcx, %rax
	sarq	$61, %rax
	subl	%edx, %eax
	cvtsi2ssl	%eax, %xmm0
	subss	.LC4(%rip), %xmm0
	mulss	.LC5(%rip), %xmm0
	movss	%xmm0, -4(%r14)
	cmpq	%rbp, %r14
	jne	.L52
	call	omp_get_wtime@PLT
	leaq	16(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	test2._omp_fn.0(%rip), %rdi
	movsd	%xmm0, (%rsp)
	movl	%r13d, 24(%rsp)
	movq	%r12, 16(%rsp)
	call	GOMP_parallel@PLT
	call	omp_get_wtime@PLT
	movapd	%xmm0, %xmm2
	subsd	(%rsp), %xmm2
	movsd	%xmm2, (%rsp)
	.p2align 4,,10
	.p2align 3
.L54:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$4, %rbx
	movslq	%eax, %rcx
	movq	%rcx, %rax
	movq	%rcx, %rdx
	salq	$30, %rax
	sarl	$31, %edx
	addq	%rcx, %rax
	sarq	$61, %rax
	subl	%edx, %eax
	cvtsi2ssl	%eax, %xmm0
	subss	.LC4(%rip), %xmm0
	mulss	.LC5(%rip), %xmm0
	movss	%xmm0, -4(%rbx)
	cmpq	%rbp, %rbx
	jne	.L54
.L55:
	movsd	8(%rsp), %xmm0
	movl	$1, %edi
	movl	$2, %eax
	movsd	.LC6(%rip), %xmm1
	leaq	.LC8(%rip), %rsi
	mulsd	%xmm1, %xmm0
	mulsd	(%rsp), %xmm1
	call	__printf_chk@PLT
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L64
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L49:
	.cfi_restore_state
	call	omp_get_wtime@PLT
	subsd	8(%rsp), %xmm0
	movsd	%xmm0, 8(%rsp)
	call	omp_get_wtime@PLT
	leaq	16(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	test2._omp_fn.0(%rip), %rdi
	movsd	%xmm0, (%rsp)
	movl	%r13d, 24(%rsp)
	movq	%r12, 16(%rsp)
	call	GOMP_parallel@PLT
	call	omp_get_wtime@PLT
	movapd	%xmm0, %xmm6
	subsd	(%rsp), %xmm6
	movsd	%xmm6, (%rsp)
	jmp	.L55
.L64:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE43:
	.size	test2, .-test2
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"ERROR:\tYou must specify the length and the number of threads!"
	.align 8
.LC10:
	.string	"N; Num_threads; tt1_seq [ms]; tt1_para [ms]; tt2_seq [ms]; tt2_para [ms]"
	.section	.rodata.str1.1
.LC11:
	.string	"%d;%d;"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movl	%edi, %ebp
	xorl	%edi, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	time@PLT
	movq	%rax, %rdi
	call	srand@PLT
	cmpl	$3, %ebp
	je	.L66
	leaq	.LC9(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
.L65:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L66:
	.cfi_restore_state
	movq	8(%rbx), %rsi
	movl	$1, %edi
	call	getArgumentValueInt
	movq	16(%rbx), %rsi
	movl	$2, %edi
	movl	%eax, %ebp
	call	getArgumentValueInt
	movl	%eax, %edi
	movl	%eax, %r13d
	call	omp_set_num_threads@PLT
	movslq	%ebp, %rdi
	salq	$2, %rdi
	call	malloc@PLT
	movl	%ebp, %esi
	movq	%rax, %rdi
	movq	%rax, %r12
	call	fillArrayWithRandomValues
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	movl	%r13d, %ecx
	movl	%ebp, %edx
	movl	$1, %edi
	leaq	.LC11(%rip), %rsi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	testSum
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	test2
	movq	%r12, %rdi
	call	free@PLT
	xorl	%eax, %eax
	jmp	.L65
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	1074454856
	.long	1074454856
	.long	1074454856
	.long	1074454856
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC1:
	.long	1074454856
	.align 4
.LC4:
	.long	1056964608
	.align 4
.LC5:
	.long	1092616192
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC6:
	.long	0
	.long	1083129856
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
