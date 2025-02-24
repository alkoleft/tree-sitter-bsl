================
Доступ к свойству
================

a = А.Б.В.Г;
a = А[0].Б.В.Г;
a = А.Б[1][2].В.Г;
a = А.Б.В.Г[3];

---

(source_file
  (assignment_statement
    (identifier)
    (expression
      (property_access
        (access
          (access
            (access
              (identifier))
            (property))
          (property))
        (property))))
  (assignment_statement
    (identifier)
    (expression
      (property_access
        (access
          (access
            (access
              (access
                (identifier))
              (index
                (const_expression
                  (number))))
            (property))
          (property))
        (property))))
  (assignment_statement
    (identifier)
    (expression
      (property_access
        (access
          (access
            (access
              (access
                (access
                  (identifier))
                (property))
              (index
                (const_expression
                  (number))))
            (index
              (const_expression
                (number))))
          (property))
        (property))))
  (assignment_statement
    (identifier)
    (expression
      (property_access
        (access
          (access
            (access
              (access
                (identifier))
              (property))
            (property))
          (property))
        (index
          (const_expression
            (number)))))))
