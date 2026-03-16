================
Новый со скобками и типом-выражением
================

ПустаяСсылка = Новый(ТипИсточника);

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (new_expression_method
        (NEW_KEYWORD)
        type: (expression
          (identifier))))))
