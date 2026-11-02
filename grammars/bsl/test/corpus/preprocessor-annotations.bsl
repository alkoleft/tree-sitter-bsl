================================
Вставка: директива уровня модуля
================================
#Вставка
а = 1;
#КонецВставки
---

(source_file
  (preprocessor
    (preproc))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (preprocessor
    (preproc)))

==========================================
Insert: английская директива уровня модуля
==========================================
#Insert
а = 1;
#EndInsert
---

(source_file
  (preprocessor
    (preproc))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (preprocessor
    (preproc)))

=================================
Удаление: директива уровня модуля
=================================
#Удаление
б = 2;
#КонецУдаления
---

(source_file
  (preprocessor
    (preproc))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (preprocessor
    (preproc)))

==========================================
Delete: английская директива уровня модуля
==========================================
#Delete
б = 2;
#EndDelete
---

(source_file
  (preprocessor
    (preproc))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (preprocessor
    (preproc)))

===================================
Вставка и Удаление в теле процедуры
===================================
Процедура ОбработатьДанные()
    #Вставка
    НовыйКод = 1;
    #КонецВставки
    #Удаление
    СтарыйКод = 2;
    #КонецУдаления
КонецПроцедуры
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (preprocessor
      (preproc))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (preprocessor
      (preproc))
    (preprocessor
      (preproc))
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (preprocessor
      (preproc))
    (ENDPROCEDURE_KEYWORD)))

===============================
Аннотация Перед с именем метода
===============================
&Перед("ПередТестовымНабором")
Процедура МодульПередТестовымНабором()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

================================
Аннотация Вместо с именем метода
================================
&Вместо("СоздатьНаСервере")
Процедура СоздатьНаСервереВместо()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

============================================
Аннотация ИзменениеИКонтроль с именем метода
============================================
&ИзменениеИКонтроль("ЗаполнитьДанныеМодуля")
Процедура ЗаполнитьДанныеМодуляМодуль()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

================================
Аннотация Before с именем метода
================================
&Before("ПередТестовымНабором")
Процедура МодульПередТестовымНабором()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

===============================
Аннотация After с именем метода
===============================
&After("ПослеТестовогоНабора")
Процедура МодульПослеТестовогоНабора()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

=============================================
Директива компиляции и аннотация Перед вместе
=============================================
&НаСервере
&Перед("СоздатьНаСервере")
Процедура ПередСоздатьНаСервере()
КонецПроцедуры
---

(source_file
  (preprocessor
    (annotation))
  (preprocessor
    (annotation)
    (string
      (string_content)))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

==========================================
Область внутри Если с Вставкой и Удалением
==========================================
#Если Сервер Тогда

#Область ИзмененияРасширения

#Вставка
Процедура НоваяПроцедура()
КонецПроцедуры
#КонецВставки

#Удаление
Процедура СтараяПроцедура()
КонецПроцедуры
#КонецУдаления

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
        (preproc))
      (procedure_definition
        (PROCEDURE_KEYWORD)
        name: (identifier)
        parameters: (parameters)
        (ENDPROCEDURE_KEYWORD))
      (preprocessor
        (preproc))
      (preprocessor
        (preproc))
      (procedure_definition
        (PROCEDURE_KEYWORD)
        name: (identifier)
        parameters: (parameters)
        (ENDPROCEDURE_KEYWORD))
      (preprocessor
        (preproc))
      (PREPROC_ENDREGION_KEYWORD))
    (PREPROC_ENDIF_KEYWORD)))
