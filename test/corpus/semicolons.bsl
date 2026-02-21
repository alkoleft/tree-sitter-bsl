================
Двойная точка с запятой после блока
================

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
