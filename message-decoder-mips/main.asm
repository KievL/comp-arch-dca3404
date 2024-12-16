# Coloque seu nome
# Coloque sua matrícula

# Segmento de dados --------------

.data

msg_codificada: .word 0x00051010, 0x116A23B1, 0x21347582, 0x10061231, 0x11642467, 0x008695AB, 0x21CD6EEF, 0x00071323
                .word 0x11264517, 0x2089A2B0, 0x00E5F601, 0x212360F1, 0x11624533, 0x21676455, 0x00627089, 0x20AB8691
                .word 0x10A6CDB3, 0x21EF6C5D, 0x10E701F2, 0x00071423, 0x0162F345, 0x21677455, 0x10628971, 0x1082AB90
                .word 0x10A4CDB6, 0x016C9DEF, 0x21016031, 0x212362F3, 0x01745545, 0x10626770, 0x10868993, 0x21AB6AFB
                .word 0x00C6DDCD, 0x00E2F0EF, 0x116001E1, 0x0162F323, 0x20454754, 0x00667167, 0x20898290, 0x113AAB1B
                .word 0x113CCD0D, 0x000211EF

# Segmento de texto (instruções)

.text

main:

	la $t0, msg_codificada
	li $t1, 42
	li $v0, 11

read_loop:
	lw $t2, 0($t0)
	
	srl $t3, $t2, 28 # invalid byte
	
	srl $t4, $t2, 24
	andi $t4, $t4, 0x0F # target nibble
	
	# t5 para ser os bytes concatenados
	li $t6, 2
	li $t7, 1
	li $t5, 0
	read_byte:
		beq $t6, $t3, decrement_byte
		bne $t7, $t4, decrement_nibble
		
		sll $t9, $t6, 3
		srlv $t8, $t2, $t9
		sll $t9, $t7, 2
		srlv $t8, $t8, $t9
		
		sll $t5, $t5, 4
		andi $t8, $t8, 0xF
		or $t5, $t5, $t8
		
		j decrement_nibble
		
	decrement_nibble:
		beq $t7, 0, decrement_byte
		subi $t7, $t7, 1
		
		j read_byte
	decrement_byte:
		beq $t6, 0, end_word
		subi $t6, $t6, 1
		li $t7, 1
		
		j read_byte
	
	end_word:
	
	move $a0, $t5
	syscall
	
	subi $t1, $t1, 1
	addi $t0, $t0, 4
	bne $t1, 0, read_loop
	
# Exit()
li $v0, 10
syscall
