====================
Если-ИначеЕсли-Иначе
====================
#Если Сервер Тогда
	а = 1;
#ИначеЕсли Клиент Тогда
	а = 2;
#Иначе
	а = 3;
#КонецЕсли
---

(source_file
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (identifier))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ELSIF_KEYWORD)
    (expression
      (identifier))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ELSE_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ENDIF_KEYWORD)))

==================
Область->Процедура
==================
#Область События

Процедура ПередТестовымНабором() Экспорт

	ИнициализироватьКонтекстМодуля();

КонецПроцедуры

#КонецОбласти
---

(source_file
  (preprocessor
    (PREPROC_REGION_KEYWORD)
    name: (identifier)
    (procedure_definition
      (PROCEDURE_KEYWORD)
      name: (identifier)
      parameters: (parameters)
      export: (EXPORT_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments)))
      (ENDPROCEDURE_KEYWORD))
    (PREPROC_ENDREGION_KEYWORD)))

========================================
Препроцессор Если с вложенными областями
========================================
#Если Сервер Тогда

#Область Область1

#Область Область1_1

Процедура ИмяПроцедуры() Экспорт

	Процедура1();

КонецПроцедуры

#КонецОбласти

#Область Область1_2

Процедура Процедура1()

#Область Область1_2_1

	а = 1;

#КонецОбласти

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
---

(source_file
  (preprocessor
    (PREPROC_IF_KEYWORD)
	(expression
	  (identifier))
	(THEN_KEYWORD)
	(preprocessor
      (PREPROC_REGION_KEYWORD)
      name: (identifier)
      (preprocessor
        (PREPROC_REGION_KEYWORD)
        name: (identifier)
        (procedure_definition
          (PROCEDURE_KEYWORD)
          name: (identifier)
          parameters: (parameters)
          export: (EXPORT_KEYWORD)
          (call_statement
            (method_call
            name: (identifier)
            arguments: (arguments)))
          (ENDPROCEDURE_KEYWORD))
        (PREPROC_ENDREGION_KEYWORD))
        (preprocessor
          (PREPROC_REGION_KEYWORD)
          name: (identifier)
          (procedure_definition
            (PROCEDURE_KEYWORD)
            name: (identifier)
            parameters: (parameters)
            (preprocessor
              (PREPROC_REGION_KEYWORD)
              name: (identifier)
              (assignment_statement
                left: (identifier)
                right: (expression
                  (const_expression
                    (number))))
              (PREPROC_ENDREGION_KEYWORD))
            (ENDPROCEDURE_KEYWORD))
          (PREPROC_ENDREGION_KEYWORD))
      (PREPROC_ENDREGION_KEYWORD))
    (PREPROC_ENDIF_KEYWORD)))

==============================================
Директива компиляции перед процедурой как sibling
==============================================
&НаКлиенте
Процедура Обработать()
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

===============================================
Несколько аннотаций перед функцией как siblings
===============================================
&НаСервере
&После("СоздатьНаСервере")
Функция Обработка()
    Возврат Истина;
КонецФункции
---

(source_file
  (preprocessor
    (annotation))
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (function_definition
    (FUNCTION_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (return_statement
      (RETURN_KEYWORD)
      result: (expression
        (const_expression
          (boolean
            (TRUE_KEYWORD)))))
    (ENDFUNCTION_KEYWORD)))

=====================================================
Директива компиляции перед переменной модуля как sibling
=====================================================
&НаСервере
Перем ОбщийФлаг Экспорт;
---

(source_file
  (preprocessor
    (annotation))
  (var_definition
    (VAR_KEYWORD)
    variable: (variable_spec
      name: (identifier))
    export: (EXPORT_KEYWORD)))
