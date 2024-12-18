# KIEV LUIZ FREITAS GUEDES
# 20220012740

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

	la $t0, msg_codificada # carregando o endereço da mensagem em t0
	li $t1, 42 # contador para o número de caracteres da mensagem
	li $v0, 11 # código para printar o caractere

read_loop:
	lw $t2, 0($t0) # caregando a word da posição 0 de t0 em t2
	
	srl $t3, $t2, 28 # fazendo um shift right para pegar o último algarismo hexadecial referente ao byte inválido
	
	srl $t4, $t2, 24 # fazendo um shift right para pegar o algarismo hexadecimal referente ao nibble desejado
	andi $t4, $t4, 0x0F # fazendo um and bit a bit para retirar os bits do byte inválido
	
	li $t6, 2 # index dos bytes em cada word
	li $t7, 1 # index do nibble para cada byte
	li $t5, 0 # t5 é o registrador que armazenará o valor dos caracteres 
	read_byte:
		beq $t6, $t3, decrement_byte # checa se o byte atual é igual ao inválido. se for igual, decrementa o byte
		bne $t7, $t4, decrement_nibble # checa se o nibble atual é igual ao nibble desejado. se não for, decrementa o nibble.
		
		sll $t9, $t6, 3 # multiplica o byte por 8 para transformar em quantidade bits
		srlv $t8, $t2, $t9 # faz um shift right para pegar o byte desejado com base no index de t6
		sll $t9, $t7, 2 # multiplica o nibble por 4 para transformar em quantidade de bits
		srlv $t8, $t8, $t9 # faz um shift right para pegar o nibble desejado com base no index de t7
		
		sll $t5, $t5, 4 # move a word 4 bits para esquerda para armazenar o novo nibble
		andi $t8, $t8, 0xF # faz um and bit a bit para pegar o valor apenas do nibble desejado
		or $t5, $t5, $t8 # faz um or bit a bit para adicionar o novo algarismo hexadecimal na word 
		
		j decrement_nibble # decrementa o nibble
		
	decrement_nibble:
		beq $t7, 0, decrement_byte # se o nibble for 0, decremetenta o index do byte
		subi $t7, $t7, 1 # decrementa o index do nibble
		
		j read_byte # volta para o início do loop
	decrement_byte:
		beq $t6, 0, end_word # se o byte for 0, então acabou a word
		subi $t6, $t6, 1 # decrementa o index do byte
		li $t7, 1 # carrega o valor do index 1 para o nibble, já que passou para o próximo byte
		
		j read_byte # volta para o início do loop
	
	end_word:
	
	move $a0, $t5 # carrega a word em a0
	syscall # syscall para printar a word
	
	subi $t1, $t1, 1 # decrementa a quantidade de caracteres restantes
	addi $t0, $t0, 4 # move o endereço de t0 em 4 para a próxima word
	bne $t1, 0, read_loop # enquanto não chegar em 0 o contador de word, volta para o loop de ler as words
	
# Exit()
li $v0, 10
syscall
