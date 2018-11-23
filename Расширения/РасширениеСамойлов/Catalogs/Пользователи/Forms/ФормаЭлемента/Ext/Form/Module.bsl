﻿&НаСервере
Процедура ПрочитатьТаблицы()
	
	//Самойлов А.С. Начало 2018-09-03 #1932
	Если НЕ ЗначениеЗаполнено(ДатаАктуальности) Тогда
		
		ДатаАктуальности = НачалоМесяца(ТекущаяДата());
		
	КонецЕсли;
	//Самойлов А.С. Конец  2018-09-03
	
	//Таблица партнеров
	НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица партнеров для мотивации"));
		
	ТаблицаВВидеСтроки = ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение];
	
	Если ЗначениеЗаполнено(ТаблицаВВидеСтроки) Тогда
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТаблицаВВидеСтроки);
		Попытка
	       	массивДанные = ПрочитатьJSON(ЧтениеJSON);
		Исключение
			Возврат;
		КонецПопытки;
		
		Для Каждого стрДанные Из массивДанные Цикл
			
			новСтрока = ТаблицаМотивацияГрузовойОтдел.Добавить();
			новСтрока.Партнер = Справочники.Партнеры.ПолучитьСсылку(Новый УникальныйИдентификатор(стрДанные.Партнер));
			новСтрока.Коэффициенты = стрДанные.Коэффициенты;
			
		КонецЦикла;
		
	КонецЕсли;
	
	//Таблица KPI
	НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица KPI"));
		
	ТаблицаВВидеСтроки = ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение];
	
	Если ЗначениеЗаполнено(ТаблицаВВидеСтроки) Тогда
				
		тз = ЗначениеИзСтрокиВнутр(ТаблицаВВидеСтроки);
		
		//Самойлов А.С. Начало 2018-09-03 #1932
		Если ТипЗнч(тз) = Тип("ТаблицаЗначений") Тогда
		//Самойлов А.С. Конец  2018-09-03		
			ТаблицаKPIГрузовойОтдел.Загрузить(тз);			
		//Самойлов А.С. Начало 2018-09-03 #1932	
		Иначе//Значит соответствие с датами, обязательно сортируем по убыванию дат
			
			ДатаИзТаблицы = '00010101';
			
			Для Каждого КлючИЗначение Из тз Цикл
				
				Если КлючИЗначение.Ключ <= ДатаАктуальности И КлючИЗначение.Ключ > ДатаИзТаблицы Тогда
					
					ДатаИзТаблицы = КлючИЗначение.Ключ;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если ЗначениеЗаполнено(ДатаИзТаблицы) Тогда
				ТаблицаKPIГрузовойОтдел.Загрузить(тз[ДатаИзТаблицы]);
			КонецЕсли;
			
		КонецЕсли;
		//Самойлов А.С. Конец  2018-09-03
			
	КонецЕсли;

	ТаблицыПрочитаны = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшС_СтраницыПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства")
		И ТекущаяСтраница.Имя = "СтраницаЭксклюзив"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ТекущаяСтраница.Имя = "СтраницаДополнительныеРеквизиты" Тогда
		
		НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица партнеров для мотивации"));
	
		Если НайденныеСтроки.Количество() = 1 Тогда 
			Элементы[НайденныеСтроки[0].ИмяРеквизитаЗначение].Видимость = Ложь;
		КонецЕсли;
		
		НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица KPI"));
	
		Если НайденныеСтроки.Количество() = 1 Тогда 
			Элементы[НайденныеСтроки[0].ИмяРеквизитаЗначение].Видимость = Ложь;
		КонецЕсли;
		 		
	КонецЕсли;
	
	Если ТекущаяСтраница.Имя = "СтраницаЭксклюзив"
		И НЕ ТаблицыПрочитаны Тогда
		
		ПрочитатьТаблицы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РасшС_ПередЗаписьюНаСервереПеред(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ТаблицыПрочитаны Тогда
		Возврат;
	КонецЕсли;
		
	//Таблица партнеров для мотивации
	массивТаблицаМотивацияГрузовойОтдел = Новый Массив;
	
	Для Каждого Стр Из ТаблицаМотивацияГрузовойОтдел Цикл
		
		структураСтрока = Новый Структура("Партнер,Коэффициенты");
		ЗаполнитьЗначенияСвойств(структураСтрока,Стр);
		структураСтрока.Партнер = Строка(структураСтрока.Партнер.УникальныйИдентификатор());
		
		массивТаблицаМотивацияГрузовойОтдел.Добавить(структураСтрока);
		
	КонецЦикла;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
		
	ЗаписатьJSON(ЗаписьJSON,массивТаблицаМотивацияГрузовойОтдел);
	
	ТаблицаВВидеСтроки = ЗаписьJSON.Закрыть();
	
	НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица партнеров для мотивации"));
	
	Если ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение] <> ТаблицаВВидеСтроки Тогда
		 ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение]  = ТаблицаВВидеСтроки;
	КонецЕсли;
	 
	//Таблица KPI
	НайденныеСтроки = ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Наименование", "Таблица KPI"));
	
	Если ЗначениеЗаполнено(ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение]) Тогда
		ДанныеИзБазы = ЗначениеИзСтрокиВнутр(ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение]);
	Иначе
		ДанныеИзБазы = Новый Соответствие;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеИзБазы) = Тип("ТаблицаЗначений") Тогда
		ДанныеИзБазы = Новый Соответствие;
	КонецЕсли;	
	
	ДанныеИзБазы[ДатаАктуальности] = ТаблицаKPIГрузовойОтдел.Выгрузить();
		
	Если ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение] <> ЗначениеВСтрокуВнутр(ДанныеИзБазы) Тогда
		ЭтаФорма[НайденныеСтроки[0].ИмяРеквизитаЗначение]  = ЗначениеВСтрокуВнутр(ДанныеИзБазы);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура РасшС_ДатаАктуальностиПриИзмененииПосле(Элемент)
	
	ПрочитатьТаблицы();	
	
КонецПроцедуры


