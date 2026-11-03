================================================
Разделитель обязателен: два присваивания без ;
================================================
А = 1 Б = 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    (ERROR
      (number))
    right: (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number)))))))

===========================
Последний statement без ;
===========================
А = 1;
Б = 2
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

=========================
Пустые statements между
=========================
А = 1;;; Б = 2;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (empty_statement)
  (empty_statement)
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

========================
Двойная точка с запятой после блока
========================
Если Истина Тогда
КонецЕсли;;
---

(source_file
  (if_statement
    (IF_KEYWORD)
    (expression
      (const_expression
        (boolean
          (TRUE_KEYWORD))))
    (THEN_KEYWORD)
    (ENDIF_KEYWORD))
  (empty_statement))

================
Пустые инструкции
================
;;

---

(source_file
  (empty_statement)
  (empty_statement))

======================================================
Составной statement требует ; при продолжении уровня
======================================================
Если Истина Тогда
	а = 1
КонецЕсли
б = 2;
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
    (ENDIF_KEYWORD))
  (MISSING ";")
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

============================================
Цепочка энеров без ; (последний на уровне)
============================================
Пока Истина Цикл
    Если Истина Тогда
        Если Истина Тогда
            Возврат 1
        КонецЕсли
    КонецЕсли
КонецЦикла
---

(source_file
  (while_statement
    (WHILE_KEYWORD)
    (expression
      (const_expression
        (boolean
          (TRUE_KEYWORD))))
    (DO_KEYWORD)
    (if_statement
      (IF_KEYWORD)
      (expression
        (const_expression
          (boolean
            (TRUE_KEYWORD))))
      (THEN_KEYWORD)
      (if_statement
        (IF_KEYWORD)
        (expression
          (const_expression
            (boolean
              (TRUE_KEYWORD))))
        (THEN_KEYWORD)
        (return_statement
          (RETURN_KEYWORD)
          result: (expression
            (const_expression
              (number))))
        (ENDIF_KEYWORD))
      (ENDIF_KEYWORD))
    (ENDDO_KEYWORD)))

=============
Label без ;
=============
Процедура П()
	~Метка:
	а = 1;
	Возврат;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (label_statement
      (identifier))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (return_statement
      (RETURN_KEYWORD))
    (ENDPROCEDURE_KEYWORD)))

=================================
Statements без ; внутри Области
=================================
#Область Тест
а = 1
б = 2;
#КонецОбласти
---

(source_file
  (preprocessor
    (PREPROC_REGION_KEYWORD)
    name: (identifier)
    (assignment_statement
      left: (identifier)
      (ERROR
        (number))
      right: (expression
        (binary_expression
          left: (expression
            (identifier))
          operator: (operator)
          right: (expression
            (const_expression
              (number))))))
    (PREPROC_ENDREGION_KEYWORD)))

==========================================
Ветка Исключение: разделитель обязателен
==========================================
Попытка
а = 1;
Исключение
а = 1
б = 2;
КонецПопытки
---

(source_file
  (try_statement
    (TRY_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (EXCEPT_KEYWORD)
    (assignment_statement
      left: (identifier)
      (ERROR
        (number))
      right: (expression
        (binary_expression
          left: (expression
            (identifier))
          operator: (operator)
          right: (expression
            (const_expression
              (number))))))
    (ENDTRY_KEYWORD)))

===============================
Простой перед составным без ;
===============================
Процедура П()
а = 1
Если Истина Тогда
КонецЕсли;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (MISSING ";")
    (if_statement
      (IF_KEYWORD)
      (expression
        (const_expression
          (boolean
            (TRUE_KEYWORD))))
      (THEN_KEYWORD)
      (ENDIF_KEYWORD))
    (ENDPROCEDURE_KEYWORD)))

=================
Аннотация без ;
=================
&НаКлиенте
Процедура П()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

=================================
Module level: определения без ;
=================================
Перем а;
Перем б;
---

(source_file
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier)))
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier))))

======================================================================
Вложенный trailing без ; (Review Focus 1)
======================================================================

Если Истина Тогда
    Если Истина Тогда
        а = 1
    КонецЕсли
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
      (ENDIF_KEYWORD))
    (ENDIF_KEYWORD)))

=====================================================
Trailing ; перед энером (Review Focus 3)
=====================================================

Процедура П()
    а = 1;
    Пока Истина Цикл
        а = 2;
    КонецЦикла;
    б = 3;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (while_statement
      (WHILE_KEYWORD)
      (expression
        (const_expression
          (boolean
            (TRUE_KEYWORD))))
      (DO_KEYWORD)
      (assignment_statement
        left: (identifier)
        right: (expression
          (const_expression
            (number))))
      (ENDDO_KEYWORD))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (ENDPROCEDURE_KEYWORD)))

===============================================================
Module level: аннотация между var-объявлениями (Review Focus 6)
===============================================================

Перем а;
&НаСервере
Перем б;
---

(source_file
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier)))
  (preprocessor
    (annotation))
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier))))

======================================================================
Каждый terminated-statement в не-последней позиции
======================================================================

Процедура П()
	а = 1;
	Сообщить(1);
	Выполнить("а = 2");
	Возврат;
	ВызватьИсключение "ошибка";
	Перем х, у;
	Продолжить;
	Прервать;
	Перейти ~Метка;
	ДобавитьОбработчик Событие, Обработчик;
	УдалитьОбработчик Событие, Обработчик;
	Попытка
		а = 3;
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	Если Истина Тогда
		а = 4;
	КонецЕсли;
	Пока Истина Цикл
		Прервать;
	КонецЦикла;
	Для Индекс = 1 По 10 Цикл
		Продолжить;
	КонецЦикла;
	Для Каждого э Из Список Цикл
		Продолжить;
	КонецЦикла;
	б = 2;
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (call_statement
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (number))))))
    (execute_statement
      (expression
        (const_expression
          (string
            (string_content)))))
    (return_statement
      (RETURN_KEYWORD))
    (rise_error_statement
      (RAISE_KEYWORD)
      (expression
        (const_expression
          (string
            (string_content)))))
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier)
      var_name: (identifier))
    (continue_statement
      (CONTINUE_KEYWORD))
    (break_statement
      (BREAK_KEYWORD))
    (goto_statement
      (GOTO_KEYWORD)
      (identifier))
    (add_handler_statement
      (ADDHANDLER_KEYWORD)
      (expression
        (identifier))
      (expression
        (identifier)))
    (remove_handler_statement
      (REMOVEHANDLER_KEYWORD)
      (expression
        (identifier))
      (expression
        (identifier)))
    (try_statement
      (TRY_KEYWORD)
      (assignment_statement
        left: (identifier)
        right: (expression
          (const_expression
            (number))))
      (EXCEPT_KEYWORD)
      (rise_error_statement
        (RAISE_KEYWORD))
      (ENDTRY_KEYWORD))
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
      (ENDIF_KEYWORD))
    (while_statement
      (WHILE_KEYWORD)
      (expression
        (const_expression
          (boolean
            (TRUE_KEYWORD))))
      (DO_KEYWORD)
      (break_statement
        (BREAK_KEYWORD))
      (ENDDO_KEYWORD))
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
      (continue_statement
        (CONTINUE_KEYWORD))
      (ENDDO_KEYWORD))
    (for_each_statement
      (FOR_KEYWORD)
      (EACH_KEYWORD)
      (identifier)
      (IN_KEYWORD)
      (expression
        (identifier))
      (DO_KEYWORD)
      (continue_statement
        (CONTINUE_KEYWORD))
      (ENDDO_KEYWORD))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (ENDPROCEDURE_KEYWORD)))
