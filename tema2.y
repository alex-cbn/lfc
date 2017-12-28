%{
#include <stdio.h>
#include <string.h>
#include <cstdlib>

int yylex();
int yyerror(const char *msg);
int EsteCorecta = 1;
char msg[500];

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
%}


%union { char* name; bool val_bool;int val_int; float val_float; char* val_string;}

%token TOK_PROGRAM TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_NEQ TOK_EQU TOK_GTR TOK_LSS TOK_LEQ TOK_GEQ TOK_BEGIN TOK_END TOK_REPEAT TOK_UNTIL TOK_IF TOK_ELSE TOK_BOOL TOK_INT TOK_FLOAT TOK_STRING TOK_PRINT TOK_ERROR
%token <val_int> TOK_INT_VALUE
%token <val_float> TOK_FLOAT_VALUE
%token <val_bool> TOK_TRUE
%token <val_bool> TOK_FALSE
%token <val_string> TOK_STRING_VALUE
%token <name> TOK_VARIABLE

%type <val_int> E_I
%type <val_float> E_F
%type <val_bool> E_B
%type <val_string> E_S

%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : 
    |
    I ';' S
    | 
    error ';' S
       { EsteCorecta = 0; }
    ;
I : TOK_VARIABLE '=' E_I
{
	if(ts != NULL)
	{
		if(ts->exists($1) == 1)
	  	{
			if(ts->getType($1)==2)
			{
				ts->setValue($1, $3);
			}
	    	else
	    	{
	    		sprintf(msg,"%d:%d Eroare semantica: Variabilei %s nu i se poate atribui o valoare de tip int", @1.first_line, @1.first_column, $1);
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
	TOK_VARIABLE '=' E_F
    {
	if(ts != NULL)
	{
	  if(ts->exists($1) == 1)
	  {
	    if(ts->getType($1)==1)
		{
			ts->setValue($1, $3);
		}
	    else
	    {
	    	sprintf(msg,"%d:%d Eroare semantica: Variabilei %s nu i se poate atribui o valoare de tip float", @1.first_line, @1.first_column, $1);
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
	TOK_VARIABLE '=' E_B
    {
		if(ts != NULL)
		{
			if(ts->exists($1) == 1)
			{
				if(ts->getType($1)==0)
				{
					ts->setValue($1, $3);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabilei %s nu i se poate atribui o valoare de tip bool", @1.first_line, @1.first_column, $1);
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
	TOK_VARIABLE '=' E_S
    {
		if(ts != NULL)
		{
			if(ts->exists($1) == 1)
			{
				if(ts->getType($1)==3)
				{
					ts->setValue($1, $3);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabilei %s nu i se poate atribui o valoare de tip string", @1.first_line, @1.first_column, $1);
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
    TOK_INT TOK_VARIABLE
	{
		if(ts != NULL)
		{
	  		if(ts->exists($2) == 0)
	  		{
	    		ts->add($2, 2);
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
	  		ts->add($2, 2);
		}
      }
	|
    TOK_INT TOK_VARIABLE '=' E_I
    {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2, 2);
	    ts->setValue($2, $4);
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
	  ts->add($2, 2);
	  ts->setValue($2, $4);
	}
      }
	|
	TOK_FLOAT TOK_VARIABLE
      {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2, 1);
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
	  ts->add($2, 1);
	}
      }
	|
	TOK_BOOL TOK_VARIABLE
      {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2, 0);
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
	  ts->add($2, 0);
	}
      }
      |
	TOK_STRING TOK_VARIABLE
      {
	if(ts != NULL)
	{
	  if(ts->exists($2) == 0)
	  {
	    ts->add($2, 3);
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
	  ts->add($2, 3);
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
		}
		if(ts->getType($2)==2)
		{
			printf("It's an int! %d\n",*(int*)ts->getValue($2));
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
E_I : E_I TOK_PLUS E_I { $$ = $1 + $3; }
    |
    E_I TOK_MINUS E_I { $$ = $1 - $3; }
    |
    E_I TOK_MULTIPLY E_I { $$ = $1 * $3; }
    |
    E_I TOK_DIVIDE E_I 
	{ 
	  if($3 == 0) 
	  { 
	      sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(msg);
	      YYERROR;
	  } 
	  else { $$ = $1 / $3; } 
	}
    | 
    TOK_LEFT E_I TOK_RIGHT
    {
	$$ = $2;
    }
    |
    TOK_INT_VALUE { $$ = $1; }
    |
    TOK_VARIABLE 
	{
		if(ts != NULL)
		{
			if(ts->exists($1) == 1)
			{
				if(ts->getType($1)==2)
				{
					$$ = *(int*)ts->getValue($1);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s trebuie sa fie de tip int", @1.first_line, @1.first_column, $1);
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
    ;
E_F : E_F TOK_PLUS E_F { $$ = $1 + $3; }
    |
    E_F TOK_MINUS E_F { $$ = $1 - $3; }
    |
    E_F TOK_MULTIPLY E_F { $$ = $1 * $3; }
    |
    E_F TOK_DIVIDE E_F 
	{ 
	  if($3 == (float)0) 
	  { 
	      sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(msg);
	      YYERROR;
	  } 
	  else { $$ = $1 / $3; } 
	}
    | 
    TOK_LEFT E_F TOK_RIGHT
    {
	$$ = $2;
    }
    |
    TOK_FLOAT_VALUE { $$ = $1; }
    ;
E_B : TOK_LEFT E_B TOK_RIGHT
    {
	$$ = $2;
    }
    |
    TOK_TRUE { $$ = $1; }
	|
	TOK_FALSE { $$ = $1; }
    ;
E_S : TOK_STRING_VALUE
	{
		$$ = $1;
	}
    ;

%%

int main()
{
	yyparse();
	
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
