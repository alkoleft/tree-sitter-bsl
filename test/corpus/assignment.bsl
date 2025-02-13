================
assignment const
================

А = 1;
А = "1";
А = true;
А = '20210101235959';

---

(source_file
  (assignment_statement
    (leftValue
      (identifier))
    (identifier))
  (assignment_statement
    (leftValue
      (identifier))
    (constValue
      (string
        (string_content))))
  (assignment_statement
    (leftValue
      (identifier))
    (identifier))
  (assignment_statement
    (leftValue
      (identifier))
    (constValue
      (date))))

================
assignment simple
================

F = 1 + 1;

---

(source_file
  (assignment_statement
    (leftValue
      (identifier))
    (binary_expression
      (identifier)
      (operation)
      (identifier))))