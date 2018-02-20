
%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#define INDENT (4)
#undef input
int line = 1;
int column = 4;
int paren = 0;


extern int lookup(char *sym);

extern int insert(char *a,int token);

extern void init();

void indent();

void error();

void write_html_char(int c);


void write_html();

void write_sep();

void write_oct();

void write_hex();

// begin {}-block
void write_begin();

// end {}-block
void write_end();

// start opening paren
void write_open();

// close paren
void write_close();

void write_bopen();

void write_bclose();

void write_directive();

void write_keyword();

void write_int();

void write_char();

void write_string();

void write_comment();

void write_fp();

void write_id();

void write_op();

void write_inline();

%}

quote				'
ditto				\"
back				\\
digit				[0-9]
exp				[eE]([+-]{0,1})({digit}{1,})
hex				[0-9a-fA-F]
alpha				[a-zA-Z_]
ch 				[^\\'"\n]

%%

{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})*{ditto}	write_string();
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote}){quote}    	write_char();
0[0-7]+ 										write_oct();
0[xX]{hex}+ 										write_hex();
{digit}+ 										write_int();
{digit}*"."{digit}*{exp}{0,1} 								write_fp();
{alpha}({digit}|{alpha})*(" "|"\n")? 							write_id();
"{"											write_begin();
"}"											write_end();
"("											write_open();
")"											write_close();
"[" 											write_bopen();
"]" 											write_bclose();
";" 											write_sep();
"+"|"-"|"%"|"/"|"*"|"="|"+="|"-="|"/="|"*="|"=="|"!="|">="|"<="|"<"|">"|"||"|"&&"|"<<"|">>"|"|"|"&"|"~"|"^"|"."|"->"|"!"|"#"|"##"|":"|";"|"..."|"%="|"," 							write_op();
"/*" 											write_comment();
\/\/[^\n]*										write_inline();
#[^\n]* 										write_directive();
[ \n\t\v\n\r\f]										{}
{ch} 											error();

%%

void indent() { printf("\n%-*d", column, line++); }

void write_html_char(int c)
{ switch (c)
{ case '<': printf("&lt;"); break;
case '>': printf("&gt;"); break;
case '"': printf("&quot;"); break;
case '&': printf("&amp;"); break;
default:  putchar(c);
}}

void write_html() { char *s = yytext;
while (*s)
write_html_char(*s++);
}

void write_oct(){
printf("<font color='#00FFFF'><I>");
write_html();
printf("</I></font>");
}

void write_hex(){
printf("<font color='#00FFFF'><I>");
write_html();
printf("</I></font>");
}

void write_int(){
printf("<font color='#00FFFF'><I>");
write_html();
printf("</I></font>");
}


void write_sep()
{ write_html();
if (!paren)
indent();
else
putchar(' ');
}

void write_begin()
{ indent();
write_html();
column += INDENT;
indent();
}

void write_end()
{ column -= INDENT;
indent();
write_html();
indent();
}


void write_open()
{ write_html();
putchar(' ');
paren++; }

void write_comment()
{ char c, c1;
printf("<font color='#00FF00'>/*");
loop:
while ((c = input()) != '*' && c != 0)
write_html_char(c);
write_html_char('*');
if ((c1 = input()) != '/' && c != 0)
{ unput(c1);
goto loop; }
if (c != 0)
write_html_char(c1);
printf("</font>");
}

void write_close()
{ write_html();
putchar(' ');
paren--; }

void write_bopen(){
write_html();
}

void write_bclose(){
write_html();
}

void write_string(){
printf("<font color='#FF0000'>");
write_html();
printf("</font>");
}

void write_char(){
printf("<font color='#00FFFF'><U>");
write_html();
printf("</U></font>");
}

void error()
{exit(0);
}

void write_fp(){
printf("<font color='#00FFFF'>");
write_html();
printf("</font>");
}

void write_directive(){
printf("<font color='#FF00FF'><b>");
write_html();
printf("</b></font>");
indent();
}

void write_op(){
printf("<b>");
write_html();
printf("</b>");
}


void write_keyword(){
printf("<font color='#0000FF'><b>");
write_html();
printf("</font></b>");
}

void write_inline(){
printf("<font color='#00FF00'>");
write_html();
printf("</font>");
indent();
}

void write_id(){
char *s = yytext;
int marker = 0;
int ff;
 if(s[strlen(s)-1]==' ' | s[strlen(s)-1]=='\n'){
 s[strlen(s)-1]=0;
 marker = 1;
 }
 ff = lookup(s);
 if(ff == 0){
 printf("<font color='#0000FF'><b>");
 write_html();
 printf("</font></b>");
 if(marker == 1)
       putchar(' ');
 }

 else  if(ff == -1){
 insert(s,1);
 printf("<a name='%s'>",s);
 printf("<font color='#0000FF'>");
 write_html();
 printf("</font></a>");
 if(marker == 1)
       putchar(' ');
 }
 else{
 printf("<a href='#%s'>",s);
 printf("<font color='#0000FF'>");
 write_html();
 printf("</font></a>");
 if(marker == 1)
	putchar(' ');
 }
}

int main()
{/* printf("<html><pre>\n");
indent();
yylex();
printf("\n</pre></html>\n");
*/

init();
FILE *pt;
pt=freopen("out.html","w",stdout);
printf("<html><pre>\n");
indent();
yyin = fopen("./input.c","r");
	yylex();
	printf("\n</pre></html>\n");
	fclose(yyin);
fclose(pt);


return 0;
}
