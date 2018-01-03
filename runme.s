	.text
	.globl main
main:
BLOCK_1:
	li	$t0, 12
	sw	$t0, m
	li	$t0, 28
	sw	$t0, n
	lw	$t0, m
	move	$t2, $t0
	lw	$t0, n
	bne	$t2, $t0, BLOCK_3
BLOCK_2:
	move	$a0, $t0
	li	$v0, 1
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
E_BLOCK_2:
	b	E_BLOCK_3
BLOCK_3:
BLOCK_4:
	lw	$t0, m
	move	$t2, $t0
	lw	$t0, n
	ble	$t2, $t0, BLOCK_6
BLOCK_5:
	lw	$t0, m
	lw	$t1, n
	sub	$t0, $t0, $t1
	sw	$t0, m
E_BLOCK_5:
	b	E_BLOCK_6
BLOCK_6:
	lw	$t0, n
	lw	$t1, m
	sub	$t0, $t0, $t1
	sw	$t0, n
E_BLOCK_6:
E_BLOCK_4:
	lw	$t0, m
	move	$t2, $t0
	lw	$t0, n
	bne	$t2, $t0, BLOCK_4
	la	$a0, cgs0
	li	$v0, 4
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
E_BLOCK_3:
E_BLOCK_1:
	li	$v0, 10
	syscall
	.data
m:			.word 0
n:			.word 0
cgs0:			.asciiz "GCD is:"
crlf:			.asciiz "\n"

