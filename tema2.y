%{
	#include <stdio.h>
	#include <string.h>
	#include <cstdlib>
	#include <stack>
	#include <string>

	int SINGLE_EXPRESSION = 1;
	int SAME_INSTRUCTION = 0;
	int block_count = 0;
	int repeat_count = 0;
	int var_count = 0;
	int string_count = 0;

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
		void printall();
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
		return 0;
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
		return 0;
	}

	void TVAR::printall()
	{
		TVAR* tmp = TVAR::head;
		while (tmp != NULL)
		{
			fprintf(yyies, "%s:\t\t\t", tmp->nume);
			if(tmp->tip == 1)
			{
			    fprintf(yyies, ".float 0.0\n");
			}
			if(tmp->tip == 2)
			{
			    fprintf(yyies, ".word 0\n");
			}
			if(tmp->tip == 3)
			{
			    fprintf(yyies, ".asciiz %s\n", tmp->val_string);
			}
			if(tmp->tip == 0)
			{
				fprintf(yyies, ".word 0\n");
			}
			tmp = tmp->next;
		}
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


	%nonassoc ifx
	%nonassoc TOK_ELSE

	%nonassoc uniexpr
	%nonassoc multiexpr

	%left TOK_VARIABLE
	%left TOK_PLUS TOK_MINUS
	%left TOK_MULTIPLY TOK_DIVIDE
%%

S : 
    |
    TOK_PROGRAM TOK_VARIABLE B
    | 
    error ';' S
	{ 
		EsteCorecta = 0; 
	}
    ;
B : 
	{
		printf("\nBLOCK_%d:\n", ++block_count);
	    fprintf(yyies, "BLOCK_%d:\n",block_count);
		block_stack.push(block_count);
	}
	TOK_BEGIN INST TOK_END
    {
		printf("E_BLOCK_%d:\n\n", block_stack.top());
		fprintf(yyies, "E_BLOCK_%d:\n",block_stack.top());
		block_stack.pop();
	}
	;
INST: 
	|
	{
	    SAME_INSTRUCTION = 0;
	    SINGLE_EXPRESSION = 1;
	}
	I 
	{
	    SAME_INSTRUCTION = 0;
	    SINGLE_EXPRESSION = 1;
	}
	';' INST
	|
	IFDECL %prec ifx
    {
	    printf("BLOCK_%d:\n\n", ++block_count);
        fprintf(yyies, "BLOCK_%d:\n",block_count);
	    block_count++;
    }
    INST
	|
	IFDECL ELSEDECL %prec TOK_ELSE INST
	;
I : 
	REPUNTIL
	|
	TOK_VARIABLE
	{
        SAME_INSTRUCTION = 0;
        SINGLE_EXPRESSION = 1;
	} 
	'=' E_BFIS
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
					    fprintf(yyies, "\tla\t$t4, %s\n", $1);			
						fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
					}
					if(ts->getType($1)==2)
					{
						ts->setValue($1, *(int*)$4->getValue());
						printf("MOV [%s], EAX\n", $1);
						fprintf(yyies, "\tsw\t$t0, %s\n", $1);
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
				    if(SINGLE_EXPRESSION)
		            {
		                if($4->is_variable)
		                {
		                    printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    printf("MOV EAX, %d\n", *(int*)$4->getValue());
		                    fprintf(yyies, "\tli\t$t0, %d\n", (int)*(bool*)$4->getValue());
		                }
		            }
				    printf("MOV [%s], EAX\n", $2);
		            fprintf(yyies, "\tsw\t$t0, %s\n", $2);
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
				    if(SINGLE_EXPRESSION)
		            {	            
		                if($4->is_variable)
		                {
		                    //printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    //printf("MOV EAX, %f\n", *(float*)$4->getValue());
		                    fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
		                }
		            }
				    fprintf(yyies, "\tla\t$t4, %s\n", $2);			
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
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
				    if(SINGLE_EXPRESSION)
		            {
		                if($4->is_variable)
		                {
		                    printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    printf("MOV EAX, %d\n", *(int*)$4->getValue());
		                    fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
		                }
		            }
				    printf("MOV [%s], EAX\n", $2);
		            fprintf(yyies, "\tsw\t$t0, %s\n", $2);
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
				    if(SINGLE_EXPRESSION)
		            {
		                if($4->is_variable)
		                {
		                    printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    printf("MOV EAX, %d\n", *(int*)$4->getValue());
		                    fprintf(yyies, "\tli\t$t0, %d\n", (bool)*(int*)$4->getValue());
		                }
		            }
				    printf("MOV [%s], EAX\n", $2);
				    fprintf(yyies, "\tsw\t$t0, %s\n", $2);
					ts->setValue($2, (bool)*(int*)$4->getValue());
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
				    if(SINGLE_EXPRESSION)
		            {	            
		                if($4->is_variable)
		                {
		                    //printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    //printf("MOV EAX, %f\n", *(float*)$4->getValue());
		                    fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
		                }
		            }
				    fprintf(yyies, "\tla\t$t4, %s\n", $2);			
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
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
				    if(SINGLE_EXPRESSION)
		            {
		                if($4->is_variable)
		                {
		                    printf("MOV EAX, [%s]\n", $4->var_name.c_str());
		                    fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
		                }
		                else
		                {
		                    printf("MOV EAX, %d\n", *(int*)$4->getValue());
		                    fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
		                }
		            }
				    printf("MOV [%s], EAX\n", $2);
				    fprintf(yyies, "\tsw\t$t0, %s\n", $2);
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
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
			    }
			    if(ts->getType($2)==2)
			    {
				    printf("It's an int! %d\n",*(int*)ts->getValue($2));
				    fprintf(yyies, "\tsw\t$t0, %s\n", $2);
				    fprintf(yyies, "\tmove\t$a0, $t0\n\tli\t$v0, 1\n\tsyscall\n");
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
			    }
			    if(ts->getType($2)==1)
			    {
				    printf("It's a float! %g\n",*(float*)ts->getValue($2));
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
	    	        fprintf(yyies, "\tmov.s\t$f12, $f0\n\tli\t$v0, 2\n\tsyscall\n");
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
				    
			    }
			    if(ts->getType($2)==0)
			    {
				    if(*(bool*)ts->getValue($2))
				    {
					    printf("It's a bool! true\n");
					    fprintf(yyies, "\tla\t$a0, %s\n\tli\t$v0, 4\n\tsyscall\n", "true_value");
				    	fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
					}
				    else
				    {
				    	printf("It's a bool! false\n");
					    fprintf(yyies, "\tla\t$a0, %s\n\tli\t$v0, 4\n\tsyscall\n", "false_value");
				    	fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
				    }
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
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
	|
	TOK_PRINT TOK_STRING_VALUE
	{
	    char internal_name[50];
	    sprintf(internal_name, "cgs%d", string_count++);
	    if(ts==NULL)
	    {
	        ts=new TVAR();
	    }
	    ts->add(internal_name, 3);
	    ts->setValue(internal_name, $2);
	    fprintf(yyies, "\tla\t$a0, %s\n\tli\t$v0, 4\n\tsyscall\n", internal_name);
	    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
    }
    ;
ELSEDECL:
    {
        printf("#ELSE\n");
		printf("JMP E_BLOCK_%d\n", block_count + 1);
		fprintf(yyies, "\tb\tE_BLOCK_%d\n",block_count+1);
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
	        fprintf(yyies, "\tbne\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if($4==1)// !=
	    {
	        printf("JE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbeq\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if($4==2)// <
	    {
	        printf("JGE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbge\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if($4==3)// >
	    {
	        printf("JLE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tble\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if($4==4)// <=
	    {
	        printf("JG BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbgt\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if($4==5)// >=
	    {
	        printf("JL BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tblt\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }


	    if($4==10)// ==
	    {
	        printf("JNE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1f\t BLOCK_%d\n",block_count+2);
	    }
	    if($4==11)// !=
	    {
	        printf("JE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if($4==12)// <
	    {
	        printf("JGE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f0, $f2\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if($4==13)// >
	    {
	        printf("JLE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if($4==14)// <=
	    {
	        printf("JG BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.lt.s $f0, $f2\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if($4==15)// >=
	    {
	        printf("JL BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	}TOK_RIGHT TOK_THEN B
	;
BOOLE:
    E_BFIS 
    {
        if(SINGLE_EXPRESSION)
        {
	        if($1->getType() == 2)
		        {
		            if($1->is_variable)
		            {
		                printf("MOV EAX, [%s]\n", $1->var_name.c_str());
		                fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
		            }
		            else
		            {
		                printf("MOV EAX, %d\n", *(int*)$1->getValue());
		                fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
		            }
		        }
	    	if($1->getType() == 1)
		        {
		            if($1->is_variable)
		            {
		                fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
		            }
		            else
		            {
		                fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
		            }
		        }
	    }
        printf("MOV ECX, EAX\n");
        fprintf(yyies, "\tmove\t$t2, $t0\n");
        SAME_INSTRUCTION = 0;
        SINGLE_EXPRESSION = 1;
    }
    TOK_EQU E_BFIS
	{
	    
		if($4->getType()==$4->getType())
		{
		    if(SINGLE_EXPRESSION)
            {
                    if($4->getType() == 2)
	                    {
	                        if($4->is_variable)
	                        {
	                            printf("MOV EAX, [%s]\n", $4->var_name.c_str());
	                            fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            printf("MOV EAX, %d\n", *(int*)$4->getValue());
	                            fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
	                        }
	                        $$ = 0;
	                    }        
	                 if($4->getType() == 1)
	                    {
	                        if($4->is_variable)
	                        {
	                            fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
	                        }
	                        $$ = 10;
	                    }
	        }
		    printf("CMP ECX, EAX\n");		    
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near ==", @1.first_line, @1.first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		SINGLE_EXPRESSION = 1;
		SAME_INSTRUCTION = 0;
	}
	|
	E_BFIS 
	{
	    if(SINGLE_EXPRESSION)
        {
                if($1->getType() == 2)
	                {
	                    if($1->is_variable)
	                    {
	                        printf("MOV EAX, [%s]\n", $1->var_name.c_str());
	                        fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        printf("MOV EAX, %d\n", *(int*)$1->getValue());
	                        fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
	                    }
	                }        
	             if($1->getType() == 1)
	                {
	                    if($1->is_variable)
	                    {
	                        fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
	                    }
	                }
	    }
	    SINGLE_EXPRESSION = 1;
	    printf("MOV ECX, EAX\n");
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    SAME_INSTRUCTION = 0;
	}
	TOK_NEQ E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		     if(SINGLE_EXPRESSION)
                {
                        if($4->getType() == 2)
	                        {
	                            if($4->is_variable)
	                            {
	                                printf("MOV EAX, [%s]\n", $4->var_name.c_str());
	                                fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
	                            }
	                            else
	                            {
	                                printf("MOV EAX, %d\n", *(int*)$4->getValue());
	                                fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
	                            }
	                            $$=1;
	                        }        
	                     if($4->getType() == 1)
	                        {
	                            if($4->is_variable)
	                            {
	                                fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
	                            }
	                            else
	                            {
	                                fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
	                            }
	                            $$=11;
	                        }
	            }
		    printf("CMP ECX, EAX\n");
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
	    if(SINGLE_EXPRESSION)
        {
                if($1->getType() == 2)
	                {
	                    if($1->is_variable)
	                    {
	                        printf("MOV EAX, [%s]\n", $1->var_name.c_str());
	                        fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        printf("MOV EAX, %d\n", *(int*)$1->getValue());
	                        fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
	                    }
	                }        
	             if($1->getType() == 1)
	                {
	                    if($1->is_variable)
	                    {
	                        fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
	                    }
	                }
	    }
	    printf("MOV ECX, EAX\n");
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    	    SAME_INSTRUCTION = 0;
	} 
	TOK_GTR E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		     if(SINGLE_EXPRESSION)
            {
                    if($4->getType() == 2)
	                    {
	                        if($4->is_variable)
	                        {
	                            printf("MOV EAX, [%s]\n", $4->var_name.c_str());
	                            fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            printf("MOV EAX, %d\n", *(int*)$4->getValue());
	                            fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
	                        }
	                        $$ = 3;
	                    }        
	                 if($4->getType() == 1)
	                    {
	                        if($4->is_variable)
	                        {
	                            fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
	                        }
	                        $$ = 13;
	                    }
	        }
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
	    if(SINGLE_EXPRESSION)
        {
                if($1->getType() == 2)
	                {
	                    if($1->is_variable)
	                    {
	                        printf("MOV EAX, [%s]\n", $1->var_name.c_str());
	                        fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        printf("MOV EAX, %d\n", *(int*)$1->getValue());
	                        fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
	                    }
	                }        
	             if($1->getType() == 1)
	                {
	                    if($1->is_variable)
	                    {
	                        fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
	                    }
	                }
	    }
	    printf("MOV ECX, EAX\n");
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    	    SAME_INSTRUCTION = 0;
	} 
	 TOK_LSS E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		     if(SINGLE_EXPRESSION)
            {
                    if($4->getType() == 2)
	                    {
	                        if($4->is_variable)
	                        {
	                            printf("MOV EAX, [%s]\n", $4->var_name.c_str());
	                            fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            printf("MOV EAX, %d\n", *(int*)$4->getValue());
	                            fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
	                        }
	                        $$ =2 ;
	                    }        
	                 if($4->getType() == 1)
	                    {
	                        if($4->is_variable)
	                        {
	                            fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
	                        }
	                        $$ =12 ;
	                    }
	        }
		    
			printf("CMP ECX, EAX\n");
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
	    if(SINGLE_EXPRESSION)
        {
                if($1->getType() == 2)
	                {
	                    if($1->is_variable)
	                    {
	                        printf("MOV EAX, [%s]\n", $1->var_name.c_str());
	                        fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        printf("MOV EAX, %d\n", *(int*)$1->getValue());
	                        fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
	                    }
	                }        
	             if($1->getType() == 1)
	                {
	                    if($1->is_variable)
	                    {
	                        fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
	                    }
	                }
	    }
	    printf("MOV ECX, EAX\n");
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    	    SAME_INSTRUCTION = 0;
	} 
	TOK_LEQ E_BFIS
	{
		if($1->getType()==$4->getType())
		{
			if(SINGLE_EXPRESSION)
			{
				if($4->getType() == 2)
				{
					if($4->is_variable)
					{
						printf("MOV EAX, [%s]\n", $4->var_name.c_str());
						fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$4->getValue());
						fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
					}
					$$ = 4;
				}

				if($4->getType() == 1)
				{
					if($4->is_variable)
					{
					    fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
					}
					else
					{
					    fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
					}
					$$ = 14;
				}
			}
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
	    if(SINGLE_EXPRESSION)
        {
                if($1->getType() == 2)
	                {
	                    if($1->is_variable)
	                    {
	                        printf("MOV EAX, [%s]\n", $1->var_name.c_str());
	                        fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        printf("MOV EAX, %d\n", *(int*)$1->getValue());
	                        fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
	                    }
	                }        
	             if($1->getType() == 1)
	                {
	                    if($1->is_variable)
	                    {
	                        fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
	                    }
	                    else
	                    {
	                        fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
	                    }
	                }
	    }
	    printf("MOV ECX, EAX\n");
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    	    SAME_INSTRUCTION = 0;
	} 
	TOK_GEQ E_BFIS
	{
		if($1->getType()==$4->getType())
		{
		     if(SINGLE_EXPRESSION)
            {
                    if($4->getType() == 2)
	                    {
	                        if($4->is_variable)
	                        {
	                            printf("MOV EAX, [%s]\n", $4->var_name.c_str());
	                            fprintf(yyies, "\tlw\t$t0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            printf("MOV EAX, %d\n", *(int*)$4->getValue());
	                            fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$4->getValue());
	                        }
	                        $$ = 5;
	                    }        
	                 if($4->getType() == 1)
	                    {
	                        if($4->is_variable)
	                        {
	                            fprintf(yyies, "\tlwc1\t$f0, %s\n", $4->var_name.c_str());
	                        }
	                        else
	                        {
	                            fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$4->getValue());
	                        }
	                        $$ = 15;
	                    }
	        }	           
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
REPUNTIL: 
	{
		    repeat_count ++;
		    repeat_stack.push(block_count+1);
	}
	TOK_REPEAT B TOK_UNTIL TOK_LEFT BOOLE
	{
		    if($6==0)// ==
		    {
		        printf("JNE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbne\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if($6==1)// !=
		    {
		        printf("JE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbeq\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if($6==2)// <
		    {
		        printf("JGE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbge\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if($6==3)// >
		    {
		        printf("JLE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tble\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if($6==4)// <=
		    {
		        printf("JG BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbgt\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if($6==5)// >=
		    {
		        printf("JL BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tblt\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    repeat_stack.pop();
	} 
	TOK_RIGHT
	;
E_BFIS:	
	E_BFIS TOK_PLUS E_BFIS
	{
		printf("----Am pe stanga %s:%d + am pe dreapta %s:%d\n",$1->var_name.c_str(), *(int*)$1->getValue(), $3->var_name.c_str(), *(int*)$3->getValue());
	    SINGLE_EXPRESSION = 0;
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
						fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
						fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					printf("ADD EAX, [%s]\n", $3->var_name.c_str());
					fprintf(yyies, "\tlw\t$t1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tadd\t$t0, $t0, $t1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						printf("ADD EAX, %d\n", *(int*)$3->getValue());
						fprintf(yyies, "\taddi\t$t0, $t0, %d\n", *(int*)$3->getValue());
					}
					else
					{
					    if($1->is_variable ==1)
					    {
					        printf("ADD EAX, [%s]\n", $1->var_name.c_str());
					        fprintf(yyies, "\tlw\t$t1, %s\n", $1->var_name.c_str());
					        fprintf(yyies, "\tadd\t$t0, $t0, $t1\n");
					    }
					    else
					    {
						    printf("ADD EAX, %d\n", *(int*)$1->getValue());
    						fprintf(yyies, "\taddi\t$t0, $t0, %d\n", *(int*)$1->getValue());
    					}
					}
				}
			}
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue()+*(float*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
					  
						fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
					}
					else
					{
						fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					fprintf(yyies, "\tlwc1\t$f1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tadd.s\t$f0, $f0, $f1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$3->getValue());
						fprintf(yyies, "\tadd.s\t$f0, $f0, $f5\n");
					}
					else
					{
					    fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$1->getValue());
						fprintf(yyies, "\tadd.s\t$f0, $f0, $f5\n");
					}
				}
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_MINUS E_BFIS
	{
		printf("----Am pe stanga %s:%d - am pe dreapta %s:%d\n",$1->var_name.c_str(), *(int*)$1->getValue(), $3->var_name.c_str(), *(int*)$3->getValue());
		SINGLE_EXPRESSION = 0;
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
						fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
						fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					printf("SUB EAX, [%s]\n", $3->var_name.c_str());
					fprintf(yyies, "\tlw\t$t1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tsub\t$t0, $t0, $t1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						printf("SUB EAX, %d\n", *(int*)$3->getValue());
						fprintf(yyies, "\taddi\t$t0, $t0, -%d\n", *(int*)$3->getValue());
					}
					else
					{
					    if($1->is_variable ==1)
					    {
					        printf("SUB EAX, [%s]\n", $1->var_name.c_str());
					        fprintf(yyies, "\tlw\t$t1, %s\n", $1->var_name.c_str());
					        fprintf(yyies, "\tsub\t$t0, $t0, $t1\n");
					    }
					    else
					    {
						    printf("SUB EAX, %d\n", *(int*)$1->getValue());
    						fprintf(yyies, "\taddi\t$t0, $t0, -%d\n", *(int*)$1->getValue());
    					}
					}
					
				}
			}
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue() - *(float*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
					  
						fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
					}
					else
					{
						fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					fprintf(yyies, "\tlwc1\t$f1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tsub.s\t$f0, $f0, $f1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$3->getValue());
						fprintf(yyies, "\tsub.s\t$f0, $f0, $f5\n");
					}
					else
					{
					    fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$1->getValue());
						fprintf(yyies, "\tsub.s\t$f0, $f0, $f5\n");
					}
				}
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_MULTIPLY E_BFIS
	{
		printf("----Am pe stanga %s:%d * am pe dreapta %s:%d\n",$1->var_name.c_str(), *(int*)$1->getValue(), $3->var_name.c_str(), *(int*)$3->getValue());
		SINGLE_EXPRESSION = 0;
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
						printf("MOV EAX, [%s]\n", $1->var_name.c_str());
						fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
					}
					else
					{
						printf("MOV EAX, %d\n", *(int*)$1->getValue());
						fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					printf("MUL EAX, [%s]\n", $3->var_name.c_str());
					fprintf(yyies, "\tlw\t$t1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tmult\t$t0, $t1\n");
					fprintf(yyies, "\tmflo\t$t0\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{					
						printf("MUL EAX, %d\n", *(int*)$3->getValue());
						fprintf(yyies, "\tli\t$t1, %d\n", *(int*)$3->getValue());
						fprintf(yyies, "\tmult\t$t0, $t1\n");
						fprintf(yyies, "\tmflo\t$t0\n");
					}
					else
					{
					    if($1->is_variable ==1)
					    {
					        printf("MUL EAX, [%s]\n", $1->var_name.c_str());
					        fprintf(yyies, "\tlw\t$t1, %s\n", $1->var_name.c_str());
					        fprintf(yyies, "\tmult\t$t0, $t1\n");
        					fprintf(yyies, "\tmflo\t$t0\n");
					    }
					    else
					    {
						    printf("MUL EAX, %d\n", *(int*)$1->getValue());
    						fprintf(yyies, "\tli\t$t1, %d\n", *(int*)$1->getValue());
    						fprintf(yyies, "\tmult\t$t0, $t1\n");
        					fprintf(yyies, "\tmflo\t$t0\n");
    					}
					}
				}
			}
			
			if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue() * *(float*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
					  
						fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
					}
					else
					{
						fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					fprintf(yyies, "\tlwc1\t$f1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tmul.s\t$f0, $f0, $f1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$3->getValue());
						fprintf(yyies, "\tmul.s\t$f0, $f0, $f5\n");
					}
					else
					{
					    fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$1->getValue());
						fprintf(yyies, "\tmul.s\t$f0, $f0, $f5\n");
					}
				}
			}
			$$->is_in_eax=1;
		}
	}
    |
    E_BFIS TOK_DIVIDE E_BFIS
	{
		printf("----Am pe stanga %s:%d / am pe dreapta %s:%d\n",$1->var_name.c_str(), *(int*)$1->getValue(), $3->var_name.c_str(), *(int*)$3->getValue());
	    SINGLE_EXPRESSION = 0;
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
			if($3->getType()==2)
			{
				if(*(int*)$3->getValue() == 0)
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", @1.first_line, @1.first_column);
		  			yyerror(msg);
		  			YYERROR;
				}
			}
			if($3->getType()==1)
			{
				if(*(float*)$3->getValue() == 0)
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", @1.first_line, @1.first_column);
		  			yyerror(msg);
		  			YYERROR;
				}
			}
			if($1->getType()==2)
			{
			    $$->setValue(*(int*)$1->getValue() / *(int*)$3->getValue());
			    if(SAME_INSTRUCTION == 0)
			    {
				    if($1->is_variable==1)
				    {
					    printf("MOV EAX, [%s]\n", $1->var_name.c_str());
					    fprintf(yyies, "\tlw\t$t0, %s\n", $1->var_name.c_str());
				    }
				    else
				    {
					    printf("MOV EAX, %d\n", *(int*)$1->getValue());
					    fprintf(yyies, "\tli\t$t0, %d\n", *(int*)$1->getValue());
				    }
				    SAME_INSTRUCTION = 1;
			    }
				if($3->is_variable==1)
				{
				    printf("DIV EAX, [%s]\n", $3->var_name.c_str());
				    fprintf(yyies, "\tlw\t$t1, %s\n", $3->var_name.c_str());
				    fprintf(yyies, "\tdiv\t$t0, $t1\n");
				    fprintf(yyies, "\tmflo\t$t0\n");
				}
				else
				{
				    if($3->is_in_eax!=1)
				    {					
						    printf("DIV EAX, %d\n", *(int*)$3->getValue());
						    fprintf(yyies, "\tli\t$t1, %d\n", *(int*)$3->getValue());
						    fprintf(yyies, "\tdiv\t$t0, $t1\n");
						    fprintf(yyies, "\tmflo\t$t0\n");
				    }
				    else
				    {
					        if($1->is_variable ==1)
					        {
					            printf("DIV EAX, [%s]\n", $1->var_name.c_str());
					            fprintf(yyies, "\tlw\t$t1, %s\n", $1->var_name.c_str());
					            fprintf(yyies, "\tdiv\t$t0, $t1\n");
	            				fprintf(yyies, "\tmflo\t$t0\n");
					        }
					        else
					        {
						        printf("DIV EAX, %d\n", *(int*)$1->getValue());
	        					fprintf(yyies, "\tli\t$t1, %d\n", *(int*)$1->getValue());
	        					fprintf(yyies, "\tdiv\t$t0, $t1\n");
	            				fprintf(yyies, "\tmflo\t$t0\n");
	        				}
				    }
				}
			}
		    if($1->getType()==1)
			{
				$$->setValue(*(float*)$1->getValue() / *(float*)$3->getValue());
				if(SAME_INSTRUCTION == 0)
				{
					if($1->is_variable==1)
					{
					  
						fprintf(yyies, "\tlwc1\t$f0, %s\n", $1->var_name.c_str());
					}
					else
					{
						fprintf(yyies, "\tli.s\t$f0, %f\n", *(float*)$1->getValue());
					}
					SAME_INSTRUCTION = 1;
				}
				if($3->is_variable==1)
				{
					fprintf(yyies, "\tlwc1\t$f1, %s\n", $3->var_name.c_str());
					fprintf(yyies, "\tdiv.s\t$f0, $f0, $f1\n");
				}
				else
				{
					if($3->is_in_eax!=1)
					{
						fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$3->getValue());
						fprintf(yyies, "\tdiv.s\t$f0, $f0, $f5\n");
					}
					else
					{
					    fprintf(yyies, "\tli.s\t$f5, %f\n", *(float*)$1->getValue());
						fprintf(yyies, "\tdiv.s\t$f0, $f0, $f5\n");
					}
				}
			}
			$$->is_in_eax=1;
			}
		}
	|
	TOK_LEFT
	{
		printf("----Vad paranteza deschisa\n");
	}
	E_BFIS TOK_RIGHT
	{
		printf("----Vad paranteza inchisa\n");
	    SINGLE_EXPRESSION = 0;
		$$ = new GenericValue();
		if($3->getType()==0)
		{
			$$->setValue(*(bool*)$3->getValue());
		}
		if($3->getType()==1)
		{
			$$->setValue(*(float*)$3->getValue());
		}
		if($3->getType()==2)
		{
			$$->setValue(*(int*)$3->getValue());
		}
		if($3->getType()==3)
		{
			$$->setValue(*(char**)$3->getValue());
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
					if(!SAME_INSTRUCTION)
				    {
			        	fprintf(yyies, "\tlwc1\t$f0, %s\n", $1);
			        }
				}
				if(ts->getType($1)==2)
				{
					$$->setValue(*(int*)ts->getValue($1));
					if(!SAME_INSTRUCTION)
				    {
				        if(!SINGLE_EXPRESSION)
				        {
			        	    printf("MOV EAX, [%s]\n", $1);
			        	    fprintf(yyies, "\tlw\t$t0, %s\n", $1);
			        	}
			        }
				}
				if(ts->getType($1)==3)
				{
					$$->setValue(*(char**)ts->getValue($1));
				}
				$$->is_variable=1;
				$$->var_name = $1;
				
			    //SAME_INSTRUCTION++; //DANGEROUS BUG
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
	TOK_INT_VALUE
	{
	    $$ = new GenericValue();
	    $$->setValue($1);
	    if(!SAME_INSTRUCTION)  // dispara
		{
		    if(!SINGLE_EXPRESSION)
		    {
			    printf("MOV EAX, %d\n", $1);
			    fprintf(yyies, "\tli\t$t0, %d\n", $1);
			}
		}
		//SAME_INSTRUCTION++;
	}
	|
	TOK_FLOAT_VALUE
	{
		$$ = new GenericValue();
		$$->setValue($1);
		if(!SAME_INSTRUCTION)
		{
			fprintf(yyies, "\tli.s\t$f0, %f\n", $1);
		}
		//SAME_INSTRUCTION++;
	}
	|
	TOK_STRING_VALUE{$$ = new GenericValue();$$->setValue($1);}
	|
	TOK_TRUE{$$ = new GenericValue();$$->setValue(true);}
	|
	TOK_FALSE{$$ = new GenericValue();$$->setValue(false);}

    ;

%%

int main()
	{
		yyies = fopen("runme.s","w");
		fprintf(yyies, "\t.text\n\t.globl main\nmain:\n");
		
		yyparse();
		
		fprintf(yyies, "\tli\t$v0, 10\n\tsyscall\n"); // exit sequence
		fprintf(yyies, "\t.data\n");
		ts->printall();
		fprintf(yyies, "crlf:\t\t\t.asciiz \"\\n\"\n");
		fprintf(yyies, "true_value:\t\t.asciiz \"True\"\n");
		fprintf(yyies, "false_value:\t\t.asciiz \"False\"\n");
		fprintf(yyies, "\n");
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
