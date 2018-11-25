%{
/*
    Elaboro: Hernandez Gomez Ricardo
    Fecha: 30/10/2018
    Compiladores
    Grupo: 2
    Profesora: Saldoval Montaño Laura
*/
#include <stdlib.h>
#include <stdio.h>

//Prototipo de funciones utilizadas en el analisis previo a su declaracion:
char** inicializarArray();          
int busquedaLineal(char **tabla, char *objetivo, int tamanio);
void guardarError(char *error);

char* inicializarString();
char* agregarChar(char *cadena, char *caracter);
void agregarAtomo(char *caracter, char *valor);

//Declaraciones de variables globales para su uso a lo largo del programa:
FILE *archSal;          //Archivo de salida
FILE *archTraduccion;       //Archivo de salida de la traduccion
//Arreglos de cadenas para el almacenamiento de cada tipo de componente lexico:
char** palabrasReservadas;
char** atomosPalabrasReservadas;
char** identificadores;
char*  valoresIdentificadores;
char** operadoresRelacionales;
char** atomosOperadoresRelacionales;
char** traduccionOpRelacionales;
char** constantesCadena;
char** constantesNumerica;
char** constantesReal;
char** errores;
//Contadores de numero de elementos en cada arreglo de cadenas:

int numPalRes, numOpRel, numIdentificadores, numConsCadena, numConsNum, numConsReal, numErrores;
int lineCount = 1;          //Numero total de lineas en el archivo fuente

//Variables globales para analizador sintáctico
int numAtomos, numAtomOpRel, numAtomPalRes;
int atomIndex = 0;
int atomValueIndex = 0;
int numErrSintacticos = 0;
char *cadenaAtomos = "";
char *cadenaAtomosValores = "";
char atr;
char c;

//Prototipos de funciones utilizadas en el análisis sintáctico:
void G();
void Z();
void Y();
void X();
void D();
char J();
void V(char t);
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

int numValoresIdentificadores = 0;
//Prototipos de funciones para analizados semantico:
int numErroresSemanticos;
int numTradOpRel;
char getValorToken();
void asignaTipo(char t, char p);
char* getTipoIdent(char val);
void printTraduccion(int idClase, char **tabla, char valorToken);

%}

letMin      [a-z]
letMay      [A-Z]
palRes      {letMay}({letMin})*
ident       {letMin}({letMin}|{letMay}){0,7}
simEsp      [\(\[,;\)\]]
asig        :=
relac       .({letMay}){2,3}.
opArit      [+*/%\-]
cadena      (\").*(\")
dig         [0-9]
enteros     ({dig})+
reales      ({dig})*(\.({dig})*|(\.)?({dig})*([Ee][+-]?({dig})+)?)
comment      "$$".*
error       [^ \t(\r)(\n)(\r\n)]

%%
{palRes}    {
            // printf("Palabra reservada: %s de longitud %lu\n", yytext, yyleng);
            
            //Se realiza una busqueda lineal de la palabra reservada en el arreglo de palabras validas:
            int valor = busquedaLineal(palabrasReservadas, yytext, numPalRes);    
            //Si el resultado es mayor a 0, se realiza su guardado como token
            if(valor>=0){
                printf("\n\t0\t%d", valor);
                printf("\n\t-----------------");
                fprintf(archSal, "0,%d\n", valor);

                //Convertimos nuestro valor en una cadena para facilitar su uso:
                char auxCadena[12];
                sprintf(auxCadena, "%d", valor);

                //ETAPA DE ANALISIS SINTACTICO:
                agregarAtomo(atomosPalabrasReservadas[valor], auxCadena);
            }else{
                //Si no se guarda como error
                guardarError(yytext);
            }

            }

{ident}     {
            // printf("Identificador: %s\n", yytext);
            
            //ETAPA DE ANALISIS LEXICO:
            //Se realiza una busqueda del identificador para confirmar que no se ha agregado aun:
            int valor = busquedaLineal(identificadores, yytext, numIdentificadores);
            
            //Si la longitud es menor a 8 se guarda en la tabla de identificadores
            if(valor == -1){
                if(!identificadores){
                    identificadores = inicializarArray();   //Se inicializa el arreglo
                }
                // Se reserva espacio en la tabla que almacena los nombres de los identificadores
                identificadores[numIdentificadores] = malloc(yyleng*sizeof(char*)); //Asignamos espacio para cada linea
                strcpy(identificadores[numIdentificadores++], yytext); //Copiamos la linea en el arreglo
                identificadores = realloc(identificadores, (numIdentificadores+2)*sizeof(char**)); //Agregamos un espacio para otra linea
                valor = numIdentificadores-1;
            }
            //Guardamos el token
            fprintf(archSal, "1,%d\n", valor);
            printf("\n\t1\t%d", valor);
            printf("\n\t-----------------");

            //Convertimos nuestro valor en una cadena para facilitar su uso:
            char auxCadena[12];
            sprintf(auxCadena, "%d", valor);
        
            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("a", auxCadena);
            }

{simEsp}    {
            // printf("Simbolo especial: %s\n", yytext);

            //Identificado un simbolo especial, este se guarda con su caracter correspondiente como token:
            fprintf(archSal, "2,%s\n", yytext);
            printf("\n\t2\t%s", yytext);
            printf("\n\t-----------------");

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo(yytext, yytext);
            }

{asig}      {
            // printf("Operador asignacion: %s\n", yytext);

            //Identificado el operador de asignacion ':=', este se guarda como token con valor '=':
            fprintf(archSal, "3,=\n");
            printf("\n\t3\t=");
            printf("\n\t-----------------");

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("=", "=");
            }

{relac}     {
            // printf("Operador relacional: %s de longitud %lu\n", yytext, yyleng);

            //Se realiza una busqueda lineal del operador relacional para confirmar que es un operador valido:
            int valor = busquedaLineal(operadoresRelacionales, yytext, numOpRel);

            //Si se encontro se guarda como token
            if(valor>=0){
                fprintf(archSal, "4,%d\n", valor);
                printf("\n\t4\t%d", valor);
                printf("\n\t-----------------");

                //ETAPA DE ANALISIS SINTACTICO:
                agregarAtomo(atomosOperadoresRelacionales[valor], atomosOperadoresRelacionales[valor]);
            }else{
                //Si no se encontro se guarda como error
                guardarError(yytext);
            }


            }

{opArit}    {
            // printf("Operador aritmetico: %s\n", yytext);

            //Identificado un operador aritmetico, este se guarda con su caracter:
            fprintf(archSal, "5,%s\n", yytext);
            printf("\n\t5\t%s", yytext);
            printf("\n\t-----------------");

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo(yytext, yytext);
            }

{cadena}    {
            // printf("Cadena: %s\n", yytext);

            //Se realiza una busqueda lineal de la cadena para confirmar que esta no se ha guardado:
            int valor = busquedaLineal(constantesCadena, yytext, numConsCadena);

            //Si no existe, se agrega:
            if(valor == -1){
                if(!constantesCadena){
                    constantesCadena = inicializarArray();
                }
                constantesCadena[numConsCadena] = malloc(yyleng*sizeof(char*)); //Asignamos espacio para cada linea
                strcpy(constantesCadena[numConsCadena++], yytext); //Copiamos la linea en el arreglo
                constantesCadena = realloc(constantesCadena, (numConsCadena+2)*sizeof(char**)); //Agregamos un espacio para otralinea
                valor = numConsCadena - 1;
            }
            //Se guarda:
            fprintf(archSal, "6,%d\n", valor);
            printf("\n\t6\t%d", valor);
            printf("\n\t-----------------");

            //Convertimos nuestro valor en una cadena para facilitar su uso:
            char auxCadena[12];
            sprintf(auxCadena, "%d", valor);

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("s", auxCadena);
            }

{enteros}   {
            // printf("Entero: %s\n", yytext);

            //Se realiza una busqueda lineal del entero para confirmar que no se ha agregado:
            int valor = busquedaLineal(constantesNumerica, yytext, numConsNum);
            if(valor == -1){
                if(!constantesNumerica){
                    constantesNumerica = inicializarArray();
                }
                constantesNumerica[numConsNum] = malloc(yyleng*sizeof(char*)); //Asignamos espacio para cada linea
                strcpy(constantesNumerica[numConsNum++], yytext); //Copiamos la linea en el arreglo
                constantesNumerica = realloc(constantesNumerica, (numConsNum+2)*sizeof(char**)); //Agregamos un espacio para otralinea
                valor = numConsNum - 1;
            }
            //Se guarda:
            fprintf(archSal, "7,%d\n", valor);
            printf("\n\t7\t%d", valor);
            printf("\n\t-----------------");

            //Convertimos nuestro valor en una cadena para facilitar su uso:
            char auxCadena[12];
            sprintf(auxCadena, "%d", valor);

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("n", auxCadena);
            }

{reales}    {
            // printf("Real: %s\n", yytext);

            //Se realiza una busqueda lineal para confirmar que no se ha agregado:
            int valor = busquedaLineal(constantesReal, yytext, numConsReal);
            if(valor == -1){
                if(!constantesReal){
                    constantesReal = inicializarArray();
                }
                constantesReal[numConsReal] = malloc(yyleng*sizeof(char*)); //Asignamos espacio para cada linea
                strcpy(constantesReal[numConsReal++], yytext); //Copiamos la linea en el arreglo
                constantesReal = realloc(constantesReal, (numConsReal+2)*sizeof(char**)); //Agregamos un espacio para otralinea
                valor = numConsReal - 1;
            }
            //Se guarda:
            fprintf(archSal, "8,%d\n", valor);
            printf("\n\t8\t%d", valor);
            printf("\n\t-----------------");

            //Convertimos nuestro valor en una cadena para facilitar su uso:
            char auxCadena[12];
            sprintf(auxCadena, "%d", valor);

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("r", auxCadena);
            }

{comment}   {
            // printf("\n\t\tComentario: %s\n", yytext);
            }

\n          {
            lineCount++;        //Contador de lineas
            }

{error}     {
            guardarError(yytext);       //Detectado un error, se guarda
            }

%%

//ANALISIS LEXICO:

//Iniciar string:
char* inicializarString(){
    char *auxPointer = (char *) malloc(1 * sizeof(char));
    return auxPointer;
}

char* agregarChar(char *cadena, char *caracter){
    char *resultado = malloc(strlen(cadena) + strlen(caracter) + 1);
    strcpy(resultado, cadena);
    strcat(resultado, caracter);
    return resultado;
}

//Funcion para agregar un atomo a la cadena de atomos.
void agregarAtomo(char *caracter, char *valor){
    if(!cadenaAtomos){
        cadenaAtomos = inicializarString();
    }
    if(!cadenaAtomosValores){
        cadenaAtomosValores = inicializarString();
    }
    cadenaAtomos = agregarChar(cadenaAtomos, caracter);
    cadenaAtomosValores = agregarChar(cadenaAtomosValores, valor);
    numAtomos++;
}

//Busqueda lineal en cada arreglo de componentes lexicos:
int busquedaLineal(char **tabla, char *objetivo, int tamanio){
    for(int i=0; i<tamanio; i++){       //Se recorre todo el arreglo
        if(strcmp(tabla[i],objetivo) == 0){         //Si se encuentra
            return i;           //Se regresa el indice en el que se encuentra
        }
    }
    return -1;          //Si no se encuentra se regresa -1
}

//Funcion para inicializar un arreglo de cadenas, sin parametros:
char** inicializarArray(){
    char **auxPointer = malloc(1 * sizeof(char**));     //Se inicializa un apuntador a una posicion de memoria para los apuntadores
    return auxPointer;          //Se regresa el apuntador
}

//Funcion para guardar un error:
//Recibe como parametro la cadena del error.
void guardarError(char *error){
    //Se imprime el error en terminal:
    printf("\n\n Error %d en linea %d: %s\n\n", ++numErrores, lineCount, yytext);

    //Si el arreglo de errores no se ha inicializado se inicializa:
    if(!errores){
        errores = inicializarArray();
    }
    errores[numErrores-1] = malloc(strlen(error)*sizeof(char*)); //Asignamos espacio para cada linea
    strcpy(errores[numErrores-1], error); //Copiamos la linea en el arreglo
    errores = realloc(errores, (numErrores+1)*sizeof(char**)); //Agregamos un espacio para otra linea
            
}

//Funcion para llenar arreglo a partir de un archivo de texto:
char** populateArray(char *fileName, int *numero){
    //Esta funcion es utilizada para leer las palabras reservadas y operadores relacionales.
    FILE *fp;   //Variable para el archivo
    char *line = NULL;  //Variable para la linea
    size_t len = 0;    
    ssize_t read;   //Longitud de la linea
    int i = 0;
    char **auxPointer;  //Apuntador de cadenas auxiliar

    auxPointer = malloc(1 * sizeof(char**));    //Inicializamos el tamanio
    fp = fopen(fileName , "r");     //Abrimos el archivo
    while((read = getline(&line, &len, fp)) != -1){
        auxPointer[i] = malloc((read)*sizeof(char*)); //Asignamos espacio para cada linea
        //Eliminamos el salto de linea de la cadena:
        line[read-1] = 0;      
        line[read-2] = 0;
        strncpy(auxPointer[i++], line, read); //Copiamos la linea en el arreglo
        auxPointer = realloc(auxPointer, (i+2)*sizeof(char**)); //Agregamos un espacio para otra linea
        // i++;
    }
    *numero = i;
    fclose(fp);
    return auxPointer; //Finalmente regresamos el apuntador
}

//Funcion para generar archivos de salida a partir de una arreglo de cadenas:
//Recibe: nombre del archivo, arreglo, longitud del arreglo.
void generarArchivo(char *nomArchivo, char **tabla, int lenTabla){
    FILE *textFile;     //Variable del archivo
    textFile = fopen(nomArchivo, "w");      //Se abre el archivo con el nombre indicado
    for(int i=0; i<lenTabla; i++){
        fprintf(textFile, "%d %s\n", i, tabla[i]);      //Se guarda cada elemento del arreglo
    }
}

//Funcion para generar archivos de salida con nombres de columna:
void generarArchivoTS(char *nomArchivo, char **tabla, int lenTabla){
    FILE *textFile;     //Variable del archivo
    textFile = fopen(nomArchivo, "w");      //Se abre el archivo con el nombre indicado
    fprintf(textFile, "Posicion\tNombre\t\tTipo\n");
    for(int i=0; i<lenTabla; i++){
        fprintf(textFile, "%d\t\t\t%s\t\n", i, tabla[i]);      //Se guarda cada elemento del arreglo
    }
}

//Funcion para imprimir una tabla a partir de un arreglo de cadenas:
//Recibe: titulo de la tabla, arreglo, longitud del arreglo.
void printTabla(char *titulo, char **tabla, int numElementos){
    printf("\n\n---------------------------------------------------\n");
    printf("%s:\n", titulo);        //Se imprime el titulo
    
    for(int i=0; i<numElementos; i++){
        printf("\t%d\t%s\n", i, tabla[i]);      //Se imprime cada cadena guardada
    }    
}

//Funcion para imprimir la tabla de simbolos:
//Recibe: titulo de la tabla, arreglo, longitud del arreglo.
void printTablaTS(char *titulo, char **tabla, int numElementos){
    int i = 0;
    char tipoIdent[8];

    printf("\n\n---------------------------------------------------\n");
    printf("%s:\n", titulo);        //Se imprime el titulo
    
    for(i=0; i<(numValoresIdentificadores); i++){
            printf("Aqui");
            strcpy(tipoIdent, getTipoIdent(valoresIdentificadores[i]));
            printf("\t%d\t%s\t%s\n", i, tabla[i], tipoIdent);      //Se imprime cada cadena guardada
    }    
    for(i;i<(numElementos);i++){
        printf("\n\n\t -ERROR SEMANTICO: %s no declarado.\n\n", tabla[i]);      //Se imprime error si se detecta que una variable no se declaro
        numErroresSemanticos++;
    }
}

char* getTipoIdent(char val){
    switch(val){
        case 'b':
            return("Bul");
        case 'c':
            return("Cadena");
        case 'e':
            return("Entero");
        case 'd':
            return("Real");
        default:
            return(NULL);    
    }
}

//FUNCIONES PARA ANALISIS SINTACTICO:
//Funcion que regresa el siguiente atomo de la cadena de atomos:
char getNextAtomo(){
    return(cadenaAtomos[atomIndex++]);
}

//Funcion que regresa un mensaje de error indicando el atomo y ubicacion en la cadena de atomos:
void error(){
    if(c != 0){
        printf("\nHay un error en el atomo %d: %c\n\n", atomIndex, c);
    }
    numErrSintacticos++;
}

//Funcion con las instrucciones para realizar el analisis sintactico:
int anSintactico(){
    c = getNextAtomo();
    atr = getValorToken();
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
        printTraduccion(2, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        Z();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
    char t, p, p1, t1;
    if(c == 'b' || c == 'c' || c == 'e' || c == 'd'){
        t = J();
        if(c == 'a'){
            p = atr;
            printTraduccion(1, identificadores, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        t1 = t;
        p1 = p;
        asignaTipo(t1, p1);
        V(t);
    }
    else{
        error();
    }
}

//Produccion J:
char J(){
    char valor = c;
    if(c == 'b'){
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'c'){
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'e'){
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'd'){
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else{
        error();
    }
    return(valor);
}

//Produccion V:
void V(char t){
    char p, p1, t1;
    if(c == ','){
        printTraduccion(2, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == 'a'){
            printTraduccion(1, identificadores, atr);
            p = atr;
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        t1 = t;
        p1 = p;
        asignaTipo(t1, p1);
        V(t);
    }
    else if(c == ';'){
        printTraduccion(2, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
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
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(1, identificadores, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '='){
            printTraduccion(3, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '['){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == 'm'){
            printTraduccion(0, palabrasReservadas, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == '('){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == ';'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '('){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == '['){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '('){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        A();
        if(c == ';'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        R();
        if(c == ';'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        A();
        if(c == ')'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == '['){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '('){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        R();
        if(c == ')'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        if(c == '['){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        if(c == '['){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
        Y();
        if(c == ']'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
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
        printTraduccion(6, constantesCadena, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == '(' || c == 'a' || c == 'n' || c == 'r'){
        E();
    }
    else if(c == 't'){
        printTraduccion(0, palabrasReservadas, atr);
        printTraduccion(2, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'f'){
        printTraduccion(0, palabrasReservadas, atr);
        c = getNextAtomo();
        atr = getValorToken();    
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
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'q'){
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == '<'){
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'l'){
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == '>'){
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'g'){
        printTraduccion(4, traduccionOpRelacionales, atr);
        c = getNextAtomo();
        atr = getValorToken();    
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
        printTraduccion(5, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        T();
        EP();
    }
    else if(c == '-'){
        printTraduccion(5, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
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
        printTraduccion(5, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        F();
        TP();
    }
    else if(c == '/'){
        printTraduccion(5, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        F();
        TP();
    }
    else if(c == '%'){
        printTraduccion(5, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
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
        printTraduccion(2, NULL, atr);
        c = getNextAtomo();
        atr = getValorToken();    
        E();
        if(c == ')'){
            printTraduccion(2, NULL, atr);
            c = getNextAtomo();
            atr = getValorToken();        
        }
        else{
            error();
        }
    }
    else if(c == 'a'){
        printTraduccion(1, identificadores, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'n'){
        printTraduccion(7, constantesNumerica, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else if(c == 'r'){
        printTraduccion(8, constantesReal, atr);
        c = getNextAtomo();
        atr = getValorToken();    
    }
    else{
        error();
    }
}


void printTraduccion(int idClase, char **tabla, char valorToken){
    if (idClase != 2 && idClase != 3 && idClase != 5){
        int valToken = valorToken - '0';
        fprintf(archTraduccion, "%s ", tabla[valToken]);
    }
    else if(idClase == 3){
        fprintf(archTraduccion, ":= ");
    }
    else{
        fprintf(archTraduccion, "%c ", valorToken);
    }
}

char getValorToken(){
    return cadenaAtomosValores[atomValueIndex++];
}

void asignaTipo(char t, char p){
    int pInt = p - '0';
    if(!valoresIdentificadores[pInt]){
        valoresIdentificadores[pInt] = t;
        numValoresIdentificadores++;
    }else{
        printf("\n\n\t -ERROR SEMANTICO: %s declarado multiples veces.\n\n", identificadores[pInt]);
        numErroresSemanticos++;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
//ANALISIS SINTACTICO:
//Funcion que regresa el valor del Token:


//Funcion que asigna el tipo a la variable:


//Funcion que almacena cada etapa del analisis:
void analisis(char *argv[]){
    //Llenamos nuestro arreglo de palabras reservadas desde archivo
    palabrasReservadas = populateArray("palabrasReservadas.txt", &numPalRes);
    //Llenamos nuestro arreglo de atomos de palabras reservadas
    atomosPalabrasReservadas = populateArray("atomosPalabrasReservadas.txt", &numAtomPalRes);

    //Llenamos nuestro arreglo de palabras reservadas desde archivo
    operadoresRelacionales = populateArray("opRelacional.txt", &numOpRel);
    //LLenamos nuestros arreglo de atomos de operadores relacionales
    atomosOperadoresRelacionales = populateArray("atomosOpRelacional.txt", &numAtomOpRel);
    //Llenamos nuestro arreglo con las traducciones de los operadores relacionales
    traduccionOpRelacionales = populateArray("traduccionOpRelacional.txt", &numTradOpRel);

    //Formato:
    printf("----------------------------------------------------\n");
    printf("Tokens:\n");
    printf("----------------------------------------------------\n");
    printf("\tClase\tValor\n");
    printf("\t-----------------");

    yyin = fopen(argv[1],"r");          //Se abre el archivo de entrada
    archSal = fopen("Tokens.txt","w");      //Se abre el archivo de salida
    yylex();                            //Se realiza el analisis lexico
    fclose(archSal);                    //Se cierra el archivo de salida

    //Se impremen las tablas de elementos:
    printTabla("Tabla de cadenas", constantesCadena, numConsCadena);
    printTabla("Tabla de enteros", constantesNumerica, numConsNum);
    printTabla("Tabla de reales", constantesReal, numConsReal);

    //ANALISIS SINTACTICO-SEMANTICO:
    archTraduccion = fopen("Traduccion.txt", "w");
    valoresIdentificadores = (char *) calloc(numIdentificadores+1, sizeof(char));
    do{
        if(anSintactico() == 1){
            printf("\n\n----- Es sintacticamente correcto. -----\n\n");
        }
    }while(c != '\0');
    fclose(archTraduccion);

    //Cadena de atomos:
    printf("\nNumero de atomos: %d", numAtomos);
    printf("\n%s\n\n", cadenaAtomos);

    //Se realiza la impresion de los simbolos:
    printTablaTS("Tabla de simbolos", identificadores, numIdentificadores);
    if(numErroresSemanticos > 0){
        printf("\n\n---Se detectaron %d errores semanticos.---\n\n", numErroresSemanticos);
    }else{
        printf("\n\n----- Es semanticamente correcto. -----\n\n");
    }

    //Se realiza el guardado de cada tabla en archivo .txt:
    generarArchivoTS("Tabla de simbolos.txt", identificadores, numIdentificadores);
    generarArchivo("Constantes cadena.txt", constantesCadena, numConsCadena);
    generarArchivo("Constantes numericas.txt", constantesNumerica, numConsNum);
    generarArchivo("Constantes reales.txt", constantesReal, numConsReal);
    generarArchivo("Errores.txt", errores, numErrores);

    printf("\n");

}

//Funcion main para realizar la ejecucion:
int main(int argc, char*argv[])
{
    analisis(argv);
    return 0;
}