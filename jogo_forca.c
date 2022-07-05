/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdbool.h>

int main()
{
    
    int erros=0;
    bool achou;
    int letras, ganhou=0;
    scanf("%d", &letras);
    char chute;
    char palavra[letras];
    char legenda[letras];
    char letraschutadas[26];
    int rodadas=0;
    for(int i=0; i<letras;i++) legenda[i]='-';
    scanf("%s", palavra);
    printf("\e[1;1H\e[2J");
    do{
        printf("\nTente uma letra: ");
        scanf(" %c", &chute);
        letraschutadas[rodadas]= chute;
        achou=false;
        for(int i=0; i<letras;i++){
            if(chute == palavra[i]){
                legenda[i]=chute;
                achou=true;
                ganhou++;
            }
        }
        if(!achou)
        erros++;
        
        printf("\e[1;1H\e[2J");
        if(erros > 0){
            printf("  O\n");
        }
        if(erros > 1){
            printf(" /");
        }
        if(erros > 2){
            printf("|");
        }
        if(erros > 3){
            printf("\\\n");
        }else{
            printf("\n");
        }
        if(erros > 4){
            printf(" /");
        }
        if(erros > 5){
            printf("\\\n");
        }else{
            printf("\n");
        }
        if(erros > 6){
            printf("Perdeu");
        }
        
        for(int i=0; i<letras; i++){
            printf("%c ", legenda[i]);
        }
        printf("\n");
        printf("Letras tentadas:");
        for(int i=0; i<rodadas+1; i++){
            printf("%c ", letraschutadas[i]);
        }
        
        rodadas++;
    }while(ganhou<letras && erros <6);
    if(erros ==6){
        printf("\nPerdeu!\nA palavra era: %s", palavra);
    }else{
        printf("\nParabens!\nGanhou em %d rodadas", rodadas);
    }
    
    return 0;
}


