&НаКлиенте
Асинх Процедура УстановитьПервые(Команда)
	
	Сколько = Ждать ВвестиЧислоАсинх(1000);
	Ждать ВвестиЧислоАсинх(1000);
	Обещание = ВвестиЧислоАсинх(1000);
	Ждать Обещание;
	Сколько = Ждать Обещание;
	ИзменитьФлажки(Истина, Сколько);
	
КонецПроцедуры