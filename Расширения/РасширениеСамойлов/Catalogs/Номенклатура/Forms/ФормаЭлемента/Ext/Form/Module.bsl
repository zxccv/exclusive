﻿
&НаКлиенте
Процедура РасшС_ИсторияПоступленийПосле(Команда)
	
	ПараметрыОтбора = Новый Структура("Номенклатура", Объект.Ссылка);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов", 
		ПараметрыОтбора, 
		Истина,
		Ложь);
		
	ОткрытьФорму(
		"Отчет.ИсторияПоступленийНоменклатуры.Форма",
		ПараметрыФормы,
		,
		"Номенклатура = " + Объект.Ссылка);
	
КонецПроцедуры
