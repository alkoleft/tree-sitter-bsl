================
CR-only: комментарий в середине модуля
================

Процедура П()	А = 1;	// контроль	Б = 2;КонецПроцедуры

---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (assignment_statement
      left: (identifier)
      right: (expression (const_expression (number))))
    (line_comment)
    (assignment_statement
      left: (identifier)
      right: (expression (const_expression (number))))
    (ENDPROCEDURE_KEYWORD)))

================
CR-only: комментарий поглощал файл до фикса
================

// шапкаА = 1;

---

(source_file
  (line_comment)
  (assignment_statement
    left: (identifier)
    right: (expression (const_expression (number)))))

================
CRLF: комментарий в середине модуля
================

Процедура П()
	А = 1;
	// контроль
	Б = 2;
КонецПроцедуры

---

(source_file
  (procedure_definition
    (PROCEDURE_KEYWORD)
    name: (identifier)
    parameters: (parameters)
    (assignment_statement
      left: (identifier)
      right: (expression (const_expression (number))))
    (line_comment)
    (assignment_statement
      left: (identifier)
      right: (expression (const_expression (number))))
    (ENDPROCEDURE_KEYWORD)))

================
LF: комментарий перед кодом
================

// шапка
А = 1;

---

(source_file
  (line_comment)
  (assignment_statement
    left: (identifier)
    right: (expression (const_expression (number)))))

================
Пустой комментарий в конце файла без терминатора
================

А = 1;//

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression (const_expression (number))))
  (line_comment))

================
Двойной CR между операторами
================

А = 1;Б = 2;

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression (const_expression (number))))
  (assignment_statement
    left: (identifier)
    right: (expression (const_expression (number)))))

