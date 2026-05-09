================
Date literals with optional separators
================
дата = '20170323';
дата = '2017.03.23 10:45:25';
дата = '2017\03\23-10~45~25';
дата = '201703231045';
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (date))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (date))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (date))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (date)))))

================
Date literals reject missing day digit
================
дата = '2017032';
---

(source_file
  (ERROR
    (identifier)
    (UNEXPECTED ''')))

================
Date literals reject odd time precision
================
дата = '201703231';
---

(source_file
  (ERROR
    (identifier)
    (UNEXPECTED ''')))

================
Date literals reject hour-only time
================
дата = '2017032310';
---

(source_file
  (ERROR
    (identifier)
    (UNEXPECTED ''')))
