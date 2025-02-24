================
Присвоение переменной
================

А = 1;
А = "1";
А = true;
А = '20210101235959';
А = "1
|2";
А = Число("123");
А = Неопределено;
А = Null;
А = 1 + 1;
А = Б;

---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (string
          (string_content)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (boolean
          (TRUE_KEYWORD)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (date))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (string
          (string_content)
          (string_content)))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (call_expression
        (method_call
          name: (identifier)
          arguments: (arguments
            (expression
              (const_expression
                (string
                  (string_content)))))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (UNDEFINED_KEYWORD))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (const_expression
        (NULL_KEYWORD))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (binary_expression
        left: (expression
          (const_expression
            (number)))
        operator: (operator)
        right: (expression
          (const_expression
            (number))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (identifier))))

================
Присвоение свойству
================

Данные.Реквизит = 1;
Данные[0].Реквизит = 1;
Данные().Реквизит = 1;
Данные.Метод().Реквизит = 1;

---

(source_file
  (assignment_statement
    left: (property_access
      (identifier)
      (property))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (const_expression
          (number)))
      (property))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number)))))

================
Присвоение индексу
================

Данные[0] = 1;
Данные[Инд] = 1;
Данные["Реквизит"] = 1;
Данные[Индекс()] = 1;
Данные[0][0] = 1;
Данные()[0] = 1;
Данные.Метод()[0] = 1;
Данные.Метод().Свойство[0] = 1;
Данные.Метод[0][1].Свойство[0] = 1;

---

(source_file
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (identifier)))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (const_expression
          (string
            (string_content)))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (call_expression
          (method_call
            name: (identifier)
            arguments: (arguments)))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (index
        (const_expression
          (number)))
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (method_call
        name: (identifier)
        arguments: (arguments))
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (method_call
        name: (identifier)
        arguments: (arguments))
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property)
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (property)
      (index
        (const_expression
          (number)))
      (index
        (const_expression
          (number)))
      (property)
      (index
        (const_expression
          (number))))
    right: (expression
      (const_expression
        (number)))))

================
Присвоение свойству метода
================

Данные().Реквизит = 1;
ЭтотОбъект.Данные().Реквизит = 1;
---

(source_file
  (assignment_statement
    left: (property_access
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number)))))

================
Присвоение свойству метода
================

Данные().Реквизит = 1;
ЭтотОбъект.Данные().Реквизит = 1;
---

(source_file
  (assignment_statement
    left: (property_access
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number))))
  (assignment_statement
    left: (property_access
      (identifier)
      (method_call
        name: (identifier)
        arguments: (arguments))
      (property))
    right: (expression
      (const_expression
        (number)))))
