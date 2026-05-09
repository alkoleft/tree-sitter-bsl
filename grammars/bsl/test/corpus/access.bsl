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

==================================
Вызов после индексного доступа
==================================

результат = Объект["Метод"](параметр);
результат = Объект["Метод"](параметр).Свойство[0];
Объект["Метод"](параметр);

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (call_expression
        (access
          (identifier))
        (index
          (const_expression
            (string
              (string_content))))
        (arguments
          (expression
            (identifier))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (property_access
        (access
          (access
            (access
              (identifier))
            (index
              (const_expression
                (string
                  (string_content))))
            (arguments
              (expression
                (identifier))))
          (property))
        (index
          (const_expression
            (number))))))
  (call_statement
    (call_expression
      (access
        (identifier))
      (index
        (const_expression
          (string
            (string_content))))
      (arguments
        (expression
          (identifier))))))

===============================================
Ключевые слова как имена после доступа
===============================================

Псевдонимы.Вставить(Псевдонимы.Неопределено, Псевдонимы.Неопределено);
ВходнойПоток.Перейти(СледующийБлок, ПозицияВПотоке.Начало);

---

(source_file
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments
          (expression
            (property_access
              (access
                (identifier))
              (property
                (UNDEFINED_KEYWORD))))
          (expression
            (property_access
              (access
                (identifier))
              (property
                (UNDEFINED_KEYWORD))))))))
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier
          (GOTO_KEYWORD))
        arguments: (arguments
          (expression
            (identifier))
          (expression
            (property_access
              (access
                (identifier))
              (property))))))))
