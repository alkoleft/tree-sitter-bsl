===============================================
Английские ключевые слова: процедура с условием
===============================================
&AtClient
Procedure CheckValue(Value)
    Var result;
    If Value > 0 Then
        result = 1;
    ElsIf Value = 0 Then
        result = 0;
    Else
        result = -1;
    EndIf;
    Return result;
EndProcedure
---

(source_file
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier)))
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier))
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
      (assignment_statement
        left: (identifier)
        right: (expression
          (const_expression
            (number))))
      (elseif_clause
        (ELSIF_KEYWORD)
        (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        (THEN_KEYWORD)
        (assignment_statement
          left: (identifier)
          right: (expression
            (const_expression
              (number)))))
      (else_clause
        (ELSE_KEYWORD)
        (assignment_statement
          left: (identifier)
          right: (expression
            (unary_expression
              operator: (operator)
              argument: (expression
                (const_expression
                  (number)))))))
      (ENDIF_KEYWORD))
    (return_statement
      (RETURN_KEYWORD)
      result: (expression
        (identifier)))
    (ENDPROCEDURE_KEYWORD)))

================================
Английские ключевые слова: циклы
================================
Procedure ProcessItems(Count)
    Var i;
    For i = 1 To Count Do
        Continue;
    EndDo
    While True Do
        Break;
    EndDo
    For Each Item In Items Do
        Message(Item);
    EndDo
EndProcedure
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier)))
    (var_statement
      (VAR_KEYWORD)
      var_name: (identifier))
    (for_statement
      (FOR_KEYWORD)
      (identifier)
      (expression
        (const_expression
          (number)))
      (TO_KEYWORD)
      (expression
        (identifier))
      (DO_KEYWORD)
      (continue_statement
        (CONTINUE_KEYWORD))
      (ENDDO_KEYWORD))
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
    (for_each_statement
      (FOR_KEYWORD)
      (EACH_KEYWORD)
      (identifier)
      (IN_KEYWORD)
      (expression
        (identifier))
      (DO_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments
            (expression
              (identifier)))))
      (ENDDO_KEYWORD))
    (ENDPROCEDURE_KEYWORD)))

=============================
Комментарии в разных позициях
=============================
// Комментарий перед процедурой
Процедура Т()
    // Комментарий внутри тела
    а = 1; // Комментарий в конце строки
КонецПроцедуры

// Комментарий перед оператором модуля
б = 2; // Комментарий в конце строки
---

(source_file
  (line_comment)
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (line_comment)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (line_comment)
    (ENDPROCEDURE_KEYWORD))
  (line_comment)
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (line_comment))

=====================================
Скобочный Выполнить с идентификатором
=====================================
Выполнить(Алгоритм);
---

(source_file
  (execute_statement
    (expression
      (identifier))))

=====================================
ТипЗнч и Вычислить как вызовы методов
=====================================
Тип = ТипЗнч(Значение);
Результат = Вычислить("1 + 2");
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (identifier))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (string
                (string_content)))))))))

======================================================
НаСервереБезКонтекста и английские серверные директивы
======================================================
&НаСервереБезКонтекста
Процедура ПолучитьДанныеНаСервере()
КонецПроцедуры

&AtServerNoContext
Procedure GetDataAtServer()
EndProcedure

&AtServer
Procedure RecalculateAtServer()
EndProcedure
---

(source_file
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD)))

=============================================================
Директивы НаКлиентеНаСервере и НаКлиентеНаСервереБезКонтекста
=============================================================
&НаКлиентеНаСервере
Процедура Проверить()
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФорматироватьНомер(Номер)
КонецПроцедуры

&AtClientAtServer
Procedure Verify()
EndProcedure

&AtClientAtServerNoContext
Procedure FormatNumber(Number)
EndProcedure
---

(source_file
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier)))
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (annotation))
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters
      parameter: (parameter
        name: (identifier)))
    (ENDPROCEDURE_KEYWORD)))
