%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// ---------- AST Node Structure ----------
typedef struct Node {
    char *type;
    char *value;
    struct Node *left;
    struct Node *right;
} Node;

// ---------- Function Prototypes ----------
Node* makeNode(char *type, char *value, Node *left, Node *right);
void printAST(Node *node, int level);
void yyerror(const char *s);
int yylex();
int yyparse();

// ---------- Helper Functions ----------
Node* makeNode(char *type, char *value, Node *left, Node *right) {
    Node *node = (Node*)malloc(sizeof(Node));
    node->type = strdup(type);
    node->value = value ? strdup(value) : NULL;
    node->left = left;
    node->right = right;
    return node;
}

void printAST(Node *node, int level) {
    if (!node) return;
    for (int i = 0; i < level; i++) printf("  ");
    printf("%s", node->type);
    if (node->value) printf(": %s", node->value);
    printf("\n");
    printAST(node->left, level + 1);
    printAST(node->right, level + 1);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

%}

%union {
    char *str;
    int num;
    Node *node;
}

%token SELECT FROM WHERE EQ SEMICOLON
%token <str> IDENTIFIER
%token <num> NUMBER
%type <node> statement select_clause from_clause where_clause condition

%%

input:
    statement SEMICOLON { 
        printf("\n--- AST ---\n"); 
        printAST($1, 0); 
    }
    ;

statement:
    select_clause from_clause where_clause
        { $$ = makeNode("STATEMENT", NULL, makeNode("SELECT", NULL, $1, makeNode("FROM", NULL, $2, $3)), NULL); }
    ;

select_clause:
    SELECT IDENTIFIER
        { $$ = makeNode("COLUMN", $2, NULL, NULL); }
    ;

from_clause:
    FROM IDENTIFIER
        { $$ = makeNode("TABLE", $2, NULL, NULL); }
    ;

where_clause:
    WHERE condition
        { $$ = makeNode("WHERE", NULL, $2, NULL); }
    ;

condition:
    IDENTIFIER EQ NUMBER
        {
            Node *id = makeNode("IDENTIFIER", $1, NULL, NULL);
            char numStr[20]; sprintf(numStr, "%d", $3);
            Node *num = makeNode("NUMBER", strdup(numStr), NULL, NULL);
            $$ = makeNode("EQUALS", "=", id, num);
        }
    ;

%%

// ---------- Main Function ----------
int main() {
    printf("Enter SQL Query:\n ");
    yyparse();
    return 0;
}
