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
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (string
              (string_content))))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (date)))
        operator: (operation)
        right: (expression
          (identifier)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operation)
        argument: (expression
          (identifier))))))

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
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (boolean
              (TRUE_KEYWORD))))
        operator: (operation
          (OR_KEYWORD))
        right: (expression
          (const_expression
            (boolean
              (FALSE_KEYWORD)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation
          (AND_KEYWORD))
        right: (expression
          (identifier)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operation)
        argument: (expression
          (identifier))))))

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
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation)
        right: (expression
          (const_expression
            (number)))))))

================
Приоритеты
================
А = А И НЕ Б;
А = -1  + 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operation
          (AND_KEYWORD))
        right: (expression
          (unary_expression
            operator: (operation)
            argument: (expression
              (identifier)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operation)
            argument: (expression
              (const_expression
                (number)))))
        operator: (operation)
        right: (expression
          (const_expression
            (number)))))))

================
Тернарный оператор
================
А = ?(А, 1, 2);
А = ?(А, ЧтоТо(), 2);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (ternary_expression
        condition: (expression
          (identifier))
        consequence: (expression
          (const_expression
            (number)))
        alternative: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (ternary_expression
        condition: (expression
          (identifier))
        consequence: (expression
          (call_expression
            (method_call
              name: (identifier)
              arguments: (arguments))))
        alternative: (expression
          (const_expression
            (number)))))))
