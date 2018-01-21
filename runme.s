	.text
	.globl main
main:
BLOCK_1:
	la	$a0, cgs0
	li	$v0, 4
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
	la	$a0, true_value
	li	$v0, 4
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
	la	$a0, crlf
	li	$v0, 4
	syscall
E_BLOCK_1:
	li	$v0, 10
	syscall
	.data
m:			.word 0
cgs0:			.asciiz "Less work than expected"
crlf:			.asciiz "\n"
true_value:		.asciiz "True"
false_value:		.asciiz "False"

