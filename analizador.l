%{
/*
    Programa 1: Analizador Léxico
    Elaboró: Hernández Gómez Ricardo
    Fecha: 23/09/2018
    Compiladores
    Grupo: 2
    Profesora: Saldoval Montaño Laura
*/
#include <stdlib.h>
#include <stdio.h>

char* cadenaAtomos = "";
#include "sintactica.c"

//Prototipo de funciones utilizadas en el analisis previo a su declaracion:
char** inicializarArray();          
int busquedaLineal(char **tabla, char *objetivo, int tamanio);
void guardarError(char *error);

char* inicializarString();
char* agregarChar(char *cadena, char *caracter);
void agregarAtomo(char *caracter);

//Declaraciones de variables globales para su uso a lo largo del programa:
FILE *archSal;          //Archivo de salida
//Arreglos de cadenas para el almacenamiento de cada tipo de componente lexico:
char** palabrasReservadas;
char** atomosPalabrasReservadas;
char** identificadores;
char** operadoresRelacionales;
char** atomosOperadoresRelacionales;
char** constantesCadena;
char** constantesNumerica;
char** constantesReal;
char** errores;
//Contadores de numero de elementos en cada arreglo de cadenas:
int numPalRes, numOpRel, numIdentficiadores, numConsCadena, numConsNum, numConsReal, numErrores;
int lineCount = 1;          //Numero total de lineas en el archivo fuente

//Variables globales para analizador sintáctico
int numAtomos, numAtomOpRel, numAtomPalRes;

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

                //ETAPA DE ANALISIS SINTACTICO:
                agregarAtomo(atomosPalabrasReservadas[valor]);
            }else{
                //Si no se guarda como error
                guardarError(yytext);
            }

            }

{ident}     {
            // printf("Identificador: %s\n", yytext);
            
            //ETAPA DE ANALISIS LEXICO:
            //Se realiza una busqueda del identificador para confirmar que no se ha agregado aun:
            int valor = busquedaLineal(identificadores, yytext, numIdentficiadores);
            
            //Si la longitud es menor a 8 se guarda en la tabla de identificadores
            if(valor == -1){
                if(!identificadores){
                    identificadores = inicializarArray();   //Se inicializa el arreglo
                }
                identificadores[numIdentficiadores] = malloc(yyleng*sizeof(char*)); //Asignamos espacio para cada linea
                strcpy(identificadores[numIdentficiadores++], yytext); //Copiamos la linea en el arreglo
                identificadores = realloc(identificadores, (numIdentficiadores+2)*sizeof(char**)); //Agregamos un espacio para otra linea
                valor = numIdentficiadores-1;
            }
            //Guardamos el token
            fprintf(archSal, "1,%d\n", valor);
            printf("\n\t1\t%d", valor);
            printf("\n\t-----------------");
        
            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("a");
            }

{simEsp}    {
            // printf("Simbolo especial: %s\n", yytext);

            //Identificado un simbolo especial, este se guarda con su caracter correspondiente como token:
            fprintf(archSal, "2,%s\n", yytext);
            printf("\n\t2\t%s", yytext);
            printf("\n\t-----------------");

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo(yytext);
            }

{asig}      {
            // printf("Operador asignacion: %s\n", yytext);

            //Identificado el operador de asignacion ':=', este se guarda como token con valor '=':
            fprintf(archSal, "3,%s\n", yytext);
            printf("\n\t3\t=");
            printf("\n\t-----------------");

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("=");
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
                agregarAtomo(atomosOperadoresRelacionales[valor]);
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
            agregarAtomo(yytext);
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

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("s");
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

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("n");
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

            //ETAPA DE ANALISIS SINTACTICO:
            agregarAtomo("r");
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
void agregarAtomo(char *caracter){
    if(!cadenaAtomos){
        cadenaAtomos = inicializarString();
    }
    cadenaAtomos = agregarChar(cadenaAtomos, caracter);
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

//Funcion que almacena cada etapa del analisis:
void analisis(char *argv[]){
    //Llenamos nuestro arreglo de palabras reservadas desde archivo
    palabrasReservadas = populateArray("palabrasReservadas.txt", &numPalRes);
    //Llenamos nuestro arreglo de atomos de palabras reservadas
    atomosPalabrasReservadas = populateArray("atomosPalabrasReservadas.txt", &numAtomPalRes);

     //Llenamos nuestro arreglo de palabras reservadas desde archivo
    operadoresRelacionales = populateArray("opRelacional.txt", &numOpRel);
    //Lenamos nuestros arreglo de atomos de operadores relacionales
    atomosOperadoresRelacionales = populateArray("atomosOpRelacional.txt", &numAtomOpRel);

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

    //Se realiza la impresion de cada una de las tablas:
    printTabla("Tabla de simbolos", identificadores, numIdentficiadores);
    printTabla("Tabla de cadenas", constantesCadena, numConsCadena);
    printTabla("Tabla de enteros", constantesNumerica, numConsNum);
    printTabla("Tabla de reales", constantesReal, numConsReal);

    //Se realiza el guardado de cada tabla en archivo .txt:
    generarArchivoTS("Tabla de simbolos.txt", identificadores, numIdentficiadores);
    generarArchivo("Constantes cadena.txt", constantesCadena, numConsCadena);
    generarArchivo("Constantes numericas.txt", constantesNumerica, numConsNum);
    generarArchivo("Constantes reales.txt", constantesReal, numConsReal);
    generarArchivo("Errores.txt", errores, numErrores);

    printf("\n");

    //Prubas analisis SINTACTICO
    // printf("Numero de identificadores: %d", numIdentficiadores);
        // printTabla("Tabla de atomos op relacional", atomosOperadoresRelacionales, numAtomOpRel);

    printf("\nNumero de atomos: %d", numAtomos);
    printf("\n%s\n\n", cadenaAtomos);

    //ANALISIS SINTACTICO:
    do{
        if(anSintactico() == 1){
            printf("\nEs sintacticamente correcto.\n");
        }
    }while(c != '\0');

}

//Funcion main para realizar la ejecucion:
int main(int argc, char*argv[])
{
    analisis(argv);
    return 0;
}