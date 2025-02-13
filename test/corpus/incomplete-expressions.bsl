================
Глобальный метод
================
Сообщить(1
----

(source_file
  (call_statement
    (call_expression
      (methodCall
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
      (identifier)
      (methodCall
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
      (identifier)
      (methodCall
        name: (identifier)
        arguments: (arguments
          (string
            (string_content))
          (call_expression
            (methodCall
              name: (identifier)
              arguments: (arguments
                (number)
                (MISSING ")"))))
          (MISSING ")"))))))
