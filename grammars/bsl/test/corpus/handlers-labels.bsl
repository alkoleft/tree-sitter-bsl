=========================================
Перейти: простая форма с точкой с запятой
=========================================
Перейти ~Метка;
---

(source_file
  (goto_statement
    (GOTO_KEYWORD)
    (identifier)))

============================
Перейти: без точки с запятой
============================
Перейти ~Метка
---

(source_file
  (goto_statement
    (GOTO_KEYWORD)
    (identifier)))

=================
Метка: объявление
=================
~Метка:
---

(source_file
  (label_statement
    (identifier)))

===========================
Метка: оператор после метки
===========================
~Метка:
Сообщить(1);
---

(source_file
  (label_statement
    (identifier))
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (const_expression
            (number)))))))

=================================
Перейти и метка в одной процедуре
=================================
Процедура ОбработатьДанные()
    Перем а, б;
    а = 0;
    б = 0;
    Для а = 1 По 10 Цикл
        Если а = 5 Тогда
            Перейти ~Готово;
        КонецЕсли;
        б = б + а;
    КонецЦикла;
    ~Готово:
    Сообщить(б);
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier)
      var_name: (identifier))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (for_statement
      (FOR_KEYWORD)
      (identifier)
      (expression
        (const_expression
          (number)))
      (TO_KEYWORD)
      (expression
        (const_expression
          (number)))
      (DO_KEYWORD)
      (if_statement
        (IF_KEYWORD)
        (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        (THEN_KEYWORD)
        (goto_statement
          (GOTO_KEYWORD)
          (identifier))
        (ENDIF_KEYWORD))
      (assignment_statement
        left: (identifier)
        right: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (identifier)))))
      (ENDDO_KEYWORD))
    (label_statement
      (identifier))
    (call_statement
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (identifier)))))
    (ENDPROCEDURE_KEYWORD)))

======================================
ДобавитьОбработчик: оба идентификаторы
======================================
ДобавитьОбработчик Событие, Обработчик;
---

(source_file
  (add_handler_statement
    (ADDHANDLER_KEYWORD)
    (expression
      (identifier))
    (expression
      (identifier))))

=================================================
ДобавитьОбработчик: событие как доступ к свойству
=================================================
ДобавитьОбработчик Форма.Элемент.ПриИзменении, ОбработчикПриИзменении;
---

(source_file
  (add_handler_statement
    (ADDHANDLER_KEYWORD)
    (expression
      (property_access
        (access
          (access
            (identifier))
          (property))
        (property)))
    (expression
      (identifier))))

===============================================
ДобавитьОбработчик: обработчик как вызов метода
===============================================
ДобавитьОбработчик Событие, ОбработчикСобытия();
---

(source_file
  (add_handler_statement
    (ADDHANDLER_KEYWORD)
    (expression
      (identifier))
    (expression
      (method_call
        name: (identifier)
        arguments: (arguments)))))

=================================================
ДобавитьОбработчик: событие как строковый литерал
=================================================
ДобавитьОбработчик "Событие", Обработчик;
---

(source_file
  (add_handler_statement
    (ADDHANDLER_KEYWORD)
    (expression
      (const_expression
        (string
          (string_content))))
    (expression
      (identifier))))

====================================================
ДобавитьОбработчик: обработчик как строковый литерал
====================================================
ДобавитьОбработчик Событие, "Обработчик";
---

(source_file
  (add_handler_statement
    (ADDHANDLER_KEYWORD)
    (expression
      (identifier))
    (expression
      (const_expression
        (string
          (string_content))))))

=====================================
УдалитьОбработчик: оба идентификаторы
=====================================
УдалитьОбработчик Событие, Обработчик;
---

(source_file
  (remove_handler_statement
    (REMOVEHANDLER_KEYWORD)
    (expression
      (identifier))
    (expression
      (identifier))))

==========================================
УдалитьОбработчик: свойство и вызов метода
==========================================
УдалитьОбработчик Форма.Элемент.ПриИзменении, ОбработчикСобытия();
---

(source_file
  (remove_handler_statement
    (REMOVEHANDLER_KEYWORD)
    (expression
      (property_access
        (access
          (access
            (identifier))
          (property))
        (property)))
    (expression
      (method_call
        name: (identifier)
        arguments: (arguments)))))

========================================
Добавить и УдалитьОбработчик в процедуре
========================================
Процедура Подписать()
    ДобавитьОбработчик Форма.Элемент.ПриИзменении, ПриИзмененииЭлемента;
    УдалитьОбработчик Форма.Элемент.ПриИзменении, ПриИзмененииЭлемента;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (add_handler_statement
      (ADDHANDLER_KEYWORD)
      (expression
        (property_access
          (access
            (access
              (identifier))
            (property))
          (property)))
      (expression
        (identifier)))
    (remove_handler_statement
      (REMOVEHANDLER_KEYWORD)
      (expression
        (property_access
          (access
            (access
              (identifier))
            (property))
          (property)))
      (expression
        (identifier)))
    (ENDPROCEDURE_KEYWORD)))

============================================
Перем: локальное объявление в теле процедуры
============================================
Процедура Т()
    Перем а;
    а = 1;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (ENDPROCEDURE_KEYWORD)))

=========================================
Перем: несколько переменных через запятую
=========================================
Процедура Т()
    Перем а, б;
    а = б;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier)
      var_name: (identifier))
    (assignment_statement
      left: (identifier)
      right: (expression
        (identifier)))
    (ENDPROCEDURE_KEYWORD)))

=================================
Ждать: оператор с идентификатором
=================================
Ждать Обещание;
---

(source_file
  (await_statement
    (await_expression
      (AWAIT_KEYWORD)
      (expression
        (identifier)))))

==================================
Ждать: в правой части присваивания
==================================
Результат = Ждать Обещание;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (await_expression
        (AWAIT_KEYWORD)
        (expression
          (identifier))))))

===============================================
Ждать: вызов асинхронного метода в присваивании
===============================================
Сколько = Ждать ВвестиЧислоАсинх(1000);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (await_expression
        (AWAIT_KEYWORD)
        (expression
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (const_expression
                  (number))))))))))

===============================
Асинх процедура с формами Ждать
===============================
Асинх Процедура УстановитьПервые(Команда)
	Сколько = Ждать ВвестиЧислоАсинх(1000);
	Ждать ВвестиЧислоАсинх(1000);
	Обещание = ВвестиЧислоАсинх(1000);
	Ждать Обещание;
	Сколько = Ждать Обещание;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (ASYNC_KEYWORD)
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier)))
    (assignment_statement
      left: (identifier)
      right: (expression
        (await_expression
          (AWAIT_KEYWORD)
          (expression
            (method_call
              name: (identifier)
              arguments: (arguments
                (expression
                  (const_expression
                    (number)))))))))
    (await_statement
      (await_expression
        (AWAIT_KEYWORD)
        (expression
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (const_expression
                  (number))))))))
    (assignment_statement
      left: (identifier)
      right: (expression
        (method_call
          name: (identifier)
          arguments: (arguments
            (expression
              (const_expression
                (number)))))))
    (await_statement
      (await_expression
        (AWAIT_KEYWORD)
        (expression
          (identifier))))
    (assignment_statement
      left: (identifier)
      right: (expression
        (await_expression
          (AWAIT_KEYWORD)
          (expression
            (identifier)))))
    (ENDPROCEDURE_KEYWORD)))
