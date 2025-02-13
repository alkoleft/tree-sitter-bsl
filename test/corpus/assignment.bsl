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
    right: (number))
  (assignment_statement
    left: (identifier)
    right: (string
      (string_content)))
  (assignment_statement
    left: (identifier)
    right: (boolean
      (TRUE_KEYWORD)))
  (assignment_statement
    left: (identifier)
    right: (date))
  (assignment_statement
    left: (identifier)
    right: (string
      (string_content)
      (string_content)))
  (assignment_statement
    left: (identifier)
    right: (call_expression
      (methodCall
        name: (identifier)
        arguments: (arguments
          (string
            (string_content))))))
  (assignment_statement
    left: (identifier)
    right: (UNDEFINED_KEYWORD))
  (assignment_statement
    left: (identifier)
    right: (NULL_KEYWORD))
  (assignment_statement
    left: (identifier)
    right: (binary_expression
      left: (number)
      operator: (operation)
      right: (number)))
  (assignment_statement
    left: (identifier)
    right: (identifier)))

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
      (accessProperty
        name: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessIndex
        index: (number))
      (accessProperty
        name: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (methodCall
        name: (identifier)
        arguments: (arguments))
      (accessProperty
        name: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessCall
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      (accessProperty
        name: (identifier)))
    right: (number)))

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
      (accessIndex
        index: (number)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessIndex
        index: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessIndex
        index: (string
          (string_content))))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessIndex
        index: (call_expression
          (methodCall
            name: (identifier)
            arguments: (arguments)))))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessIndex
        index: (number))
      (accessIndex
        index: (number)))
    right: (number))
  (assignment_statement
    left: (property_access
      (methodCall
        name: (identifier)
        arguments: (arguments))
      (accessIndex
        index: (number)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessCall
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      (accessIndex
        index: (number)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessCall
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      (accessProperty
        name: (identifier))
      (accessIndex
        index: (number)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessProperty
        name: (identifier))
      (accessIndex
        index: (number))
      (accessIndex
        index: (number))
      (accessProperty
        name: (identifier))
      (accessIndex
        index: (number)))
    right: (number)))

================
Присвоение свойству метода
================

Данные().Реквизит = 1;
ЭтотОбъект.Данные().Реквизит = 1;
---

(source_file
  (assignment_statement
    left: (property_access
      (methodCall
        name: (identifier)
        arguments: (arguments))
      (accessProperty
        name: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessCall
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      (accessProperty
        name: (identifier)))
    right: (number)))

================
Присвоение свойству метода
================

Данные().Реквизит = 1;
ЭтотОбъект.Данные().Реквизит = 1;
---

(source_file
  (assignment_statement
    left: (property_access
      (methodCall
        name: (identifier)
        arguments: (arguments))
      (accessProperty
        name: (identifier)))
    right: (number))
  (assignment_statement
    left: (property_access
      (identifier)
      (accessCall
        (methodCall
          name: (identifier)
          arguments: (arguments)))
      (accessProperty
        name: (identifier)))
    right: (number)))
