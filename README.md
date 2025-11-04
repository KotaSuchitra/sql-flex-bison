OUTPUT: 
Enter SQL Query:
 SELECT col FROM table WHERE id=1;

--- AST ---
STATEMENT
  SELECT
    COLUMN: col
    FROM
      TABLE: table
      WHERE
        EQUALS: =
          IDENTIFIER: id
          NUMBER: 1
