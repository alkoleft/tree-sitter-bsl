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

=============================
Выполнить метод объекта
=============================

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

=====================================
Выполнить цепочку методов объекта
=====================================

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
