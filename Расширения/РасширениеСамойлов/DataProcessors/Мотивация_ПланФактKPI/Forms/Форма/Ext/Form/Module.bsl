﻿&НаСервере
Функция СоздатьТаблицуДанных()
	
	//Самойлов А.С. Начало 2018-09-04 #1932
	//тзПоказателиМенеджеров = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьТаблицуПоказателейМенеджеров();
	тзПоказателиМенеджеров = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьТаблицуПоказателейМенеджеров(Объект.Период);
	//Самойлов А.С. Конец  2018-09-04
		
	тзПоказателиМенеджеров.Свернуть("Показатель");
	
	тзДанные = Новый ТаблицаЗначений;
	//Самойлов А.С. Начало 2018-05-11 #1537
	//тзДанные.Колонки.Добавить("Менеджер",Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	тзДанные.Колонки.Добавить("Менеджер",Новый ОписаниеТипов("СправочникСсылка.Пользователи,СправочникСсылка.ГруппыПользователей"));
	//Самойлов А.С. Конец  2018-05-11
	
	ЗапросПоказатели = Новый Запрос;
	ЗапросПоказатели.Текст =
	"ВЫБРАТЬ
	|	Экс_KPIМенеджеровГрузовогоОтдела.Ссылка КАК Показатель,
	|	Экс_KPIМенеджеровГрузовогоОтдела.ФактЗадаётсяВручную,
	|	Экс_KPIМенеджеровГрузовогоОтдела.ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.Экс_KPIМенеджеровГрузовогоОтдела КАК Экс_KPIМенеджеровГрузовогоОтдела
	|ГДЕ
	|	Экс_KPIМенеджеровГрузовогоОтдела.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Экс_KPIМенеджеровГрузовогоОтдела.Наименование";
	
	ВыборкаПоказатели = ЗапросПоказатели.Выполнить().Выбрать();
	
	Пока ВыборкаПоказатели.Следующий() Цикл
		
		Если тзПоказателиМенеджеров.Найти(ВыборкаПоказатели.Показатель,"Показатель") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		УИДПоказателя = СтрЗаменить(Строка(ВыборкаПоказатели.Показатель.УникальныйИдентификатор()),"-","_");
		
		тзДанные.Колонки.Добавить("Показатель_" + УИДПоказателя + "_Использование",Новый ОписаниеТипов("Булево"));
		тзДанные.Колонки.Добавить("Показатель_" + УИДПоказателя + "_План",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10,2)));
		Если ВыборкаПоказатели.ФактЗадаётсяВручную Тогда
			тзДанные.Колонки.Добавить("Показатель_" + УИДПоказателя + "_Факт",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10,2)));
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат тзДанные;	
	
КонецФункции

&НаСервере
Процедура ДобавитьТаблицуНаФорму(тзДанные)
	
	УстановитьПривилегированныйРежим(Истина);
	тзНастройки = ХранилищеОбщихНастроек.Загрузить("НастройкиЭксклюзив","ГруппыПользователейМотивацииГрузовогоОтдела",,"НастройкиЭксклюзив");
		
	Если ТипЗнч(тзНастройки) = Тип("ТаблицаЗначений") И тзНастройки.Количество() > 0 Тогда		
		
		СписокГрупп = тзНастройки.ВыгрузитьКолонку("ГруппаПользователей");
		
	Иначе
		ВызватьИсключение "Нет настроек";
	КонецЕсли;
	
	МассивДобавляемыхРеквизитов = Новый Массив;
    Для Каждого Колонка Из тзДанные.Колонки Цикл
        МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения,"ТаблицаДанных" ,Колонка.Заголовок));  
    КонецЦикла;
         
    ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	текущаяГруппа = Элементы["ТаблицаДанных"];
	
	Для Каждого Колонка Из тзДанные.Колонки Цикл		
		
		Если Прав(Колонка.Имя,14) = "_Использование" Тогда
			НоваяКолонка = Элементы.Добавить("ТаблицаДанных" + Колонка.Имя, Тип("ПолеФормы"), Элементы["ТаблицаДанных"]);
			НоваяКолонка.Заголовок = Колонка.Заголовок;
			НоваяКолонка.ПутьКДанным = "ТаблицаДанных" + "." + Колонка.Имя;
			НоваяКолонка.Вид = ВидПоляФормы.ПолеВвода;			
			НоваяКолонка.Видимость = Ложь;
						
			//Показатель = Справочники.Экс_KPIМенеджеровГрузовогоОтдела[Лев(Колонка.Имя,СтрДлина(Колонка.Имя)-14)];
			Показатель = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьСсылку(
				Новый УникальныйИдентификатор(СтрЗаменить(Сред(Колонка.Имя,12,36),"_","-")));
				
			УИДПоказателя = СтрЗаменить(Строка(Показатель.УникальныйИдентификатор()),"-","_");
						
			текущаяГруппа =  Элементы.Добавить("ТаблицаДанныхПоказатель_" + УИДПоказателя,Тип("ГруппаФормы"),Элементы["ТаблицаДанных"]);			
			текущаяГруппа.Заголовок = Показатель.Наименование;
			текущаяГруппа.ОтображатьВШапке = Истина;
			текущаяГруппа.Группировка = ГруппировкаКолонок.Горизонтальная;
			текущаяГруппа.Высота = 3;			
			текущаяГруппа.Ширина = 1;
			Продолжить;
		КонецЕсли;
		
		НоваяКолонка = Элементы.Добавить("ТаблицаДанных" + Колонка.Имя, Тип("ПолеФормы"), текущаяГруппа);
		НоваяКолонка.Заголовок = ?(Колонка.Имя = "Менеджер",Колонка.Имя,Прав(Колонка.Имя,4));
		НоваяКолонка.ПутьКДанным = "ТаблицаДанных" + "." + Колонка.Имя;
		НоваяКолонка.Вид = ВидПоляФормы.ПолеВвода;
		НоваяКолонка.РежимРедактирования = РежимРедактированияКолонки.ВходПриВводе;
				
		Если Колонка.Имя = "Менеджер" Тогда
			ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
			ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДанных" + Колонка.Имя);
			ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДанных.Менеджер");
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			сзГруппы = Новый СписокЗначений;
			сзГруппы.ЗагрузитьЗначения(СписокГрупп);
			ЭлементОтбора.ПравоеЗначение = сзГруппы;
			ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ЭлементУсловногоОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Шрифт")).Значение,,,Истина));
			//ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",Истина);
			Продолжить;
		КонецЕсли;
		
		НоваяКолонка.Ширина = 10;
		
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДанных" + Колонка.Имя);
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаДанных.Показатель_" + УИДПоказателя + "_Использование");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ложь; 
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СеребристоСерый);
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",Истина);
		
	КонецЦикла;               
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицу(тзДанные)
	
	УстановитьПривилегированныйРежим(Истина);
	тзНастройки = ХранилищеОбщихНастроек.Загрузить("НастройкиЭксклюзив","ГруппыПользователейМотивацииГрузовогоОтдела",,"НастройкиЭксклюзив");
		
	Если ТипЗнч(тзНастройки) = Тип("ТаблицаЗначений") И тзНастройки.Количество() > 0 Тогда		
		
		СписокГрупп = тзНастройки.ВыгрузитьКолонку("ГруппаПользователей");
		
	Иначе
		ВызватьИсключение "Нет настроек";
	КонецЕсли;
	
	тзДанные.Очистить();
	
	//Самойлов А.С. Начало 2018-09-04 #1932
	//тзKPIМенеджеров = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьТаблицуПоказателейМенеджеров();
	тзKPIМенеджеров = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьТаблицуПоказателейМенеджеров(Объект.Период);
	//Самойлов А.С. Конец  2018-09-04
	
	ЗапросДанныеKPI = Новый Запрос;
	ЗапросДанныеKPI.Текст =
	"ВЫБРАТЬ
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Менеджер,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Показатель,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.План,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Факт
	|ИЗ
	|	РегистрСведений.Экс_ДанныеKPIМенеджеровГрузовогоОтдела КАК Экс_ДанныеKPIМенеджеровГрузовогоОтдела
	|ГДЕ
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Месяц = &Период";
	
	ЗапросДанныеKPI.УстановитьПараметр("Период",Объект.Период);
	
	тзДанныеKPI = ЗапросДанныеKPI.Выполнить().Выгрузить();	
	
	ЗапросМенеджеры = Новый Запрос;
	ЗапросМенеджеры.Текст =
	//Самойлов А.С. Начало 2018-05-11 #1537
	//"ВЫБРАТЬ
	//|	ПользователиДополнительныеРеквизиты.Ссылка КАК Менеджер
	//|ИЗ
	//|	Справочник.Пользователи.ДополнительныеРеквизиты КАК ПользователиДополнительныеРеквизиты
	//|ГДЕ
	//|	ПользователиДополнительныеРеквизиты.Свойство = &СвойствоРасчет
	//|	И ПользователиДополнительныеРеквизиты.Значение = ИСТИНА
	//|УПОРЯДОЧИТЬ ПО
	//|	ПользователиДополнительныеРеквизиты.Ссылка.Наименование";
	"ВЫБРАТЬ
	|	ПользователиДополнительныеРеквизиты.Ссылка КАК Менеджер,
	|	ГруппыПользователей.Группа КАК Группа
	|ИЗ
	|	Справочник.Пользователи.ДополнительныеРеквизиты КАК ПользователиДополнительныеРеквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ГруппыПользователейСостав.Пользователь КАК Пользователь,
	|			МАКСИМУМ(ГруппыПользователейСостав.Ссылка) КАК Группа
	|		ИЗ
	|			Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|		ГДЕ
	|			ГруппыПользователейСостав.Ссылка В (&ГруппыПользователей)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ГруппыПользователейСостав.Пользователь) КАК ГруппыПользователей
	|		ПО ПользователиДополнительныеРеквизиты.Ссылка = ГруппыПользователей.Пользователь
	|ГДЕ
	|	ПользователиДополнительныеРеквизиты.Свойство = &СвойствоРасчет
	|	И ПользователиДополнительныеРеквизиты.Значение = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыПользователей.Группа.Наименование,
	|	ПользователиДополнительныеРеквизиты.Ссылка.Наименование";
	
	ЗапросМенеджеры.УстановитьПараметр("ГруппыПользователей",СписокГрупп);
	//Самойлов А.С. Конец  2018-05-11
	
	ЗапросМенеджеры.УстановитьПараметр("СвойствоРасчет",ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Заголовок","Расчет мотивации грузового отдела"));
	
	ВыборкаМенеджеры = ЗапросМенеджеры.Выполнить().Выбрать();
	
	//Самойлов А.С. Начало 2018-05-11 #1537
	ТекущаяГруппа = Неопределено;
	//Самойлов А.С. Конец  2018-05-11
	
	Пока ВыборкаМенеджеры.Следующий() Цикл
		
		//Самойлов А.С. Начало 2018-05-11 #1537
		Если ТекущаяГруппа <> ВыборкаМенеджеры.Группа Тогда
			новСтрока = тзДанные.Добавить();
			новСтрока.Менеджер = ВыборкаМенеджеры.Группа;
			ТекущаяГруппа = ВыборкаМенеджеры.Группа;
		КонецЕсли;		
		//Самойлов А.С. Конец  2018-05-11
		
		новСтрока = тзДанные.Добавить();
		новСтрока.Менеджер = ВыборкаМенеджеры.Менеджер;
		
		Для Каждого Колонка Из тзДанные.Колонки Цикл
			
			Если НЕ Прав(Колонка.Имя,14) = "_Использование" Тогда
				Продолжить;
			КонецЕсли;
			
			Показатель = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьСсылку(
				Новый УникальныйИдентификатор(СтрЗаменить(Сред(Колонка.Имя,12,36),"_","-")));
			УИДПоказателя = СтрЗаменить(Строка(Показатель.УникальныйИдентификатор()),"-","_");
			
			Если тзKPIМенеджеров.НайтиСтроки(Новый Структура("Менеджер,Показатель",ВыборкаМенеджеры.Менеджер,Показатель)).Количество() > 0 Тогда
				новСтрока[Колонка.Имя] = Истина;
			КонецЕсли;
			
			строкиДанныеKPI = тзДанныеKPI.НайтиСтроки(Новый Структура("Менеджер,Показатель",ВыборкаМенеджеры.Менеджер,Показатель));
			
			Если строкиДанныеKPI.Количество() > 0 Тогда
				строкаДанныеKPI = строкиДанныеKPI[0];
				
				КолонкаПлан = тзДанные.Колонки.Найти("Показатель_" + УИДПоказателя + "_План");
				Если КолонкаПлан <> Неопределено Тогда
					новСтрока[КолонкаПлан.Имя] = строкаДанныеKPI.План;					
				КонецЕсли;
				
				КолонкаФакт = тзДанные.Колонки.Найти("Показатель_" + УИДПоказателя + "_Факт");
				Если КолонкаФакт <> Неопределено Тогда
					новСтрока[КолонкаФакт.Имя] = строкаДанныеKPI.Факт;					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Период = НачалоМесяца(ТекущаяДата());
	
	тзДанные = СоздатьТаблицуДанных();
	ДобавитьТаблицуНаФорму(тзДанные);
	ЗаполнитьТаблицу(тзДанные);
	ЗначениеВРеквизитФормы(тзДанные, "ТаблицаДанных");
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()
	тзДанные = РеквизитФормыВЗначение("ТаблицаДанных"); 
	ЗаполнитьТаблицу(тзДанные);
	ЗначениеВРеквизитФормы(тзДанные, "ТаблицаДанных");	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ПериодПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеНаСервере()
	тзДанные = РеквизитФормыВЗначение("ТаблицаДанных");
	Для Каждого стрДанные Из тзДанные Цикл
		
		Для Каждого Колонка Из тзДанные.Колонки Цикл
			
			Если Прав(Колонка.Имя,14) = "_Использование" И стрДанные[Колонка.Имя] = Истина Тогда
				
				Показатель = Справочники.Экс_KPIМенеджеровГрузовогоОтдела.ПолучитьСсылку(
					Новый УникальныйИдентификатор(СтрЗаменить(Сред(Колонка.Имя,12,36),"_","-")));
				УИДПоказателя = СтрЗаменить(Строка(Показатель.УникальныйИдентификатор()),"-","_");
						
				мзДанныеKPI = РегистрыСведений.Экс_ДанныеKPIМенеджеровГрузовогоОтдела.СоздатьМенеджерЗаписи();
				мзДанныеKPI.Месяц = Объект.Период;
				мзДанныеKPI.Менеджер = стрДанные.Менеджер;
				мзДанныеKPI.Показатель = Показатель;
				мзДанныеKPI.Прочитать();
				
				КолонкаПлан = тзДанные.Колонки.Найти("Показатель_" + УИДПоказателя + "_План");
				Если КолонкаПлан <> Неопределено Тогда
					План = стрДанные[КолонкаПлан.Имя];
				Иначе
					План = 0;
				КонецЕсли;
				
				КолонкаФакт = тзДанные.Колонки.Найти("Показатель_" + УИДПоказателя + "_Факт");
				Если КолонкаФакт <> Неопределено Тогда
					Факт = стрДанные[КолонкаФакт.Имя];
				Иначе
					Факт = 0;
				КонецЕсли;
				
				Если мзДанныеKPI.План <> План
					ИЛИ мзДанныеKPI.Факт <> Факт Тогда
					
					мзДанныеKPI.Месяц = Объект.Период;
					мзДанныеKPI.Менеджер = стрДанные.Менеджер;
					мзДанныеKPI.Показатель = Показатель;
					мзДанныеKPI.План = План;
					мзДанныеKPI.Факт = Факт;
					мзДанныеKPI.Записать();				
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	ЗаписатьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПеренестиПланПрошлогоМесяцаНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ТекущийПериод КАК Месяц,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Менеджер,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Показатель,
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.План,
	|	0 КАК Факт
	|ИЗ
	|	РегистрСведений.Экс_ДанныеKPIМенеджеровГрузовогоОтдела КАК Экс_ДанныеKPIМенеджеровГрузовогоОтдела
	|ГДЕ
	|	Экс_ДанныеKPIМенеджеровГрузовогоОтдела.План > 0
	|	И Экс_ДанныеKPIМенеджеровГрузовогоОтдела.Месяц = &ПрошлыйПериод";
	
	Запрос.УстановитьПараметр("ТекущийПериод",Объект.Период);
	Запрос.УстановитьПараметр("ПрошлыйПериод",ДобавитьМесяц(Объект.Период,-1));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		мз = РегистрыСведений.Экс_ДанныеKPIМенеджеровГрузовогоОтдела.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(мз,Выборка);
		мз.Записать();
		
	КонецЦикла;
	
	тзДанные = РеквизитФормыВЗначение("ТаблицаДанных"); 
	ЗаполнитьТаблицу(тзДанные);
	ЗначениеВРеквизитФормы(тзДанные, "ТаблицаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиПланПрошлогоМесяца(Команда)
	ПеренестиПланПрошлогоМесяцаНаСервере();
КонецПроцедуры
