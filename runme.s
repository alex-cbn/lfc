	.text
	.globl main
main:
BLOCK_1:
	li	$t0, 6
	li	$t1, 2
	div	$t0, $t1
	mflo	$t0
	addi	$t0, $t0, 2
	li	$t1, 3
	mult	$t0, $t1
	mflo	$t0
	sw	$t0, mvar
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
E_BLOCK_1:
	li	$v0, 10
	syscall
	.data
mvar:			.word 0
cgs0:			.asciiz "AM mai mult de 4 clase"
crlf:			.asciiz "\n"

