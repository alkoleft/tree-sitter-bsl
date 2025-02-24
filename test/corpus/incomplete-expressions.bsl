================
Глобальный метод
================
Сообщить(1
----

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (const_expression
            (number)))
        (MISSING ")")))))

================
Метод объекта
================
Запрос.УстановитьПараметр(1
----

(source_file
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (number)))
          (MISSING ")"))))
    (MISSING ";")))

================
Двойной незакрытый метод
================
Запрос.УстановитьПараметр("1", Дата(1
----

(source_file
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (string
                (string_content))))
          (expression
            (method_call
              name: (identifier)
              arguments: (arguments
                (expression
                  (const_expression
                    (number)))
                (MISSING ")"))))
          (MISSING ")"))))))
