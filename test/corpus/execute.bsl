================
Метод выполнить
================

Выполнить("1+1");
---

(source_file
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content))))))

================
Оператор выполнить
================

Выполнить "ВызовКакого то метода";
---

(source_file
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content))))))

================
Запрос выполнить
================

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
