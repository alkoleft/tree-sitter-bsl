================
String literal with escaped double quotes
================
Возврат "строка ""кавычки""";
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (const_expression
        (string
          (string_content))))))

================
Multiline string with indented continuation lines
================
Возврат "строка1
    |строка2
    |строка3";
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (const_expression
        (string
          (string_content)
          (string_content)
          (string_content))))))

================
Multiline string continuation can contain comment-looking text
================
Возврат "строка1
|// это часть строки
|строка3";
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (const_expression
        (string
          (string_content)
          (string_content)
          (string_content))))))

================
Multiline string in assignment
================
а = "строка1
|строка2";
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (string
          (string_content)
          (string_content))))))

================
Adjacent quoted strings are not implicit concatenation
================
Возврат "строка1"
"строка2";
---

(source_file
  (return_statement
    (RETURN_KEYWORD)
    result: (expression
      (const_expression
        (string
          (string_content)))))
  (ERROR
    (identifier)))
