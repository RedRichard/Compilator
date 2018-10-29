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

char getNextAtomo(){
    // printf("\n%c\n", cadenaAtomos[atomIndex]);
    return cadenaAtomos[atomIndex++];
}

void error(){
    printf("\nHay un error en el atomo %d: %c\n\n", atomIndex, c);
    numErrSintacticos++;
}

int anSintactico(){
    c = getNextAtomo();
    // printf("\nchar actual: %c\n", c);
    G();
    if(numErrSintacticos == 0){
        printf("Fin");
        return 1;
    }
    else{
        return 0;
    }
}

void G(){
    if(c == '['){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        Z();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

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

void Y(){
    if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i'){
        S();
        X();
    }
    else{
        error();
    }
}

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

void D(){
    if(c == 'b' || c == 'c' || c == 'e' || c == 'd'){
        J();
        if(c == 'a'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
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

void J(){
    if(c == 'b'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'c'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'e'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'd'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else{
        error();
    }
}

void V(){
    if(c == ','){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == 'a'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        V();
    }
    else if(c == ';'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else{
        error();
    }
}

void S(){
    if(c == 'a'){
        A();
        if(c == ';'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
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

void A(){
    if(c == 'a'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '='){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
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

void H(){
    if(c == 'h'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '['){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == 'm'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == '('){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == ';'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

void M(){
    if(c == 'm'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '('){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

void P(){
    if(c == 'p'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '('){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        A();
        if(c == ';'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        R();
        if(c == ';'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        A();
        if(c == ')'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

void I(){
    if(c == 'i'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '('){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        if(c == '['){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
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

void N(){
    if(c == 'a' || c == 'h' || c == 'm' || c == 'p' || c == 'i' || c == ']' || c == 0){
        return;
    }
    else if(c == 'o'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        if(c == '['){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else{
        error();
    }
}

void K(){
    if(c == 's'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        E();
    }
    else if(c == 't'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'f'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
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

void O(){
    if(c == '!'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'q'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == '<'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'l'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == '>'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'g'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else{
        error();
    }
}

void E(){
    if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        T();
        EP();
    }
    else{
        error();
    }
}

void EP(){
    if(c == '+'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        T();
        EP();
    }
    else if(c == '-'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
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

void T(){
    if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        F();
        TP();
    }
    else{
        error();
    }
}

void TP(){
    if(c == '*'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        F();
        TP();
    }
    else if(c == '/'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        F();
        TP();
    }
    else if(c == '%'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
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

void F(){
    if(c == '('){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
        E();
        if(c == ')'){
            c = getNextAtomo();
            // printf("\nchar actual: %c\n", c);
        }
        else{
            error();
        }
    }
    else if(c == 'a'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'n'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
    }
    else if(c == 'r'){
        c = getNextAtomo();
        // printf("\nchar actual: %c\n", c);
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
