	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LASANPC4:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC35:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L3
	movq	stats_bytes(%rip), %r8
	pxor	%xmm2, %xmm2
	movq	stats_connections(%rip), %rdx
	pxor	%xmm1, %xmm1
	pxor	%xmm0, %xmm0
	movl	httpd_conn_count(%rip), %r9d
	cvtsi2ssq	%rdi, %xmm2
	movl	stats_simultaneous(%rip), %ecx
	movl	$.LC0, %esi
	movl	$6, %edi
	cvtsi2ssq	%r8, %xmm1
	movl	$2, %eax
	cvtsi2ssq	%rdx, %xmm0
	divss	%xmm2, %xmm1
	divss	%xmm2, %xmm0
	cvtss2sd	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm0
	call	syslog
.L3:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LASANPC25:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r11d
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	movabsq	$6148914691236517206, %rbp
	testl	%r11d, %r11d
	jg	.L65
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L93:
	leaq	(%r9,%r9), %rdx
	cmpq	%rdx, %r8
	movq	%rcx, %rdx
	jle	.L16
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L84
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	$5, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	%ebx, %edx
	xorl	%eax, %eax
	movl	$.LC1, %esi
	call	syslog
	movq	%r12, %rcx
	addq	throttles(%rip), %rcx
	popq	%r9
	.cfi_def_cfa_offset 40
	popq	%r10
	.cfi_def_cfa_offset 32
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L85
.L20:
	movq	24(%rcx), %r8
.L13:
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L86
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L22
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L23
	cmpb	$3, %al
	jle	.L87
.L23:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L88
.L22:
	addl	$1, %ebx
	cmpl	%ebx, numthrottles(%rip)
	jle	.L26
.L65:
	movslq	%ebx, %rax
	leaq	(%rax,%rax,2), %r12
	salq	$4, %r12
	movq	%r12, %rcx
	addq	throttles(%rip), %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L89
	leaq	32(%rcx), %rdi
	movq	24(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	%rax, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L90
	movq	32(%rcx), %rdx
	leaq	8(%rcx), %rdi
	movq	$0, 32(%rcx)
	movq	%rdx, %rsi
	shrq	$63, %rsi
	addq	%rdx, %rsi
	sarq	%rsi
	addq	%rax, %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%rbp
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	%rsi, %rdx
	cmpb	$0, 2147450880(%rax)
	movq	%rdx, %r8
	movq	%rdx, 24(%rcx)
	jne	.L91
	movq	8(%rcx), %r9
	cmpq	%r9, %rdx
	jle	.L13
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L14
	cmpb	$3, %al
	jle	.L92
.L14:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L93
	addq	$16, %rcx
	movq	%rcx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L22
	movq	%rcx, %rdi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L88:
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L94
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$.LC3, %esi
	xorl	%eax, %eax
	movl	$5, %edi
	addl	$1, %ebx
	call	syslog
	cmpl	%ebx, numthrottles(%rip)
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	jg	.L65
	.p2align 4,,10
	.p2align 3
.L26:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %r8
	movq	$-1, %rbp
	leaq	(%rax,%rax,8), %rax
	salq	$4, %rax
	leaq	64(%r8), %r9
	leaq	208(%r8,%rax), %rbx
	jmp	.L29
	.p2align 4,,10
	.p2align 3
.L32:
	addq	$144, %r9
	addq	$144, %r8
	cmpq	%rbx, %r9
	je	.L6
.L29:
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L27
	cmpb	$3, %al
	jle	.L95
.L27:
	movl	(%r8), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L32
	movq	%r9, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L96
	leaq	-8(%r9), %rdi
	movq	%rbp, 64(%r8)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L31
	cmpb	$3, %al
	jle	.L97
.L31:
	movl	56(%r8), %eax
	testl	%eax, %eax
	jle	.L32
	subl	$1, %eax
	movq	throttles(%rip), %r11
	leaq	-48(%r9), %rsi
	leaq	20(%r8,%rax,4), %r10
	movq	%rbp, %r12
	jmp	.L38
	.p2align 4,,10
	.p2align 3
.L33:
	movslq	(%rsi), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r11, %rcx
	leaq	8(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L98
	leaq	40(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L35
	cmpb	$3, %dl
	jle	.L99
.L35:
	movslq	40(%rcx), %rcx
	cqto
	idivq	%rcx
	cmpq	$-1, %r12
	je	.L83
	cmpq	%r12, %rax
	cmovg	%r12, %rax
.L83:
	addq	$4, %rsi
	movq	%rax, 64(%r8)
	cmpq	%rsi, %r10
	je	.L32
	movq	64(%r8), %r12
.L38:
	movq	%rsi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rsi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L33
	testb	%dl, %dl
	je	.L33
	movq	%rsi, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L16:
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L100
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	$.LC2, %esi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$6, %edi
	xorl	%eax, %eax
	movl	%ebx, %edx
	call	syslog
	movq	%r12, %rcx
	addq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%r8
	.cfi_def_cfa_offset 32
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L20
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L6:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L97:
	.cfi_restore_state
	call	__asan_report_load4
.L96:
	movq	%r9, %rdi
	call	__asan_report_store8
.L95:
	movq	%r8, %rdi
	call	__asan_report_load4
.L100:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L94:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L87:
	call	__asan_report_load4
.L86:
	call	__asan_report_load8
.L85:
	call	__asan_report_load8
.L84:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L92:
	call	__asan_report_load4
.L91:
	call	__asan_report_load8
.L90:
	call	__asan_report_load8
.L89:
	call	__asan_report_load8
.L99:
	call	__asan_report_load4
.L98:
	call	__asan_report_load8
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC4:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LASANPC14:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L107
	rep ret
.L107:
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	shrq	$3, %rax
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rax)
	jne	.L108
	movq	stderr(%rip), %rdi
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L108:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LASANPC13:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L115
	rep ret
.L115:
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	shrq	$3, %rax
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rax)
	jne	.L116
	movq	stderr(%rip), %rdi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L116:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LASANPC11:
.LFB11:
	.cfi_startproc
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L118
	movl	$stderr, %edi
	call	__asan_report_load8
.L118:
	movq	stderr(%rip), %rdi
	movl	$.LC6, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC30:
.LFB30:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rax
	movq	%rdi, (%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L140
	movq	(%rsp), %rsi
	leaq	96(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L141
	movq	%rsi, %rax
	movq	$0, 96(%rsi)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L123
	cmpb	$3, %al
	jle	.L142
.L123:
	cmpl	$3, (%rsi)
	je	.L143
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L143:
	.cfi_restore_state
	leaq	8(%rsi), %rdi
	movl	$2, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L144
	movq	8(%rsi), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L126
	cmpb	$3, %dl
	jle	.L145
.L126:
	movl	704(%rax), %edi
	movl	$1, %edx
	call	fdwatch_add_fd
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L142:
	.cfi_restore_state
	movq	%rsi, %rdi
	call	__asan_report_load4
.L141:
	call	__asan_report_store8
.L140:
	movq	%rsp, %rdi
	call	__asan_report_load8
.L145:
	call	__asan_report_load4
.L144:
	call	__asan_report_load8
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"1 32 16 2 tv "
	.section	.rodata
	.align 32
.LC8:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LASANPC34:
.LFB34:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$104, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbp
	movq	%rsp, %r13
	testl	%eax, %eax
	jne	.L154
.L146:
	movq	%rbp, %r12
	movq	$1102416563, 0(%rbp)
	movq	$.LC7, 8(%rbp)
	shrq	$3, %r12
	testq	%rbx, %rbx
	movq	$.LASANPC34, 16(%rbp)
	movl	$-235802127, 2147450880(%r12)
	movl	$-185335808, 2147450884(%r12)
	movl	$-202116109, 2147450888(%r12)
	je	.L155
.L150:
	movq	%rbx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L156
	movq	(%rbx), %rax
	movl	$1, %ecx
	movl	$.LC8, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbx
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbx
	movq	%rax, stats_time(%rip)
	cmove	%rcx, %rbx
	xorl	%eax, %eax
	movq	%rbx, %rcx
	call	syslog
	movq	%rbx, %rdi
	call	thttpd_logstats
	movq	%rbx, %rdi
	call	httpd_logstats
	movq	%rbx, %rdi
	call	mmc_logstats
	movq	%rbx, %rdi
	call	fdwatch_logstats
	movq	%rbx, %rdi
	call	tmr_logstats
	cmpq	%rbp, %r13
	jne	.L157
	movq	$0, 2147450880(%r12)
	movl	$0, 2147450888(%r12)
.L148:
	addq	$104, %rsp
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
	.p2align 4,,10
	.p2align 3
.L155:
	.cfi_restore_state
	leaq	32(%rbp), %rbx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	call	gettimeofday
	jmp	.L150
.L157:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movl	$-168430091, 2147450888(%r12)
	movq	%rax, 2147450880(%r12)
	jmp	.L148
.L154:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L146
.L156:
	movq	%rbx, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LASANPC6:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L160
	testb	%dl, %dl
	jne	.L175
.L160:
	xorl	%edi, %edi
	movl	(%rbx), %ebp
	call	logstats
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L161
	testb	%dl, %dl
	jne	.L176
.L161:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L176:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L175:
	movq	%rbx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LASANPC32:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC9:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LASANPC7:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L180
	testb	%dl, %dl
	jne	.L196
.L180:
	movl	watchdog_flag(%rip), %eax
	movl	(%rbx), %ebp
	testl	%eax, %eax
	je	.L197
	movl	$360, %edi
	movl	$0, watchdog_flag(%rip)
	call	alarm
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L182
	testb	%dl, %dl
	jne	.L198
.L182:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L198:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L196:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L197:
	movl	$.LC9, %edi
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC10:
	.string	"1 32 4 6 status "
	.section	.rodata
	.align 32
.LC11:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LASANPC3:
.LFB3:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbp
	testl	%eax, %eax
	jne	.L248
.L199:
	movq	%rbp, %r13
	movq	$1102416563, 0(%rbp)
	movq	$.LC10, 8(%rbp)
	shrq	$3, %r13
	movq	$.LASANPC3, 16(%rbp)
	leaq	96(%rbp), %r12
	movl	$-235802127, 2147450880(%r13)
	movl	$-185273340, 2147450884(%r13)
	movl	$-202116109, 2147450888(%r13)
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L203
	testb	%dl, %dl
	jne	.L249
.L203:
	movl	(%rbx), %eax
	movq	%rbx, %r15
	subq	$64, %r12
	xorl	%r14d, %r14d
	shrq	$3, %r15
	movl	%eax, 12(%rsp)
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%rsp)
	.p2align 4,,10
	.p2align 3
.L204:
	movl	$1, %edx
	movq	%r12, %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L209
	js	.L250
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L204
	leaq	36(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L210
	testb	%cl, %cl
	jne	.L251
.L210:
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%r14d, %eax
	movl	%eax, 36(%rdx)
	jmp	.L204
	.p2align 4,,10
	.p2align 3
.L250:
	movzbl	2147450880(%r15), %eax
	cmpb	%al, 11(%rsp)
	jl	.L207
	testb	%al, %al
	jne	.L252
.L207:
	movl	(%rbx), %eax
	cmpl	$4, %eax
	je	.L204
	cmpl	$11, %eax
	je	.L204
	cmpl	$10, %eax
	je	.L209
	movl	$.LC11, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L209:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L213
	testb	%dl, %dl
	jne	.L253
.L213:
	movl	12(%rsp), %eax
	movl	%eax, (%rbx)
	leaq	16(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L254
	movq	$0, 2147450880(%r13)
	movl	$0, 2147450888(%r13)
.L201:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L248:
	.cfi_restore_state
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L199
.L254:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movl	$-168430091, 2147450888(%r13)
	movq	%rax, 2147450880(%r13)
	jmp	.L201
.L253:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L251:
	call	__asan_report_load4
.L252:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L249:
	movq	%rbx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC12:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC13:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LASANPC15:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L259
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L259:
	.cfi_restore_state
	movl	$.LC12, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L260
	movq	stderr(%rip), %rdi
	movl	$.LC13, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L260:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC14:
	.string	"1 32 100 4 line "
	.section	.rodata
	.align 32
.LC15:
	.string	"r"
	.zero	62
	.align 32
.LC16:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC17:
	.string	"debug"
	.zero	58
	.align 32
.LC18:
	.string	"port"
	.zero	59
	.align 32
.LC19:
	.string	"dir"
	.zero	60
	.align 32
.LC20:
	.string	"chroot"
	.zero	57
	.align 32
.LC21:
	.string	"nochroot"
	.zero	55
	.align 32
.LC22:
	.string	"data_dir"
	.zero	55
	.align 32
.LC23:
	.string	"symlink"
	.zero	56
	.align 32
.LC24:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC25:
	.string	"symlinks"
	.zero	55
	.align 32
.LC26:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC27:
	.string	"user"
	.zero	59
	.align 32
.LC28:
	.string	"cgipat"
	.zero	57
	.align 32
.LC29:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC30:
	.string	"urlpat"
	.zero	57
	.align 32
.LC31:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC32:
	.string	"localpat"
	.zero	55
	.align 32
.LC33:
	.string	"throttles"
	.zero	54
	.align 32
.LC34:
	.string	"host"
	.zero	59
	.align 32
.LC35:
	.string	"logfile"
	.zero	56
	.align 32
.LC36:
	.string	"vhost"
	.zero	58
	.align 32
.LC37:
	.string	"novhost"
	.zero	56
	.align 32
.LC38:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC39:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC40:
	.string	"pidfile"
	.zero	56
	.align 32
.LC41:
	.string	"charset"
	.zero	56
	.align 32
.LC42:
	.string	"p3p"
	.zero	60
	.align 32
.LC43:
	.string	"max_age"
	.zero	56
	.align 32
.LC44:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LASANPC12:
.LFB12:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %r12
	testl	%eax, %eax
	jne	.L365
.L261:
	movq	%r12, %r13
	movq	$1102416563, (%r12)
	movq	$.LC14, 8(%r12)
	shrq	$3, %r13
	movq	$.LASANPC12, 16(%r12)
	movl	$.LC15, %esi
	movl	$-235802127, 2147450880(%r13)
	movl	$-185273340, 2147450896(%r13)
	movq	%rbx, %rdi
	movl	$-202116109, 2147450900(%r13)
	call	fopen
	testq	%rax, %rax
	movq	%rax, 8(%rsp)
	je	.L361
	leaq	32(%r12), %rax
	movabsq	$4294977024, %r14
	movq	%rax, (%rsp)
.L265:
	movq	8(%rsp), %rdx
	movq	(%rsp), %rdi
	movl	$1000, %esi
	call	fgets
	testq	%rax, %rax
	je	.L366
	movq	(%rsp), %rdi
	movl	$35, %esi
	call	strchr
	testq	%rax, %rax
	je	.L266
	movq	%rax, %rdx
	movq	%rax, %rsi
	shrq	$3, %rdx
	andl	$7, %esi
	movzbl	2147450880(%rdx), %edx
	cmpb	%sil, %dl
	jg	.L267
	testb	%dl, %dl
	jne	.L367
.L267:
	movb	$0, (%rax)
.L266:
	movq	(%rsp), %rbx
	movl	$.LC16, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L268
	testb	%al, %al
	jne	.L368
	.p2align 4,,10
	.p2align 3
.L268:
	cmpb	$0, (%rbx)
	je	.L265
	movl	$.LC16, %esi
	movq	%rbx, %rdi
	call	strcspn
	leaq	(%rbx,%rax), %r15
	movq	%r15, %rax
	movq	%r15, %rsi
	shrq	$3, %rax
	andl	$7, %esi
	movzbl	2147450880(%rax), %eax
	cmpb	%sil, %al
	jg	.L270
	testb	%al, %al
	jne	.L369
.L270:
	movzbl	(%r15), %eax
	cmpb	$32, %al
	ja	.L271
	btq	%rax, %r14
	jnc	.L271
	movq	%r15, %rdi
	.p2align 4,,10
	.p2align 3
.L274:
	movq	%rdi, %rax
	movq	%rdi, %rsi
	addq	$1, %r15
	shrq	$3, %rax
	andl	$7, %esi
	movzbl	2147450880(%rax), %eax
	cmpb	%sil, %al
	jg	.L272
	testb	%al, %al
	jne	.L370
.L272:
	movq	%r15, %rax
	movb	$0, -1(%r15)
	movq	%r15, %rsi
	shrq	$3, %rax
	andl	$7, %esi
	movzbl	2147450880(%rax), %eax
	cmpb	%sil, %al
	jg	.L273
	testb	%al, %al
	jne	.L371
.L273:
	movzbl	(%r15), %eax
	cmpb	$32, %al
	jbe	.L372
.L271:
	movl	$61, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L310
	movq	%rax, %rsi
	movq	%rax, %rdi
	leaq	1(%rax), %rbp
	shrq	$3, %rsi
	andl	$7, %edi
	movzbl	2147450880(%rsi), %esi
	cmpb	%dil, %sil
	jg	.L276
	testb	%sil, %sil
	jne	.L373
.L276:
	movb	$0, (%rax)
.L275:
	movl	$.LC17, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L374
	movl	$.LC18, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L375
	movl	$.LC19, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L376
	movl	$.LC20, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L377
	movl	$.LC21, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L378
	movl	$.LC22, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L379
	movl	$.LC23, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L363
	movl	$.LC24, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L364
	movl	$.LC25, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L363
	movl	$.LC26, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L364
	movl	$.LC27, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L380
	movl	$.LC28, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L381
	movl	$.LC29, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L382
	movl	$.LC30, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L383
	movl	$.LC31, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L384
	movl	$.LC32, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L385
	movl	$.LC33, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L386
	movl	$.LC34, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L387
	movl	$.LC35, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L388
	movl	$.LC36, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L389
	movl	$.LC37, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L390
	movl	$.LC38, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L391
	movl	$.LC39, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L392
	movl	$.LC40, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L393
	movl	$.LC41, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L394
	movl	$.LC42, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L395
	movl	$.LC43, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L304
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	.p2align 4,,10
	.p2align 3
.L278:
	movl	$.LC16, %esi
	movq	%r15, %rdi
	call	strspn
	leaq	(%r15,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L268
	testb	%al, %al
	je	.L268
	movq	%rbx, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L372:
	btq	%rax, %r14
	movq	%r15, %rdi
	jc	.L274
	jmp	.L271
.L374:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
	jmp	.L278
.L375:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L278
.L310:
	xorl	%ebp, %ebp
	jmp	.L275
.L376:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L278
.L377:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L278
.L378:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L278
.L363:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L278
.L379:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L278
.L364:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L278
.L380:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L278
.L381:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L278
.L382:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L278
.L383:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L278
.L385:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L278
.L384:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L278
.L366:
	movq	8(%rsp), %rdi
	call	fclose
	leaq	16(%rsp), %rax
	cmpq	%r12, %rax
	jne	.L396
	movl	$0, 2147450880(%r13)
	movq	$0, 2147450896(%r13)
.L263:
	addq	$216, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L371:
	.cfi_restore_state
	movq	%r15, %rdi
	call	__asan_report_load1
.L387:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L278
.L386:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L278
.L373:
	movq	%rax, %rdi
	call	__asan_report_store1
.L396:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%r12)
	movq	%rax, 2147450880(%r13)
	movq	%rax, 2147450888(%r13)
	movq	%rax, 2147450896(%r13)
	jmp	.L263
.L370:
	call	__asan_report_store1
.L361:
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L365:
	movl	$192, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %r12
	jmp	.L261
.L367:
	movq	%rax, %rdi
	call	__asan_report_store1
.L368:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L369:
	movq	%r15, %rdi
	call	__asan_report_load1
.L304:
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L397
	movq	stderr(%rip), %rdi
	movq	%rbx, %rcx
	movl	$.LC44, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L395:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L278
.L391:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L278
.L390:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L278
.L389:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L278
.L388:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L278
.L393:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L278
.L392:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L278
.L394:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L278
.L397:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC45:
	.string	"nobody"
	.zero	57
	.align 32
.LC46:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC47:
	.string	""
	.zero	63
	.align 32
.LC48:
	.string	"-V"
	.zero	61
	.align 32
.LC49:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC50:
	.string	"-C"
	.zero	61
	.align 32
.LC51:
	.string	"-p"
	.zero	61
	.align 32
.LC52:
	.string	"-d"
	.zero	61
	.align 32
.LC53:
	.string	"-r"
	.zero	61
	.align 32
.LC54:
	.string	"-nor"
	.zero	59
	.align 32
.LC55:
	.string	"-dd"
	.zero	60
	.align 32
.LC56:
	.string	"-s"
	.zero	61
	.align 32
.LC57:
	.string	"-nos"
	.zero	59
	.align 32
.LC58:
	.string	"-u"
	.zero	61
	.align 32
.LC59:
	.string	"-c"
	.zero	61
	.align 32
.LC60:
	.string	"-t"
	.zero	61
	.align 32
.LC61:
	.string	"-h"
	.zero	61
	.align 32
.LC62:
	.string	"-l"
	.zero	61
	.align 32
.LC63:
	.string	"-v"
	.zero	61
	.align 32
.LC64:
	.string	"-nov"
	.zero	59
	.align 32
.LC65:
	.string	"-g"
	.zero	61
	.align 32
.LC66:
	.string	"-nog"
	.zero	59
	.align 32
.LC67:
	.string	"-i"
	.zero	61
	.align 32
.LC68:
	.string	"-T"
	.zero	61
	.align 32
.LC69:
	.string	"-P"
	.zero	61
	.align 32
.LC70:
	.string	"-M"
	.zero	61
	.align 32
.LC71:
	.string	"-D"
	.zero	61
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LASANPC10:
.LFB10:
	.cfi_startproc
	movl	$80, %eax
	cmpl	$1, %edi
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$0, debug(%rip)
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movw	%ax, port(%rip)
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	$0, dir(%rip)
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC45, user(%rip)
	movq	$.LC46, charset(%rip)
	movq	$.LC47, p3p(%rip)
	movl	$-1, max_age(%rip)
	jle	.L447
	leaq	8(%rsi), %rdi
	movq	%rsi, %r13
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L472
	movq	8(%rsi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L401
	testb	%al, %al
	jne	.L473
.L401:
	cmpb	$45, (%rbx)
	jne	.L442
	movl	$1, %ebp
	jmp	.L445
	.p2align 4,,10
	.p2align 3
.L479:
	leal	1(%rbp), %r14d
	cmpl	%r14d, %r12d
	jg	.L474
	movl	$.LC51, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L409
.L408:
	movl	$.LC52, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L409
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L409
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L475
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, dir(%rip)
.L407:
	addl	$1, %ebp
	cmpl	%ebp, %r12d
	jle	.L399
.L481:
	movslq	%ebp, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L476
	movq	(%rdi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L444
	testb	%al, %al
	jne	.L477
.L444:
	cmpb	$45, (%rbx)
	jne	.L442
.L445:
	movl	$.LC48, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L478
	movl	$.LC50, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L479
	movl	$.LC51, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L408
	leal	1(%rbp), %r14d
	cmpl	%r14d, %r12d
	jle	.L409
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L480
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	addl	$1, %ebp
	call	atoi
	cmpl	%ebp, %r12d
	movw	%ax, port(%rip)
	jg	.L481
.L399:
	cmpl	%ebp, %r12d
	jne	.L442
	popq	%rbx
	.cfi_remember_state
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
.L409:
	.cfi_restore_state
	movl	$.LC53, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L412
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L412:
	movl	$.LC54, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L413
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L474:
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L482
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	read_config
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L413:
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L414
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L414
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L483
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, data_dir(%rip)
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L414:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L416
	movl	$0, no_symlink_check(%rip)
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L416:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L484
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L418
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L418
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L485
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, user(%rip)
	jmp	.L407
.L484:
	movl	$1, no_symlink_check(%rip)
	jmp	.L407
.L418:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L420
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L420
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L486
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L407
.L420:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L487
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L425
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L426
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L488
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, hostname(%rip)
	jmp	.L407
.L487:
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L423
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L489
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, throttlefile(%rip)
	jmp	.L407
.L423:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L425
.L426:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L429
	movl	$1, do_vhost(%rip)
	jmp	.L407
.L425:
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L426
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L426
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L490
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, logfile(%rip)
	jmp	.L407
.L429:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L491
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L431
	movl	$1, do_global_passwd(%rip)
	jmp	.L407
.L491:
	movl	$0, do_vhost(%rip)
	jmp	.L407
.L447:
	movl	$1, %ebp
	jmp	.L399
.L431:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L432
	movl	$0, do_global_passwd(%rip)
	jmp	.L407
.L478:
	movl	$.LC49, %edi
	call	puts
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L432:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L492
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L436
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L434
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L493
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, charset(%rip)
	jmp	.L407
.L492:
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L434
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L494
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, pidfile(%rip)
	jmp	.L407
.L434:
	movl	$.LC69, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L439
.L438:
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L439
	leal	1(%rbp), %r14d
	cmpl	%r14d, %r12d
	jle	.L439
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L495
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L407
.L436:
	movl	$.LC69, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L438
	leal	1(%rbp), %eax
	cmpl	%eax, %r12d
	jle	.L439
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L496
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, p3p(%rip)
	jmp	.L407
.L439:
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L442
	movl	$1, debug(%rip)
	jmp	.L407
.L493:
	call	__asan_report_load8
.L494:
	call	__asan_report_load8
.L488:
	call	__asan_report_load8
.L489:
	call	__asan_report_load8
.L486:
	call	__asan_report_load8
.L472:
	call	__asan_report_load8
.L442:
	call	__asan_handle_no_return
	call	usage
.L476:
	call	__asan_report_load8
.L475:
	call	__asan_report_load8
.L483:
	call	__asan_report_load8
.L482:
	call	__asan_report_load8
.L480:
	call	__asan_report_load8
.L477:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L473:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L490:
	call	__asan_report_load8
.L485:
	call	__asan_report_load8
.L495:
	call	__asan_report_load8
.L496:
	call	__asan_report_load8
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC72:
	.string	"5 32 8 9 max_limit 96 8 9 min_limit 160 16 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC73:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC74:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.align 32
.LC75:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC76:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC77:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC78:
	.string	"|/"
	.zero	61
	.align 32
.LC79:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC80:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10392, %rsp
	.cfi_def_cfa_offset 10448
	leaq	48(%rsp), %rax
	movq	%rdi, 16(%rsp)
	movq	%rax, 24(%rsp)
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	testl	%eax, %eax
	jne	.L579
.L497:
	movq	24(%rsp), %rax
	movl	$.LC15, %esi
	movq	$1102416563, (%rax)
	movq	$.LC72, 8(%rax)
	leaq	10336(%rax), %rbx
	movq	$.LASANPC17, 16(%rax)
	movq	16(%rsp), %rdi
	shrq	$3, %rax
	movq	%rax, 32(%rsp)
	movl	$-235802127, 2147450880(%rax)
	movl	$-185273344, 2147450884(%rax)
	movl	$-218959118, 2147450888(%rax)
	movl	$-185273344, 2147450892(%rax)
	movl	$-218959118, 2147450896(%rax)
	movl	$-185335808, 2147450900(%rax)
	movl	$-218959118, 2147450904(%rax)
	movl	$-185273344, 2147451532(%rax)
	movl	$-218959118, 2147451536(%rax)
	movl	$-185273344, 2147452164(%rax)
	movl	$-202116109, 2147452168(%rax)
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r12
	je	.L580
	movq	24(%rsp), %r14
	xorl	%esi, %esi
	leaq	160(%r14), %rdi
	leaq	224(%r14), %r15
	leaq	32(%r14), %r13
	call	gettimeofday
	movq	%r14, %rax
	leaq	96(%r14), %r14
	leaq	5280(%rax), %rbp
	addq	$5281, %rax
	movq	%rax, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L502:
	movq	%r12, %rdx
	movl	$5000, %esi
	movq	%r15, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L581
	movl	$35, %esi
	movq	%r15, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L503
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L504
	testb	%dl, %dl
	jne	.L582
.L504:
	movb	$0, (%rax)
.L503:
	movq	%r15, %rdi
	call	strlen
	cmpl	$0, %eax
	jle	.L505
	subl	$1, %eax
	movslq	%eax, %rsi
	leaq	(%r15,%rsi), %rdx
	movq	%rdx, %rcx
	movq	%rdx, %rdi
	shrq	$3, %rcx
	andl	$7, %edi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%dil, %cl
	jg	.L506
	testb	%cl, %cl
	jne	.L583
.L506:
	movzbl	-10112(%rbx,%rsi), %ecx
	cmpb	$32, %cl
	jbe	.L584
	.p2align 4,,10
	.p2align 3
.L507:
	xorl	%eax, %eax
	movq	%r13, %r8
	movq	%r14, %rcx
	movq	%rbp, %rdx
	movl	$.LC74, %esi
	movq	%r15, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L509
	xorl	%eax, %eax
	movq	%r13, %rcx
	movq	%rbp, %rdx
	movl	$.LC75, %esi
	movq	%r15, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L515
	movq	$0, -10240(%rbx)
	.p2align 4,,10
	.p2align 3
.L509:
	cmpb	$47, -5056(%rbx)
	jne	.L518
	jmp	.L585
	.p2align 4,,10
	.p2align 3
.L519:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L518:
	movl	$.LC78, %esi
	movq	%rbp, %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L519
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L520
	testl	%eax, %eax
	jne	.L521
	movl	$4800, %edi
	movl	$100, maxthrottles(%rip)
	call	malloc
	movq	%rax, throttles(%rip)
.L522:
	testq	%rax, %rax
	je	.L523
	movslq	numthrottles(%rip), %rdx
.L524:
	leaq	(%rdx,%rdx,2), %rdx
	movq	%rbp, %rdi
	salq	$4, %rdx
	addq	%rax, %rdx
	movq	%rdx, 8(%rsp)
	call	e_strdup
	movq	8(%rsp), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L586
	movq	%rax, (%rdx)
	movslq	numthrottles(%rip), %rax
	movq	-10304(%rbx), %rcx
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	throttles(%rip), %rax
	leaq	8(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L587
	leaq	16(%rax), %rdi
	movq	%rcx, 8(%rax)
	movq	-10240(%rbx), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L588
	leaq	24(%rax), %rdi
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L589
	leaq	32(%rax), %rdi
	movq	$0, 24(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L590
	leaq	40(%rax), %rdi
	movq	$0, 32(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L531
	cmpb	$3, %cl
	jle	.L591
.L531:
	movl	$0, 40(%rax)
	leal	1(%rdx), %eax
	movl	%eax, numthrottles(%rip)
	jmp	.L502
	.p2align 4,,10
	.p2align 3
.L584:
	movabsq	$4294977024, %rdi
	leaq	(%r15,%rsi), %rdx
	btq	%rcx, %rdi
	movq	%rdi, %r8
	jc	.L572
	jmp	.L507
	.p2align 4,,10
	.p2align 3
.L511:
	testl	%eax, %eax
	movb	$0, (%rdx)
	je	.L502
	subl	$1, %eax
	movslq	%eax, %rsi
	leaq	(%r15,%rsi), %rcx
	movq	%rcx, %rdi
	movq	%rcx, %r9
	shrq	$3, %rdi
	andl	$7, %r9d
	movzbl	2147450880(%rdi), %edi
	cmpb	%r9b, %dil
	jg	.L513
	testb	%dil, %dil
	jne	.L592
.L513:
	movzbl	-10112(%rbx,%rsi), %ecx
	cmpb	$32, %cl
	ja	.L507
	subq	$1, %rdx
	btq	%rcx, %r8
	jnc	.L507
.L572:
	addq	%r15, %rsi
	movq	%rsi, %rcx
	movq	%rsi, %rdi
	shrq	$3, %rcx
	andl	$7, %edi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%dil, %cl
	jg	.L511
	testb	%cl, %cl
	je	.L511
	movq	%rsi, %rdi
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L521:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L522
.L515:
	movq	16(%rsp), %rdx
	xorl	%eax, %eax
	movq	%r15, %rcx
	movl	$.LC76, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L593
	movq	16(%rsp), %rcx
	movq	stderr(%rip), %rdi
	movq	%r15, %r8
	movl	$.LC77, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L502
.L520:
	movq	throttles(%rip), %rax
	jmp	.L524
.L581:
	movq	%r12, %rdi
	call	fclose
	leaq	48(%rsp), %rax
	cmpq	24(%rsp), %rax
	jne	.L594
	movq	32(%rsp), %rax
	movq	$0, 2147450880(%rax)
	movq	$0, 2147450888(%rax)
	movq	$0, 2147450896(%rax)
	movl	$0, 2147450904(%rax)
	movq	$0, 2147451532(%rax)
	movq	$0, 2147452164(%rax)
.L499:
	addq	$10392, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L585:
	.cfi_restore_state
	movq	40(%rsp), %rsi
	movq	%rbp, %rdi
	call	strcpy
	jmp	.L518
.L505:
	jne	.L507
	jmp	.L502
.L587:
	call	__asan_report_store8
.L586:
	movq	%rdx, %rdi
	call	__asan_report_store8
.L523:
	xorl	%eax, %eax
	movl	$.LC79, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L595
	movq	stderr(%rip), %rdi
	movl	$.LC80, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L591:
	call	__asan_report_store4
.L595:
	movl	$stderr, %edi
	call	__asan_report_load8
.L589:
	call	__asan_report_store8
.L588:
	call	__asan_report_store8
.L590:
	call	__asan_report_store8
.L592:
	movq	%rcx, %rdi
	call	__asan_report_load1
.L583:
	movq	%rdx, %rdi
	call	__asan_report_load1
.L582:
	movq	%rax, %rdi
	call	__asan_report_store1
.L580:
	movq	16(%rsp), %rbx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	movq	%rbx, %rdx
	call	syslog
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L579:
	movl	$10336, %edi
	call	__asan_stack_malloc_8
	testq	%rax, %rax
	cmove	24(%rsp), %rax
	movq	%rax, 24(%rsp)
	jmp	.L497
.L594:
	movq	24(%rsp), %rax
	leaq	48(%rsp), %rdx
	movl	$10336, %esi
	movq	%rax, %rdi
	movq	$1172321806, (%rax)
	call	__asan_stack_free_8
	jmp	.L499
.L593:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC81:
	.string	"-"
	.zero	62
	.align 32
.LC82:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC83:
	.string	"a"
	.zero	62
	.align 32
.LC84:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC8:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L611
	cmpq	$0, hs(%rip)
	je	.L611
	movq	logfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L611
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movl	$.LC81, %esi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	strcmp
	testl	%eax, %eax
	jne	.L612
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
.L611:
	rep ret
	.p2align 4,,10
	.p2align 3
.L612:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC82, %esi
	movl	$5, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC83, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movq	%rax, %rbx
	movl	$384, %esi
	movq	%rbp, %rdi
	call	chmod
	testq	%rbx, %rbx
	je	.L600
	testl	%eax, %eax
	jne	.L600
	movq	%rbx, %rdi
	call	fileno
	movl	$2, %esi
	movl	%eax, %edi
	movl	$1, %edx
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L600:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC84, %esi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	movl	$2, %edi
	xorl	%eax, %eax
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC85:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC86:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC87:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movl	%esi, %r12d
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbp
	shrq	$3, %r13
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L637:
	cmpl	%eax, max_connects(%rip)
	jle	.L689
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L616
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L617
	cmpb	$3, %al
	jle	.L690
.L617:
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L616
	leaq	8(%rbx), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L691
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L692
.L620:
	movq	hs(%rip), %rdi
	movl	%r12d, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L624
	cmpl	$2, %eax
	je	.L639
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L625
	cmpb	$3, %al
	jle	.L693
.L625:
	leaq	4(%rbx), %rdi
	movl	$1, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L626
	testb	%dl, %dl
	jne	.L694
.L626:
	addl	$1, num_connects(%rip)
	cmpb	$0, 2147450880(%r13)
	movl	4(%rbx), %eax
	movl	$-1, 4(%rbx)
	movl	%eax, first_free_connect(%rip)
	jne	.L695
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L696
	leaq	96(%rbx), %rdi
	movq	%rax, 88(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L697
	leaq	104(%rbx), %rdi
	movq	$0, 96(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L698
	leaq	136(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L699
	leaq	56(%rbx), %rdi
	movq	$0, 136(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L632
	cmpb	$3, %al
	jle	.L700
.L632:
	movq	%r14, %rax
	movl	$0, 56(%rbx)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L701
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L634
	cmpb	$3, %dl
	jle	.L702
.L634:
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L703
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L636
	cmpb	$3, %dl
	jle	.L704
.L636:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L637
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L637
	.p2align 4,,10
	.p2align 3
.L639:
	movl	$1, %eax
.L613:
	addq	$16, %rsp
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
.L624:
	.cfi_restore_state
	movq	%rbp, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
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
.L692:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	testq	%rax, %rax
	movq	%rax, 8(%rbx)
	je	.L705
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L622
	cmpb	$3, %dl
	jle	.L706
.L622:
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	movq	%rax, %rdx
	jmp	.L620
.L706:
	movq	%rax, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L689:
	xorl	%eax, %eax
	movl	$.LC85, %esi
	movl	$4, %edi
	call	syslog
	movq	%rbp, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L613
.L616:
	movl	$2, %edi
	movl	$.LC86, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L705:
	movl	$2, %edi
	movl	$.LC87, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L697:
	call	__asan_report_store8
.L690:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L694:
	call	__asan_report_load4
.L695:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L696:
	call	__asan_report_store8
.L691:
	movq	%r14, %rdi
	call	__asan_report_load8
.L698:
	call	__asan_report_store8
.L699:
	call	__asan_report_store8
.L700:
	call	__asan_report_store4
.L701:
	movq	%r14, %rdi
	call	__asan_report_load8
.L702:
	call	__asan_report_load4
.L703:
	movq	%r14, %rdi
	call	__asan_report_load8
.L704:
	call	__asan_report_load4
.L693:
	movq	%rbx, %rdi
	call	__asan_report_store4
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC88:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	56(%rdi), %rax
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rax, 16(%rsp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L708
	cmpb	$3, %al
	jle	.L789
.L708:
	leaq	72(%rbx), %rax
	movl	$0, 56(%rbx)
	movq	%rax, %rdx
	movq	%rax, 32(%rsp)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L790
	leaq	64(%rbx), %rcx
	movq	$-1, %rax
	movq	%rax, 72(%rbx)
	movq	%rcx, %r13
	movq	%rcx, 24(%rsp)
	shrq	$3, %r13
	cmpb	$0, 2147450880(%r13)
	jne	.L791
	movq	%rax, 64(%rbx)
	leaq	8(%rbx), %rax
	xorl	%r14d, %r14d
	movq	%rax, 40(%rsp)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jle	.L734
	movq	16(%rsp), %rbp
	leaq	8(%rbx), %r12
	movq	%rdx, 8(%rsp)
	shrq	$3, %r12
	shrq	$3, %rbp
	jmp	.L769
	.p2align 4,,10
	.p2align 3
.L805:
	addl	$1, %ecx
	movslq	%ecx, %r11
.L722:
	movzbl	2147450880(%rbp), %edx
	testb	%dl, %dl
	je	.L726
	cmpb	$3, %dl
	jle	.L792
.L726:
	movslq	56(%rbx), %rdx
	leal	1(%rdx), %r8d
	leaq	16(%rbx,%rdx,4), %r10
	movl	%r8d, 56(%rbx)
	movq	%r10, %r8
	shrq	$3, %r8
	movzbl	2147450880(%r8), %r15d
	movq	%r10, %r8
	andl	$7, %r8d
	addl	$3, %r8d
	cmpb	%r15b, %r8b
	jl	.L727
	testb	%r15b, %r15b
	jne	.L793
.L727:
	movl	%r14d, 16(%rbx,%rdx,4)
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L728
	cmpb	$3, %dl
	jle	.L794
.L728:
	cqto
	movl	%ecx, 40(%rsi)
	idivq	%r11
	cmpb	$0, 2147450880(%r13)
	jne	.L795
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L787
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L787:
	movq	%rax, 64(%rbx)
	movq	8(%rsp), %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L796
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L788
	cmpq	%r9, %rax
	cmovge	%rax, %r9
.L788:
	movq	%r9, 72(%rbx)
.L716:
	addl	$1, %r14d
	cmpl	%r14d, numthrottles(%rip)
	jle	.L734
	movzbl	2147450880(%rbp), %eax
	testb	%al, %al
	je	.L735
	cmpb	$3, %al
	jle	.L797
.L735:
	cmpl	$9, 56(%rbx)
	jg	.L734
.L769:
	cmpb	$0, 2147450880(%r12)
	jne	.L798
	movq	8(%rbx), %rax
	leaq	240(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L799
	movq	240(%rax), %rsi
	movslq	%r14d, %rax
	leaq	(%rax,%rax,2), %r15
	salq	$4, %r15
	movq	%r15, %rdi
	addq	throttles(%rip), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L800
	movq	(%rdi), %rdi
	call	match
	testl	%eax, %eax
	je	.L716
	movq	%r15, %rsi
	addq	throttles(%rip), %rsi
	leaq	24(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L801
	leaq	8(%rsi), %rdi
	movq	24(%rsi), %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L802
	movq	8(%rsi), %rax
	leaq	(%rax,%rax), %rcx
	cmpq	%rcx, %rdx
	jg	.L738
	leaq	16(%rsi), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L803
	movq	16(%rsi), %r9
	cmpq	%r9, %rdx
	jl	.L738
	leaq	40(%rsi), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L720
	cmpb	$3, %dl
	jle	.L804
.L720:
	movl	40(%rsi), %ecx
	testl	%ecx, %ecx
	jns	.L805
	xorl	%eax, %eax
	movl	$.LC88, %esi
	movl	$3, %edi
	call	syslog
	movq	%r15, %rsi
	addq	throttles(%rip), %rsi
	leaq	40(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L723
	cmpb	$3, %al
	jle	.L806
.L723:
	leaq	8(%rsi), %rax
	movl	$0, 40(%rsi)
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L807
	leaq	16(%rsi), %rcx
	movq	8(%rsi), %rax
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L808
	movq	16(%rsi), %r9
	movl	$1, %r11d
	movl	$1, %ecx
	jmp	.L722
	.p2align 4,,10
	.p2align 3
.L734:
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L738:
	.cfi_restore_state
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L806:
	.cfi_restore_state
	call	__asan_report_store4
.L796:
	movq	32(%rsp), %rdi
	call	__asan_report_load8
.L795:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L797:
	movq	16(%rsp), %rdi
	call	__asan_report_load4
.L803:
	call	__asan_report_load8
.L802:
	call	__asan_report_load8
.L801:
	call	__asan_report_load8
.L794:
	call	__asan_report_store4
.L793:
	movq	%r10, %rdi
	call	__asan_report_store4
.L792:
	movq	16(%rsp), %rdi
	call	__asan_report_load4
.L804:
	call	__asan_report_load4
.L800:
	call	__asan_report_load8
.L799:
	call	__asan_report_load8
.L798:
	movq	40(%rsp), %rdi
	call	__asan_report_load8
.L791:
	movq	%rcx, %rdi
	call	__asan_report_store8
.L790:
	movq	%rax, %rdi
	call	__asan_report_store8
.L789:
	movq	16(%rsp), %rdi
	call	__asan_report_store4
.L808:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L807:
	movq	%rax, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %esi
	leaq	16(%rsp), %r12
	testl	%esi, %esi
	jne	.L863
.L809:
	leaq	32(%r12), %rbx
	movq	%r12, %r13
	movq	$1102416563, (%r12)
	shrq	$3, %r13
	movq	$.LC7, 8(%r12)
	movq	$.LASANPC18, 16(%r12)
	xorl	%esi, %esi
	movq	%rbx, %rdi
	movl	$-235802127, 2147450880(%r13)
	movl	$-185335808, 2147450884(%r13)
	movl	$-202116109, 2147450888(%r13)
	xorl	%ebp, %ebp
	call	gettimeofday
	movq	%rbx, %rdi
	call	logstats
	movl	max_connects(%rip), %ecx
	movq	%rbx, 8(%rsp)
	testl	%ecx, %ecx
	jg	.L850
	jmp	.L824
	.p2align 4,,10
	.p2align 3
.L817:
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L864
	movq	8(%rax), %rdi
	testq	%rdi, %rdi
	je	.L820
	call	httpd_destroy_conn
	addq	connects(%rip), %rbx
	leaq	8(%rbx), %r15
	movq	%r15, %r14
	shrq	$3, %r14
	cmpb	$0, 2147450880(%r14)
	jne	.L865
	movq	8(%rbx), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	cmpb	$0, 2147450880(%r14)
	jne	.L866
	movq	$0, 8(%rbx)
.L820:
	addl	$1, %ebp
	cmpl	%ebp, max_connects(%rip)
	jle	.L824
.L850:
	movslq	%ebp, %rax
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L816
	cmpb	$3, %dl
	jle	.L867
.L816:
	movl	(%rax), %edx
	testl	%edx, %edx
	je	.L817
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L868
	movq	8(%rax), %rdi
	movq	8(%rsp), %rsi
	call	httpd_close_conn
	movq	%rbx, %rax
	addq	connects(%rip), %rax
	jmp	.L817
	.p2align 4,,10
	.p2align 3
.L824:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L815
	leaq	72(%rbx), %rdi
	movq	$0, hs(%rip)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L825
	cmpb	$3, %al
	jle	.L869
.L825:
	movl	72(%rbx), %edi
	cmpl	$-1, %edi
	je	.L826
	call	fdwatch_del_fd
.L826:
	leaq	76(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L827
	testb	%dl, %dl
	jne	.L870
.L827:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	je	.L828
	call	fdwatch_del_fd
.L828:
	movq	%rbx, %rdi
	call	httpd_terminate
.L815:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L812
	call	free
.L812:
	leaq	16(%rsp), %rax
	cmpq	%r12, %rax
	jne	.L871
	movq	$0, 2147450880(%r13)
	movl	$0, 2147450888(%r13)
.L811:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L870:
	.cfi_restore_state
	call	__asan_report_load4
.L869:
	call	__asan_report_load4
.L868:
	call	__asan_report_load8
.L866:
	movq	%r15, %rdi
	call	__asan_report_store8
.L865:
	movq	%r15, %rdi
	call	__asan_report_load8
.L864:
	call	__asan_report_load8
.L867:
	movq	%rax, %rdi
	call	__asan_report_load4
.L863:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %r12
	jmp	.L809
.L871:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%r12)
	movl	$-168430091, 2147450888(%r13)
	movq	%rax, 2147450880(%r13)
	jmp	.L811
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC89:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LASANPC5:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L877
	movl	$1, got_usr1(%rip)
	ret
.L877:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC89, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC90:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LASANPC2:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	shut_down
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC90, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC36:
.LFB36:
	.cfi_startproc
	leaq	56(%rdi), %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L881
	cmpb	$3, %al
	jle	.L907
.L881:
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L880
	subl	$1, %eax
	movq	throttles(%rip), %r8
	leaq	16(%rdi), %rdx
	leaq	20(%rdi,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L885:
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L883
	testb	%cl, %cl
	jne	.L908
.L883:
	movslq	(%rdx), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r8, %rax
	leaq	40(%rax), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L884
	cmpb	$3, %cl
	jle	.L909
.L884:
	addq	$4, %rdx
	subl	$1, 40(%rax)
	cmpq	%rsi, %rdx
	jne	.L885
.L880:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L907:
	.cfi_restore_state
	movq	%rdx, %rdi
	call	__asan_report_load4
.L909:
	call	__asan_report_load4
.L908:
	movq	%rdx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	leaq	8(%rdi), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rbp, %rax
	shrq	$3, %rax
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%rax)
	jne	.L950
	movq	%rdi, %rbx
	movq	8(%rdi), %rdi
	leaq	200(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L951
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L913
	cmpb	$3, %al
	jle	.L952
.L913:
	cmpl	$3, (%rbx)
	je	.L914
	leaq	704(%rdi), %rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L915
	cmpb	$3, %al
	jle	.L953
.L915:
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	%rbp, %rax
	movq	8(%rsp), %rsi
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L954
	movq	8(%rbx), %rdi
.L914:
	leaq	104(%rbx), %r12
	call	httpd_close_conn
	movq	%r12, %rbp
	movq	%rbx, %rdi
	shrq	$3, %rbp
	call	clear_throttles.isra.0
	cmpb	$0, 2147450880(%rbp)
	jne	.L955
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L918
	call	tmr_cancel
	cmpb	$0, 2147450880(%rbp)
	jne	.L956
	movq	$0, 104(%rbx)
.L918:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L920
	cmpb	$3, %al
	jle	.L957
.L920:
	leaq	4(%rbx), %rdi
	movl	$0, (%rbx)
	movl	first_free_connect(%rip), %ecx
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L921
	testb	%dl, %dl
	jne	.L958
.L921:
	movl	%ecx, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	subl	$1, num_connects(%rip)
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L952:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_load4
.L958:
	call	__asan_report_store4
.L957:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L953:
	movq	%rdx, %rdi
	call	__asan_report_load4
.L954:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L950:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L955:
	movq	%r12, %rdi
	call	__asan_report_load8
.L956:
	movq	%r12, %rdi
	call	__asan_report_store8
.L951:
	movq	%rax, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 32
.LC91:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC92:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	96(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%r13, %rbp
	shrq	$3, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%rbp)
	jne	.L1032
	movq	%rdi, %rbx
	movq	96(%rdi), %rdi
	movq	%rsi, %r12
	testq	%rdi, %rdi
	je	.L961
	call	tmr_cancel
	cmpb	$0, 2147450880(%rbp)
	jne	.L1033
	movq	$0, 96(%rbx)
.L961:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L963
	cmpb	$3, %al
	jle	.L1034
.L963:
	movl	(%rbx), %ecx
	cmpl	$4, %ecx
	je	.L1035
	leaq	8(%rbx), %rbp
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1036
	movq	8(%rbx), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L971
	testb	%sil, %sil
	jne	.L1037
.L971:
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L969
	cmpl	$3, %ecx
	je	.L972
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L973
	cmpb	$3, %dl
	jle	.L1038
.L973:
	movl	704(%rax), %edi
	call	fdwatch_del_fd
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1039
	movq	8(%rbx), %rax
.L972:
	movq	%rbx, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L975
	cmpb	$3, %dl
	jle	.L1040
.L975:
	leaq	704(%rax), %rdi
	movl	$4, (%rbx)
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L976
	cmpb	$3, %dl
	jle	.L1041
.L976:
	movl	704(%rax), %edi
	movl	$1, %esi
	call	shutdown
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1042
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L978
	cmpb	$3, %dl
	jle	.L1043
.L978:
	movl	704(%rax), %edi
	leaq	104(%rbx), %rbp
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	movq	%rbp, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1044
	cmpq	$0, 104(%rbx)
	je	.L980
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L980:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$500, %ecx
	movl	$linger_clear_connection, %esi
	movq	%r12, %rdi
	call	tmr_create
	movq	%rbp, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1045
	testq	%rax, %rax
	movq	%rax, 104(%rbx)
	je	.L1046
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
	.p2align 4,,10
	.p2align 3
.L1035:
	.cfi_restore_state
	leaq	104(%rbx), %r13
	movq	%r13, %rbp
	shrq	$3, %rbp
	cmpb	$0, 2147450880(%rbp)
	jne	.L1047
	movq	104(%rbx), %rdi
	call	tmr_cancel
	cmpb	$0, 2147450880(%rbp)
	jne	.L1048
	leaq	8(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1049
	movq	8(%rbx), %rdx
	leaq	556(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L968
	testb	%cl, %cl
	jne	.L1050
.L968:
	movl	$0, 556(%rdx)
.L969:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L1034:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1043:
	call	__asan_report_load4
.L1041:
	call	__asan_report_load4
.L1040:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L1037:
	call	__asan_report_load4
.L1038:
	call	__asan_report_load4
.L1046:
	movl	$2, %edi
	movl	$.LC92, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1044:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1032:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1039:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1050:
	call	__asan_report_store4
.L1049:
	call	__asan_report_load8
.L1048:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1047:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1036:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1042:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1045:
	movq	%rbp, %rdi
	call	__asan_report_store8
.L1033:
	movq	%r13, %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	addq	$8, %rdi
	movq	%rdi, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1054
	movq	8(%rbx), %rdi
	movq	%rsi, %rbp
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
.L1054:
	.cfi_restore_state
	call	__asan_report_load8
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	addq	$8, %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	cmpb	$0, 2147450880(%rax)
	jne	.L1175
	movq	8(%rbp), %rbx
	leaq	160(%rbx), %r13
	movq	%r13, %r15
	shrq	$3, %r15
	cmpb	$0, 2147450880(%r15)
	jne	.L1176
	leaq	152(%rbx), %r14
	movq	%rsi, %r12
	movq	160(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1177
	movq	152(%rbx), %rdx
	leaq	144(%rbx), %rcx
	cmpq	%rdx, %rsi
	jb	.L1059
	cmpq	$5000, %rdx
	jbe	.L1060
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1178
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1179
.L1081:
	movq	httpd_err400title(%rip), %rdx
	movl	$.LC47, %r9d
	movl	$400, %esi
	movq	%r9, %rcx
	movq	%rbx, %rdi
	call	httpd_send_err
.L1174:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1060:
	.cfi_restore_state
	leaq	144(%rbx), %rcx
	addq	$1000, %rdx
	movq	%r14, %rsi
	movq	%rax, 8(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, (%rsp)
	call	httpd_realloc_str
	movq	8(%rsp), %rax
	movq	(%rsp), %rcx
	cmpb	$0, 2147450880(%rax)
	jne	.L1180
	cmpb	$0, 2147450880(%r15)
	movq	152(%rbx), %rdx
	jne	.L1181
	movq	160(%rbx), %rsi
.L1059:
	movq	%rcx, %rax
	subq	%rsi, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1182
	leaq	704(%rbx), %r14
	addq	144(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1066
	cmpb	$3, %al
	jle	.L1183
.L1066:
	movl	704(%rbx), %edi
	call	read
	testl	%eax, %eax
	je	.L1184
	js	.L1185
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1186
	cltq
	addq	%rax, 160(%rbx)
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1187
	leaq	88(%rbp), %rdi
	movq	(%r12), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1188
	movq	%rax, 88(%rbp)
	movq	%rbx, %rdi
	call	httpd_got_request
	testl	%eax, %eax
	je	.L1055
	cmpl	$2, %eax
	jne	.L1172
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1189
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1081
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1185:
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1071
	testb	%cl, %cl
	jne	.L1190
.L1071:
	movl	(%rax), %eax
	cmpl	$4, %eax
	jne	.L1191
.L1055:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1184:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1192
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1081
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1191:
	cmpl	$11, %eax
	je	.L1055
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1193
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1081
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1172:
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L1174
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L1194
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L1174
	leaq	528(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1088
	cmpb	$3, %al
	jle	.L1195
.L1088:
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L1089
	leaq	536(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1196
	leaq	136(%rbp), %rdi
	movq	536(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1197
	leaq	544(%rbx), %rdi
	movq	%rax, 136(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1198
	leaq	128(%rbp), %rdi
	movq	544(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	$1, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1199
.L1098:
	movq	%rax, 128(%rbp)
.L1094:
	leaq	712(%rbx), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1200
	cmpq	$0, 712(%rbx)
	je	.L1201
	leaq	136(%rbp), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1202
	movq	%rdi, %rdx
	movq	136(%rbp), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1203
	cmpq	128(%rbp), %rax
	jge	.L1174
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1112
	cmpb	$3, %al
	jle	.L1204
.L1112:
	movq	%r12, %rax
	movl	$2, 0(%rbp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1205
	leaq	80(%rbp), %rdi
	movq	(%r12), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1206
	leaq	112(%rbp), %rdi
	movq	%rax, 80(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1207
	movq	%r14, %rax
	movq	$0, 112(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1116
	cmpb	$3, %al
	jle	.L1208
.L1116:
	movl	704(%rbx), %edi
	call	fdwatch_del_fd
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1117
	cmpb	$3, %al
	jle	.L1209
.L1117:
	movl	704(%rbx), %edi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	movl	$1, %edx
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L1194:
	.cfi_restore_state
	leaq	208(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1210
	movl	$httpd_err503form, %eax
	movq	208(%rbx), %r9
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1211
	movl	$httpd_err503title, %eax
	movq	httpd_err503form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1212
	movq	httpd_err503title(%rip), %rdx
	movl	$.LC47, %ecx
	movl	$503, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
	jmp	.L1174
.L1183:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1190:
	movq	%rax, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1089:
	leaq	192(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1213
	movq	192(%rbx), %rax
	leaq	128(%rbp), %rdi
	testq	%rax, %rax
	js	.L1214
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1098
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1201:
	leaq	56(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1101
	cmpb	$3, %al
	jle	.L1215
.L1101:
	movl	56(%rbp), %eax
	testl	%eax, %eax
	jle	.L1216
	leaq	200(%rbx), %rdi
	movq	throttles(%rip), %r8
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1217
	subl	$1, %eax
	movq	200(%rbx), %rsi
	leaq	16(%rbp), %rdi
	leaq	20(%rbp,%rax,4), %r9
	.p2align 4,,10
	.p2align 3
.L1108:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1106
	testb	%dl, %dl
	jne	.L1218
.L1106:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r8, %rax
	leaq	32(%rax), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1219
	addq	$4, %rdi
	addq	%rsi, 32(%rax)
	cmpq	%r9, %rdi
	jne	.L1108
.L1104:
	leaq	136(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1220
	movq	%rsi, 136(%rbp)
	jmp	.L1174
.L1214:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1221
	movq	$0, 128(%rbp)
	jmp	.L1094
.L1216:
	leaq	200(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1222
	movq	200(%rbx), %rsi
	jmp	.L1104
.L1189:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1219:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L1217:
	call	__asan_report_load8
.L1218:
	call	__asan_report_load4
.L1221:
	call	__asan_report_store8
.L1202:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1215:
	call	__asan_report_load4
.L1222:
	call	__asan_report_load8
.L1212:
	movl	$httpd_err503title, %edi
	call	__asan_report_load8
.L1211:
	movl	$httpd_err503form, %edi
	call	__asan_report_load8
.L1210:
	call	__asan_report_load8
.L1192:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1176:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1175:
	call	__asan_report_load8
.L1186:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1187:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1180:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1181:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1178:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1179:
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
.L1182:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1177:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1188:
	call	__asan_report_store8
.L1193:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1196:
	call	__asan_report_load8
.L1195:
	call	__asan_report_load4
.L1204:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1206:
	call	__asan_report_store8
.L1205:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1207:
	call	__asan_report_store8
.L1209:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1200:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1199:
	call	__asan_report_store8
.L1198:
	call	__asan_report_load8
.L1197:
	call	__asan_report_store8
.L1203:
	call	__asan_report_load8
.L1208:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1213:
	call	__asan_report_load8
.L1220:
	call	__asan_report_store8
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC93:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC94:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LASANPC29:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L1255
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r15
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$httpd_err408form, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xorl	%ebp, %ebp
	movq	%rsi, %r14
	shrq	$3, %r15
	shrq	$3, %r12
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L1246
	.p2align 4,,10
	.p2align 3
.L1261:
	jl	.L1226
	cmpl	$3, %eax
	jg	.L1226
	cmpb	$0, 2147450880(%r15)
	jne	.L1256
	leaq	88(%rbx), %rdi
	movq	(%r14), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1257
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L1258
.L1226:
	addl	$1, %ebp
	cmpl	%ebp, max_connects(%rip)
	jle	.L1259
.L1246:
	movslq	%ebp, %rax
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1225
	cmpb	$3, %al
	jle	.L1260
.L1225:
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L1261
	cmpb	$0, 2147450880(%r15)
	jne	.L1262
	leaq	88(%rbx), %rdi
	movq	(%r14), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1263
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L1226
	leaq	8(%rbx), %r13
	movq	%r13, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1264
	movq	8(%rbx), %rax
	movq	%rcx, 8(%rsp)
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC93, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	cmpb	$0, 2147450880(%r12)
	movq	8(%rsp), %rcx
	jne	.L1265
	movl	$httpd_err408title, %eax
	movq	httpd_err408form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1266
	cmpb	$0, 2147450880(%rcx)
	movq	httpd_err408title(%rip), %rdx
	jne	.L1267
	movq	8(%rbx), %rdi
	movl	$.LC47, %r9d
	movl	$408, %esi
	movq	%r9, %rcx
	addl	$1, %ebp
	call	httpd_send_err
	movq	%r14, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	cmpl	%ebp, max_connects(%rip)
	jg	.L1246
	.p2align 4,,10
	.p2align 3
.L1259:
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_restore 13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_restore 14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_restore 15
	.cfi_def_cfa_offset 8
.L1255:
	rep ret
	.p2align 4,,10
	.p2align 3
.L1258:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1268
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC94, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r14, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1226
.L1260:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1268:
	call	__asan_report_load8
.L1267:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1266:
	movl	$httpd_err408title, %edi
	call	__asan_report_load8
.L1265:
	movl	$httpd_err408form, %edi
	call	__asan_report_load8
.L1264:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1263:
	call	__asan_report_load8
.L1262:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1257:
	call	__asan_report_load8
.L1256:
	movq	%r14, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.1
.LC95:
	.string	"1 32 32 2 iv "
	.section	.rodata
	.align 32
.LC96:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC97:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC98:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbp
	subq	$152, %rsp
	.cfi_def_cfa_offset 208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsi, 8(%rsp)
	leaq	48(%rsp), %r14
	testl	%eax, %eax
	jne	.L1422
.L1269:
	leaq	8(%rbp), %r12
	movq	%r14, %rbx
	movq	$1102416563, (%r14)
	shrq	$3, %rbx
	movq	$.LC95, 8(%r14)
	movq	$.LASANPC21, 16(%r14)
	movq	%r12, %rax
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147450888(%rbx)
	shrq	$3, %rax
	leaq	96(%r14), %rsi
	cmpb	$0, 2147450880(%rax)
	jne	.L1423
	leaq	64(%rbp), %rax
	movq	8(%rbp), %rcx
	movq	%rax, 24(%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1424
	movq	64(%rbp), %rax
	movl	$1000000000, %edx
	cmpq	$-1, %rax
	je	.L1275
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovns	%rax, %rdx
	sarq	$2, %rdx
.L1275:
	leaq	472(%rcx), %r8
	movq	%r8, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1425
	movq	472(%rcx), %rax
	testq	%rax, %rax
	jne	.L1277
	leaq	128(%rbp), %r13
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1426
	leaq	136(%rbp), %r15
	movq	128(%rbp), %rax
	movq	%r15, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1427
	movq	136(%rbp), %rsi
	leaq	712(%rcx), %rdi
	subq	%rsi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1428
	leaq	704(%rcx), %rax
	addq	712(%rcx), %rsi
	movq	%rax, 16(%rsp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edi
	testb	%dil, %dil
	je	.L1281
	cmpb	$3, %dil
	jle	.L1429
.L1281:
	movl	704(%rcx), %edi
	movq	%r8, 40(%rsp)
	movq	%rcx, 32(%rsp)
	call	write
	testl	%eax, %eax
	movq	32(%rsp), %rcx
	movq	40(%rsp), %r8
	js	.L1430
.L1288:
	je	.L1292
	movq	8(%rsp), %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1431
	leaq	88(%rbp), %rdi
	movq	8(%rsp), %rdx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	movq	(%rdx), %rdx
	cmpb	$0, 2147450880(%rsi)
	jne	.L1432
	movq	%rdx, 88(%rbp)
	movq	%r8, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1433
	movq	472(%rcx), %rdx
	testq	%rdx, %rdx
	je	.L1420
	movslq	%eax, %rsi
	cmpq	%rsi, %rdx
	ja	.L1434
	subl	%edx, %eax
	movq	$0, 472(%rcx)
.L1420:
	movslq	%eax, %rdx
.L1309:
	movq	%r15, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1435
	movq	%r12, %rax
	movq	%rdx, %r10
	addq	136(%rbp), %r10
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	movq	%r10, 136(%rbp)
	jne	.L1436
	movq	8(%rbp), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1437
	movq	%rdx, %r9
	addq	200(%rax), %r9
	leaq	56(%rbp), %rdi
	movq	%r9, 200(%rax)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1315
	cmpb	$3, %al
	jle	.L1438
.L1315:
	movl	56(%rbp), %eax
	testl	%eax, %eax
	jle	.L1323
	subl	$1, %eax
	movq	throttles(%rip), %r15
	leaq	16(%rbp), %rdi
	leaq	20(%rbp,%rax,4), %r11
	.p2align 4,,10
	.p2align 3
.L1322:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L1320
	testb	%sil, %sil
	jne	.L1439
.L1320:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r15, %rax
	leaq	32(%rax), %rsi
	movq	%rsi, %r8
	shrq	$3, %r8
	cmpb	$0, 2147450880(%r8)
	jne	.L1440
	addq	$4, %rdi
	addq	%rdx, 32(%rax)
	cmpq	%r11, %rdi
	jne	.L1322
.L1323:
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1441
	cmpq	128(%rbp), %r10
	jge	.L1442
	leaq	112(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1443
	movq	112(%rbp), %rax
	cmpq	$100, %rax
	jg	.L1444
.L1325:
	movq	24(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1445
	movq	64(%rbp), %rsi
	cmpq	$-1, %rsi
	je	.L1272
	movq	8(%rsp), %rax
	leaq	80(%rbp), %rdi
	movq	(%rax), %r13
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1446
	subq	80(%rbp), %r13
	movl	$1, %eax
	cmove	%rax, %r13
	movq	%r9, %rax
	cqto
	idivq	%r13
	cmpq	%rax, %rsi
	jge	.L1272
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1329
	cmpb	$3, %al
	jg	.L1329
	movq	%rbp, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1277:
	leaq	368(%rcx), %rdi
	movq	%rdi, %r11
	shrq	$3, %r11
	cmpb	$0, 2147450880(%r11)
	jne	.L1447
	movq	368(%rcx), %rdi
	movq	%rax, -56(%rsi)
	movq	%rdi, -64(%rsi)
	leaq	712(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1448
	leaq	136(%rbp), %r15
	movq	712(%rcx), %rax
	movq	%r15, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1449
	movq	136(%rbp), %rdi
	leaq	128(%rbp), %r13
	addq	%rdi, %rax
	movq	%rax, -48(%rsi)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1450
	movq	128(%rbp), %rax
	subq	%rdi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	leaq	704(%rcx), %rax
	movq	%rdx, -40(%rsi)
	movq	%rax, 16(%rsp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1287
	cmpb	$3, %al
	jle	.L1451
.L1287:
	movl	704(%rcx), %edi
	subq	$64, %rsi
	movl	$2, %edx
	movq	%r8, 40(%rsp)
	movq	%rcx, 32(%rsp)
	call	writev
	testl	%eax, %eax
	movq	40(%rsp), %r8
	movq	32(%rsp), %rcx
	jns	.L1288
.L1430:
	movq	%rcx, 24(%rsp)
	call	__errno_location
	movq	%rax, %rdx
	movq	24(%rsp), %rcx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1289
	testb	%sil, %sil
	jne	.L1452
.L1289:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1272
	cmpl	$11, %eax
	je	.L1292
	cmpl	$32, %eax
	setne	%sil
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %sil
	je	.L1302
	cmpl	$104, %eax
	je	.L1302
	leaq	208(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1453
	movq	208(%rcx), %rdx
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1302:
	movq	8(%rsp), %rsi
	movq	%rbp, %rdi
	call	clear_connection
	jmp	.L1272
	.p2align 4,,10
	.p2align 3
.L1292:
	leaq	112(%rbp), %r12
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1454
	movq	%rbp, %rax
	addq	$100, 112(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1296
	cmpb	$3, %al
	jle	.L1455
.L1296:
	movq	16(%rsp), %rax
	movl	$3, 0(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1297
	cmpb	$3, %al
	jle	.L1456
.L1297:
	movl	704(%rcx), %edi
	leaq	96(%rbp), %r13
	call	fdwatch_del_fd
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1457
	cmpq	$0, 96(%rbp)
	je	.L1299
	movl	$.LC96, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1299:
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1458
	movq	112(%rbp), %rcx
	movq	8(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1459
.L1301:
	testq	%rax, %rax
	movq	%rax, 96(%rbp)
	je	.L1460
.L1272:
	leaq	48(%rsp), %rax
	cmpq	%r14, %rax
	jne	.L1461
	movl	$0, 2147450880(%rbx)
	movl	$0, 2147450888(%rbx)
.L1271:
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1444:
	.cfi_restore_state
	subq	$100, %rax
	movq	%rax, 112(%rbp)
	jmp	.L1325
	.p2align 4,,10
	.p2align 3
.L1434:
	leaq	368(%rcx), %rdi
	subl	%eax, %edx
	movslq	%edx, %r8
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1462
	movq	368(%rcx), %rdi
	movq	%r8, %rdx
	movq	%rcx, 40(%rsp)
	movq	%r8, 32(%rsp)
	addq	%rdi, %rsi
	call	memmove
	movq	32(%rsp), %r8
	movq	40(%rsp), %rcx
	xorl	%edx, %edx
	movq	%r8, 472(%rcx)
	jmp	.L1309
	.p2align 4,,10
	.p2align 3
.L1329:
	movq	16(%rsp), %rax
	movl	$3, 0(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1330
	cmpb	$3, %al
	jg	.L1330
	movq	16(%rsp), %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1330:
	movl	704(%rcx), %edi
	call	fdwatch_del_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1463
	movq	8(%rbp), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1464
	movq	24(%rsp), %rdx
	movq	200(%rax), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1465
	cqto
	leaq	96(%rbp), %r12
	idivq	64(%rbp)
	subl	%r13d, %eax
	movslq	%eax, %r13
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1466
	cmpq	$0, 96(%rbp)
	je	.L1335
	movl	$.LC96, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1335:
	testl	%r13d, %r13d
	movl	$500, %ecx
	jle	.L1336
	imulq	$1000, %r13, %rcx
.L1336:
	movq	8(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%rbp, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1301
	movq	%r12, %rdi
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1442:
	movq	8(%rsp), %rsi
	movq	%rbp, %rdi
	call	finish_connection
	jmp	.L1272
.L1422:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %r14
	jmp	.L1269
.L1461:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%r14)
	movl	$-168430091, 2147450888(%rbx)
	movq	%rax, 2147450880(%rbx)
	jmp	.L1271
.L1462:
	call	__asan_report_load8
.L1449:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1456:
	movq	16(%rsp), %rdi
	call	__asan_report_load4
.L1453:
	call	__asan_report_load8
.L1448:
	call	__asan_report_load8
.L1447:
	call	__asan_report_load8
.L1431:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1432:
	call	__asan_report_store8
.L1436:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1452:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1455:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1466:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1465:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L1464:
	call	__asan_report_load8
.L1463:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1454:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1441:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1457:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1437:
	call	__asan_report_load8
.L1438:
	call	__asan_report_load4
.L1439:
	call	__asan_report_load4
.L1440:
	movq	%rsi, %rdi
	call	__asan_report_load8
.L1435:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1433:
	movq	%r8, %rdi
	call	__asan_report_load8
.L1429:
	movq	16(%rsp), %rdi
	call	__asan_report_load4
.L1451:
	movq	16(%rsp), %rdi
	call	__asan_report_load4
.L1427:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1426:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1425:
	movq	%r8, %rdi
	call	__asan_report_load8
.L1450:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1423:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1428:
	call	__asan_report_load8
.L1424:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L1460:
	movl	$2, %edi
	movl	$.LC97, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1458:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1459:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1445:
	movq	24(%rsp), %rdi
	call	__asan_report_load8
.L1446:
	call	__asan_report_load8
.L1443:
	call	__asan_report_load8
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC31:
.LFB31:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rax
	movq	%rdi, (%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1471
	movq	(%rsp), %rdi
	leaq	104(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1472
	movq	$0, 104(%rdi)
	call	really_clear_connection
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L1471:
	.cfi_restore_state
	movq	%rsp, %rdi
	call	__asan_report_load8
.L1472:
	movq	%rax, %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC99:
	.string	"1 32 4096 3 buf "
	.globl	__asan_stack_free_7
	.text
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LASANPC22:
.LFB22:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r14
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %r13
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$4160, %rsp
	.cfi_def_cfa_offset 4208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbx
	movq	%rsp, %r12
	testl	%eax, %eax
	jne	.L1496
.L1473:
	leaq	8(%r14), %rdi
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	shrq	$3, %rbp
	movq	$.LC99, 8(%rbx)
	movq	$.LASANPC22, 16(%rbx)
	movq	%rdi, %rax
	movl	$-235802127, 2147450880(%rbp)
	movl	$-202116109, 2147451396(%rbp)
	shrq	$3, %rax
	leaq	4160(%rbx), %rsi
	cmpb	$0, 2147450880(%rax)
	jne	.L1497
	movq	8(%r14), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1478
	cmpb	$3, %dl
	jle	.L1498
.L1478:
	movl	704(%rax), %edi
	subq	$4128, %rsi
	movl	$4096, %edx
	call	read
	testl	%eax, %eax
	js	.L1499
	je	.L1482
.L1476:
	cmpq	%rbx, %r12
	jne	.L1500
	movl	$0, 2147450880(%rbp)
	movl	$0, 2147451396(%rbp)
.L1475:
	addq	$4160, %rsp
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
.L1499:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1480
	testb	%cl, %cl
	jne	.L1501
.L1480:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1476
	cmpl	$11, %eax
	je	.L1476
.L1482:
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	really_clear_connection
	jmp	.L1476
.L1498:
	call	__asan_report_load4
.L1501:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1496:
	movl	$4160, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1473
.L1500:
	movq	$1172321806, (%rbx)
	movq	%r12, %rdx
	movl	$4160, %esi
	movq	%rbx, %rdi
	call	__asan_stack_free_7
	jmp	.L1475
.L1497:
	call	__asan_report_load8
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.8
	.align 8
.LC100:
	.string	"3 32 8 2 ai 96 10 7 portstr 160 48 5 hints "
	.section	.rodata
	.align 32
.LC101:
	.string	"%d"
	.zero	61
	.align 32
.LC102:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC103:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC104:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LASANPC37:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %r12
	subq	$296, %rsp
	.cfi_def_cfa_offset 352
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rdi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	leaq	32(%rsp), %rbx
	testl	%eax, %eax
	jne	.L1577
.L1502:
	leaq	160(%rbx), %r10
	movq	%rbx, %r15
	movq	$1102416563, (%rbx)
	shrq	$3, %r15
	movq	$.LC100, 8(%rbx)
	movq	$.LASANPC37, 16(%rbx)
	movq	%r10, %rdi
	xorl	%esi, %esi
	movl	$-235802127, 2147450880(%r15)
	movl	$-185273344, 2147450884(%r15)
	movl	$-218959118, 2147450888(%r15)
	movl	$48, %edx
	movl	$-185335296, 2147450892(%r15)
	movl	$-218959118, 2147450896(%r15)
	leaq	96(%rbx), %r14
	movl	$-185335808, 2147450904(%r15)
	movl	$-202116109, 2147450908(%r15)
	leaq	256(%rbx), %rbp
	movq	%r10, 24(%rsp)
	call	memset
	movzwl	port(%rip), %ecx
	movq	%r14, %rdi
	movl	$.LC101, %edx
	movl	$10, %esi
	xorl	%eax, %eax
	movl	$1, -96(%rbp)
	movl	$1, -88(%rbp)
	call	snprintf
	movq	24(%rsp), %r10
	movq	hostname(%rip), %rdi
	leaq	32(%rbx), %rcx
	movq	%r14, %rsi
	movq	%r10, %rdx
	call	getaddrinfo
	testl	%eax, %eax
	movl	%eax, %r14d
	jne	.L1578
	movq	-224(%rbp), %rax
	testq	%rax, %rax
	je	.L1508
	xorl	%r14d, %r14d
	xorl	%r10d, %r10d
	jmp	.L1514
	.p2align 4,,10
	.p2align 3
.L1582:
	cmpl	$10, %edx
	jne	.L1510
	testq	%r10, %r10
	cmove	%rax, %r10
.L1510:
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1579
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1580
.L1514:
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1509
	testb	%sil, %sil
	jne	.L1581
.L1509:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L1582
	testq	%r14, %r14
	cmove	%rax, %r14
	jmp	.L1510
	.p2align 4,,10
	.p2align 3
.L1580:
	testq	%r10, %r10
	je	.L1583
	leaq	16(%r10), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1518
	cmpb	$3, %al
	jle	.L1584
.L1518:
	movl	16(%r10), %r8d
	cmpq	$128, %r8
	ja	.L1576
	movq	16(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	movq	%r10, 24(%rsp)
	call	memset
	movq	24(%rsp), %r10
	leaq	24(%r10), %rdi
	movl	16(%r10), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1585
	movq	24(%r10), %rsi
	movq	16(%rsp), %rdi
	call	memmove
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r13, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1521
	testb	%dl, %dl
	jne	.L1586
.L1521:
	movl	$1, 0(%r13)
.L1517:
	testq	%r14, %r14
	je	.L1587
	leaq	16(%r14), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1525
	cmpb	$3, %al
	jle	.L1588
.L1525:
	movl	16(%r14), %r8d
	cmpq	$128, %r8
	ja	.L1576
	movq	8(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	call	memset
	leaq	24(%r14), %rdi
	movl	16(%r14), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1589
	movq	24(%r14), %rsi
	movq	8(%rsp), %rdi
	call	memmove
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r12, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1528
	testb	%dl, %dl
	jne	.L1590
.L1528:
	movl	$1, (%r12)
.L1524:
	movq	-224(%rbp), %rdi
	call	freeaddrinfo
	leaq	32(%rsp), %rax
	cmpq	%rbx, %rax
	jne	.L1591
	movq	$0, 2147450880(%r15)
	movq	$0, 2147450888(%r15)
	movl	$0, 2147450896(%r15)
	movq	$0, 2147450904(%r15)
.L1504:
	addq	$296, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1583:
	.cfi_restore_state
	movq	%r14, %rax
.L1508:
	movq	%r13, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%r13, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1516
	testb	%cl, %cl
	jne	.L1592
.L1516:
	movl	$0, 0(%r13)
	movq	%rax, %r14
	jmp	.L1517
.L1587:
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r12, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1523
	testb	%dl, %dl
	jne	.L1593
.L1523:
	movl	$0, (%r12)
	jmp	.L1524
.L1592:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1577:
	movl	$256, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1502
.L1591:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movq	%rax, 2147450880(%r15)
	movq	%rax, 2147450888(%r15)
	movq	%rax, 2147450896(%r15)
	movq	%rax, 2147450904(%r15)
	jmp	.L1504
.L1579:
	call	__asan_report_load8
.L1581:
	call	__asan_report_load4
.L1589:
	call	__asan_report_load8
.L1578:
	movl	%eax, %edi
	call	gai_strerror
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	movl	$.LC102, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	%r14d, %edi
	call	gai_strerror
	movl	$stderr, %esi
	movq	%rax, %r8
	movq	hostname(%rip), %rcx
	shrq	$3, %rsi
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rsi)
	jne	.L1594
	movq	stderr(%rip), %rdi
	movl	$.LC103, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1586:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1594:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1584:
	call	__asan_report_load4
.L1585:
	call	__asan_report_load8
.L1576:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	movl	$.LC104, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1590:
	movq	%r12, %rdi
	call	__asan_report_store4
.L1588:
	call	__asan_report_load4
.L1593:
	movq	%r12, %rdi
	call	__asan_report_store4
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.8
	.align 8
.LC105:
	.string	"6 32 4 5 gotv4 96 4 5 gotv6 160 16 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC106:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC107:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC108:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC109:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC110:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC111:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC112:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC113:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC114:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC115:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC116:
	.string	"chdir"
	.zero	58
	.align 32
.LC117:
	.string	"/"
	.zero	62
	.align 32
.LC118:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC119:
	.string	"w"
	.zero	62
	.align 32
.LC120:
	.string	"%d\n"
	.zero	60
	.align 32
.LC121:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC122:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC123:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC124:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC125:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC126:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC127:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC128:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC129:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC130:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC131:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC132:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC133:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC134:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC135:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC136:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC137:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC138:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC139:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LASANPC9:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4728, %rsp
	.cfi_def_cfa_offset 4784
	movl	__asan_option_detect_stack_use_after_return(%rip), %esi
	leaq	16(%rsp), %rbx
	testl	%esi, %esi
	jne	.L1874
.L1595:
	movq	%rbx, %rax
	movq	$1102416563, (%rbx)
	movq	$.LC105, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC9, 16(%rbx)
	leaq	4704(%rbx), %rbp
	movl	$-235802127, 2147450880(%rax)
	movl	$-185273340, 2147450884(%rax)
	movl	$-218959118, 2147450888(%rax)
	movl	$-185273340, 2147450892(%rax)
	movl	$-218959118, 2147450896(%rax)
	movl	$-185335808, 2147450900(%rax)
	movl	$-218959118, 2147450904(%rax)
	movl	$-218959118, 2147450924(%rax)
	movl	$-218959118, 2147450944(%rax)
	movl	$-185273343, 2147451460(%rax)
	movl	$-202116109, 2147451464(%rax)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1875
	movq	0(%r13), %r12
	movl	$47, %esi
	movq	%r12, %rdi
	movq	%r12, argv0(%rip)
	call	strrchr
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	movl	$9, %esi
	cmovne	%rdx, %r12
	movl	$24, %edx
	movq	%r12, %rdi
	call	openlog
	movq	%r13, %rsi
	movl	%r14d, %edi
	leaq	384(%rbx), %r13
	call	parse_args
	call	tzset
	leaq	96(%rbx), %rcx
	leaq	32(%rbx), %rsi
	addq	$224, %rbx
	movq	%r13, %rdx
	movq	%rbx, %rdi
	call	lookup_hostname.constprop.1
	movl	-4672(%rbp), %ecx
	testl	%ecx, %ecx
	jne	.L1601
	cmpl	$0, -4608(%rbp)
	je	.L1876
.L1601:
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L1603
	call	read_throttlefile
.L1603:
	call	getuid
	testl	%eax, %eax
	movl	$32767, (%rsp)
	movl	$32767, 4(%rsp)
	je	.L1877
.L1604:
	movq	logfile(%rip), %r12
	testq	%r12, %r12
	je	.L1703
	movl	$.LC110, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L1878
	movl	$.LC81, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1611
	movl	$stdout, %eax
	movq	stdout(%rip), %r15
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1879
.L1609:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1618
	call	chdir
	testl	%eax, %eax
	js	.L1880
.L1618:
	leaq	-4160(%rbp), %r12
	movl	$4096, %esi
	movq	%r12, %rdi
	call	getcwd
	movq	%r12, %rdi
	call	strlen
	leaq	-1(%rax), %rdx
	leaq	(%r12,%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L1619
	testb	%cl, %cl
	jne	.L1881
.L1619:
	cmpb	$47, -4160(%rdx,%rbp)
	je	.L1620
	leaq	(%r12,%rax), %rdi
	movl	$2, %edx
	movl	$.LC117, %esi
	call	memcpy
.L1620:
	movl	debug(%rip), %edx
	testl	%edx, %edx
	jne	.L1621
	movl	$stdin, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1882
	movq	stdin(%rip), %rdi
	call	fclose
	movl	$stdout, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1883
	movq	stdout(%rip), %rdi
	cmpq	%rdi, %r15
	je	.L1624
	call	fclose
.L1624:
	movl	$stderr, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1884
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	testl	%eax, %eax
	movl	$.LC118, %esi
	js	.L1870
.L1626:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1627
	movl	$.LC119, %esi
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r14
	je	.L1885
	call	getpid
	movq	%r14, %rdi
	movl	%eax, %edx
	movl	$.LC120, %esi
	xorl	%eax, %eax
	call	fprintf
	movq	%r14, %rdi
	call	fclose
.L1627:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects(%rip)
	js	.L1886
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L1887
.L1630:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1635
	call	chdir
	testl	%eax, %eax
	js	.L1888
.L1635:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	xorl	%esi, %esi
	cmpl	$0, -4608(%rbp)
	movl	no_empty_referers(%rip), %eax
	movq	%r13, %rdx
	movzwl	port(%rip), %ecx
	movl	cgi_limit(%rip), %r9d
	movq	cgi_pattern(%rip), %r8
	movq	hostname(%rip), %rdi
	cmove	%rsi, %rdx
	cmpl	$0, -4672(%rbp)
	pushq	%rax
	.cfi_def_cfa_offset 4792
	movl	do_global_passwd(%rip), %eax
	pushq	local_pattern(%rip)
	.cfi_def_cfa_offset 4800
	pushq	url_pattern(%rip)
	.cfi_def_cfa_offset 4808
	pushq	%rax
	.cfi_def_cfa_offset 4816
	movl	do_vhost(%rip), %eax
	cmovne	%rbx, %rsi
	pushq	%rax
	.cfi_def_cfa_offset 4824
	movl	no_symlink_check(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 4832
	movl	no_log(%rip), %eax
	pushq	%r15
	.cfi_def_cfa_offset 4840
	pushq	%rax
	.cfi_def_cfa_offset 4848
	movl	max_age(%rip), %eax
	pushq	%r12
	.cfi_def_cfa_offset 4856
	pushq	%rax
	.cfi_def_cfa_offset 4864
	pushq	p3p(%rip)
	.cfi_def_cfa_offset 4872
	pushq	charset(%rip)
	.cfi_def_cfa_offset 4880
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4784
	testq	%rax, %rax
	movq	%rax, hs(%rip)
	je	.L1871
	movl	$JunkClientData, %ebx
	movq	%rbx, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1889
	movq	JunkClientData(%rip), %rdx
	movl	$occasional, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC129, %esi
	je	.L1872
	cmpb	$0, 2147450880(%r12)
	jne	.L1890
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L1891
	cmpl	$0, numthrottles(%rip)
	jle	.L1643
	cmpb	$0, 2147450880(%r12)
	jne	.L1892
	movq	JunkClientData(%rip), %rdx
	movl	$update_throttles, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC131, %esi
	je	.L1872
.L1643:
	shrq	$3, %rbx
	cmpb	$0, 2147450880(%rbx)
	jne	.L1893
	movq	JunkClientData(%rip), %rdx
	movl	$show_stats, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC132, %esi
	je	.L1872
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	je	.L1894
.L1648:
	movslq	max_connects(%rip), %r12
	movq	%r12, %rbx
	imulq	$144, %r12, %r12
	movq	%r12, %rdi
	call	malloc
	testq	%rax, %rax
	movq	%rax, connects(%rip)
	je	.L1654
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	leaq	4(%rax), %rdx
	jle	.L1663
	.p2align 4,,10
	.p2align 3
.L1814:
	leaq	-4(%rdx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1659
	cmpb	$3, %sil
	jle	.L1895
.L1659:
	movq	%rdx, %rsi
	addl	$1, %ecx
	movl	$0, -4(%rdx)
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %edi
	movq	%rdx, %rsi
	andl	$7, %esi
	addl	$3, %esi
	cmpb	%dil, %sil
	jl	.L1660
	testb	%dil, %dil
	jne	.L1896
.L1660:
	leaq	4(%rdx), %rdi
	movl	%ecx, (%rdx)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1897
	movq	$0, 4(%rdx)
	addq	$144, %rdx
	cmpl	%ecx, %ebx
	jne	.L1814
.L1663:
	leaq	-144(%rax,%r12), %rdx
	leaq	4(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1656
	testb	%cl, %cl
	jne	.L1898
.L1656:
	movq	hs(%rip), %rax
	movl	$-1, 4(%rdx)
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L1664
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1665
	cmpb	$3, %dl
	jle	.L1899
.L1665:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1666
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L1666:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1667
	testb	%cl, %cl
	jne	.L1900
.L1667:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1664
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L1664:
	subq	$4544, %rbp
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
	.p2align 4,,10
	.p2align 3
.L1668:
	movl	terminate(%rip), %eax
	testl	%eax, %eax
	je	.L1701
	cmpl	$0, num_connects(%rip)
	jle	.L1901
.L1701:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L1902
.L1669:
	movq	%rbp, %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L1903
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L1904
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1687
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1678
	testb	%cl, %cl
	jne	.L1905
.L1678:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1679
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1680
.L1684:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1687
.L1679:
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1685
	cmpb	$3, %dl
	jle	.L1906
.L1685:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1687
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1907
	.p2align 4,,10
	.p2align 3
.L1687:
	call	fdwatch_get_next_client_data
	cmpq	$-1, %rax
	movq	%rax, %rbx
	je	.L1908
	testq	%rbx, %rbx
	je	.L1687
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1909
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1689
	cmpb	$3, %dl
	jle	.L1910
.L1689:
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1911
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1692
	cmpb	$3, %al
	jle	.L1912
.L1692:
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L1693
	cmpl	$4, %eax
	je	.L1694
	cmpl	$1, %eax
	jne	.L1687
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L1687
.L1878:
	movl	$1, no_log(%rip)
	xorl	%r15d, %r15d
	jmp	.L1609
.L1903:
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1671
	testb	%cl, %cl
	jne	.L1913
.L1671:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1668
	cmpl	$11, %eax
	je	.L1668
	movl	$.LC139, %esi
	movl	$3, %edi
.L1873:
	xorl	%eax, %eax
	call	syslog
.L1871:
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1621:
	call	setsid
	jmp	.L1626
.L1877:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L1914
	leaq	16(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1607
	cmpb	$3, %dl
	jle	.L1915
.L1607:
	leaq	20(%rax), %rdi
	movl	16(%rax), %ecx
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movl	%ecx, 4(%rsp)
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1608
	testb	%cl, %cl
	jne	.L1916
.L1608:
	movl	20(%rax), %eax
	movl	%eax, (%rsp)
	jmp	.L1604
.L1876:
	xorl	%eax, %eax
	movl	$.LC106, %esi
	movl	$3, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1917
	movq	stderr(%rip), %rdi
	movl	$.LC107, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1894:
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	testl	%eax, %eax
	movl	$.LC133, %esi
	js	.L1870
	movl	(%rsp), %edi
	call	setgid
	testl	%eax, %eax
	movl	$.LC134, %esi
	js	.L1870
	movl	(%rsp), %esi
	movq	user(%rip), %rdi
	call	initgroups
	testl	%eax, %eax
	js	.L1918
.L1651:
	movl	4(%rsp), %edi
	call	setuid
	testl	%eax, %eax
	movl	$.LC136, %esi
	js	.L1870
	cmpl	$0, do_chroot(%rip)
	jne	.L1648
	movl	$.LC137, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1648
.L1891:
	movl	$.LC130, %esi
.L1872:
	movl	$2, %edi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1911:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1687
.L1693:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L1687
.L1694:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L1687
.L1908:
	movq	%rbp, %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L1668
	cmpl	$0, terminate(%rip)
	jne	.L1668
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L1668
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1697
	cmpb	$3, %dl
	jg	.L1697
	call	__asan_report_load4
.L1697:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1698
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L1698:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1699
	testb	%cl, %cl
	je	.L1699
	call	__asan_report_load4
.L1699:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1700
	call	fdwatch_del_fd
.L1700:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L1668
.L1902:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L1669
.L1886:
	movl	$.LC121, %esi
.L1870:
	movl	$2, %edi
	jmp	.L1873
.L1904:
	movq	%rbp, %rdi
	call	tmr_run
	jmp	.L1668
.L1887:
	movq	%r12, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L1919
	movq	logfile(%rip), %r14
	testq	%r14, %r14
	je	.L1632
	movl	$.LC81, %esi
	movq	%r14, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L1632
	movq	%r12, %rdi
	call	strlen
	movq	%r12, %rsi
	movq	%rax, %rdx
	movq	%r14, %rdi
	movq	%rax, 8(%rsp)
	call	strncmp
	testl	%eax, %eax
	je	.L1920
	xorl	%eax, %eax
	movl	$.LC123, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1921
	movq	stderr(%rip), %rdi
	movl	$.LC124, %esi
	xorl	%eax, %eax
	call	fprintf
.L1632:
	movl	$2, %edx
	movl	$.LC117, %esi
	movq	%r12, %rdi
	call	memcpy
	movq	%r12, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L1630
	movl	$.LC125, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC126, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1703:
	xorl	%r15d, %r15d
	jmp	.L1609
.L1611:
	movq	%r12, %rdi
	movl	$.LC83, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movq	%rax, %r15
	movl	$384, %esi
	movq	%r12, %rdi
	call	chmod
	testq	%r15, %r15
	je	.L1706
	testl	%eax, %eax
	jne	.L1706
	movq	%r12, %rax
	movq	%r12, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L1615
	testb	%al, %al
	je	.L1615
	movq	%r12, %rdi
	call	__asan_report_load1
.L1615:
	cmpb	$47, (%r12)
	je	.L1616
	xorl	%eax, %eax
	movl	$.LC111, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1922
	movq	stderr(%rip), %rdi
	movl	$.LC112, %esi
	xorl	%eax, %eax
	call	fprintf
.L1616:
	movq	%r15, %rdi
	call	fileno
	movl	$1, %edx
	movl	%eax, %edi
	movl	$2, %esi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L1609
	movq	%r15, %rdi
	call	fileno
	movl	(%rsp), %edx
	movl	4(%rsp), %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L1609
	movl	$.LC113, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC114, %edi
	call	perror
	jmp	.L1609
.L1880:
	movl	$.LC115, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC116, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1885:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC73, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1888:
	movl	$.LC127, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC128, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1920:
	movq	8(%rsp), %rcx
	movq	%r14, %rdi
	leaq	-1(%r14,%rcx), %rsi
	call	strcpy
	jmp	.L1632
.L1680:
	movq	hs(%rip), %rdx
	leaq	76(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1682
	testb	%cl, %cl
	jne	.L1923
.L1682:
	movl	76(%rdx), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1668
	jmp	.L1684
.L1907:
	movq	hs(%rip), %rax
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1686
	cmpb	$3, %dl
	jle	.L1924
.L1686:
	movl	72(%rax), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1668
	jmp	.L1687
.L1706:
	movq	%r12, %rdx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1901:
	call	shut_down
	movl	$5, %edi
	movl	$.LC89, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L1919:
	movl	$.LC122, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC20, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1914:
	movq	user(%rip), %rdx
	movl	$.LC108, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1925
	movq	stderr(%rip), %rdi
	movl	$.LC109, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1654:
	movl	$.LC138, %esi
	jmp	.L1870
.L1918:
	movl	$.LC135, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1651
.L1874:
	movl	$4704, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1595
.L1906:
	call	__asan_report_load4
.L1922:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1905:
	call	__asan_report_load4
.L1924:
	call	__asan_report_load4
.L1913:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1921:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1916:
	call	__asan_report_load4
.L1917:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1882:
	movl	$stdin, %edi
	call	__asan_report_load8
.L1883:
	movl	$stdout, %edi
	call	__asan_report_load8
.L1881:
	call	__asan_report_load1
.L1879:
	movl	$stdout, %edi
	call	__asan_report_load8
.L1889:
	movq	%rbx, %rdi
	call	__asan_report_load8
.L1884:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1875:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1890:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1892:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1893:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1923:
	call	__asan_report_load4
.L1909:
	call	__asan_report_load8
.L1912:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1910:
	call	__asan_report_load4
.L1900:
	call	__asan_report_load4
.L1899:
	call	__asan_report_load4
.L1898:
	call	__asan_report_store4
.L1897:
	call	__asan_report_store8
.L1896:
	movq	%rdx, %rdi
	call	__asan_report_store4
.L1895:
	call	__asan_report_store4
.L1915:
	call	__asan_report_load4
.L1925:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 8
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 8
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 8
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 8
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 8
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 8
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 8
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 8
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 8
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 8
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 8
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 8
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 8
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 8
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 8
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 8
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC140:
	.string	"thttpd.c"
	.data
	.align 16
	.type	.LASANLOC1, @object
	.size	.LASANLOC1, 16
.LASANLOC1:
	.quad	.LC140
	.long	135
	.long	40
	.align 16
	.type	.LASANLOC2, @object
	.size	.LASANLOC2, 16
.LASANLOC2:
	.quad	.LC140
	.long	135
	.long	30
	.align 16
	.type	.LASANLOC3, @object
	.size	.LASANLOC3, 16
.LASANLOC3:
	.quad	.LC140
	.long	135
	.long	21
	.align 16
	.type	.LASANLOC4, @object
	.size	.LASANLOC4, 16
.LASANLOC4:
	.quad	.LC140
	.long	129
	.long	5
	.align 16
	.type	.LASANLOC5, @object
	.size	.LASANLOC5, 16
.LASANLOC5:
	.quad	.LC140
	.long	128
	.long	22
	.align 16
	.type	.LASANLOC6, @object
	.size	.LASANLOC6, 16
.LASANLOC6:
	.quad	.LC140
	.long	118
	.long	12
	.align 16
	.type	.LASANLOC7, @object
	.size	.LASANLOC7, 16
.LASANLOC7:
	.quad	.LC140
	.long	117
	.long	40
	.align 16
	.type	.LASANLOC8, @object
	.size	.LASANLOC8, 16
.LASANLOC8:
	.quad	.LC140
	.long	117
	.long	26
	.align 16
	.type	.LASANLOC9, @object
	.size	.LASANLOC9, 16
.LASANLOC9:
	.quad	.LC140
	.long	117
	.long	12
	.align 16
	.type	.LASANLOC10, @object
	.size	.LASANLOC10, 16
.LASANLOC10:
	.quad	.LC140
	.long	116
	.long	20
	.align 16
	.type	.LASANLOC11, @object
	.size	.LASANLOC11, 16
.LASANLOC11:
	.quad	.LC140
	.long	96
	.long	26
	.align 16
	.type	.LASANLOC12, @object
	.size	.LASANLOC12, 16
.LASANLOC12:
	.quad	.LC140
	.long	96
	.long	12
	.align 16
	.type	.LASANLOC13, @object
	.size	.LASANLOC13, 16
.LASANLOC13:
	.quad	.LC140
	.long	95
	.long	21
	.align 16
	.type	.LASANLOC14, @object
	.size	.LASANLOC14, 16
.LASANLOC14:
	.quad	.LC140
	.long	85
	.long	12
	.align 16
	.type	.LASANLOC15, @object
	.size	.LASANLOC15, 16
.LASANLOC15:
	.quad	.LC140
	.long	84
	.long	14
	.align 16
	.type	.LASANLOC16, @object
	.size	.LASANLOC16, 16
.LASANLOC16:
	.quad	.LC140
	.long	83
	.long	14
	.align 16
	.type	.LASANLOC17, @object
	.size	.LASANLOC17, 16
.LASANLOC17:
	.quad	.LC140
	.long	82
	.long	14
	.align 16
	.type	.LASANLOC18, @object
	.size	.LASANLOC18, 16
.LASANLOC18:
	.quad	.LC140
	.long	81
	.long	14
	.align 16
	.type	.LASANLOC19, @object
	.size	.LASANLOC19, 16
.LASANLOC19:
	.quad	.LC140
	.long	80
	.long	14
	.align 16
	.type	.LASANLOC20, @object
	.size	.LASANLOC20, 16
.LASANLOC20:
	.quad	.LC140
	.long	79
	.long	14
	.align 16
	.type	.LASANLOC21, @object
	.size	.LASANLOC21, 16
.LASANLOC21:
	.quad	.LC140
	.long	78
	.long	14
	.align 16
	.type	.LASANLOC22, @object
	.size	.LASANLOC22, 16
.LASANLOC22:
	.quad	.LC140
	.long	77
	.long	14
	.align 16
	.type	.LASANLOC23, @object
	.size	.LASANLOC23, 16
.LASANLOC23:
	.quad	.LC140
	.long	76
	.long	12
	.align 16
	.type	.LASANLOC24, @object
	.size	.LASANLOC24, 16
.LASANLOC24:
	.quad	.LC140
	.long	75
	.long	14
	.align 16
	.type	.LASANLOC25, @object
	.size	.LASANLOC25, 16
.LASANLOC25:
	.quad	.LC140
	.long	74
	.long	12
	.align 16
	.type	.LASANLOC26, @object
	.size	.LASANLOC26, 16
.LASANLOC26:
	.quad	.LC140
	.long	73
	.long	14
	.align 16
	.type	.LASANLOC27, @object
	.size	.LASANLOC27, 16
.LASANLOC27:
	.quad	.LC140
	.long	72
	.long	59
	.align 16
	.type	.LASANLOC28, @object
	.size	.LASANLOC28, 16
.LASANLOC28:
	.quad	.LC140
	.long	72
	.long	49
	.align 16
	.type	.LASANLOC29, @object
	.size	.LASANLOC29, 16
.LASANLOC29:
	.quad	.LC140
	.long	72
	.long	31
	.align 16
	.type	.LASANLOC30, @object
	.size	.LASANLOC30, 16
.LASANLOC30:
	.quad	.LC140
	.long	72
	.long	23
	.align 16
	.type	.LASANLOC31, @object
	.size	.LASANLOC31, 16
.LASANLOC31:
	.quad	.LC140
	.long	72
	.long	12
	.align 16
	.type	.LASANLOC32, @object
	.size	.LASANLOC32, 16
.LASANLOC32:
	.quad	.LC140
	.long	71
	.long	14
	.align 16
	.type	.LASANLOC33, @object
	.size	.LASANLOC33, 16
.LASANLOC33:
	.quad	.LC140
	.long	70
	.long	14
	.align 16
	.type	.LASANLOC34, @object
	.size	.LASANLOC34, 16
.LASANLOC34:
	.quad	.LC140
	.long	69
	.long	23
	.align 16
	.type	.LASANLOC35, @object
	.size	.LASANLOC35, 16
.LASANLOC35:
	.quad	.LC140
	.long	68
	.long	12
	.align 16
	.type	.LASANLOC36, @object
	.size	.LASANLOC36, 16
.LASANLOC36:
	.quad	.LC140
	.long	67
	.long	14
	.section	.rodata.str1.1
.LC141:
	.string	"watchdog_flag"
.LC142:
	.string	"got_usr1"
.LC143:
	.string	"got_hup"
.LC144:
	.string	"terminate"
.LC145:
	.string	"hs"
.LC146:
	.string	"httpd_conn_count"
.LC147:
	.string	"first_free_connect"
.LC148:
	.string	"max_connects"
.LC149:
	.string	"num_connects"
.LC150:
	.string	"connects"
.LC151:
	.string	"maxthrottles"
.LC152:
	.string	"numthrottles"
.LC153:
	.string	"hostname"
.LC154:
	.string	"throttlefile"
.LC155:
	.string	"local_pattern"
.LC156:
	.string	"no_empty_referers"
.LC157:
	.string	"url_pattern"
.LC158:
	.string	"cgi_limit"
.LC159:
	.string	"cgi_pattern"
.LC160:
	.string	"do_global_passwd"
.LC161:
	.string	"do_vhost"
.LC162:
	.string	"no_symlink_check"
.LC163:
	.string	"no_log"
.LC164:
	.string	"do_chroot"
.LC165:
	.string	"argv0"
.LC166:
	.string	"*.LC94"
.LC167:
	.string	"*.LC115"
.LC168:
	.string	"*.LC38"
.LC169:
	.string	"*.LC82"
.LC170:
	.string	"*.LC135"
.LC171:
	.string	"*.LC78"
.LC172:
	.string	"*.LC79"
.LC173:
	.string	"*.LC1"
.LC174:
	.string	"*.LC127"
.LC175:
	.string	"*.LC130"
.LC176:
	.string	"*.LC68"
.LC177:
	.string	"*.LC34"
.LC178:
	.string	"*.LC59"
.LC179:
	.string	"*.LC75"
.LC180:
	.string	"*.LC61"
.LC181:
	.string	"*.LC81"
.LC182:
	.string	"*.LC53"
.LC183:
	.string	"*.LC122"
.LC184:
	.string	"*.LC128"
.LC185:
	.string	"*.LC35"
.LC186:
	.string	"*.LC20"
.LC187:
	.string	"*.LC31"
.LC188:
	.string	"*.LC134"
.LC189:
	.string	"*.LC54"
.LC190:
	.string	"*.LC44"
.LC191:
	.string	"*.LC102"
.LC192:
	.string	"*.LC28"
.LC193:
	.string	"*.LC6"
.LC194:
	.string	"*.LC3"
.LC195:
	.string	"*.LC106"
.LC196:
	.string	"*.LC104"
.LC197:
	.string	"*.LC74"
.LC198:
	.string	"*.LC76"
.LC199:
	.string	"*.LC114"
.LC200:
	.string	"*.LC30"
.LC201:
	.string	"*.LC39"
.LC202:
	.string	"*.LC48"
.LC203:
	.string	"*.LC55"
.LC204:
	.string	"*.LC40"
.LC205:
	.string	"*.LC117"
.LC206:
	.string	"*.LC60"
.LC207:
	.string	"*.LC29"
.LC208:
	.string	"*.LC0"
.LC209:
	.string	"*.LC83"
.LC210:
	.string	"*.LC136"
.LC211:
	.string	"*.LC120"
.LC212:
	.string	"*.LC11"
.LC213:
	.string	"*.LC45"
.LC214:
	.string	"*.LC46"
.LC215:
	.string	"*.LC101"
.LC216:
	.string	"*.LC126"
.LC217:
	.string	"*.LC42"
.LC218:
	.string	"*.LC97"
.LC219:
	.string	"*.LC18"
.LC220:
	.string	"*.LC24"
.LC221:
	.string	"*.LC125"
.LC222:
	.string	"*.LC108"
.LC223:
	.string	"*.LC109"
.LC224:
	.string	"*.LC139"
.LC225:
	.string	"*.LC19"
.LC226:
	.string	"*.LC49"
.LC227:
	.string	"*.LC71"
.LC228:
	.string	"*.LC87"
.LC229:
	.string	"*.LC65"
.LC230:
	.string	"*.LC62"
.LC231:
	.string	"*.LC63"
.LC232:
	.string	"*.LC112"
.LC233:
	.string	"*.LC15"
.LC234:
	.string	"*.LC119"
.LC235:
	.string	"*.LC118"
.LC236:
	.string	"*.LC77"
.LC237:
	.string	"*.LC121"
.LC238:
	.string	"*.LC4"
.LC239:
	.string	"*.LC123"
.LC240:
	.string	"*.LC16"
.LC241:
	.string	"*.LC66"
.LC242:
	.string	"*.LC21"
.LC243:
	.string	"*.LC41"
.LC244:
	.string	"*.LC64"
.LC245:
	.string	"*.LC25"
.LC246:
	.string	"*.LC84"
.LC247:
	.string	"*.LC32"
.LC248:
	.string	"*.LC47"
.LC249:
	.string	"*.LC116"
.LC250:
	.string	"*.LC124"
.LC251:
	.string	"*.LC103"
.LC252:
	.string	"*.LC98"
.LC253:
	.string	"*.LC137"
.LC254:
	.string	"*.LC93"
.LC255:
	.string	"*.LC73"
.LC256:
	.string	"*.LC8"
.LC257:
	.string	"*.LC132"
.LC258:
	.string	"*.LC69"
.LC259:
	.string	"*.LC80"
.LC260:
	.string	"*.LC52"
.LC261:
	.string	"*.LC67"
.LC262:
	.string	"*.LC56"
.LC263:
	.string	"*.LC133"
.LC264:
	.string	"*.LC88"
.LC265:
	.string	"*.LC138"
.LC266:
	.string	"*.LC2"
.LC267:
	.string	"*.LC91"
.LC268:
	.string	"*.LC5"
.LC269:
	.string	"*.LC92"
.LC270:
	.string	"*.LC131"
.LC271:
	.string	"*.LC96"
.LC272:
	.string	"*.LC89"
.LC273:
	.string	"*.LC22"
.LC274:
	.string	"*.LC57"
.LC275:
	.string	"*.LC9"
.LC276:
	.string	"*.LC113"
.LC277:
	.string	"*.LC110"
.LC278:
	.string	"*.LC85"
.LC279:
	.string	"*.LC33"
.LC280:
	.string	"*.LC129"
.LC281:
	.string	"*.LC43"
.LC282:
	.string	"*.LC26"
.LC283:
	.string	"*.LC86"
.LC284:
	.string	"*.LC90"
.LC285:
	.string	"*.LC50"
.LC286:
	.string	"*.LC70"
.LC287:
	.string	"*.LC37"
.LC288:
	.string	"*.LC51"
.LC289:
	.string	"*.LC58"
.LC290:
	.string	"*.LC36"
.LC291:
	.string	"*.LC27"
.LC292:
	.string	"*.LC12"
.LC293:
	.string	"*.LC13"
.LC294:
	.string	"*.LC107"
.LC295:
	.string	"*.LC23"
.LC296:
	.string	"*.LC111"
.LC297:
	.string	"*.LC17"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 9408
.LASAN0:
	.quad	watchdog_flag
	.quad	4
	.quad	64
	.quad	.LC141
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC1
	.quad	got_usr1
	.quad	4
	.quad	64
	.quad	.LC142
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC2
	.quad	got_hup
	.quad	4
	.quad	64
	.quad	.LC143
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC3
	.quad	terminate
	.quad	4
	.quad	64
	.quad	.LC144
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC4
	.quad	hs
	.quad	8
	.quad	64
	.quad	.LC145
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC5
	.quad	httpd_conn_count
	.quad	4
	.quad	64
	.quad	.LC146
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC6
	.quad	first_free_connect
	.quad	4
	.quad	64
	.quad	.LC147
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC7
	.quad	max_connects
	.quad	4
	.quad	64
	.quad	.LC148
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC8
	.quad	num_connects
	.quad	4
	.quad	64
	.quad	.LC149
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC9
	.quad	connects
	.quad	8
	.quad	64
	.quad	.LC150
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC10
	.quad	maxthrottles
	.quad	4
	.quad	64
	.quad	.LC151
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC11
	.quad	numthrottles
	.quad	4
	.quad	64
	.quad	.LC152
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC12
	.quad	throttles
	.quad	8
	.quad	64
	.quad	.LC33
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC13
	.quad	max_age
	.quad	4
	.quad	64
	.quad	.LC43
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC14
	.quad	p3p
	.quad	8
	.quad	64
	.quad	.LC42
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC15
	.quad	charset
	.quad	8
	.quad	64
	.quad	.LC41
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC16
	.quad	user
	.quad	8
	.quad	64
	.quad	.LC27
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC17
	.quad	pidfile
	.quad	8
	.quad	64
	.quad	.LC40
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC18
	.quad	hostname
	.quad	8
	.quad	64
	.quad	.LC153
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC19
	.quad	throttlefile
	.quad	8
	.quad	64
	.quad	.LC154
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC20
	.quad	logfile
	.quad	8
	.quad	64
	.quad	.LC35
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC21
	.quad	local_pattern
	.quad	8
	.quad	64
	.quad	.LC155
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC22
	.quad	no_empty_referers
	.quad	4
	.quad	64
	.quad	.LC156
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC23
	.quad	url_pattern
	.quad	8
	.quad	64
	.quad	.LC157
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC24
	.quad	cgi_limit
	.quad	4
	.quad	64
	.quad	.LC158
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC25
	.quad	cgi_pattern
	.quad	8
	.quad	64
	.quad	.LC159
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC26
	.quad	do_global_passwd
	.quad	4
	.quad	64
	.quad	.LC160
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC27
	.quad	do_vhost
	.quad	4
	.quad	64
	.quad	.LC161
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC28
	.quad	no_symlink_check
	.quad	4
	.quad	64
	.quad	.LC162
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC29
	.quad	no_log
	.quad	4
	.quad	64
	.quad	.LC163
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC30
	.quad	do_chroot
	.quad	4
	.quad	64
	.quad	.LC164
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC31
	.quad	data_dir
	.quad	8
	.quad	64
	.quad	.LC22
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC32
	.quad	dir
	.quad	8
	.quad	64
	.quad	.LC19
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC33
	.quad	port
	.quad	2
	.quad	64
	.quad	.LC18
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC34
	.quad	debug
	.quad	4
	.quad	64
	.quad	.LC17
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC35
	.quad	argv0
	.quad	8
	.quad	64
	.quad	.LC165
	.quad	.LC140
	.quad	0
	.quad	.LASANLOC36
	.quad	.LC94
	.quad	35
	.quad	96
	.quad	.LC166
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC115
	.quad	11
	.quad	64
	.quad	.LC167
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC38
	.quad	13
	.quad	64
	.quad	.LC168
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC82
	.quad	19
	.quad	64
	.quad	.LC169
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC135
	.quad	16
	.quad	64
	.quad	.LC170
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC78
	.quad	3
	.quad	64
	.quad	.LC171
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC79
	.quad	39
	.quad	96
	.quad	.LC172
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC1
	.quad	70
	.quad	128
	.quad	.LC173
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC127
	.quad	20
	.quad	64
	.quad	.LC174
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC130
	.quad	24
	.quad	64
	.quad	.LC175
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC68
	.quad	3
	.quad	64
	.quad	.LC176
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC34
	.quad	5
	.quad	64
	.quad	.LC177
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC59
	.quad	3
	.quad	64
	.quad	.LC178
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC75
	.quad	16
	.quad	64
	.quad	.LC179
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC61
	.quad	3
	.quad	64
	.quad	.LC180
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC81
	.quad	2
	.quad	64
	.quad	.LC181
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC53
	.quad	3
	.quad	64
	.quad	.LC182
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC122
	.quad	12
	.quad	64
	.quad	.LC183
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC128
	.quad	15
	.quad	64
	.quad	.LC184
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC35
	.quad	8
	.quad	64
	.quad	.LC185
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC20
	.quad	7
	.quad	64
	.quad	.LC186
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC31
	.quad	16
	.quad	64
	.quad	.LC187
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC134
	.quad	12
	.quad	64
	.quad	.LC188
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC54
	.quad	5
	.quad	64
	.quad	.LC189
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC44
	.quad	32
	.quad	64
	.quad	.LC190
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC102
	.quad	26
	.quad	64
	.quad	.LC191
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC28
	.quad	7
	.quad	64
	.quad	.LC192
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC6
	.quad	219
	.quad	256
	.quad	.LC193
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC3
	.quad	65
	.quad	128
	.quad	.LC194
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC106
	.quad	29
	.quad	64
	.quad	.LC195
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC104
	.quad	39
	.quad	96
	.quad	.LC196
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC74
	.quad	20
	.quad	64
	.quad	.LC197
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC76
	.quad	33
	.quad	96
	.quad	.LC198
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC114
	.quad	15
	.quad	64
	.quad	.LC199
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC30
	.quad	7
	.quad	64
	.quad	.LC200
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC39
	.quad	15
	.quad	64
	.quad	.LC201
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC48
	.quad	3
	.quad	64
	.quad	.LC202
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC55
	.quad	4
	.quad	64
	.quad	.LC203
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC40
	.quad	8
	.quad	64
	.quad	.LC204
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC117
	.quad	2
	.quad	64
	.quad	.LC205
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC60
	.quad	3
	.quad	64
	.quad	.LC206
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC29
	.quad	9
	.quad	64
	.quad	.LC207
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC0
	.quad	104
	.quad	160
	.quad	.LC208
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC83
	.quad	2
	.quad	64
	.quad	.LC209
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC136
	.quad	12
	.quad	64
	.quad	.LC210
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC120
	.quad	4
	.quad	64
	.quad	.LC211
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC11
	.quad	16
	.quad	64
	.quad	.LC212
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC45
	.quad	7
	.quad	64
	.quad	.LC213
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC46
	.quad	11
	.quad	64
	.quad	.LC214
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC101
	.quad	3
	.quad	64
	.quad	.LC215
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC126
	.quad	13
	.quad	64
	.quad	.LC216
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC42
	.quad	4
	.quad	64
	.quad	.LC217
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC97
	.quad	37
	.quad	96
	.quad	.LC218
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC18
	.quad	5
	.quad	64
	.quad	.LC219
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC24
	.quad	10
	.quad	64
	.quad	.LC220
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC125
	.quad	18
	.quad	64
	.quad	.LC221
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC108
	.quad	23
	.quad	64
	.quad	.LC222
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC109
	.quad	25
	.quad	64
	.quad	.LC223
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC139
	.quad	13
	.quad	64
	.quad	.LC224
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC19
	.quad	4
	.quad	64
	.quad	.LC225
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC49
	.quad	26
	.quad	64
	.quad	.LC226
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC71
	.quad	3
	.quad	64
	.quad	.LC227
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC87
	.quad	39
	.quad	96
	.quad	.LC228
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC65
	.quad	3
	.quad	64
	.quad	.LC229
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC62
	.quad	3
	.quad	64
	.quad	.LC230
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC63
	.quad	3
	.quad	64
	.quad	.LC231
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC112
	.quad	72
	.quad	128
	.quad	.LC232
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC15
	.quad	2
	.quad	64
	.quad	.LC233
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC119
	.quad	2
	.quad	64
	.quad	.LC234
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC118
	.quad	12
	.quad	64
	.quad	.LC235
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC77
	.quad	38
	.quad	96
	.quad	.LC236
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC121
	.quad	31
	.quad	64
	.quad	.LC237
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC4
	.quad	37
	.quad	96
	.quad	.LC238
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC123
	.quad	74
	.quad	128
	.quad	.LC239
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC16
	.quad	5
	.quad	64
	.quad	.LC240
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC66
	.quad	5
	.quad	64
	.quad	.LC241
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC21
	.quad	9
	.quad	64
	.quad	.LC242
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC41
	.quad	8
	.quad	64
	.quad	.LC243
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC64
	.quad	5
	.quad	64
	.quad	.LC244
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC25
	.quad	9
	.quad	64
	.quad	.LC245
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC84
	.quad	22
	.quad	64
	.quad	.LC246
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC32
	.quad	9
	.quad	64
	.quad	.LC247
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC47
	.quad	1
	.quad	64
	.quad	.LC248
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC116
	.quad	6
	.quad	64
	.quad	.LC249
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC124
	.quad	79
	.quad	128
	.quad	.LC250
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC103
	.quad	25
	.quad	64
	.quad	.LC251
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC98
	.quad	25
	.quad	64
	.quad	.LC252
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC137
	.quad	58
	.quad	96
	.quad	.LC253
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC93
	.quad	35
	.quad	96
	.quad	.LC254
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC73
	.quad	11
	.quad	64
	.quad	.LC255
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC8
	.quad	39
	.quad	96
	.quad	.LC256
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC132
	.quad	30
	.quad	64
	.quad	.LC257
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC69
	.quad	3
	.quad	64
	.quad	.LC258
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC80
	.quad	44
	.quad	96
	.quad	.LC259
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC52
	.quad	3
	.quad	64
	.quad	.LC260
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC67
	.quad	3
	.quad	64
	.quad	.LC261
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC56
	.quad	3
	.quad	64
	.quad	.LC262
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC133
	.quad	15
	.quad	64
	.quad	.LC263
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC88
	.quad	56
	.quad	96
	.quad	.LC264
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC138
	.quad	38
	.quad	96
	.quad	.LC265
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC2
	.quad	62
	.quad	96
	.quad	.LC266
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC91
	.quad	33
	.quad	96
	.quad	.LC267
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC5
	.quad	34
	.quad	96
	.quad	.LC268
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC92
	.quad	43
	.quad	96
	.quad	.LC269
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC131
	.quad	36
	.quad	96
	.quad	.LC270
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC96
	.quad	33
	.quad	96
	.quad	.LC271
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC89
	.quad	8
	.quad	64
	.quad	.LC272
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC22
	.quad	9
	.quad	64
	.quad	.LC273
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC57
	.quad	5
	.quad	64
	.quad	.LC274
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC9
	.quad	5
	.quad	64
	.quad	.LC275
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC113
	.quad	20
	.quad	64
	.quad	.LC276
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC110
	.quad	10
	.quad	64
	.quad	.LC277
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC85
	.quad	22
	.quad	64
	.quad	.LC278
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC33
	.quad	10
	.quad	64
	.quad	.LC279
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC129
	.quad	30
	.quad	64
	.quad	.LC280
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC43
	.quad	8
	.quad	64
	.quad	.LC281
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC26
	.quad	11
	.quad	64
	.quad	.LC282
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC86
	.quad	36
	.quad	96
	.quad	.LC283
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC90
	.quad	25
	.quad	64
	.quad	.LC284
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC50
	.quad	3
	.quad	64
	.quad	.LC285
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC70
	.quad	3
	.quad	64
	.quad	.LC286
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC37
	.quad	8
	.quad	64
	.quad	.LC287
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC51
	.quad	3
	.quad	64
	.quad	.LC288
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC58
	.quad	3
	.quad	64
	.quad	.LC289
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC36
	.quad	6
	.quad	64
	.quad	.LC290
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC27
	.quad	5
	.quad	64
	.quad	.LC291
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC12
	.quad	31
	.quad	64
	.quad	.LC292
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC13
	.quad	36
	.quad	96
	.quad	.LC293
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC107
	.quad	34
	.quad	96
	.quad	.LC294
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC23
	.quad	8
	.quad	64
	.quad	.LC295
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC111
	.quad	67
	.quad	128
	.quad	.LC296
	.quad	.LC140
	.quad	0
	.quad	0
	.quad	.LC17
	.quad	6
	.quad	64
	.quad	.LC297
	.quad	.LC140
	.quad	0
	.quad	0
	.section	.text.exit,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	movl	$168, %esi
	movl	$.LASAN0, %edi
	jmp	__asan_unregister_globals
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	__asan_init
	call	__asan_version_mismatch_check_v6
	movl	$168, %esi
	movl	$.LASAN0, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__asan_register_globals
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_00099_1_terminate
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
