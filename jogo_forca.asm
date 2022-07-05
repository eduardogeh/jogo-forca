.eqv GERA_NUMERO_ALEATORIO 42
.eqv PRINTA 4
.eqv TERMINA_SUCESSO 10


.data

cabeca: .asciiz "O"
bracoeperna: .asciiz "/"
bracodperna: .asciiz "\\"
corpo: .asciiz "|"
espaco: .asciiz " "
quebralinha: .asciiz "\n"
msgboneco: .asciiz "Boneco:"

msg1: .asciiz "Tente uma letra: "
msg2: .asciiz "Perdeu a palavra era "
msg3: .asciiz "Ganhou"
msg4: .asciiz "Letras tentandas: "
msg5: .asciiz "tente uma letra: "
msg6: .asciiz "Quer jogar novamente?\n1 para sim\nqualquer outro caracter para não"
palavra: .asciiz  "louco    "
		 "comida   "
		 "gente    "
		 "terra    "
		 "gostar   "
		 "maluco   "
		 "comum    "
		 "doce     "
		 "salsicha "
		 "duradouro"
		 "fechadura"
		 "irmandade"
		 "carro    "
		 "lapela   "
		 "correia  "
		 "famoso   "
palavra_invisivel: .asciiz "---------"
chutado: .space 2
letras_chutadas: .asciiz "                  "


.text
	j inicio
#s0= erros, $s1= acertos, s2=localização da palavra escolhida s3= numero de letras s4=rodadas s5= reiniciador do jogo
inicio_again:
	jal renicia_palavra_invisivel
	jal renicia_letras_chutadas
inicio:
	jal sorteia_palavra
	add $s2, $v0, $zero #guarda a localizacao da palavra escolhida
	jal conta_letras
	add $s3, $v0 ,$zero #guarda o numero de letras
	jal ajeita_palavra_invisivel
	addi $s0, $zero, 0 #inicia erros
	addi $s1, $zero, 0 #inicia acertos
	addi $s4, $zero, 0 #inicia rodadas
	addi $s5, $zero, 0 #inicia reiniciador do jogo
main:
	jal imprime_palavra
	jal chute
	add $s1, $v0, $s1 #incrementa o acerto
	add $s0, $v1, $s0 #incrementa o erro
	jal imprime_boneco
	jal imprime_letras_ja_tentadas
	addi $s4, $s4, 1 #incrementa rodadas
	
condicao_principal:

	jal perdeu
	jal ganhou
	add $s5, $v0, $zero
	beq $s5, 1, inicio_again 
	j main #laço de repetição
	
renicia_palavra_invisivel:#t1= contador do for, t2= carrega o hifen
	addi $t1, $zero, 0
	addi $t2, $zero, 45
for_renicia_palavra:
	sb $t2, palavra_invisivel($t1)
	addi $t1, $t1, 1 #incrementa contador
	beq $t1, 9, volta_renicia_palavra
	j for_renicia_palavra
volta_renicia_palavra:
	jr $ra
	
renicia_letras_chutadas:#t1= contador, t2= representa o espaço
	addi $t1, $zero, 0
	addi $t2, $zero, 32
for_renicia_letras:
	sb $t2, letras_chutadas($t1)
	addi $t1, $t1, 1 #incrementa contador
	beq $t1, 17, volta_renicia_letras
	j for_renicia_letras
volta_renicia_letras:
	jr $ra
	
conta_letras: #t1= contador t3= carrega a letra $t2= numero de letras
	move $a0, $s2
	addi $t2, $zero, -1 #numero de letras
	
for_conta_letras:
	lb $t3, palavra($a0) #carrega a letra
	addi $a0, $a0, 1 #incrementa
	addi $t2, $t2, 1
	beq $t3, 0, volta_conta_letras
	beq $t3, 32, volta_conta_letras
	
	j for_conta_letras
volta_conta_letras:
	move $v0, $t2 #numero de letras
	jr $ra

ajeita_palavra_invisivel:

	add $a1, $zero, $s3 #carrega o numero de letras
	sb $zero, palavra_invisivel($a1) #posiciona um zero no lugar correto para fazer o \0

	jr $ra
	
sorteia_palavra:

	li $a1, 16  #seta o máximo
    	li $v0, GERA_NUMERO_ALEATORIO  #gera o numero aleatorio
    	syscall
    	
    	
    	
	add $t1, $zero, $a0 #passa o numero aleatorio para t1
	addi $t2, $zero, 10 #carrega o numero de letras 
	mult $t1, $t2
	
	mflo $t2 #move para t1 o resultado da multiplicação
	
	#li $v0 PRINTA #imprime palavra escolhida
    	#la $a0, palavra($t2)
    	#syscall para teste
    	move $v0, $t2 #passa para o retorno
    	jr $ra
    	
imprime_boneco:

	li $v0 PRINTA #imprime espaço
    	la $a0 quebralinha
    	syscall
    	
    	li $v0 PRINTA #imprime espaço
    	la $a0 msgboneco
    	syscall
	
	addi  $t1, $zero, 0 #carrega numero de erros
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime espaço
    	la $a0 quebralinha
    	syscall
	
	li $v0 PRINTA #imprime espaço
    	la $a0 espaco
    	syscall
	
	li $v0 PRINTA #imprime cabeça
    	la $a0 cabeca
    	syscall
	
	li $v0 PRINTA
    	la $a0 quebralinha
    	syscall
    	#####
	addi  $t1, $zero, 1
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime braco
    	la $a0 bracoeperna
    	syscall
	#####
	addi  $t1, $zero, 2
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime corpo
    	la $a0 corpo
    	syscall
	#####
	addi  $t1, $zero, 3
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime outro braco
    	la $a0 bracodperna
    	syscall
    	
    	li $v0 PRINTA
    	la $a0 quebralinha
    	syscall
	#####
	addi  $t1, $zero, 4
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime perna
    	la $a0 bracoeperna
    	syscall
	
	#####
	addi  $t1, $zero, 5
	ble   $s0, $t1, volta_imprime_boneco
	
	li $v0 PRINTA #imprime espaco
    	la $a0 espaco
    	syscall
	
	li $v0 PRINTA #imprime perna outra
    	la $a0 bracodperna
    	syscall
    	#####
    	
volta_imprime_boneco:
	jr $ra
	

imprime_palavra:
    	
    	li $v0 PRINTA #imprime quebra
    	la $a0 quebralinha
    	syscall
    	
    	li $v0 PRINTA #imprime palavra invisivel
    	la $a0 palavra_invisivel
    	syscall
    	
    	jr $ra

imprime_letras_ja_tentadas:

	li $v0 PRINTA #imprime quebra
    	la $a0 quebralinha
    	syscall
    	
	li $v0 PRINTA #imprime palavra letras ja tentadas
    	la $a0 msg4
    	syscall
    	
    	li $v0 PRINTA #imprime palavra invisivel
    	la $a0 letras_chutadas
    	syscall
    	
    	jr $ra

chute: # t0= letra chutada t1=contador a0= posicao da palavra escolhida que vai ser incremetado 
	#t3= carrega a letra, $v0= retorna acerto, $v1= retorna erro, t4 conta acertos, t5= conta erro
   	sub $sp, $sp, 4
   	sw $ra, 0($sp) #coloca na posicao a info do $ra
   	
   	li $v0 PRINTA
    	la $a0 quebralinha
    	syscall
    	
    	li $v0 PRINTA
    	la $a0 msg5
    	syscall
    	
   	li $v0 8
    	la $a0 chutado #le o char do usuario
    	la $a1 2
    	syscall
    	
    	lb $t0, chutado
    	move $a0, $s2
    	addi $t1, $zero, 0 #contador do for
    	addi $t4, $zero , 0 #zera os acertos
    	addi $t5, $zero, 0 #zera erros
for_chute:
	lb $t3, palavra($a0)
    	addi $a0, $a0, 1
    	addi $t1, $t1, 1
    	bne $t3, $t0, condicao_chute #vai para a condicao
    	jal chute_passou #chama funcao
    	addi $t4, $t4, 1  #indica que acertou
condicao_chute:

	bne $t1, $s3, for_chute #compara o contador com o numero de letras a serem testadas
	sb $t0, letras_chutadas($s4) #atualiza
	bne $t4, $zero, volta_chute
	addi $t5, $t5, 1
volta_chute:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $v0, $t4 #carrega o numero de acertos
	move $v1, $t5
	jr $ra


chute_passou:#a0= letra, a1=qual pos da letra
	
	sub $sp, $sp, 8
	sw $a0, 4($sp) #tem q ver o numero q vai aqui
	sw $a1, 0($sp)
	
	move $a1, $t1
	sub $a1, $a1, 1
	move $a0, $t0 #carrega a letra
	sb $a0, palavra_invisivel($a1)
	sb $a0, letras_chutadas($s4)
	
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	jr $ra

ganhou:

	beq $s1, $s3, ganhou_passou
	jr $ra
	
ganhou_passou:
	sub $sp, $sp, 4 
	sw $ra, 0($sp)
	
	jal imprime_palavra
	
	li $v0 PRINTA
    	la $a0 quebralinha
    	syscall
    	
    	li $v0 PRINTA #imprime mensagem de ganhou
    	la $a0 msg3
    	syscall
    	
    	jal jogar_novamente
    	
    	lw $ra, 0($sp)
	addi $sp, $sp, 4
    	jr $ra


perdeu:
	beq $s0, 7, perdeu_passou
	jr $ra
perdeu_passou:
	sub $sp, $sp, 4 
	sw $ra, 0($sp)
	
	li $v0 PRINTA
    	la $a0 quebralinha
    	syscall
    	
	li $v0 PRINTA #imprime mensagem de perdeu
    	la $a0 msg2
    	syscall
    	
    	li $v0 PRINTA #imprime mensagem de perdeu
    	la $a0 palavra($s2)
    	syscall
	
	jal jogar_novamente
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	

jogar_novamente:

	li $v0 PRINTA #imprime quebralinha
    	la $a0 quebralinha
    	syscall

	li $v0 PRINTA #imprime mensagem de jogar novamente
    	la $a0 msg6
    	syscall
    	
    	li $v0 PRINTA #imprime quebralinha
    	la $a0 quebralinha
    	syscall
    	
    	li $v0 8
    	la $a0 chutado #le o char do usuario
    	la $a1 2
    	syscall
    	
    	lb $t0, chutado
    	
    	beq $t0, 49, volta_jogar_novamente
    	
    	li $v0, TERMINA_SUCESSO           # Use system call 10 (exit)
	syscall
    	  
volta_jogar_novamente:
	addi $v0, $zero, 1
	jr $ra
	

#int main()
#{
#    
#    int erros=0;
#    bool achou;
#    int letras, ganhou=0;
#    scanf("%d", &letras);
#    char chute;
#    char palavra[letras];
#    char legenda[letras];
#    char letraschutadas[26];
#    int rodadas=0;
#    for(int i=0; i<letras;i++) legenda[i]='-';
#    scanf("%s", palavra);
#    printf("\e[1;1H\e[2J");
#    do{
#        printf("\nTente uma letra: ");
#        scanf(" %c", &chute);
#        letraschutadas[rodadas]= chute;
#        achou=false;
#        for(int i=0; i<letras;i++){
#            if(chute == palavra[i]){
#                legenda[i]=chute;
#                achou=true;
#                ganhou++;
#            }
#        }
#        if(!achou)
#        erros++;       
#        printf("\e[1;1H\e[2J");
#        if(erros > 0){
#            printf("  O\n");
#        }
#        if(erros > 1){
#            printf(" /");
#        }
#        if(erros > 2){
#            printf("|");
#        }
#        if(erros > 3){
#            printf("\\\n");
#        }else{
#            printf("\n");
#        }
#        if(erros > 4){
#            printf(" /");
#        }
#        if(erros > 5){
#            printf("\\\n");
#        }else{
#            printf("\n");
#        }
#        if(erros > 6){
#            printf("Perdeu");
#        }
#        
#        for(int i=0; i<letras; i++){
#            printf("%c ", legenda[i]);
#        }
#        printf("\n");
#        printf("Letras tentadas:");
#        for(int i=0; i<rodadas+1; i++){
#            printf("%c ", letraschutadas[i]);
#        }        
#        rodadas++;
#    }while(ganhou<letras && erros <6);
#    if(erros ==6){
#        printf("\nPerdeu!\nA palavra era: %s", palavra);
#    }else{
#        printf("\nParabens!\nGanhou em %d rodadas", rodadas);
#    }
#   
#    return 0;
#}


