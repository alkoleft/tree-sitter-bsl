=====================================
Preproc: Или, НЕ и скобки в условии
=====================================
#Если Сервер Или ВнешнееСоединение Тогда
	а = 1;
#КонецЕсли

#Если НЕ Клиент Тогда
	б = 2;
#КонецЕсли

#Если Не (Сервер Или Клиент) Тогда
	в = 3;
#КонецЕсли
---

(source_file
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (identifier))))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ENDIF_KEYWORD))
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (identifier))))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ENDIF_KEYWORD))
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (parenthesized_expression
            (expression
              (binary_expression
                left: (expression
                  (identifier))
                operator: (operator)
                right: (expression
                  (identifier))))))))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ENDIF_KEYWORD)))

========================================
Preproc: составное условие в ИначеЕсли
========================================
#Если Сервер Или ВнешнееСоединение Тогда
	а = 1;
#ИначеЕсли НЕ Клиент И Не ТонкийКлиент Тогда
	б = 2;
#Иначе
	в = 3;
#КонецЕсли
---

(source_file
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (identifier))))
    (THEN_KEYWORD)
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (PREPROC_ELSIF_KEYWORD)
    (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))
        operator: (operator)
        right: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))))
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

=================================================
Вложенный тернарник в условии и методы в ветках
=================================================
а = ?(?(б > 0, б, 0) > 10, "много", "мало");
Сумма = ?(а > 0, Макс(а, б), Мин(а, б));
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (ternary_expression
        condition: (expression
          (binary_expression
            left: (expression
              (ternary_expression
                condition: (expression
                  (binary_expression
                    left: (expression
                      (identifier))
                    operator: (operator)
                    right: (expression
                      (const_expression
                        (number)))))
                consequence: (expression
                  (identifier))
                alternative: (expression
                  (const_expression
                    (number)))))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        consequence: (expression
          (const_expression
            (string
              (string_content))))
        alternative: (expression
          (const_expression
            (string
              (string_content)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (ternary_expression
        condition: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        consequence: (expression
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (identifier))
              (expression
                (identifier)))))
        alternative: (expression
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (identifier))
              (expression
                (identifier)))))))))

=============================
Вложенный тернарник в ветке
=============================
Результат = ?(а > 0, ?(а > 100, "А", "Б"), "В");
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (ternary_expression
        condition: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        consequence: (expression
          (ternary_expression
            condition: (expression
              (binary_expression
                left: (expression
                  (identifier))
                operator: (operator)
                right: (expression
                  (const_expression
                    (number)))))
            consequence: (expression
              (const_expression
                (string
                  (string_content))))
            alternative: (expression
              (const_expression
                (string
                  (string_content))))))
        alternative: (expression
          (const_expression
            (string
              (string_content))))))))

===============================
Тернарник в аргументах вызова
===============================
Сообщить(?(Готово, "да", "нет"));
Результат = Функция1(?(флаг, 1, 2), , Значение);
Объект.Метод(?(флаг, Объект.Поле, ""), ?(Другое, 1, 2));
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (ternary_expression
            condition: (expression
              (identifier))
            consequence: (expression
              (const_expression
                (string
                  (string_content))))
            alternative: (expression
              (const_expression
                (string
                  (string_content)))))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (ternary_expression
              condition: (expression
                (identifier))
              consequence: (expression
                (const_expression
                  (number)))
              alternative: (expression
                (const_expression
                  (number)))))
          (omitted_argument)
          (expression
            (identifier))))))
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (ternary_expression
              condition: (expression
                (identifier))
              consequence: (expression
                (property_access
                  (access
                    (identifier))
                  (property)))
              alternative: (expression
                (const_expression
                  (string
                    (string_content))))))
          (expression
            (ternary_expression
              condition: (expression
                (identifier))
              consequence: (expression
                (const_expression
                  (number)))
              alternative: (expression
                (const_expression
                  (number))))))))))

========================================
Композиция вызов-индекс-вызов-свойство
========================================
Результат = Объект.Метод()[0].Метод2(1).Свойство;
Сообщить(Объект.Метод()[0].Свойство);
Объект.Метод()[0].Метод2(1);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (property_access
        (access
          (access
            (access
              (access
                (identifier))
              (method_call
                name: (identifier)
                arguments: (arguments)))
            (index
              (const_expression
                (number))))
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (const_expression
                  (number))))))
        (property))))
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (property_access
            (access
              (access
                (access
                  (identifier))
                (method_call
                  name: (identifier)
                  arguments: (arguments)))
              (index
                (const_expression
                  (number))))
            (property))))))
  (call_statement
    (call_expression
      (access
        (access
          (access
            (identifier))
          (method_call
            name: (identifier)
            arguments: (arguments)))
        (index
          (const_expression
            (number))))
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (number))))))))

==========================================
Omitted args в глубоких цепочках доступа
==========================================
Объект.Свойство.Метод(, арг2, , арг4).Другой(1)[2].Поле = 3;
Структура.Вставить("Ключ")[0].Поле();
---

(source_file
  (assignment_statement
    left: (property_access
      (access
        (access
          (access
            (access
              (access
                (identifier))
              (property))
            (method_call
              name: (identifier)
              arguments: (arguments
                (omitted_argument)
                (expression
                  (identifier))
                (omitted_argument)
                (expression
                  (identifier)))))
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (const_expression
                  (number))))))
        (index
          (const_expression
            (number))))
      (property))
    right: (expression
      (const_expression
        (number))))
  (call_statement
    (call_expression
      (access
        (access
          (access
            (identifier))
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (const_expression
                  (string
                    (string_content)))))))
        (index
          (const_expression
            (number))))
      (method_call
        name: (identifier)
        arguments: (arguments)))))

=====================================
Английские Try, Raise, Goto и Label
=====================================
Try
    DoSomething();
Except
    Raise "Error";
EndTry;

Goto ~Finish;

~Finish:
---

(source_file
  (try_statement
    (TRY_KEYWORD)
    (call_statement
      (method_call
        name: (identifier)
        arguments: (arguments)))
    (EXCEPT_KEYWORD)
    (rise_error_statement
      (RAISE_KEYWORD)
      (expression
        (const_expression
          (string
            (string_content)))))
    (ENDTRY_KEYWORD))
  (goto_statement
    (GOTO_KEYWORD)
    (identifier))
  (label_statement
    (identifier)))

=======================================
Английские AddHandler и RemoveHandler
=======================================
AddHandler Событие, Обработчик;

RemoveHandler Событие, Обработчик;

AddHandler Форма.Элемент.ПриИзменении, "ОбработчикПриИзменении";
---

(source_file
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
      (const_expression
        (string
          (string_content))))))

==========================================
Многострочная строка в аргументах вызова
==========================================
Сообщить("строка1
|строка2
|строка3");

Запрос.Текст("ВЫБРАТЬ
|	Поле
|ИЗ
|	Таблица");
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (const_expression
            (string
              (string_content)
              (string_content)
              (string_content)))))))
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
                (string_content)
                (string_content)
                (string_content)
                (string_content)))))))))

=========================================
Многострочная строка с пустыми строками
=========================================
Сообщить("первая
|
|третья");

Текст = "
|
|";
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (const_expression
            (string
              (string_content)
              (string_content)
              (string_content)))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (string
          (string_content)
          (string_content)
          (string_content))))))

=========================================================
Многострочная строка в правой части бинарного выражения
=========================================================
Результат = "начало
|продолжение" + Суффикс;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (string
              (string_content)
              (string_content))))
        operator: (operator)
        right: (expression
          (identifier))))))

=======================================
Унарный минус со скобочным операндом
=======================================
а = -(-б);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (parenthesized_expression
            (expression
              (unary_expression
                operator: (operator)
                argument: (expression
                  (identifier))))))))))

=========================================
Двойное НЕ в скобках — валидный BSL
=========================================
а = Не (Не б);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (parenthesized_expression
            (expression
              (unary_expression
                operator: (operator)
                argument: (expression
                  (identifier))))))))))

================================================
Унарный минус в композиции с бинарным выражением
================================================
в = -(а + б) * -в;
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (parenthesized_expression
                (expression
                  (binary_expression
                    left: (expression
                      (identifier))
                    operator: (operator)
                    right: (expression
                      (identifier))))))))
        operator: (operator)
        right: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))))))

==========================================
Двойное НЕ без скобок — невалидный BSL
==========================================
б = Не Не Готово;
---

; двойной НЕ без скобок невалиден в 1С (как и двойной унарный минус,
; см. секцию «Double unary minus is invalid BSL» ниже): recovery съедает
; только первый НЕ в ERROR внутри assignment_statement,
; второй унарный НЕ с identifier парсится нормально
; (после member_name-миграции лишний НЕ в ERROR помечен как operator)
(source_file
  (assignment_statement
    left: (identifier)
    (ERROR
      (operator))
    right: (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (identifier))))))

=============================================
НЕ НЕ с вызовом — невалидный BSL
=============================================
НЕ НЕ Валюта.Пустая();
---

; statement не может начинаться с двух НЕ подряд: оба ключевых слова
; попадают в ERROR, дальше call_statement парсится отдельно.
; Guard для member_name precedence-инварианта (см. grammar.js): member_name
; не должен выигрывать лексическую конкуренцию вне after-dot позиции —
; иначе recovery не находит resync на старте statement и глотает весь
; ввод в один ERROR (метод вызова терялся, @function подсветка тоже).
(source_file
  (ERROR
    (operator)
    (operator))
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments)))))

===================================
Выполнить с многострочной строкой
===================================
Выполнить "Запрос1
|Запрос2
|Запрос3";

Выполнить("Алгоритм
|Тело");
---

(source_file
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content)
          (string_content)
          (string_content)))))
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content)
          (string_content))))))

==================================
Английский Execute с выражениями
==================================
Execute "Алгоритм
|Тело";

Execute("Код");

Execute Объект.Метод();
---

(source_file
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content)
          (string_content)))))
  (execute_statement
    (expression
      (const_expression
        (string
          (string_content)))))
  (execute_statement
    (expression
      (call_expression
        (access
          (identifier))
        (method_call
          name: (identifier)
          arguments: (arguments))))))

===========================================================
Выполнить с бинарным выражением, индексом и конструктором
===========================================================
Выполнить условие + 1;

Выполнить массив[0];

Выполнить Новый Структура;
---

(source_file
  (execute_statement
    (expression
      (binary_expression
        left: (expression
          (identifier))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (execute_statement
    (expression
      (property_access
        (access
          (identifier))
        (index
          (const_expression
            (number))))))
  (execute_statement
    (expression
      (new_expression
        (NEW_KEYWORD)
        type: (identifier)))))

=============================
Пустые блоки Если и Попытка
=============================
Если Готово Тогда
КонецЕсли;

Попытка
Исключение
КонецПопытки;

Если а Тогда
Иначе
КонецЕсли;
---

(source_file
  (if_statement
    (IF_KEYWORD)
    (expression
      (identifier))
    (THEN_KEYWORD)
    (ENDIF_KEYWORD))
  (try_statement
    (TRY_KEYWORD)
    (EXCEPT_KEYWORD)
    (ENDTRY_KEYWORD))
  (if_statement
    (IF_KEYWORD)
    (expression
      (identifier))
    (THEN_KEYWORD)
    (else_clause
      (ELSE_KEYWORD))
    (ENDIF_KEYWORD)))

============================================
Смешанные русские и английские конструкции
============================================
Procedure СмешаннаяПроцедура()
    If Готово Then
        Сообщить("готово");
    EndIf;
    While Счетчик < 10 Do
        Счетчик = Счетчик + 1;
    EndDo;
    Try
        Действие();
    Except
        Raise "ошибка";
    EndTry
EndProcedure

#If Сервер Тогда
	Перем ОбщийФлаг Экспорт;
#EndIf
---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (if_statement
      (IF_KEYWORD)
      (expression
        (identifier))
      (THEN_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments
            (expression
              (const_expression
                (string
                  (string_content)))))))
      (ENDIF_KEYWORD))
    (while_statement
      (WHILE_KEYWORD)
      (expression
        (binary_expression
          left: (expression
            (identifier))
          operator: (operator)
          right: (expression
            (const_expression
              (number)))))
      (DO_KEYWORD)
      (assignment_statement
        left: (identifier)
        right: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number))))))
      (ENDDO_KEYWORD))
    (try_statement
      (TRY_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments)))
      (EXCEPT_KEYWORD)
      (rise_error_statement
        (RAISE_KEYWORD)
        (expression
          (const_expression
            (string
              (string_content)))))
      (ENDTRY_KEYWORD))
    (ENDPROCEDURE_KEYWORD))
  (preprocessor
    (PREPROC_IF_KEYWORD)
    (expression
      (identifier))
    (THEN_KEYWORD)
    (var_definition
      (VAR_KEYWORD)
      variable: (variable_spec
        name: (identifier))
      export: (EXPORT_KEYWORD))
    (empty_statement)
    (PREPROC_ENDIF_KEYWORD)))

================================================================================
Identifier: ё inside identifier in assignment
================================================================================

функцияЁ = 1;

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number)))))

================================================================================
Identifier: procedure name with ё
================================================================================

Функция Тестё()
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
      result: (expression
        (const_expression
          (number))))
    (ENDFUNCTION_KEYWORD)))

================================================================================
Identifier: method call with ё
================================================================================

Резёльтат = Тестё(парамётьё) + Объект.Методё();

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (method_call
            name: (identifier)
            arguments: (arguments
              (expression
                (identifier)))))
        operator: (operator)
        right: (expression
          (call_expression
            (access
              (identifier))
            (method_call
              name: (identifier)
              arguments: (arguments))))))))

======================
Double unary minus is invalid BSL
======================
б = --а;

---

; двойной унарный знак без скобок — невалидный 1С: recovery съедает
; только лишний минус в ERROR внутри assignment_statement,
; сам statement и унарный минус при нём парсятся нормально
(source_file
  (assignment_statement
    left: (identifier)
    (ERROR
      (operator))
    right: (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (identifier))))))

================================================================================
Двойной унарный минус в левом операнде бинарного — невалидный BSL
================================================================================

б = --а + 1;

---

; двойной унарный знак обязан давать ERROR даже внутри более крупного
; бинарного выражения; раньше была лазейка: список операндов унарного
; включал binary_expression, чей левый операнд — полное выражение
(source_file
  (assignment_statement
    left: (identifier)
    (ERROR
      (operator))
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))
        operator: (operator)
        right: (expression
          (const_expression
            (number)))))))

================================================================================
Двойной унарный минус с пробелом перед бинарным умножением — невалидный BSL
================================================================================

б = - -а * в;

---

; двойной унарный знак обязан давать ERROR даже внутри более крупного
; бинарного выражения; раньше была лазейка: список операндов унарного
; включал binary_expression, чей левый операнд — полное выражение
(source_file
  (assignment_statement
    left: (identifier)
    (ERROR
      (operator))
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))
        operator: (operator)
        right: (expression
          (identifier))))))

========================
Унарный минус в обоих операндах бинарного выражения
========================
е = -а + -б;

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))
        operator: (operator)
        right: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))))))
