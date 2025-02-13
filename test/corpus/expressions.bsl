================
Арифметические
================
А = 1 - 1;
А = "1" + 1;
А = 2 * 3;
А = '20221228130405' - А ;
А = 4 % 3;
А = 6/3;
А = -А;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (number)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (string
        (string_content))
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (number)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (date)
      operator: (operation)
      right: (identifier)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (number)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (number)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (unary_expression
      operator: (operation)
      argument: (identifier))))

================
Логические
================
А = Истина Или Ложь;
А = А И Б;
А = НЕ А;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (boolean
        (TRUE_KEYWORD))
      operator: (operation
        (OR_KEYWORD))
      right: (boolean
        (FALSE_KEYWORD))))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation
        (AND_KEYWORD))
      right: (identifier)))
  (assignment_statement
    left: (identifier)
    right: (unary_expression
      operator: (operation)
      argument: (identifier))))

================
Сравнение
================
А = А > 2;
А = А < 2;
А = А <= 2;
А = А >= 2;
А = А <> 2;
А = А = 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation)
      right: (number))))

================
Приоритеты
================
А = А И НЕ Б;
А = -1  + 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (identifier)
      operator: (operation
        (AND_KEYWORD))
      right: (unary_expression
        operator: (operation)
        argument: (identifier))))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (unary_expression
        operator: (operation)
        argument: (number))
      operator: (operation)
      right: (number))))

================
Тернарный оператор
================
А = ?(А, 1, 2);
А = ?(А, ЧтоТо(), 2);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (ternary_expression
      condition: (identifier)
      consequence: (number)
      alternative: (number)))
  (assignment_statement
    left: (identifier)
    right: (ternary_expression
      condition: (identifier)
      consequence: (call_expression
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      alternative: (number))))
