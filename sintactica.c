#include<stdio.h>

void G();
void Z();
void Y();
void X();
void D();
void J();
void V();
void S();
void A();
void H();
void M();
void P();
void I();
void N();
void K();
void R();
void Q();
void O();
void E();
void EP();
void T();
void TP();
void F();

// char* cadenaAtomos = "[ea;ca;a=n;i(a!n)[a=s;]]";
char c;
int atomIndex = 0;
int numErrSintacticos = 0;

//Funcion que regresa el siguiente atomo de la cadena de atomos:
char getNextAtomo(){
    return cadenaAtomos[atomIndex++];
}

//Funcion que regresa un mensaje de error indicando el atomo y ubicacion en la cadena de atomos:
void error(){
    printf("\nHay un error en el atomo %d: %c\n\n", atomIndex, c);
    numErrSintacticos++;
}

//Funcion con las instrucciones para realizar el analisis sintactico:
int anSintactico(){
    c = getNextAtomo();
    G();
    if(numErrSintacticos == 0){
        printf("Fin");
        return 1;
    }
    else{
        return 0;
    }
}

//Produccion G:
void G(){
    if(c == '['){
        c = getNextAtomo();    
        Z();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

//Produccion Z:
void Z(){
    if(c == 'b' || c == 'c' || c == 'e' || c == 'd'){
        D();
        Z();
    } 
    else if(c == ']' || c == 0){
        return;
    }
    else if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
        Y();
    }
    else{
        error();
    }
}

//Produccion Y:
void Y(){
    if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
        S();
        X();
    }
    else{
        error();
    }
}

//Produccion X:
void X(){
    if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
        Y();
    }
    else if(c == ']' || c == 0){
        return;
    }
    else{
        error();
    }
}

//Produccion D:
void D(){
    if(c == 'b' || c == 'c' || c == 'e' || c == 'd'){
        J();
        if(c == 'a'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        V();
    }
    else{
        error();
    }
}

//Produccion J:
void J(){
    if(c == 'b'){
        c = getNextAtomo();    
    }
    else if(c == 'c'){
        c = getNextAtomo();    
    }
    else if(c == 'e'){
        c = getNextAtomo();    
    }
    else if(c == 'd'){
        c = getNextAtomo();    
    }
    else{
        error();
    }
}

//Produccion V:
void V(){
    if(c == ','){
        c = getNextAtomo();    
        if(c == 'a'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        V();
    }
    else if(c == ';'){
        c = getNextAtomo();    
    }
    else{
        error();
    }
}

//Produccion S:
void S(){
    if(c == 'a'){
        A();
        if(c == ';'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else if(c == 'h'){
        H();
    }
    else if(c == 'm'){
        M();
    }
    else if(c == 'p'){
        P();
    }
    else if(c == 'i'){
        I();
    }
    else{
        error();
    }
}

//Produccion A:
void A(){
    if(c == 'a'){
        c = getNextAtomo();    
        if(c == '='){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        K();
    }
    else{
        error();
    }
}

//Produccion H:
void H(){
    if(c == 'h'){
        c = getNextAtomo();    
        if(c == '['){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == 'm'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == '('){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == ';'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

//Produccion M:
void M(){
    if(c == 'm'){
        c = getNextAtomo();    
        if(c == '('){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

//Produccion P:
void P(){
    if(c == 'p'){
        c = getNextAtomo();    
        if(c == '('){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        A();
        if(c == ';'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        R();
        if(c == ';'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        A();
        if(c == ')'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

//Produccion I:
void I(){
    if(c == 'i'){
        c = getNextAtomo();    
        if(c == '('){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        N();
    }
    else{
        error();
    }
}

//Produccion N:
void N(){
    if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i' || c == ']' || c == 0){
        return;
    }
    else if(c == 'o'){
        c = getNextAtomo();    
        if(c == '['){
            c = getNextAtomo();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

//Produccion K:
void K(){
    if(c == 's'){
        c = getNextAtomo();    
    }
    else if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        E();
    }
    else if(c == 't'){
        c = getNextAtomo();    
    }
    else if(c == 'f'){
        c = getNextAtomo();    
    }
    else{
        error();
    }
}

void R(){
    if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        E();
        Q();
    }
    else{
        error();
    }
}

//Produccion Q:
void Q(){
    if(c == '>' || c == '<' || c == 'q' || c == 'l' || c == 'g' || c == '!'){
        O();
        E();
    }
    else if(c == ')' || c == ';' || c == 0){
        return;
    }
    else{
        error();
    }
}

//Produccion O:
void O(){
    if(c == '!'){
        c = getNextAtomo();    
    }
    else if(c == 'q'){
        c = getNextAtomo();    
    }
    else if(c == '<'){
        c = getNextAtomo();    
    }
    else if(c == 'l'){
        c = getNextAtomo();    
    }
    else if(c == '>'){
        c = getNextAtomo();    
    }
    else if(c == 'g'){
        c = getNextAtomo();    
    }
    else{
        error();
    }
}

//Produccion E:
void E(){
    if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        T();
        EP();
    }
    else{
        error();
    }
}

//Produccion EP:
void EP(){
    if(c == '+'){
        c = getNextAtomo();    
        T();
        EP();
    }
    else if(c == '-'){
        c = getNextAtomo();    
        T();
        EP();
    }
    else if(c == '>' || c == '<' || c == 'q' || c == 'l' || c == 'g' || c == '!' || c == ')' || c == ';' || c == 0){
        return;
    }
    else{
        error();
    }
}

//Produccion T:
void T(){
    if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        F();
        TP();
    }
    else{
        error();
    }
}

//Produccion TP:
void TP(){
    if(c == '*'){
        c = getNextAtomo();    
        F();
        TP();
    }
    else if(c == '/'){
        c = getNextAtomo();    
        F();
        TP();
    }
    else if(c == '%'){
        c = getNextAtomo();    
        F();
        TP();
    }
    else if(c == '>' || c == '<' || c == 'q' || c == 'l' || c == 'g' || c == '!' || c == ')' || c == ';' || c == 0 || c == '+' || c == '-'){
        return;
    }
    else{
        error();
    }
}

//Produccion F:
void F(){
    if(c == '('){
        c = getNextAtomo();    
        E();
        if(c == ')'){
            c = getNextAtomo();        
        }
        else{
            error();
        }
    }
    else if(c == 'a'){
        c = getNextAtomo();    
    }
    else if(c == 'n'){
        c = getNextAtomo();    
    }
    else if(c == 'r'){
        c = getNextAtomo();    
    }
    else{
        error();
    }
}

// void main(){
//     do{
//         if(anSintactico() == 1){
//             printf("\nEs sintacticamente correcto.\n");
//         }
//     }while(c != '\0');
// }
