# ALUNO: Kiev Luiz Freitas Guedes
# Matrícula: 20220012740

.data

.align 2 # alinhando a memória por um fator de 4

vetor: .space 40 # criando um vetor com espaço reservado de 40 bytes (ou seja, 10 elementos de 4 bytes)

espaco: .asciiz " "
array: .asciiz "\nArray Ordenada: "

MAX: .word 10 # quantidade de elementos do vetor

.text

main:

la $s0, vetor # carregando o endereço do vetor em s0

lw $t7, MAX # carregando a word de MAX em t7

add $t1, $zero, $zero # inicializando t1 que é o índice do for Loop a seguir
add $t3, $zero, $zero # inicializando t3 que é o índice de leitura da memória 

Loop: 

add $t2, $t3, $s0 # carregando o próximo endereço de leitura da memória em t2

add $a0, $zero, $zero # limite inferior do número aleatório
addi $a1, $zero, 255 # limite superior do número aleatório
add $v0, $zero, 42 # 42 para gerar o número aleatório
syscall

sw $a0, 0($t2) # carreando o resultado do número aleatório em t2

addi $t1, $t1, 1 # próximo index
sll $t3, $t1, 2 # próximo index do endereço de memória (shift left de 4 bytes)

beq $t1, $t7, Exit # checa se já sorteou todos os números e manda pra Exit caso verdadeiro

j Loop # volta para o início do Loop

Exit:

la $a0, array # carrega o endereço da mensagem em a0
addi $v0, $zero, 4 # 4 para printar a mensagem
syscall

add $t1, $zero, $zero # inicializando o indice do for mais externo do bubble sort

Loop1:

add $t2, $zero, $zero # inicializando o indice do for mais interno do bubble sort
add $t4, $zero, $zero # inicializando o indice de leitura do vetor 

sub $t3, $t7, $t1 # indice de parada do for Loop2

Loop2:

add $t5, $t4, $s0 # atribuindo o endereço de leitura do primeiro valor a ser checado no bubblesort a t5
addi $t6, $t5, 4 # atribuindo o endereço de leitura do próximo valor de t5 a t6 para ser comparado com t5

lw $t8, 0($t5) # carregando o valor de t5 em t8
lw $t9, 0($t6) # carregando o valor de t6 em t9

bgt $t8, $t9, greater # checando de o valor mais a esquerda é maior que o da direita. caso positivo, ir para greater.

j else2 # se não, vai para else2

greater:

# troca a ordem dos elementos
sw $t9, 0($t5) 
sw $t8, 0($t6)

else2:

# atualiza os index
addi $t2, $t2, 1
sll $t4, $t2, 2

beq $t2, $t3, Exit2 # checa se já chegou na condição de parada

j Loop2 # se não, volta para o início do Loop2

Exit2:

addi $t1, $t1, 1 # atualiza o index do Loop mais externo

beq $t1, $t7, Exit1 # checa a condição de parada do Loop mais externo. caso positivo, vai para Exit1.

j Loop1 # se não, volta para o início do Loop1.

Exit1: 
# resta printar o vetor ordenado.

add $t1, $zero, $zero # inicializa em t1 o index do Loop3 para printar
add $t2, $zero, $zero # inicializa em t2 o index de leitura do vetor

Loop3:

add $t3, $t2, $s0 # carrega em t3 o endereço de s0 somado com o índice de leitura desejado

lw $a0, 0($t3) # carrega em a0 o valor presente no endereço de t3

addi $v0, $zero, 1 # printa o valor
syscall

la $a0, espaco
addi $v0, $zero, 4 # printa o espaço
syscall

addi $t1, $t1, 1 # atualiza o index do Loop3
sll $t2, $t1, 2 # atualiza o index de leitura do vetor

beq $t1, $t7, Exit3 # checa a condição de saída. caso favorável, vai para Exit3.

j Loop3 # se não, volta para o início do Loop3

Exit3: 

add $v0, $zero, 10 # finaliza o programa
syscall


