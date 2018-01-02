%{
#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <stack>
#include <string>

int SAME_INSTRUCTION = 0;
int block_count = 0;
int repeat_count = 0;
int var_count = 0;

FILE * yyies = NULL;

std::stack<int> block_stack;
std::stack<int> repeat_stack;

int yylex();
int yyerror(const char *msg);
int EsteCorecta = 1;
char msg[500];
char types[4][10]={"boolean","float","int","string"};

void printStack(std::stack<std::string> stack)
{
	while (!stack.empty())
	{
		printf("Stack is");
		printf("%s\n", stack.top().c_str());
		stack.pop();
	}
}

class TVAR
{
	char* nume;
	int tip;
	int val_int;
	bool val_bool;
	float val_float;
	char* val_string;
	int is_init;
	TVAR* next;

public:
	static TVAR* head;
	static TVAR* tail;

	TVAR(char* n, int v = -1, float vf = -1, bool vb = false,  char* vs =NULL, int t = -1 );
	TVAR();
	int exists(char* n);
	void add(char* n, int type);
	void* getValue(char* n);
	int getType(char* n);
	int isInitialized(char* n);
	void setValue(char* n, int v);
	void setValue(char* n, float v);
	void setValue(char* n, bool v);
	void setValue(char* n, char* v);
};

TVAR* TVAR::head;
TVAR* TVAR::tail;

TVAR::TVAR(char* n, int v, float vf, bool vb, char* vs, int t)
{
	this->nume = new char[strlen(n) + 1];
	strcpy(this->nume, n);
	this->tip = t;
	this->val_int = v;
	this->val_float = vf;
	this->val_bool = vb;
	this->val_string = vs;
	this->next = NULL;
}

TVAR::TVAR()
{
	TVAR::head = NULL;
	TVAR::tail = NULL;
}

int TVAR::exists(char* n)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
			return 1;
		tmp = tmp->next;
	}
	return 0;
}

void TVAR::add(char* n, int type)
{
	TVAR* elem;
	if (type == 3)
	{
		elem = new TVAR(n, -1, 0, 0,NULL, 3);
	}
	if (type == 2)
	{
		elem = new TVAR(n, -1, 0, 0,NULL, 2);
	}
	if (type == 1)
	{
		elem = new TVAR(n, 0, -1.0, 0, NULL,1);
	}
	if (type == 0)
	{
		elem = new TVAR(n, 0, 0, false,NULL, 0);
	}
	
	elem->is_init = 0;
	
	if (head == NULL)
	{
		TVAR::head = TVAR::tail = elem;
	}
	else
	{
		TVAR::tail->next = elem;
		TVAR::tail = elem;
	}
}

void* TVAR::getValue(char* n)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			if (tmp->tip == 0)
			{
				return (void*)&(tmp->val_bool);
			}
			if (tmp->tip == 1)
			{
				return (void*)&(tmp->val_float);
			}
			if (tmp->tip == 2)
			{
				return (void*)&(tmp->val_int);
			}
			if (tmp->tip == 3)
			{
				return (void*)&(tmp->val_string);
			}

		}
		tmp = tmp->next;
	}
	return NULL;
}

int TVAR::getType(char* n)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			return tmp->tip;
		}
		tmp = tmp->next;
	}
	return NULL;
}

void TVAR::setValue(char* n, int v)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			tmp->val_int = v;
			tmp->tip = 2;
			tmp->is_init = 1;
		}
		tmp = tmp->next;
	}
}

void TVAR::setValue(char* n, float v)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			tmp->val_float = v;
			tmp->tip = 1;
			tmp->is_init = 1;
		}
		tmp = tmp->next;
	}
}

void TVAR::setValue(char* n, bool v)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			tmp->val_bool = v;
			tmp->tip = 0;
			tmp->is_init = 1;
		}
		tmp = tmp->next;
	}
}

void TVAR::setValue(char* n, char* v)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			tmp->val_string = new char[strlen(v)+1];
			strcpy(tmp->val_string, v);
			tmp->tip = 3;
			tmp->is_init = 1;
		}
		tmp = tmp->next;
	}
}

int TVAR::isInitialized(char* n)
{
	TVAR* tmp = TVAR::head;
	while (tmp != NULL)
	{
		if (strcmp(tmp->nume, n) == 0)
		{
			return tmp->is_init;
		}
		tmp = tmp->next;
	}
	return NULL;
}

TVAR* ts = NULL;
class GenericValue
{
	int tip;
	int val_int;
	bool val_bool;
	float val_float;
	char* val_string;
public:
	int is_variable;
	int is_in_eax;
	std::string var_name;
	GenericValue();
	void* getValue();
	int getType();
	void setValue(int v);
	void setValue(float v);
	void setValue(bool v);
	void setValue(char* v);
};

GenericValue::GenericValue()
{
	tip=-1;
	is_variable=0;
}

void* GenericValue::getValue()
{
	if (this->tip == 0)
	{
		return (void*)&(this->val_bool);
	}
	if (this->tip == 1)
	{
		return (void*)&(this->val_float);
	}
	if (this->tip == 2)
	{
		return (void*)&(this->val_int);
	}
	if (this->tip == 3)
	{
		return (void*)&(this->val_string);
	}
}

int GenericValue::getType()
{
	return this->tip;
}

void GenericValue::setValue(int v)
{
	this->val_int = v;
	this->tip = 2;
}

void GenericValue::setValue(float v)
{
	this->val_float = v;
	this->tip = 1;
}

void GenericValue::setValue(bool v)
{
	this->val_bool = v;
	this->tip = 0;
}

void GenericValue::setValue(char* v)
{
	this->val_string = new char[strlen(v) + 1];
	strcpy(this->val_string, v);
	this->tip = 3;
}
GenericValue* gv=new GenericValue();

%}


%union { char* name; bool val_bool;int val_int; float val_float; char* val_string; class GenericValue* val_generic;}

%token TOK_PROGRAM TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_NEQ TOK_EQU TOK_GTR TOK_LSS TOK_LEQ TOK_GEQ TOK_BEGIN TOK_END TOK_REPEAT TOK_UNTIL TOK_IF TOK_ELSE TOK_PRINT TOK_ERROR TOK_THEN ifx
%token <val_int> TOK_INT_VALUE
%token <val_float> TOK_FLOAT_VALUE
%token <val_bool> TOK_TRUE
%token <val_bool> TOK_FALSE
%token <val_string> TOK_STRING_VALUE
%token <val_int> TOK_DATA_TYPE
%token <name> TOK_VARIABLE

%type <val_generic> E_BFIS
%type <val_int> B
%type <val_int> BOOLE

%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%nonassoc ifx
%nonassoc TOK_ELSE

%%

S : 
    |
    TOK_PROGRAM TOK_VARIABLE B
    | 
    error ';' S
       { EsteCorecta = 0; }
    ;
B : {
	printf("\nBLOCK_%d:\n", ++block_count);
	block_stack.push(block_count);
	}
TOK_BEGIN INST TOK_END
    {
	printf("E_BLOCK_%d:\n\n", block_stack.top());
	block_stack.pop();
	}
	;
INST: 
	|
	{
	SAME_INSTRUCTION = 0;
	}
	I 
	{
	SAME_INSTRUCTION = 0;
	}';' INST
	;
I : IFDECL %prec ifx
{
	printf("BLOCK_%d:\n\n", ++block_count);
	block_count++;
}
	|
	IFDECL ELSEDECL %prec TOK_ELSE
	|
	{
	    repeat_count ++;
	    repeat_stack.push(block_count+1);
	}
	REPUNTIL
	{
	    printf("CMP EAX, EBX\n");
	    printf("LOOP BLOCK_%d\n", repeat_stack.top());
	    repeat_stack.pop();
	}
	|
	TOK_VARIABLE
	{
        SAME_INSTRUCTION = 0;	
	} '=' E_BFIS
	{
		if(ts != NULL)
		{
			if(ts->exists($1) == 1)
		  	{
		  		if(ts->getType($1)==$4->getType())
				{
					if(ts->getType($1)==0)
					{
						ts->setValue($1, *(bool*)$4->getValue());
					}
					if(ts->getType($1)==1)
					{
						ts->setValue($1, *(float*)$4->getValue());
					}
					if(ts->getType($1)==2)
					{
						ts->setValue($1, *(int*)$4->getValue());
						printf("MOV [%s], EAX\n", $1);
					}
					if(ts->getType($1)==3)
					{
						ts->setValue($1, *(char**)$4->getValue());
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabilei %s (de tip %s) nu i se poate atribui o valoare de tip %s", @1.first_line, @1.first_column, $1, types[ts->getType($1)], types[$4->getType()]);
					yyerror(msg);
					YYERROR;
				}					
		  	}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
			yyerror(msg);
			YYERROR;
		}
	}
	|
    TOK_DATA_TYPE TOK_VARIABLE '=' E_BFIS
    {
    SAME_INSTRUCTION = 0;
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2, $1);
	    
	    if($1==0)
	    {
	    	if($4->getType()==0)
			{
				ts->setValue($2, *(bool*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat bool!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==1)
	    {
	    	if($4->getType()==1)
			{
				ts->setValue($2, *(float*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat float!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==2)
	    {
	        printf("MOV [%s], EAX\n", $2);
	    	if($4->getType()==2)
			{
				ts->setValue($2, *(int*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat int!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==3)
	    {
	    	if($4->getType()==3)
			{
				ts->setValue($2, *(char**)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat string!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    SAME_INSTRUCTION = 0;
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  ts = new TVAR();
	  ts->add($2, $1);
	    if($1==0)
	    {
	    	if($4->getType()==0)
			{
				ts->setValue($2, *(bool*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat bool!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==1)
	    {
	    	if($4->getType()==1)
			{
				ts->setValue($2, *(float*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat float!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==2)
	    {
	    	if($4->getType()==2)
			{
			    printf("MOV [%s], EAX\n", $2);
				ts->setValue($2, *(int*)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat int!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	    if($1==3)
	    {
	    	if($4->getType()==3)
			{
				ts->setValue($2, *(char**)$4->getValue());
			}
			else
			{
				sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat string!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;  
			}
	    }
	}
    }
    |
    TOK_DATA_TYPE TOK_VARIABLE
    {
    if(ts != NULL)
    {
    	if(ts->exists($2)==1)
    	{
    		sprintf(msg,"%d:%d Variabila %s a fost declarata deja..", @1.first_line, @1.first_column, $2);
			yyerror(msg);
			YYERROR;  
    	}
    	else
    	{
    		ts->add($2, $1);
    	}
    }
    else
    {
    	ts = new TVAR();
    	ts->add($2, $1);
    }
    }
	|
    TOK_PRINT TOK_VARIABLE
    {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 1)
	  {
	    if(ts->isInitialized($2) == 0)
	    {
	      sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $2);
	      yyerror(msg);
	      YYERROR;
	    }
	    else
	    {
	    if(ts->getType($2)==3)
		{
			printf("It's a string! %s\n",*(char**)ts->getValue($2));
			fprintf(yyies, "\tmove\t$a0, $t0\n\tli\t$v0, 4\n\tsyscall\n");
			fprintf(yyies, "\tla\t$a0, new_line\n\tli\t$v0, 4\n\tsyscall\n");
		}
		if(ts->getType($2)==2)
		{
			printf("It's an int! %d\n",*(int*)ts->getValue($2));
			fprintf(yyies, "\tmove\t$a0, $t0\n\tli\t$v0, 1\n\tsyscall\n");
		}
		if(ts->getType($2)==1)
		{
			printf("It's a float! %g\n",*(float*)ts->getValue($2));
		}
		if(ts->getType($2)==0)
		{
			if(*(bool*)ts->getValue($2))
			printf("It's a bool! true\n");
			else
			printf("It's a bool! false\n");
		}
	    }
	  }
	  else
	  {
	    sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
	    yyerror(msg);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
	  yyerror(msg);
	  YYERROR;
	}
	
}
    ;
ELSEDECL:
    {
        printf("#ELSE\n");
		printf("JMP E_BLOCK_%d\n", block_count + 1);
	}
    TOK_ELSE B

    ;
IFDECL:	
	{
	    printf("#IF\n");
		//printf("CMP EAX, ECX\n");
	}
	TOK_IF TOK_LEFT BOOLE 
	{
	    if($4==0)// ==
	    {
	        printf("JNE BLOCK_%d \n",block_count+2);
	    }
	    if($4==1)// !=
	    {
	        printf("JE BLOCK_%d \n",block_count+2);
	    }
	    if($4==2)// <
	    {
	        printf("JGE BLOCK_%d \n",block_count+2);
	    }
	    if($4==3)// >
	    {
	        printf("JLE BLOCK_%d \n",block_count+2);
	    }
	    if($4==4)// <=
	    {
	        printf("JG BLOCK_%d \n",block_count+2);
	    }
	    if($4==5)// >=
	    {
	        printf("JL BLOCK_%d \n",block_count+2);
	    }
	}TOK_RIGHT TOK_THEN B
	;

BOOLE: 
    E_BFIS 
    {
        printf("MOV ECX, EAX\n");
    }
    TOK_EQU E_BFIS
	{
		if($1->getType()==$4->getType())
		{
			printf("CMP EAX, ECX\n");
		    $$ = 0;
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near ==", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	|
	E_BFIS 
	{
	    printf("MOV ECX, EAX\n");
	    SAME_INSTRUCTION = 0;
	}
	TOK_NEQ E_BFIS
	{
		if($1->getType()==$4->getType())
		{
            $$=1;
		    printf("CMP EAX, ECX\n");
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near !=", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	|
	E_BFIS
	{
	    printf("MOV ECX, EAX\n");
	} 
	TOK_GTR E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		    $$=3;
			printf("CMP ECX, EAX\n");
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near >", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	|
	E_BFIS
	{
	    printf("MOV ECX, EAX\n");
	} 
	 TOK_LSS E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		    $$ =2 ;
			printf("CMP ECX, EAX\n");
		    printf("JGE BLOCK_%d \n",block_count+2);
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near <", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	|
	E_BFIS
	{
	    printf("MOV ECX, EAX\n");
	} 
	  TOK_LEQ E_BFIS
	{
	if($1->getType()==$4->getType())
		{
		    $$ = 4;
			printf("CMP ECX, EAX\n");
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near <=", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	|
	E_BFIS
	{
	    printf("MOV ECX, EAX\n");
	} 
	TOK_GEQ E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		    $$ = 5;
			printf("CMP ECX, EAX\n");
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near >=", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
	;
REPUNTIL: TOK_REPEAT B TOK_UNTIL TOK_LEFT BOOLE TOK_RIGHT
	{
		printf("I repeat but I also protek\n");
	}
	;
E_BFIS: TOK_INT_VALUE
{
    $$ = new GenericValue();
    $$->setValue($1);
    if(!SAME_INSTRUCTION)
	{
			    	printf("MOV EAX, %d\n", $1);
	}
	SAME_INSTRUCTION++;
}

	|
	TOK_FLOAT_VALUE{$$ = new GenericValue();$$->setValue($1);}
	|
	TOK_STRING_VALUE{$$ = new GenericValue();$$->setValue($1);}
	|
	TOK_TRUE{$$ = new GenericValue();$$->setValue(true);}
	|
	TOK_FALSE{$$ = new GenericValue();$$->setValue(false);}
	|
	E_BFIS TOK_PLUS E_BFIS 
	{
		$$ = new GenericValue();
		if($1->getType()!=$3->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			if($1->getType()==2)
			{
				$$->setValue(*(int*)$1->getValue()+*(int*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
						printf("MOV EAX, [%s]\n", $1->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					printf("ADD EAX, [%s]\n", $3->var_name.c_str());
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						printf("ADD EAX, %d\n", *(int*)$3->getValue());
					}
					else
					{
						printf("ADD EAX, %d\n", *(int*)$1->getValue());
					}
				}
			}
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue()+*(float*)$3->getValue());
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_MINUS E_BFIS 
	{
		$$ = new GenericValue();
		if($1->getType()!=$3->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			if($1->getType()==2)
			{
				$$->setValue(*(int*)$1->getValue()-*(int*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
						printf("MOV EAX, [%s]\n", $1->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					printf("SUB EAX, [%s]\n", $3->var_name.c_str());
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						printf("SUB EAX, %d\n", *(int*)$3->getValue());
					}
					else
					{
						printf("!!SUB EAX, %d\n", *(int*)$3->getValue());
					}
					
				}
			}
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue()-*(float*)$3->getValue());
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_MULTIPLY E_BFIS
	{
		$$ = new GenericValue();
		if($1->getType()!=$3->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			if($1->getType()==2)
			{
				$$->setValue(*(int*)$1->getValue() * *(int*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
						if(var_count % 2 == 0)
						{
							printf("MOV EAX, EBX\n");
						}
						else
						{
							printf("MOV EAX, ECX\n");
						}
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
						if(var_count % 2 != 0)
						{
							printf("MUL EAX, EBX\n");
						}
						else
						{
							printf("MUL EAX, ECX\n");
						}
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						printf("MUL EAX, %d\n", *(int*)$3->getValue());
					}
					else
					{
						printf("MUL EAX, %d\n", *(int*)$1->getValue());
					}
				}
			}
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue() * *(float*)$3->getValue());
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_DIVIDE E_BFIS 
	{
		$$ = new GenericValue();
		if($3->getType()!=1 && $3->getType()!=2)
		{
			sprintf(msg,"%d:%d Did you just tried to divide by a %s", @1.first_line, @1.first_column, types[$3->getType()]);
	  		yyerror(msg);
	  		YYERROR;
		}
		if($1->getType()!=$3->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			if($1->getType()==2)
			{
				if(*(int*)$3->getValue() != 0)
				{
					$$->setValue(*(int*)$1->getValue() / *(int*)$3->getValue());
					if(SAME_INSTRUCTION == 0)
					{
						if($1->is_variable==1)
						{
							if(var_count % 2 == 0)
							{
								printf("MOV EAX, EBX\n");
							}
							else
							{
								printf("MOV EAX, ECX\n");
							}
						}
						else
						{
							printf("MOV EAX, %d\n", *(int*)$1->getValue());
						}
						SAME_INSTRUCTION = 1;
					}
					if($3->is_variable==1)
					{
						if(var_count % 2 != 0)
						{
							printf("DIV EAX, EBX\n");
						}
						else
						{
							printf("DIV EAX, ECX\n");
						}
					}
					else
					{
						if($3->is_in_eax!=1)
						{
							printf("DIV EAX, %d\n", *(int*)$3->getValue());
						}
						else
						{
							printf("!!DIV EAX, %d\n", *(int*)$3->getValue());
						}
					}	
				}
				else
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", @1.first_line, @1.first_column);
	  				yyerror(msg);
	  				YYERROR;
				}
			}
			if($1->getType()==1)
			{
				if(*(float*)$3->getValue() != 0)
				{
					$$->setValue(*(float*)$1->getValue() / *(float*)$3->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", @1.first_line, @1.first_column);
	  				yyerror(msg);
	  				YYERROR;
				}
			}
			$$->is_in_eax=1;
			
		}
	}
	|
	TOK_LEFT E_BFIS TOK_RIGHT
	{
		$$ = new GenericValue();
		if($2->getType()==0)
		{
			$$->setValue(*(bool*)$2->getValue());
		}
		if($2->getType()==1)
		{
			$$->setValue(*(float*)$2->getValue());
		}
		if($2->getType()==2)
		{
			$$->setValue(*(int*)$2->getValue());
		}
		if($2->getType()==3)
		{
			$$->setValue(*(char**)$2->getValue());
		}
		
	}
	|
	TOK_VARIABLE
	{
		if(ts != NULL)
		{
		if(ts->exists($1) == 1)
			{
				$$=new GenericValue();
				if(ts->getType($1)==0)
				{
					$$->setValue(*(bool*)ts->getValue($1));
				}
				if(ts->getType($1)==1)
				{
					$$->setValue(*(float*)ts->getValue($1));
				}
				if(ts->getType($1)==2)
				{
					$$->setValue(*(int*)ts->getValue($1));
				}
				if(ts->getType($1)==3)
				{
					$$->setValue(*(char**)ts->getValue($1));
				}
				$$->is_variable=1;
				$$->var_name = $1;
				if(!SAME_INSTRUCTION)
				{
			    	printf("MOV EAX, [%s]\n", $1);
			    }
			    SAME_INSTRUCTION++;
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
		  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
		  yyerror(msg);
		  YYERROR;
		}
	}
    ;

%%

int main()
{
	yyies = fopen("runme.s","w");
	fprintf(yyies, "\t.text\n\t.globl main\nmain:\n");
	
	yyparse();
	
	fclose(yyies);
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	
	return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
