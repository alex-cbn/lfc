/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "tema2.y" /* yacc.c:339  */

	#include <string.h>
	#include <cstdlib>
	#include <cstdio>
	#include <stack>
	#include <string>
	#include <stdlib.h>
	#include <stdio.h>

	int SINGLE_EXPRESSION = 1;
	int SAME_INSTRUCTION = 0;
	int block_count = 0;
	int repeat_count = 0;
	int var_count = 0;
	int string_count = 0;

	int depth = -1;

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
		std::string correct_order;
		int depth;
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

#line 427 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_PROGRAM = 258,
    TOK_PLUS = 259,
    TOK_MINUS = 260,
    TOK_MULTIPLY = 261,
    TOK_DIVIDE = 262,
    TOK_LEFT = 263,
    TOK_RIGHT = 264,
    TOK_NEQ = 265,
    TOK_EQU = 266,
    TOK_GTR = 267,
    TOK_LSS = 268,
    TOK_LEQ = 269,
    TOK_GEQ = 270,
    TOK_BEGIN = 271,
    TOK_END = 272,
    TOK_REPEAT = 273,
    TOK_UNTIL = 274,
    TOK_IF = 275,
    TOK_ELSE = 276,
    TOK_PRINT = 277,
    TOK_ERROR = 278,
    TOK_THEN = 279,
    ifx = 280,
    TOK_INT_VALUE = 281,
    TOK_FLOAT_VALUE = 282,
    TOK_TRUE = 283,
    TOK_FALSE = 284,
    TOK_STRING_VALUE = 285,
    TOK_DATA_TYPE = 286,
    TOK_VARIABLE = 287,
    uniexpr = 288,
    multiexpr = 289
  };
#endif
/* Tokens.  */
#define TOK_PROGRAM 258
#define TOK_PLUS 259
#define TOK_MINUS 260
#define TOK_MULTIPLY 261
#define TOK_DIVIDE 262
#define TOK_LEFT 263
#define TOK_RIGHT 264
#define TOK_NEQ 265
#define TOK_EQU 266
#define TOK_GTR 267
#define TOK_LSS 268
#define TOK_LEQ 269
#define TOK_GEQ 270
#define TOK_BEGIN 271
#define TOK_END 272
#define TOK_REPEAT 273
#define TOK_UNTIL 274
#define TOK_IF 275
#define TOK_ELSE 276
#define TOK_PRINT 277
#define TOK_ERROR 278
#define TOK_THEN 279
#define ifx 280
#define TOK_INT_VALUE 281
#define TOK_FLOAT_VALUE 282
#define TOK_TRUE 283
#define TOK_FALSE 284
#define TOK_STRING_VALUE 285
#define TOK_DATA_TYPE 286
#define TOK_VARIABLE 287
#define uniexpr 288
#define multiexpr 289

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 362 "tema2.y" /* yacc.c:355  */
 char* name; bool val_bool;int val_int; float val_float; char* val_string; class GenericValue* val_generic;

#line 538 "y.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 569 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  6
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   82

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  37
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  27
/* YYNRULES -- Number of rules.  */
#define YYNRULES  52
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  91

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   289

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    35,
       2,    36,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   391,   391,   393,   395,   401,   401,   411,   413,   417,
     413,   423,   422,   430,   433,   436,   435,   489,   627,   649,
     717,   732,   732,   741,   746,   741,   819,   818,   846,   845,
     873,   872,   900,   899,   927,   926,   953,   952,   980,   985,
     980,  1058,  1095,  1132,  1170,  1227,  1226,  1251,  1297,  1306,
    1315,  1317,  1319
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TOK_PROGRAM", "TOK_PLUS", "TOK_MINUS",
  "TOK_MULTIPLY", "TOK_DIVIDE", "TOK_LEFT", "TOK_RIGHT", "TOK_NEQ",
  "TOK_EQU", "TOK_GTR", "TOK_LSS", "TOK_LEQ", "TOK_GEQ", "TOK_BEGIN",
  "TOK_END", "TOK_REPEAT", "TOK_UNTIL", "TOK_IF", "TOK_ELSE", "TOK_PRINT",
  "TOK_ERROR", "TOK_THEN", "ifx", "TOK_INT_VALUE", "TOK_FLOAT_VALUE",
  "TOK_TRUE", "TOK_FALSE", "TOK_STRING_VALUE", "TOK_DATA_TYPE",
  "TOK_VARIABLE", "uniexpr", "multiexpr", "';'", "'='", "$accept", "S",
  "B", "$@1", "INST", "$@2", "$@3", "$@4", "I", "$@5", "ELSEDECL", "$@6",
  "IFDECL", "$@7", "$@8", "BOOLE", "$@9", "$@10", "$@11", "$@12", "$@13",
  "$@14", "REPUNTIL", "$@15", "$@16", "E_BFIS", "$@17", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,    59,    61
};
# endif

#define YYPACT_NINF -36

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-36)))

#define YYTABLE_NINF -37

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
      57,   -23,   -14,    44,    57,   -36,   -36,   -36,   -36,    14,
      -3,    32,   -16,    31,    42,   -36,    29,    33,   -36,   -36,
     -36,    45,    -3,    -3,    43,    58,   -36,   -36,    34,    35,
      37,   -36,   -36,   -36,   -36,    -1,    -1,    -1,    -3,    48,
     -36,   -36,   -36,   -36,   -36,   -36,   -36,   -36,   -36,    41,
      28,    28,   -36,    60,    -1,    64,    -1,    -1,    -1,    -1,
      63,    59,    65,    62,    66,    61,    -1,     4,    54,    30,
      30,   -36,   -36,    -1,    -1,    -1,    -1,    -1,    -1,   -36,
     -36,   -36,    28,    28,    28,    28,    28,    28,    70,   -36,
     -36
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     5,     1,     4,     3,     0,
       8,     0,    38,    11,     0,     6,     0,     0,    15,     9,
      14,     0,     8,     8,     0,     0,    20,    19,    18,     0,
       0,     5,    12,    13,     5,     0,     0,     0,     8,     0,
      22,    45,    48,    49,    51,    52,    50,    47,    24,    26,
      17,    16,    10,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    41,
      42,    43,    44,     0,     0,     0,     0,     0,     0,    39,
      46,     5,    27,    29,    31,    33,    35,    37,     0,    25,
      40
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -36,    77,   -31,   -36,   -18,   -36,   -36,   -36,   -36,   -36,
     -36,   -36,   -36,   -36,   -36,    16,   -36,   -36,   -36,   -36,
     -36,   -36,   -36,   -36,   -36,   -35,   -36
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     3,     8,     9,    11,    12,    30,    22,    19,    29,
      23,    24,    13,    14,    55,    48,    60,    61,    62,    63,
      64,    65,    20,    21,    88,    49,    54
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      39,    50,    51,    40,    32,    33,    16,    41,    56,    57,
      58,    59,     4,    80,    -7,    17,    18,   -23,     5,    67,
      52,    69,    70,    71,    72,    42,    43,    44,    45,    46,
      10,    47,    56,    57,    58,    59,    58,    59,    82,    83,
      84,    85,    86,    87,     6,    56,    57,    58,    59,    15,
      89,   -28,   -21,   -30,   -32,   -34,   -36,    -2,     1,    26,
       2,    27,    25,    31,    34,    28,    35,    53,    66,    74,
      36,    37,    38,    68,    73,    76,    78,    75,    81,    90,
      77,     7,    79
};

static const yytype_uint8 yycheck[] =
{
      31,    36,    37,    34,    22,    23,    22,     8,     4,     5,
       6,     7,    35,     9,    17,    31,    32,    20,    32,    54,
      38,    56,    57,    58,    59,    26,    27,    28,    29,    30,
      16,    32,     4,     5,     6,     7,     6,     7,    73,    74,
      75,    76,    77,    78,     0,     4,     5,     6,     7,    17,
      81,    10,    21,    12,    13,    14,    15,     0,     1,    30,
       3,    32,    20,    18,    21,    32,     8,    19,     8,    10,
      36,    36,    35,     9,    11,    13,    15,    12,    24,     9,
      14,     4,    66
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     1,     3,    38,    35,    32,     0,    38,    39,    40,
      16,    41,    42,    49,    50,    17,    22,    31,    32,    45,
      59,    60,    44,    47,    48,    20,    30,    32,    32,    46,
      43,    18,    41,    41,    21,     8,    36,    36,    35,    39,
      39,     8,    26,    27,    28,    29,    30,    32,    52,    62,
      62,    62,    41,    19,    63,    51,     4,     5,     6,     7,
      53,    54,    55,    56,    57,    58,     8,    62,     9,    62,
      62,    62,    62,    11,    10,    12,    13,    14,    15,    52,
       9,    24,    62,    62,    62,    62,    62,    62,    61,    39,
       9
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    37,    38,    38,    38,    40,    39,    41,    42,    43,
      41,    44,    41,    41,    45,    46,    45,    45,    45,    45,
      45,    48,    47,    50,    51,    49,    53,    52,    54,    52,
      55,    52,    56,    52,    57,    52,    58,    52,    60,    61,
      59,    62,    62,    62,    62,    63,    62,    62,    62,    62,
      62,    62,    62
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     3,     3,     0,     4,     0,     0,     0,
       5,     0,     3,     3,     1,     0,     4,     4,     2,     2,
       2,     0,     3,     0,     0,     8,     0,     4,     0,     4,
       0,     4,     0,     4,     0,     4,     0,     4,     0,     0,
       8,     3,     3,     3,     3,     0,     4,     1,     1,     1,
       1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static unsigned
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  unsigned res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (yylocationp);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Location data for the lookahead symbol.  */
YYLTYPE yylloc
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yyls1, yysize * sizeof (*yylsp),
                    &yystacksize);

        yyls = yyls1;
        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
#line 396 "tema2.y" /* yacc.c:1646  */
    { 
		EsteCorecta = 0; 
	}
#line 1807 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 401 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "BLOCK_%d:\n",++block_count);
		block_stack.push(block_count);
	}
#line 1816 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 406 "tema2.y" /* yacc.c:1646  */
    {
		fprintf(yyies, "E_BLOCK_%d:\n",block_stack.top());
		block_stack.pop();
	}
#line 1825 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 413 "tema2.y" /* yacc.c:1646  */
    {
	    depth = -1;
	}
#line 1833 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 417 "tema2.y" /* yacc.c:1646  */
    {
	    depth = -1;
	}
#line 1841 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 423 "tema2.y" /* yacc.c:1646  */
    {
	    printf("BLOCK_%d:\n\n", ++block_count);
        fprintf(yyies, "BLOCK_%d:\n",block_count);
	    block_count++;
    }
#line 1851 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 436 "tema2.y" /* yacc.c:1646  */
    {
	}
#line 1858 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 439 "tema2.y" /* yacc.c:1646  */
    {
		if(ts != NULL)
		{
			if(ts->exists((yyvsp[-3].name)) == 1)
		  	{
		  		if(ts->getType((yyvsp[-3].name))==(yyvsp[0].val_generic)->getType())
				{
					if(ts->getType((yyvsp[-3].name))==0)
					{
						ts->setValue((yyvsp[-3].name), *(bool*)(yyvsp[0].val_generic)->getValue());
					}
					if(ts->getType((yyvsp[-3].name))==1)
					{
						ts->setValue((yyvsp[-3].name), *(float*)(yyvsp[0].val_generic)->getValue());
					    fprintf(yyies, "\tla\t$t4, %s\n", (yyvsp[-3].name));
						fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
					}
					if(ts->getType((yyvsp[-3].name))==2)
					{
						ts->setValue((yyvsp[-3].name), *(int*)(yyvsp[0].val_generic)->getValue());
						fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[-3].name));
					}
					if(ts->getType((yyvsp[-3].name))==3)
					{
						ts->setValue((yyvsp[-3].name), *(char**)(yyvsp[0].val_generic)->getValue());
					}
					depth = -1;
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabilei %s (de tip %s) nu i se poate atribui o valoare de tip %s", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-3].name), types[ts->getType((yyvsp[-3].name))], types[(yyvsp[0].val_generic)->getType()]);
					yyerror(msg);
					YYERROR;
				}					
		  	}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-3].name));
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-3].name));
			yyerror(msg);
			YYERROR;
		}
	}
#line 1912 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 490 "tema2.y" /* yacc.c:1646  */
    {
		depth = -1;
		if(ts != NULL)
		{
		  if(ts->exists((yyvsp[-2].name)) == 0)
		  {
		    ts->add((yyvsp[-2].name), (yyvsp[-3].val_int));
		    
		    if((yyvsp[-3].val_int)==0)
		    {
		    	if((yyvsp[0].val_generic)->getType()==0)
				{
		            fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[-2].name));
					ts->setValue((yyvsp[-2].name), *(bool*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat bool!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==1)
		    {
		    	if((yyvsp[0].val_generic)->getType()==1)
				{
				    fprintf(yyies, "\tla\t$t4, %s\n", (yyvsp[-2].name));			
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
					ts->setValue((yyvsp[-2].name), *(float*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat float!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==2)
		    {
		    	if((yyvsp[0].val_generic)->getType()==2)
				{
		            fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[-2].name));
					ts->setValue((yyvsp[-2].name), *(int*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat int!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==3)
		    {
		    	if((yyvsp[0].val_generic)->getType()==3)
				{
					ts->setValue((yyvsp[-2].name), *(char**)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat string!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    SAME_INSTRUCTION = 0;
		  }
		  else
		  {
		    sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
		    yyerror(msg);
		    YYERROR;
		  }
		}
		else
		{
		  ts = new TVAR();
		  ts->add((yyvsp[-2].name), (yyvsp[-3].val_int));
		    if((yyvsp[-3].val_int)==0)
		    {
		    	if((yyvsp[0].val_generic)->getType()==0)
				{
				    fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[-2].name));
					ts->setValue((yyvsp[-2].name), (bool)*(int*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat bool!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==1)
		    {
		        
		    	if((yyvsp[0].val_generic)->getType()==1)
				{
				    fprintf(yyies, "\tla\t$t4, %s\n", (yyvsp[-2].name));			
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
					ts->setValue((yyvsp[-2].name), *(float*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat float!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==2)
		    {
		    	if((yyvsp[0].val_generic)->getType()==2)
				{
				    fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[-2].name));
					ts->setValue((yyvsp[-2].name), *(int*)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat int!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		    if((yyvsp[-3].val_int)==3)
		    {
		    	if((yyvsp[0].val_generic)->getType()==3)
				{
					ts->setValue((yyvsp[-2].name), *(char**)(yyvsp[0].val_generic)->getValue());
				}
				else
				{
					sprintf(msg,"%d:%d Variabilei %s nu i se poate atrbui o alta valoare decat string!", (yylsp[-3]).first_line, (yylsp[-3]).first_column, (yyvsp[-2].name));
					yyerror(msg);
					YYERROR;  
				}
		    }
		}
    }
#line 2053 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 628 "tema2.y" /* yacc.c:1646  */
    {
	    if(ts != NULL)
	    {
	    	if(ts->exists((yyvsp[0].name))==1)
	    	{
	    		sprintf(msg,"%d:%d Variabila %s a fost declarata deja..", (yylsp[-1]).first_line, (yylsp[-1]).first_column, (yyvsp[0].name));
				yyerror(msg);
				YYERROR;  
	    	}
	    	else
	    	{
	    		ts->add((yyvsp[0].name), (yyvsp[-1].val_int));
	    	}
	    }
	    else
	    {
	    	ts = new TVAR();
	    	ts->add((yyvsp[0].name), (yyvsp[-1].val_int));
	    }
    }
#line 2078 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 650 "tema2.y" /* yacc.c:1646  */
    {
	    if(ts != NULL)
	    {
	      if(ts->exists((yyvsp[0].name)) == 1)
	      {
	        if(ts->isInitialized((yyvsp[0].name)) == 0)
	        {
	          sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", (yylsp[-1]).first_line, (yylsp[-1]).first_column, (yyvsp[0].name));
	          yyerror(msg);
	          YYERROR;
	        }
	        else
	        {
		        if(ts->getType((yyvsp[0].name))==3)
			    {
				    printf("It's a string! %s\n",*(char**)ts->getValue((yyvsp[0].name)));
				    fprintf(yyies, "\tmove\t$a0, $t0\n\tli\t$v0, 4\n\tsyscall\n");
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
			    }
			    if(ts->getType((yyvsp[0].name))==2)
			    {
				    printf("It's an int! %d\n",*(int*)ts->getValue((yyvsp[0].name)));
				    fprintf(yyies, "\tsw\t$t0, %s\n", (yyvsp[0].name));
				    fprintf(yyies, "\tmove\t$a0, $t0\n\tli\t$v0, 1\n\tsyscall\n");
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
			    }
			    if(ts->getType((yyvsp[0].name))==1)
			    {
				    printf("It's a float! %g\n",*(float*)ts->getValue((yyvsp[0].name)));
				    fprintf(yyies, "\tswc1\t$f0, 0($t4)\n");
	    	        fprintf(yyies, "\tmov.s\t$f12, $f0\n\tli\t$v0, 2\n\tsyscall\n");
				    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
				    
			    }
			    if(ts->getType((yyvsp[0].name))==0)
			    {
				    if(*(bool*)ts->getValue((yyvsp[0].name)))
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
	        sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[-1]).first_line, (yylsp[-1]).first_column, (yyvsp[0].name));
	        yyerror(msg);
	        YYERROR;
	      }
	    }
	    else
	    {
	      sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[-1]).first_line, (yylsp[-1]).first_column, (yyvsp[0].name));
	      yyerror(msg);
	      YYERROR;
	    }
	}
#line 2149 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 718 "tema2.y" /* yacc.c:1646  */
    {
	    char internal_name[50];
	    sprintf(internal_name, "cgs%d", string_count++);
	    if(ts==NULL)
	    {
	        ts=new TVAR();
	    }
	    ts->add(internal_name, 3);
	    ts->setValue(internal_name, (yyvsp[0].val_string));
	    fprintf(yyies, "\tla\t$a0, %s\n\tli\t$v0, 4\n\tsyscall\n", internal_name);
	    fprintf(yyies, "\tla\t$a0, crlf\n\tli\t$v0, 4\n\tsyscall\n");
    }
#line 2166 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 732 "tema2.y" /* yacc.c:1646  */
    {
        //printf("#ELSE\n");
		//printf("JMP E_BLOCK_%d\n", block_count + 1);
		fprintf(yyies, "\tb\tE_BLOCK_%d\n",block_count+1);
	}
#line 2176 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 741 "tema2.y" /* yacc.c:1646  */
    {
	    //printf("#IF\n");
		//printf("CMP EAX, ECX\n");
	}
#line 2185 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 746 "tema2.y" /* yacc.c:1646  */
    {
	    if((yyvsp[0].val_int)==0)// ==
	    {
	        //printf("JNE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbne\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==1)// !=
	    {
	        //printf("JE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbeq\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==2)// <
	    {
	        //printf("JGE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbge\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==3)// >
	    {
	        //printf("JLE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tble\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==4)// <=
	    {
	        //printf("JG BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tbgt\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==5)// >=
	    {
	        //printf("JL BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tblt\t$t2, $t0, BLOCK_%d\n",block_count+2);
	    }


	    if((yyvsp[0].val_int)==10)// ==
	    {
	        //printf("JNE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1f\t BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==11)// !=
	    {
	        //printf("JE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==12)// <
	    {
	        //printf("JGE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f0, $f2\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==13)// >
	    {
	        //printf("JLE BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==14)// <=
	    {
	        //printf("JG BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.lt.s $f0, $f2\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	    if((yyvsp[0].val_int)==15)// >=
	    {
	        //printf("JL BLOCK_%d \n",block_count+2);
	        fprintf(yyies, "\tc.le.s $f2, $f0\n");
	        fprintf(yyies, "\tbc1t\t BLOCK_%d\n",block_count+2);
	    }
	}
#line 2260 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 819 "tema2.y" /* yacc.c:1646  */
    {
        fprintf(yyies, "\tmove\t$t2, $t0\n");
        depth = -1;
    }
#line 2269 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 824 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[0].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
			if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 0;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 10;
			}	    
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near ==", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		depth = -1;
	}
#line 2294 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 846 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    depth = -1;
	}
#line 2303 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 851 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
			if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 1;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 11;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near !=", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		depth = -1;
	}
#line 2328 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 873 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    depth = -1;
	}
#line 2337 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 878 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
			if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 3;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 13;
			};
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near >", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		depth = -1;
	}
#line 2362 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 900 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    depth = -1;
	}
#line 2371 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 905 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
			if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 2;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 12;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near <", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		depth = -1;
	}
#line 2396 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 927 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
	    depth = -1;
	}
#line 2405 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 932 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
			if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 4;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 14;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near <=", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
	}
#line 2429 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 953 "tema2.y" /* yacc.c:1646  */
    {
	    fprintf(yyies, "\tmove\t$t2, $t0\n");
		depth = -1;
	}
#line 2438 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 958 "tema2.y" /* yacc.c:1646  */
    {
		if((yyvsp[-3].val_generic)->getType()==(yyvsp[0].val_generic)->getType())
		{
		    if((yyvsp[0].val_generic)->getType() == 2)
			{
				(yyval.val_int) = 2;
			}
			if((yyvsp[0].val_generic)->getType() == 1)
			{
				(yyval.val_int) = 12;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Type mismatch near >=", (yylsp[-3]).first_line, (yylsp[-3]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		depth = -1;
	}
#line 2463 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 980 "tema2.y" /* yacc.c:1646  */
    {
		    repeat_count ++;
		    repeat_stack.push(block_count+1);
	}
#line 2472 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 985 "tema2.y" /* yacc.c:1646  */
    {
		    if((yyvsp[0].val_int)==0)// ==
		    {
		        //printf("JNE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbne\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==1)// !=
		    {
		        //printf("JE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbeq\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==2)// <
		    {
		        //printf("JGE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbge\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==3)// >
		    {
		        //printf("JLE BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tble\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==4)// <=
		    {
		        //printf("JG BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tbgt\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==5)// >=
		    {
		        printf("JL BLOCK_%d \n",repeat_stack.top());
		        fprintf(yyies, "\tblt\t$t2, $t0, BLOCK_%d\n",repeat_stack.top());
		    }

		    if((yyvsp[0].val_int)==10)// ==
		    {
		        //printf("JNE BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
		        fprintf(yyies, "\tbc1f\t BLOCK_%d\n", repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==11)// !=
		    {
		        //printf("JE BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.eq.s $f2, $f0\n");
		        fprintf(yyies, "\tbc1t\t BLOCK_%d\n", repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==12)// <
		    {
		        //printf("JGE BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.le.s $f0, $f2\n");
		        fprintf(yyies, "\tbc1t\t BLOCK_%d\n", repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==13)// >
		    {
		        //printf("JLE BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.le.s $f2, $f0\n");
		        fprintf(yyies, "\tbc1t\t BLOCK_%d\n", repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==14)// <=
		    {
		        //printf("JG BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.lt.s $f0, $f2\n");
		        fprintf(yyies, "\tbc1t\t BLOCK_%d\n", repeat_stack.top());
		    }
		    if((yyvsp[0].val_int)==15)// >=
		    {
		        //printf("JL BLOCK_%d \n",block_count+2);
		        fprintf(yyies, "\tc.le.s $f2, $f0\n");
		        fprintf(yyies, "\tbc1t\t BLOCK_%d\n", repeat_stack.top());
		    }
		    repeat_stack.pop();
	}
#line 2547 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 1059 "tema2.y" /* yacc.c:1646  */
    {
		(yyval.val_generic) = new GenericValue();
		if((yyvsp[-2].val_generic)->getType()!=(yyvsp[0].val_generic)->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			(yyval.val_generic)->depth=--depth;
			if((yyvsp[-2].val_generic)->getType()==2)
			{
				(yyval.val_generic)->setValue(*(int*)(yyvsp[-2].val_generic)->getValue()+*(int*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tadd\t$t%d, $t%d, $t%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
			if((yyvsp[-2].val_generic)->getType()==1)
			{
				(yyval.val_generic)->setValue(*(float*)(yyvsp[-2].val_generic)->getValue()+*(float*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tadd.s\t$f%d, $f%d, $f%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
			if((yyvsp[-2].val_generic)->getType()==3)
			{
				sprintf(msg,"%d:%d I can't quite concatenate that for you", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
			if((yyvsp[-2].val_generic)->getType()==0)
			{
				sprintf(msg,"%d:%d I am not performing OR instead of addition", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
		}
	}
#line 2587 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 1096 "tema2.y" /* yacc.c:1646  */
    {
		(yyval.val_generic) = new GenericValue();
		if((yyvsp[-2].val_generic)->getType()!=(yyvsp[0].val_generic)->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			(yyval.val_generic)->depth=--depth;
			if((yyvsp[-2].val_generic)->getType()==2)
			{
				(yyval.val_generic)->setValue(*(int*)(yyvsp[-2].val_generic)->getValue()-*(int*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tsub\t$t%d, $t%d, $t%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
			if((yyvsp[-2].val_generic)->getType()==1)
			{
				(yyval.val_generic)->setValue(*(float*)(yyvsp[-2].val_generic)->getValue() - *(float*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tsub.s\t$f%d, $f%d, $f%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
			if((yyvsp[-2].val_generic)->getType()==3)
			{
				sprintf(msg,"%d:%d I can't eleminiate a substring from a string", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
			if((yyvsp[-2].val_generic)->getType()==0)
			{
				sprintf(msg,"%d:%d I can't substract a boolean value from another", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
		}
	}
#line 2627 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 1133 "tema2.y" /* yacc.c:1646  */
    {
		(yyval.val_generic) = new GenericValue();
		if((yyvsp[-2].val_generic)->getType()!=(yyvsp[0].val_generic)->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			(yyval.val_generic)->depth=--depth;
			if((yyvsp[-2].val_generic)->getType()==2)
			{
				(yyval.val_generic)->setValue(*(int*)(yyvsp[-2].val_generic)->getValue() * *(int*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tmult\t$t%d, $t%d\n", (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
				fprintf(yyies, "\tmflo\t$t%d\n", depth);		
			}
			if((yyvsp[-2].val_generic)->getType()==1)
			{
				(yyval.val_generic)->setValue(*(float*)(yyvsp[-2].val_generic)->getValue() * *(float*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tmul.s\t$f%d, $f%d, $f%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
			if((yyvsp[-2].val_generic)->getType()==3)
			{
				sprintf(msg,"%d:%d I can't multiply 2 strings...call me crazy", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
			if((yyvsp[-2].val_generic)->getType()==0)
			{
				sprintf(msg,"%d:%d I am not performing AND instead of multiplication", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
		}
	}
#line 2668 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 1171 "tema2.y" /* yacc.c:1646  */
    {
		(yyval.val_generic) = new GenericValue();
		if((yyvsp[-2].val_generic)->getType()!=(yyvsp[0].val_generic)->getType())
		{
			sprintf(msg,"%d:%d Type mismatch", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  		yyerror(msg);
	  		YYERROR;
		}
		else
		{
			if((yyvsp[-2].val_generic)->getType()==3)
			{
				sprintf(msg,"%d:%d I can't divide 2 strings...call me crazy", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
			if((yyvsp[-2].val_generic)->getType()==0)
			{
				sprintf(msg,"%d:%d I don't like dividing boolean values", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
	  			yyerror(msg);
	  			YYERROR;
			}
			if((yyvsp[0].val_generic)->getType()==2)
			{
				if(*(int*)(yyvsp[0].val_generic)->getValue() == 0)
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
		  			yyerror(msg);
		  			YYERROR;
				}
			}
			if((yyvsp[0].val_generic)->getType()==1)
			{
				if(*(float*)(yyvsp[0].val_generic)->getValue() == 0)
				{
					sprintf(msg,"%d:%d Deliberate division by 0...I'd put you in jail...", (yylsp[-2]).first_line, (yylsp[-2]).first_column);
		  			yyerror(msg);
		  			YYERROR;
				}
			}
			(yyval.val_generic)->depth=--depth;
			if((yyvsp[-2].val_generic)->getType()==2)
			{
			    (yyval.val_generic)->setValue(*(int*)(yyvsp[-2].val_generic)->getValue() / *(int*)(yyvsp[0].val_generic)->getValue());
			    fprintf(yyies, "\tdiv\t$t%d, $t%d\n", (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
				fprintf(yyies, "\tmflo\t$t%d\n", depth);
			}
		    if((yyvsp[-2].val_generic)->getType()==1)
			{
				(yyval.val_generic)->setValue(*(float*)(yyvsp[-2].val_generic)->getValue() / *(float*)(yyvsp[0].val_generic)->getValue());
				fprintf(yyies, "\tdiv.s\t$f%d, $f%d, $f%d\n", depth, (yyvsp[-2].val_generic)->depth, (yyvsp[0].val_generic)->depth);
			}
		}
	}
#line 2727 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 1227 "tema2.y" /* yacc.c:1646  */
    {
	}
#line 2734 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 1230 "tema2.y" /* yacc.c:1646  */
    {
		(yyval.val_generic) = new GenericValue();
		(yyval.val_generic)->depth = (yyvsp[-1].val_generic)->depth;
		if((yyvsp[-1].val_generic)->getType()==0)
		{
			(yyval.val_generic)->setValue(*(bool*)(yyvsp[-1].val_generic)->getValue());
		}
		if((yyvsp[-1].val_generic)->getType()==1)
		{
			(yyval.val_generic)->setValue(*(float*)(yyvsp[-1].val_generic)->getValue());
		}
		if((yyvsp[-1].val_generic)->getType()==2)
		{
			(yyval.val_generic)->setValue(*(int*)(yyvsp[-1].val_generic)->getValue());
		}
		if((yyvsp[-1].val_generic)->getType()==3)
		{
			(yyval.val_generic)->setValue(*(char**)(yyvsp[-1].val_generic)->getValue());
		}	
	}
#line 2759 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 1252 "tema2.y" /* yacc.c:1646  */
    {
		depth++;
		if(ts != NULL)
		{
		if(ts->exists((yyvsp[0].name)) == 1)
			{
				(yyval.val_generic)=new GenericValue();
				(yyval.val_generic)->correct_order = (yyvsp[0].name);
				(yyval.val_generic)->depth = depth;
				if(ts->getType((yyvsp[0].name))==0)
				{
					(yyval.val_generic)->setValue(*(bool*)ts->getValue((yyvsp[0].name)));
				}
				if(ts->getType((yyvsp[0].name))==1)
				{
					(yyval.val_generic)->setValue(*(float*)ts->getValue((yyvsp[0].name)));
					fprintf(yyies, "\tlwc1\t$f%d, %s\n", depth, (yyvsp[0].name));
				}
				if(ts->getType((yyvsp[0].name))==2)
				{
					(yyval.val_generic)->setValue(*(int*)ts->getValue((yyvsp[0].name)));
					fprintf(yyies, "\tlw\t$t%d, %s\n", depth, (yyvsp[0].name));
				}
				if(ts->getType((yyvsp[0].name))==3)
				{
					(yyval.val_generic)->setValue(*(char**)ts->getValue((yyvsp[0].name)));
				}
				(yyval.val_generic)->is_variable=1;
				(yyval.val_generic)->var_name = (yyvsp[0].name);
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[0]).first_line, (yylsp[0]).first_column, (yyvsp[0].name));
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
		  sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", (yylsp[0]).first_line, (yylsp[0]).first_column, (yyvsp[0].name));
		  yyerror(msg);
		  YYERROR;
		}
	}
#line 2808 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 1298 "tema2.y" /* yacc.c:1646  */
    {
		depth++;
	    (yyval.val_generic) = new GenericValue();
	    (yyval.val_generic)->depth = depth;
	    (yyval.val_generic)->setValue((yyvsp[0].val_int));
	    fprintf(yyies, "\tli\t$t%d, %d\n", depth, (yyvsp[0].val_int));
	}
#line 2820 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 1307 "tema2.y" /* yacc.c:1646  */
    {
		depth++;
		(yyval.val_generic) = new GenericValue();
		(yyval.val_generic)->depth = depth;
		(yyval.val_generic)->setValue((yyvsp[0].val_float));
		fprintf(yyies, "\tli.s\t$f%d, %f\n", depth, (yyvsp[0].val_float));
	}
#line 2832 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 1315 "tema2.y" /* yacc.c:1646  */
    {(yyval.val_generic) = new GenericValue();(yyval.val_generic)->setValue((yyvsp[0].val_string));}
#line 2838 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 1317 "tema2.y" /* yacc.c:1646  */
    {(yyval.val_generic) = new GenericValue();(yyval.val_generic)->setValue(true);}
#line 2844 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 1319 "tema2.y" /* yacc.c:1646  */
    {(yyval.val_generic) = new GenericValue();(yyval.val_generic)->setValue(false);}
#line 2850 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2854 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[1] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1323 "tema2.y" /* yacc.c:1906  */


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
