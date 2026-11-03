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

==========================================
Доступ к свойству после тернарного оператора
==========================================
А = ?(Б = 1, В, Г).Поле;
Б = ?(В = 1, Г, Д).Метод();
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (property_access
        (access
          (ternary_expression
            condition: (expression
              (binary_expression
                left: (expression
                  (identifier))
                operator: (operator)
                right: (expression
                  (const_expression
                    (number)))))
            consequence: (expression
              (identifier))
            alternative: (expression
              (identifier))))
        (property))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (call_expression
        (access
          (ternary_expression
            condition: (expression
              (binary_expression
                left: (expression
                  (identifier))
                operator: (operator)
                right: (expression
                  (const_expression
                    (number)))))
            consequence: (expression
              (identifier))
            alternative: (expression
              (identifier))))
        (method_call
          name: (identifier)
          arguments: (arguments))))))

================
ternary with space between ? and (
================
А = ? (А, 1, 2);
Б = ?(  А > 0 , "да", "нет");
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
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        consequence: (expression
          (const_expression
            (string
              (string_content))))
        alternative: (expression
          (const_expression
            (string
              (string_content))))))))

================
Конструкторы
================
А = Новый Массив(1);
А = Новый(Тип("Массив"));
А = Новый(Тип("Массив"), Параметры);
---

(source_file
  (assignment_statement
    (identifier)
    (expression
      (new_expression
        (NEW_KEYWORD)
        (identifier)
        (arguments
          (expression
            (const_expression
              (number)))))))
  (assignment_statement
    (identifier)
    (expression
      (new_expression_method
        (NEW_KEYWORD)
        (expression
          (method_call
            (identifier)
            (arguments
              (expression
                (const_expression
                  (string
                    (string_content))))))))))
  (assignment_statement
    (identifier)
    (expression
      (new_expression_method
        (NEW_KEYWORD)
        (expression
          (method_call
            (identifier)
            (arguments
              (expression
                (const_expression
                  (string
                    (string_content)))))))
        (expression
          (identifier))))))

=====================================================
Доступ к свойству после скобок — невалидный 1С
=====================================================
А = (Б).В;
---

; parenthesized_expression сознательно не входит в access-базы
; (grammar.js: «(А).Б — невалидный 1С, доступ после скобок не работает»):
; доступ к члену после скобочного выражения обязан оставаться ERROR.
; Присваивание А распознаётся (parenthesized_expression в right),
; точка и имя свойства попадают в ERROR на уровне source_file.
(source_file
  (assignment_statement
    (identifier)
    (expression
      (parenthesized_expression
        (expression
          (identifier)))))
  (ERROR
    (identifier)))
