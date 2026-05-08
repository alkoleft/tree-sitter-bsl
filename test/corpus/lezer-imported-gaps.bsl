====================================
Lezer import: parenthesized return
====================================
Возврат (1 + 2);
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (parenthesized_expression
        (expression
          (binary_expression
            left: (expression
              (const_expression
                (number)))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))))))

===============================================
Lezer import: parenthesized binary precedence
===============================================
Возврат (1 + 2) * 3;
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (binary_expression
        left: (expression
          (parenthesized_expression
            (expression
              (binary_expression
                left: (expression
                  (const_expression
                    (number)))
                operator: (operator)
                right: (expression
                  (const_expression
                    (number)))))))
        operator: (operator)
        right: (expression
          (const_expression
            (number)))))))

====================================
Lezer import: leading semicolons
====================================
;;;а = 1;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

====================================
Lezer import: repeated semicolons
====================================
а = 1;;;б = 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

==============================================
Lezer import: empty semicolon inside if block
==============================================
Если Истина Тогда
    ;
    а = 1
КонецЕсли
---

(source_file
  (if_statement
    (IF_KEYWORD)
    (expression
      (const_expression
        (boolean
          (TRUE_KEYWORD))))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (ENDIF_KEYWORD)))

=============================================
Lezer import: exception branch bare rethrow
=============================================
Попытка
    Действие();
Исключение
    ВызватьИсключение;
КонецПопытки
---

(source_file
  (try_statement
    (TRY_KEYWORD)
    (call_statement
      (method_call
        name: (identifier)
        arguments: (arguments)))
    (EXCEPT_KEYWORD)
    (rise_error_statement
      (RAISE_KEYWORD))
    (ENDTRY_KEYWORD)))

=========================================
Lezer import: standalone bare raise
=========================================
ВызватьИсключение;
---

(source_file
  (rise_error_statement
    (RAISE_KEYWORD)
    (expression
      (MISSING identifier))))

============================================
Lezer import: raise with expression
============================================
ВызватьИсключение "Ошибка";
---

(source_file
  (rise_error_statement
    (RAISE_KEYWORD)
    (expression
      (const_expression
        (string
          (string_content))))))

============================================
Lezer import: raise with arguments
============================================
ВызватьИсключение("Ошибка");
---

(source_file
  (rise_error_statement
    (RAISE_KEYWORD)
    (arguments
      (expression
        (const_expression
          (string
            (string_content)))))))

============================================
Lezer import: execute object method call
============================================
Выполнить Объект.Метод();
---

(source_file
  (execute_statement
    (expression
      (call_expression
        (access
          (identifier))
        (method_call
          name: (identifier)
          arguments: (arguments))))))

==============================================
Lezer import: execute chained method call
==============================================
Выполнить Объект.Метод1().Метод2();
---

(source_file
  (execute_statement
    (expression
      (call_expression
        (access
          (access
            (identifier))
          (method_call
            name: (identifier)
            arguments: (arguments)))
        (method_call
          name: (identifier)
          arguments: (arguments))))))

===========================================
Lezer import: call named like execute
===========================================
Запрос.Выполнить();
---

(source_file
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        (identifier)
        (arguments)))))

==========================================
Lezer import: property access by string
==========================================
значение = Объект["Свойство"];
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (property_access
        (access
          (identifier))
        (index
          (const_expression
            (string
              (string_content))))))))

========================================
Lezer import: call after string index
========================================
результат = Объект["Метод"](параметр);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (call_expression
        (access
          (identifier))
        (index
          (const_expression
            (string
              (string_content))))
        (arguments
          (expression
            (identifier)))))))

=====================================
Lezer import: omitted middle argument
=====================================
Метод(а,,б);
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (identifier))
        (omitted_argument)
        (expression
          (identifier))))))

=====================================
Lezer import: omitted edge arguments
=====================================
Метод(,а,);
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (omitted_argument)
        (expression
          (identifier))
        (omitted_argument)))))

=======================================
Lezer import: per-variable export
=======================================
Перем а, б Экспорт, в;
---

(source_file
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier))
    variable: (variable_spec
      name: (identifier)
      export: (EXPORT_KEYWORD))
    variable: (variable_spec
      name: (identifier))))

===========================================
Lezer import: whole declaration export
===========================================
Перем а, б, в Экспорт;
---

(source_file
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier))
    variable: (variable_spec
      name: (identifier))
    variable: (variable_spec
      name: (identifier))
    export: (EXPORT_KEYWORD)))
