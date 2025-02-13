================
Простая функция
================
Функция Простая()
	Возврат 1;
КонецФункции
---

(source_file
  (function_definition
    (FUNCTION_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (return_statement
      (RETURN_KEYWORD)
      (number))
    (END_FUNCTION_KEYWORD)))

================
Пустая процедура
================
Процедура ИмяПроцедуры()
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (END_PROCEDURE_KEYWORD)))

================
Параметры метода
================
Процедура ИмяПроцедуры(п1, Знач п2, п3 = Неопределено, п4="1")
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier))
      parameter: (parameter
        val: (VAL_KEYWORD)
        name: (identifier))
      parameter: (parameter
        name: (identifier)
        def: (UNDEFINED_KEYWORD))
      parameter: (parameter
        name: (identifier)
        def: (string
          (string_content))))
    (END_PROCEDURE_KEYWORD)))

================
Асинхронный метод
================
Асинх Процедура ИмяПроцедуры()
  Ждать Чтото();
КонецПроцедуры
---

(source_file
  (procedure_definition
    (ASYNC_KEYWORD)
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (await_statement
      (await_expression
        (AWAIT_KEYWORD)
        (call_expression
          (methodCall
            name: (identifier)
            arguments: (arguments)))))
    (END_PROCEDURE_KEYWORD)))

================
Вызов метод
================

Объект().Метод[0].Метод()

---

(source_file
  (call_statement
    (call_expression
      (methodCall
        (identifier)
        (arguments))
      (accessProperty
        (identifier))
      (accessIndex
        (number))
      (methodCall
        (identifier)
        (arguments)))))
