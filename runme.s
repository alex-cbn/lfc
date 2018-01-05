	.text
	.globl main
main:
BLOCK_1:
	lw	$t0, 4
	sw	$t0, a
	lw	$t0, 7
	sw	$t0, b
	lw	$t0, 10
	sw	$t0, c
	lw	$t0, a
	sw	$t0, d
	lw	$t0, b
	lw	$t1, c
	add	$t0, $t0, $t1
	lw	$t1, a
	add	$t0, $t0, $t1
	lw	$t1, d
	add	$t0, $t0, $t1
	sw	$t0, m
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
a:			.word 0
b:			.word 0
c:			.word 0
d:			.word 0
m:			.word 0
cgs0:			.asciiz "AM mai mult de 4 clase"
crlf:			.asciiz "\n"

