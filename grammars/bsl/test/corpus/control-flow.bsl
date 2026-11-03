======================
Пока: пустое тело
======================
Пока Истина Цикл
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
    (ENDDO_KEYWORD)))

========================================
Пока: составное условие с Не и И
========================================
Пока а < 10 И Не Готово Цикл
    а = а + 1;
КонецЦикла
---

(source_file
  (while_statement
    (WHILE_KEYWORD)
    (expression
      (binary_expression
        left: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (const_expression
                (number)))))
        operator: (operator)
        right: (expression
          (unary_expression
            operator: (operator)
            argument: (expression
              (identifier))))))
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
    (ENDDO_KEYWORD)))

================================
Для По: числовые границы
================================
Для а = 1 По 10 Цикл
    сумма = сумма + а;
КонецЦикла
---

(source_file
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
    (assignment_statement
      left: (identifier)
      right: (expression
        (binary_expression
          left: (expression
            (identifier))
          operator: (operator)
          right: (expression
            (identifier)))))
    (ENDDO_KEYWORD)))

==========================================
Для По: унарный минус в границах
==========================================
Для а = -10 По -1 Цикл
    результат = результат + а;
КонецЦикла
---

(source_file
  (for_statement
    (FOR_KEYWORD)
    (identifier)
    (expression
      (unary_expression
        operator: (operator)
        argument: (expression
          (const_expression
            (number)))))
    (TO_KEYWORD)
    (expression
      (unary_expression
        operator: (operator)
        argument: (expression
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
            (identifier)))))
    (ENDDO_KEYWORD)))

========================================
Для По: выражение в верхней границе
========================================
Для а = 0 По Счетчик - 1 Цикл
    массив[а] = 0;
КонецЦикла
---

(source_file
  (for_statement
    (FOR_KEYWORD)
    (identifier)
    (expression
      (const_expression
        (number)))
    (TO_KEYWORD)
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
      left: (property_access
        (access
          (identifier))
        (index
          (identifier)))
      right: (expression
        (const_expression
          (number))))
    (ENDDO_KEYWORD)))

======================================
Для Каждого Из: коллекция-переменная
======================================
Для Каждого элемент Из коллекция Цикл
    Сообщить(элемент);
КонецЦикла
---

(source_file
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
    (ENDDO_KEYWORD)))

==========================================
Для Каждого Из: вызов метода объекта
==========================================
Для Каждого элемент Из Объект.Метод() Цикл
    Сообщить(элемент);
КонецЦикла
---

(source_file
  (for_each_statement
    (FOR_KEYWORD)
    (EACH_KEYWORD)
    (identifier)
    (IN_KEYWORD)
    (expression
      (call_expression
        (access
          (identifier))
        (method_call
          name: (identifier)
          arguments: (arguments))))
    (DO_KEYWORD)
    (call_statement
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (identifier)))))
    (ENDDO_KEYWORD)))

====================================
Продолжить и Прервать без разделителя — ERROR
====================================
Пока Истина Цикл
    Продолжить
    Прервать
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
    (continue_statement
      (CONTINUE_KEYWORD))
    (MISSING ";")
    (break_statement
      (BREAK_KEYWORD))
    (ENDDO_KEYWORD)))

==========================================
Продолжить с точкой с запятой в цикле
==========================================
Пока Истина Цикл
    Продолжить;
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
    (continue_statement
      (CONTINUE_KEYWORD))
    (ENDDO_KEYWORD)))

========================================
Прервать с точкой с запятой в цикле Для
========================================
Для а = 1 По 10 Цикл
    Прервать;
КонецЦикла
---

(source_file
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
    (break_statement
      (BREAK_KEYWORD))
    (ENDDO_KEYWORD)))

=================================
Если: ветка Иначе
=================================
Если Истина Тогда
    а = 1;
Иначе
    а = 2;
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
    (assignment_statement
      left: (identifier)
      right: (expression
        (const_expression
          (number))))
    (else_clause
      (ELSE_KEYWORD)
      (assignment_statement
        left: (identifier)
        right: (expression
          (const_expression
            (number)))))
    (ENDIF_KEYWORD)))

========================================
Если: ИначеЕсли и Иначе вместе
========================================
Если а > 0 Тогда
    результат = 1;
ИначеЕсли а = 0 Тогда
    результат = 0;
Иначе
    результат = -1;
КонецЕсли
---

(source_file
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
    (ENDIF_KEYWORD)))

============================================
Если: несколько веток ИначеЕсли подряд
============================================
Если а > 0 Тогда
    результат = 1;
ИначеЕсли а = 0 Тогда
    результат = 0;
ИначеЕсли а < 0 Тогда
    результат = -1;
КонецЕсли
---

(source_file
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
          (unary_expression
            operator: (operator)
            argument: (expression
              (const_expression
                (number)))))))
    (ENDIF_KEYWORD)))

================================================
Композиция: Попытка внутри цикла Пока
================================================
Пока Истина Цикл
    Попытка
        Действие();
    Исключение
        Сообщить("Ошибка");
    КонецПопытки;
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
    (try_statement
      (TRY_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments)))
      (EXCEPT_KEYWORD)
      (call_statement
        (method_call
          name: (identifier)
          arguments: (arguments
            (expression
              (const_expression
                (string
                  (string_content)))))))
      (ENDTRY_KEYWORD))
    (ENDDO_KEYWORD)))

========================================
Композиция: вложенные циклы Для
========================================
Для а = 1 По 10 Цикл
    Для б = 1 По 10 Цикл
        результат = результат + а * б;
    КонецЦикла;
КонецЦикла;
---

(source_file
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
      (assignment_statement
        left: (identifier)
        right: (expression
          (binary_expression
            left: (expression
              (identifier))
            operator: (operator)
            right: (expression
              (binary_expression
                left: (expression
                  (identifier))
                operator: (operator)
                right: (expression
                  (identifier)))))))
      (ENDDO_KEYWORD))
    (ENDDO_KEYWORD)))

=============================================
Композиция: Если с Прервать внутри Пока
=============================================
Пока а < 10 Цикл
    Если а > 5 Тогда
        Прервать;
    КонецЕсли;
    а = а + 1;
КонецЦикла
---

(source_file
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
      (break_statement
        (BREAK_KEYWORD))
      (ENDIF_KEYWORD))
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
    (ENDDO_KEYWORD)))
