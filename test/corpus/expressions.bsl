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
        operator: (operator)
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
        operator: (operator)
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
        operator: (operator)
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
        operator: (operator)
        right: (expression
          (identifier)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operator)
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
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operator)
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
        operator: (operator)
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
        operator: (operator)
        right: (expression
          (identifier)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operator)
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
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
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
        operator: (operator)
        right: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (const_expression
                (number)))))
        operator: (operator)
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
          (method_call
            name: (identifier)
            arguments: (arguments)))
        alternative: (expression
          (const_expression
            (number)))))))

================
Parenthesized in assignment
================
А = (X + Y);
---
(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (parenthesized_expression
        inner: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (identifier))))))))

================
Parenthesized in condition
================
Если (А И Б) Тогда
    Возврат;
КонецЕсли;
---
(source_file
  (if_statement
    (IF_KEYWORD)
    (expression
      (parenthesized_expression
        inner: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (identifier))))))
    (THEN_KEYWORD)
    (return_statement
      (RETURN_KEYWORD))
    (ENDIF_KEYWORD)))

================
Nested parentheses
================
А = ((X = Y) И Z);
---
(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (parenthesized_expression
        inner: (expression
          (binary_expression
            left: (expression
              (parenthesized_expression
                inner: (expression
                  (binary_expression
                    left: (expression
                      (identifier))
                    operator: (operator)
                    right: (expression
                      (identifier))))))
            operator: (operator)
            right: (expression
              (identifier))))))))

================
Parenthesized unary
================
А = (-X);
А = (Не Б);
---
(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (parenthesized_expression
        inner: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (parenthesized_expression
        inner: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))))))

================
Double parens in call
================
Р = МойМетод((X));
---
(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (parenthesized_expression
              inner: (expression
                (identifier)))))))))
