================
Глобальный метод
================
Сообщить(1
----

(source_file
  (call_statement
    (call_expression
      (method_call
        name: (identifier)
        arguments: (arguments
          (number)
          (MISSING ")"))))))

================
Метод объекта
================
Запрос.УстановитьПараметр(1
----

(source_file
  (call_statement
    (call_expression
      (property)
      (method_call
        name: (identifier)
        arguments: (arguments
          (number)
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
      (property)
      (method_call
        name: (identifier)
        arguments: (arguments
          (string
            (string_content))
          (call_expression
            (method_call
              name: (identifier)
              arguments: (arguments
                (number)
                (MISSING ")"))))
          (MISSING ")"))))))
