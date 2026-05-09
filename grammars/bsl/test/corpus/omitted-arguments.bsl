===========================================
Repeated omitted arguments in ordinary calls
===========================================
ПоказатьПредупреждение(, "Текст", , "Заголовок");
Метод(а, , , б);
---

(source_file
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (omitted_argument)
        (expression
          (const_expression
            (string
              (string_content))))
        (omitted_argument)
        (expression
          (const_expression
            (string
              (string_content)))))))
  (call_statement
    (method_call
      name: (identifier)
      arguments: (arguments
        (expression
          (identifier))
        (omitted_argument)
        (omitted_argument)
        (expression
          (identifier))))))

=======================================
Repeated omitted arguments in method calls
=======================================
Результат = Реквизит.НайтиТекст(ПредикатОбласти.Текст, , , , Истина, , Истина);
Документ.Область(, НомерКолонки, , НомерКолонки);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
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
                (property)))
            (omitted_argument)
            (omitted_argument)
            (omitted_argument)
            (expression
              (const_expression
                (boolean
                  (TRUE_KEYWORD))))
            (omitted_argument)
            (expression
              (const_expression
                (boolean
                  (TRUE_KEYWORD)))))))))
  (call_statement
    (call_expression
      (access
        (identifier))
      (method_call
        name: (identifier)
        arguments: (arguments
          (omitted_argument)
          (expression
            (identifier))
          (omitted_argument)
          (expression
            (identifier)))))))

==========================================
Repeated omitted arguments in constructors
==========================================
ОписаниеТипа = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(3, 0, ДопустимыйЗнак.Неотрицательный));
Параметры = Новый ПараметрыЗаписиJSON(, СимволыОтступа);
---

(source_file
  (assignment_statement
    left: (identifier)
    right: (expression
      (new_expression
        (NEW_KEYWORD)
        type: (identifier)
        arguments: (arguments
          (expression
            (const_expression
              (string
                (string_content))))
          (omitted_argument)
          (omitted_argument)
          (expression
            (new_expression
              (NEW_KEYWORD)
              type: (identifier)
              arguments: (arguments
                (expression
                  (const_expression
                    (number)))
                (expression
                  (const_expression
                    (number)))
                (expression
                  (property_access
                    (access
                      (identifier))
                    (property))))))))))
  (assignment_statement
    left: (identifier)
    right: (expression
      (new_expression
        (NEW_KEYWORD)
        type: (identifier)
        arguments: (arguments
          (omitted_argument)
          (expression
            (identifier)))))))
