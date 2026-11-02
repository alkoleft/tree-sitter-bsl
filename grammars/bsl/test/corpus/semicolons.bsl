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
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

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
