#define MAXSYMBOLS 200
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct entry{
	char *lexptr;
	int token;
};

char* kw[] = {"auto","break","case","char","continue","default","do",
					"double","else","enum","extern","const","float","for","goto","if","int",
					"long","register","return","short","signed","sizeof","static",
					"struct","switch","typedef","union","unsigned","void","volatile",
					"while"}; 

struct entry symtable[MAXSYMBOLS+1];

void init(){
	int i=0;
	for(i = 0;i<=MAXSYMBOLS;i++){
		symtable[i].lexptr = malloc(100*sizeof(char));
		symtable[i].token = -1;
	}
	for(i = 0;i<32;i++){
		symtable[i].lexptr = kw[i];
		symtable[i].token = 0;
	}
}

int insert(char *a, int token){
	int i = 31;
	while(symtable[++i].token != -1);
	if(i >= MAXSYMBOLS){
		return -1;
	}
	else{
		strncpy(symtable[i].lexptr,a,strlen(a));
		symtable[i].token = token;
		return 0;
	}	
}

int lookup(char *sym){
	int i = 0;
	for(i = 0;i<MAXSYMBOLS;i++){
		if(strcmp(symtable[i].lexptr,sym)==0){
			return symtable[i].token;
		}
	}
	return -1;
}





