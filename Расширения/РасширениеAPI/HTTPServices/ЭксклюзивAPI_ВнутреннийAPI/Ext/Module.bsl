﻿//************************************************
//Общие функции
//************************************************
#Область ОбщиеФункции
Функция ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","application/json");
		
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
		
	ЗаписатьJSON(ЗаписьJSON,структураОтвет);
	
	Ответ.УстановитьТелоИзСтроки(ЗаписьJSON.Закрыть(),КодировкаТекста.UTF8);
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьТелоЗапросаКакСтруктуру(Запрос);
	
	Попытка
		ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
		
		структураЗапрос = ПрочитатьJSON(ЧтениеJSON);
		
		Возврат структураЗапрос;
		
	Исключение
		
		Возврат Неопределено;
		                        
	КонецПопытки;
	
КонецФункции

Процедура ПроверитьЗаполненностьОбязательныхПараметров(структураЗапрос,структураОбязательныхПараметров,ОписаниеОшибок,ПутьКЗначениям = "")
	
	Для Каждого ОбязательныйПараметр Из структураОбязательныхПараметров Цикл
		
		Если НЕ структураЗапрос.Свойство(ОбязательныйПараметр.Ключ) Тогда
			Если ОписаниеОшибок <> "" Тогда
				ОписаниеОшибок = ОписаниеОшибок + Символы.ПС;
			КонецЕсли;
			ОписаниеОшибок = ОписаниеОшибок + ПутьКЗначениям + "Отсутствует обязательный параметр " + ОбязательныйПараметр.Ключ;
			Продолжить;
		КонецЕсли;
		
		ПроверяемоеЗначение = структураЗапрос[ОбязательныйПараметр.Ключ];
		
		Если Тип(ОбязательныйПараметр.Значение) = Тип("Структура") Тогда
			
			Если ТипЗнч(ПроверяемоеЗначение) = Тип("Массив") Тогда
				
				Для Н = 0 По ПроверяемоеЗначение.Количество() - 1 Цикл
					
					ПроверитьЗаполненностьОбязательныхПараметров(ПроверяемоеЗначение[Н],ОбязательныйПараметр.Значение,ОписаниеОшибок,ПутьКЗначениям + ОбязательныйПараметр.Ключ + "[" + Н + "].");	
					
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(ПроверяемоеЗначение) = Тип("Структура") Тогда
				
				ПроверитьЗаполненностьОбязательныхПараметров(ПроверяемоеЗначение,ОбязательныйПараметр.Значение,ОписаниеОшибок,ПутьКЗначениям + ОбязательныйПараметр.Ключ + ".");
				
			Иначе
				Если ОписаниеОшибок <> "" Тогда
					ОписаниеОшибок = ОписаниеОшибок + Символы.ПС;
				КонецЕсли;
				ОписаниеОшибок = ОписаниеОшибок + ПутьКЗначениям + "Неправильный тип значения обязательного параметра " + ОбязательныйПараметр.Ключ + ", в этом параметре должен быть массив или структура";
				Продолжить;
			КонецЕсли;
			
		Иначе
								
			Если ТипЗнч(ПроверяемоеЗначение) = Тип("Массив") Тогда
				
				Для Каждого ПроверяемыйЭлемент Из ПроверяемоеЗначение Цикл
					
					Если ТипЗнч(ПроверяемыйЭлемент) <> Тип(ОбязательныйПараметр.Значение) Тогда
				
						Если ОписаниеОшибок <> "" Тогда
							ОписаниеОшибок = ОписаниеОшибок + Символы.ПС;
						КонецЕсли;
						ОписаниеОшибок = ОписаниеОшибок + ПутьКЗначениям + "Неправильный тип значения обязательного параметра " + ОбязательныйПараметр.Ключ + ", должно быть значение типа " + ОбязательныйПараметр.Значение;
						Прервать;
				
					КонецЕсли;	
					
				КонецЦикла;
				
			ИначеЕсли Тип(ОбязательныйПараметр.Значение) = Тип("УникальныйИдентификатор") Тогда
				
				Попытка
					УИД = Новый УникальныйИдентификатор(ПроверяемоеЗначение);
				Исключение
					Если ОписаниеОшибок <> "" Тогда
						ОписаниеОшибок = ОписаниеОшибок + Символы.ПС;
					КонецЕсли;
					ОписаниеОшибок = ОписаниеОшибок + ПутьКЗначениям + "Неправильный тип значения обязательного параметра " + ОбязательныйПараметр.Ключ + ", должно быть значение типа УникальныйИдентификатор";
					Продолжить;		
				КонецПопытки;
				
			ИначеЕсли ТипЗнч(ПроверяемоеЗначение) <> Тип(ОбязательныйПараметр.Значение) Тогда
				
				Если ОписаниеОшибок <> "" Тогда
					ОписаниеОшибок = ОписаниеОшибок + Символы.ПС;
				КонецЕсли;
				ОписаниеОшибок = ОписаниеОшибок + ПутьКЗначениям + "Неправильный тип значения обязательного параметра " + ОбязательныйПараметр.Ключ + ", должно быть значение типа " + ОбязательныйПараметр.Значение;
				Продолжить;	
				
			КонецЕсли;
						
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти

//************************************************
//Обработчики запросов
//************************************************
#Область ОбработчикиЗапросов
Функция VersionGET(Запрос)
	
	структураОтвет = Новый Структура;
	структураОтвет.Вставить("errorCode",0);
	структураОтвет.Вставить("errorDescription","");
	
	УстановитьПривилегированныйРежим(Истина);
	мсвРасширений = РасширенияКонфигурации.Получить(Новый Структура("Имя","РасширениеAPI"));
	
	Если мсвРасширений.Количество() = 0 Тогда
		Версия = "Не установлено";
	КонецЕсли;	
	
	Версия = мсвРасширений[0].Версия;
	
	структураОтвет.Вставить("Version",Версия);
		
	структураОтвет.Вставить("ConfigurationVersion",Метаданные.Версия);
	СисИнфо = Новый СистемнаяИнформация;	
	структураОтвет.Вставить("PlatformVersion",СисИнфо.ВерсияПриложения);
	Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
	
КонецФункции

Функция CreateOrderPOST(Запрос)
	
	структураОтвет = Новый Структура;
	структураОтвет.Вставить("errorCode",0);
	структураОтвет.Вставить("errorDescription","");
	
	структураЗапрос = ПолучитьТелоЗапросаКакСтруктуру(Запрос);
	
	Если структураЗапрос = Неопределено Тогда
		
		структураОтвет.errorCode = 601;
		структураОтвет.errorDescription = "Ошибка парсинга JSON тела запроса";
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;                                                                                             

	Если структураЗапрос.site = "4kolesa.spb.ru" Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(структураЗапрос);
		ФоновыеЗадания.Выполнить("ЭксклюзивAPI_СерверныеПроцедуры.СоздатьЗаказ4kolesa",Параметры, Новый УникальныйИдентификатор, "Создание заказа 4kolesa");
			
		//Самойлов А.С. Начало 2018-10-23 #
		//Ответ = Новый HTTPСервисОтвет(200);
		Ответ = ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		//Самойлов А.С. Конец  2018-10-23
		Возврат Ответ;
	ИначеЕсли структураЗапрос.site = "tyres.spb.ru" Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(структураЗапрос);
		ФоновыеЗадания.Выполнить("ЭксклюзивAPI_СерверныеПроцедуры.СоздатьЗаказTyresSpbRu",Параметры, Новый УникальныйИдентификатор, "Создание заказа tyres");
			
		//Самойлов А.С. Начало 2018-10-23 #
		//Ответ = Новый HTTPСервисОтвет(200);
		Ответ = ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		//Самойлов А.С. Конец  2018-10-23
		Возврат Ответ;
	Иначе
		структураОтвет.errorCode = 602;
		структураОтвет.errorDescription = "Неизвестный сайт " + структураЗапрос.site;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
	КонецЕсли;
		
КонецФункции

//Самойлов А.С. Начало 2018-10-19 #1163
Функция CreateAcquiringPOST(Запрос)
	
	структураОтвет = Новый Структура;
	структураОтвет.Вставить("errorCode",0);
	структураОтвет.Вставить("errorDescription","");
	
	структураЗапрос = ПолучитьТелоЗапросаКакСтруктуру(Запрос);
	
	Если структураЗапрос = Неопределено Тогда
		
		структураОтвет.errorCode = 601;
		структураОтвет.errorDescription = "Ошибка парсинга JSON тела запроса";
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	структураОбязательныхПараметров = Новый Структура("order_id,price,status","Строка","Число","Строка");
	ОписаниеОшибок = "";
	ПроверитьЗаполненностьОбязательныхПараметров(структураЗапрос,структураОбязательныхПараметров,ОписаниеОшибок);
	
	Если ЗначениеЗаполнено(ОписаниеОшибок) Тогда
		
		структураОтвет.errorCode = 602;
		структураОтвет.errorDescription = ОписаниеОшибок;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	Если НЕ структураЗапрос.status = "hold" Тогда
		
		структураОтвет.errorCode = 100;
		структураОтвет.errorDescription = "Неизвестный статус " + структураЗапрос.status;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;	
	
	Заказ = Документы.ЗаказКлиента.ПолучитьСсылку(Новый УникальныйИдентификатор(структураЗапрос.order_id));
	
	Если НЕ ЗначениеЗаполнено(Заказ.Номер) Тогда
		
		структураОтвет.errorCode = 101;
		структураОтвет.errorDescription = "Не найден заказ с идентификатором " + структураЗапрос.order_id;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	Если Заказ.СуммаДокумента <> структураЗапрос.price Тогда
		
		структураОтвет.errorCode = 102;
		структураОтвет.errorDescription = "По данным 1С сумма документа составляет " + Заказ.СуммаДокумента + " р., а в запросе передана сумма " + структураЗапрос.price + " р. ";  		
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	ЗапросЭО = Новый Запрос;
	ЗапросЭО.Текст =
	"ВЫБРАТЬ
	|	ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК ОперацияПоПлатежнойКартеРасшифровкаПлатежа
	|ГДЕ
	|	ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Заказ = &Заказ
	|	И ОперацияПоПлатежнойКартеРасшифровкаПлатежа.Ссылка.ПометкаУдаления = ЛОЖЬ";
	
	ЗапросЭО.УстановитьПараметр("Заказ",Заказ);
	
	Если НЕ ЗапросЭО.Выполнить().Пустой() Тогда
		
		структураОтвет.errorCode = 103;
		структураОтвет.errorDescription = "По документу " + Заказ + " уже введены документы оплаты";  		
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	настройкиЭквайринга = Экс_ОбщегоНазначенияСервер.ПолучитьВнешнююНастройку("ИнтернетЭквайринг",Истина,Ложь);
	
	стрНастройкаЭквайринга = настройкиЭквайринга.Найти(Заказ.Организация,"Организация");
	
	Если стрНастройкаЭквайринга = Неопределено Тогда
		
		структураОтвет.errorCode = 104;
		структураОтвет.errorDescription = "Для организации " + Заказ.Организация + " не заданы настройки эквайринга";
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	новОперацияПоПлатежнойКарте = Документы.ОперацияПоПлатежнойКарте.СоздатьДокумент();
	
	новОперацияПоПлатежнойКарте.Дата = ТекущаяДата();
	новОперацияПоПлатежнойКарте.Организация = Заказ.Организация;
	новОперацияПоПлатежнойКарте.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента;
	новОперацияПоПлатежнойКарте.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	новОперацияПоПлатежнойКарте.Контрагент = Заказ.Контрагент;
	новОперацияПоПлатежнойКарте.СуммаДокумента = Заказ.СуммаДокумента;
	новОперацияПоПлатежнойКарте.ЭквайринговыйТерминал = стрНастройкаЭквайринга.ЭквайринговыйТерминал;
	новОперацияПоПлатежнойКарте.НомерПлатежнойКарты = структураЗапрос.card;
	новОперацияПоПлатежнойКарте.ОплатаВыполнена = Ложь;
	новОперацияПоПлатежнойКарте.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	новОперацияПоПлатежнойКарте.Комментарий = "Операция создана по запросу с сайта " + ТекущаяДата();
	
	новСтрРасшифровка = новОперацияПоПлатежнойКарте.РасшифровкаПлатежа.Добавить();
	
	новСтрРасшифровка.Партнер = Заказ.Партнер;
	новСтрРасшифровка.СтатьяДвиженияДенежныхСредств = стрНастройкаЭквайринга.СтатьяДДС;
	новСтрРасшифровка.ОснованиеПлатежа = Заказ;
	новСтрРасшифровка.Заказ = Заказ;
	новСтрРасшифровка.Сумма = новОперацияПоПлатежнойКарте.СуммаДокумента;
	новСтрРасшифровка.СуммаВзаиморасчетов = новОперацияПоПлатежнойКарте.СуммаДокумента;
	новСтрРасшифровка.ВалютаВзаиморасчетов = новОперацияПоПлатежнойКарте.Валюта;
	новСтрРасшифровка.СтавкаНДС = Заказ.Товары[0].СтавкаНДС;
	
	ТекПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(новСтрРасшифровка.СтавкаНДС);			
	новСтрРасшифровка.СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(новСтрРасшифровка.СуммаВзаиморасчетов, ТекПроцентНДС);			
	
	Попытка
		новОперацияПоПлатежнойКарте.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		структураОтвет.errorCode = 105;
		структураОтвет.errorDescription = "Ошибка проведения эквайринговой операции по документу " + Заказ;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
	КонецПопытки;
	
	структураОтвет.Вставить("acquiring_id",Строка(новОперацияПоПлатежнойКарте.Ссылка.УникальныйИдентификатор()));
	Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
КонецФункции
//Самойлов А.С. Конец  2018-10-19

//Притула Р.В. Начало 07.11.2018 #2480
Функция CheckPromocodeGET(Запрос)
	
	структураОтвет = Новый Структура;
	структураОтвет.Вставить("errorCode",0);
	структураОтвет.Вставить("errorDescription","");
	
	структураЗапрос = ПолучитьТелоЗапросаКакСтруктуру(Запрос);
	
	Если структураЗапрос = Неопределено Тогда
		
		структураОтвет.errorCode = 601;
		структураОтвет.errorDescription = "Ошибка парсинга JSON тела запроса";
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	структураОбязательныхПараметров = Новый Структура("promocode","Строка");
	ОписаниеОшибок = "";
	ПроверитьЗаполненностьОбязательныхПараметров(структураЗапрос,структураОбязательныхПараметров,ОписаниеОшибок);
	
	Если ЗначениеЗаполнено(ОписаниеОшибок) Тогда
		
		структураОтвет.errorCode = 602;
		структураОтвет.errorDescription = ОписаниеОшибок;
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;
	
	Промокод = структураЗапрос.promocode;
	
	ТЗСвойствТоваров = Новый ТаблицаЗначений;
	ТЗСвойствТоваров.Колонки.Добавить("ИДТовара");
	ТЗСвойствТоваров.Колонки.Добавить("ВидНоменклатуры");
	ТЗСвойствТоваров.Колонки.Добавить("Количество");
	ТЗСвойствТоваров.Колонки.Добавить("Сумма");
	ТЗСвойствТоваров.Колонки.Добавить("ЦенаРозничная");
	ТЗСвойствТоваров.Колонки.Добавить("ЦенаОптовая");
	ТЗСвойствТоваров.Колонки.Добавить("ЦенаЗакупочная");
	ТЗСвойствТоваров.Колонки.Добавить("ЦенаB2B");
	ТЗСвойствТоваров.Колонки.Добавить("ЦенаМИЦ");	
	ТЗСвойствТоваров.Колонки.Добавить("ДопРеквизит");
	ТЗСвойствТоваров.Колонки.Добавить("Значение");
		
	
	настройкаСоответствиеВидов = Экс_ОбщегоНазначенияСервер.ПолучитьВнешнююНастройку("ОбменССайтом_СоответствиеВидовНоменклатуры",Истина,Ложь);
	настройкаРеквизиты = Экс_ОбщегоНазначенияСервер.ПолучитьВнешнююНастройку("ОбменССайтом_СоответствиеРеквизитов",Истина,Ложь);
		
	массивОшибок = Новый Массив;
		
	Для каждого структураТовар Из структураЗапрос.goods Цикл
		
		строкаВид = настройкаСоответствиеВидов.Найти(структураТовар.type);
		Если строкаВид = Неопределено Тогда
			массивОшибок.Добавить("Не удалось определить вид номенклатуры для типа товара " + структураТовар.type);
			Продолжить;						
		КонецЕсли;
		
		СтруктураОбщихРеквизитов = Новый Структура("ИДТовара, ВидНоменклатуры, Количество, Сумма, ЦенаРозничная, ЦенаОптовая, ЦенаЗакупочная, ЦенаB2B, ЦенаМИЦ",
		                                            структураТовар.good_id_market,
													строкаВид.ВидНоменклатуры,
													структураТовар.quantity,
													структураТовар.sum,
													структураТовар.attributes.price_retail,
													структураТовар.attributes.price_wholesale_large,
													структураТовар.attributes.price_prime_cost,
													структураТовар.attributes.price_b2b,
													структураТовар.attributes.price_mip);
															
		строкиРеквизиты = настройкаРеквизиты.НайтиСтроки(Новый Структура("ВидНоменклатуры",строкаВид.ВидНоменклатуры));
											
		Для каждого строкаРеквизит Из строкиРеквизиты Цикл
			
			Попытка
				РеквизитССайта = структураТовар.attributes[строкаРеквизит.НаименованиеРеквизитаССайта];
			Исключение
				массивОшибок.Добавить("Для товара с id " + структураТовар.good_id_market + " не передано значение обязательного реквизита " + строкаРеквизит.НаименованиеРеквизитаССайта);
				Продолжить;	
			КонецПопытки;
			
			ТипЗначения = строкаРеквизит.ДополнительныйРеквизит.ТипЗначения;
			
			ЗначениеРеквизита = Неопределено;
			Если ЗначениеЗаполнено(строкаРеквизит.АлгоритмПреобразования) Тогда
				Выполнить(строкаРеквизит.АлгоритмПреобразования);
			ИначеЕсли ТипЗначения.СодержитТип(Тип("Булево")) Тогда
				ЗначениеРеквизита = ?(РеквизитССайта = 0, Ложь, Истина);
			ИначеЕсли ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
				Если ТипЗнч(РеквизитССайта) = Тип("Число") Тогда
					РеквизитССайта = Формат(РеквизитССайта,"ЧРД=.; ЧРГ=; ЧН=0; ЧГ=");
				КонецЕсли;
				ЗначениеРеквизита = Справочники.ЗначенияСвойствОбъектов.НайтиПоНаименованию(РеквизитССайта,Истина,,строкаРеквизит.ДополнительныйРеквизит);
			ИначеЕсли ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
				Если ТипЗнч(РеквизитССайта) = Тип("Число") Тогда
					РеквизитССайта = Формат(РеквизитССайта,"ЧРД=.; ЧРГ=; ЧН=0; ЧГ=");
				КонецЕсли;
				ЗначениеРеквизита = Справочники.ЗначенияСвойствОбъектовИерархия.НайтиПоНаименованию(РеквизитССайта,Истина,,строкаРеквизит.ДополнительныйРеквизит);
			Иначе
				ЗначениеРеквизита = РеквизитССайта;			
			КонецЕсли;
			
			Если ЗначениеРеквизита = Неопределено Тогда
				массивОшибок.Добавить("Для товара с id " + структураТовар.good_id_market + " не удалось получить значение обязательного реквизита " + строкаРеквизит.НаименованиеРеквизитаССайта);
				Продолжить;	
			КонецЕсли;

			НовСтр = ТЗСвойствТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, СтруктураОбщихРеквизитов);
			НовСтр.ДопРеквизит = строкаРеквизит.ДополнительныйРеквизит;
			НовСтр.Значение = ЗначениеРеквизита;
			
		КонецЦикла;	
			
	КонецЦикла;	
	
	Если массивОшибок.Количество() Тогда		
				
		структураОтвет.errorCode = 102;
		структураОтвет.errorDescription = СтрСоединить(массивОшибок,Символы.ПС);
		
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);

	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
			|    ТЗ.ИДТовара КАК ИДТовара,
			|    ТЗ.Номенклатура КАК Номенклатура,
			|    ТЗ.ВидНоменклатуры КАК ВидНоменклатуры,
			|    ТЗ.Количество КАК Количество,
			|    ТЗ.Сумма КАК Сумма,
			|    ТЗ.ЦенаРозничная КАК ЦенаРозничная,
			|    ТЗ.ЦенаОптовая КАК ЦенаОптовая,
			|    ТЗ.ЦенаЗакупочная КАК ЦенаЗакупочная,
			|    ТЗ.ЦенаB2B КАК ЦенаB2B,
			|    ТЗ.ЦенаМИЦ КАК ЦенаМИЦ,
			|    ТЗ.ДопРеквизит КАК ДопРеквизит,
			|    ТЗ.Значение КАК Значение
			|ПОМЕСТИТЬ ВТ_СвойстваТоваров
			|ИЗ
			|    &ТЗСвойстТоваров КАК ТЗ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|    АкцииПоПромокоду.Ссылка КАК Акция,
			|    АкцииПоПромокоду.ВидАкции КАК ВидАкции,
			|    АкцииПоПромокоду.Промокод КАК Промокод,
			|    АкцииПоПромокоду.МожноИспользовать КАК МожноИспользовать,
			|    АкцииПоПромокоду.ВидНоменклатуры КАК ВидНоменклатуры,
			|    Экс_АкцииПоПромокодамСкидки.КодСтроки КАК КодСтроки,
			|    Экс_АкцииПоПромокодамУсловияАкции.ДопРеквизит КАК ДопРеквизит,
			|    Экс_АкцииПоПромокодамУсловияАкции.Значение КАК Значение,
			|    Экс_АкцииПоПромокодамСкидки.ПроцентСкидки КАК ПроцентСкидки,
			|    Экс_АкцииПоПромокодамСкидки.ВидЦены КАК ВидЦены
			|ПОМЕСТИТЬ ВТ_УсловияАкции
			|ИЗ
			|    (ВЫБРАТЬ
			|        Экс_АкцииПоПромокодамПромокоды.Ссылка КАК Ссылка,
			|        Экс_АкцииПоПромокодамПромокоды.Промокод КАК Промокод,
			|        НЕ Экс_АкцииПоПромокодамПромокоды.Использован
			|            ИЛИ Экс_АкцииПоПромокодамПромокоды.Многоразовость КАК МожноИспользовать,
			|        Экс_АкцииПоПромокодамПромокоды.Ссылка.ВидНоменклатуры КАК ВидНоменклатуры,
			|        Экс_АкцииПоПромокодамПромокоды.Ссылка.ВидАкции КАК ВидАкции
			|    ИЗ
			|        Справочник.Экс_АкцииПоПромокодам.Промокоды КАК Экс_АкцииПоПромокодамПромокоды
			|    ГДЕ
			|        Экс_АкцииПоПромокодамПромокоды.Ссылка.Действует
			|        И НЕ Экс_АкцииПоПромокодамПромокоды.Ссылка.ПометкаУдаления
			|        И Экс_АкцииПоПромокодамПромокоды.Промокод ПОДОБНО &Промокод) КАК АкцииПоПромокоду
			|        ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Экс_АкцииПоПромокодам.УсловияАкции КАК Экс_АкцииПоПромокодамУсловияАкции
			|            ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Экс_АкцииПоПромокодам.Скидки КАК Экс_АкцииПоПромокодамСкидки
			|            ПО Экс_АкцииПоПромокодамУсловияАкции.Ссылка = Экс_АкцииПоПромокодамСкидки.Ссылка
			|                И Экс_АкцииПоПромокодамУсловияАкции.КодСтроки = Экс_АкцииПоПромокодамСкидки.КодСтроки
			|        ПО АкцииПоПромокоду.Ссылка = Экс_АкцииПоПромокодамУсловияАкции.Ссылка
			|            И (Экс_АкцииПоПромокодамУсловияАкции.Значение <> ЗНАЧЕНИЕ(Справочник.ЗначенияСвойствОбъектов.ПустаяСсылка))
			|            И (Экс_АкцииПоПромокодамУсловияАкции.Значение <> ЗНАЧЕНИЕ(Справочник.ЗначенияСвойствОбъектовИерархия.ПустаяСсылка))
			|            И (Экс_АкцииПоПромокодамУсловияАкции.Значение <> """")
			|            И (Экс_АкцииПоПромокодамУсловияАкции.Значение <> 0)
			|            И (Экс_АкцииПоПромокодамУсловияАкции.Значение <> НЕОПРЕДЕЛЕНО)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|    ВТ_УсловияАкции.Акция КАК Акция,
			|    ВТ_УсловияАкции.ВидАкции КАК ВидАкции,
			|    ВТ_УсловияАкции.Промокод КАК Промокод,
			|    ВТ_УсловияАкции.МожноИспользовать КАК МожноИспользовать,
			|    ВТ_УсловияАкции.ВидНоменклатуры КАК ВидНоменклатуры,
			|    ВТ_УсловияАкции.КодСтроки КАК КодСтроки,
			|    ВТ_УсловияАкции.ДопРеквизит КАК ДопРеквизит,
			|    ВТ_УсловияАкции.Значение КАК Значение,
			|    ВТ_УсловияАкции.ПроцентСкидки КАК ПроцентСкидки,
			|    ВТ_УсловияАкции.ВидЦены КАК ВидЦены,
			|    ВТ_СвойстваТоваров.ИДТовара КАК ИДТовара,
			|    ВТ_СвойстваТоваров.Номенклатура КАК Номенклатура,
			|    ВТ_СвойстваТоваров.Количество КАК Количество,
			|    ВТ_СвойстваТоваров.Сумма КАК Сумма,
			|    ВТ_СвойстваТоваров.ЦенаРозничная КАК ЦенаРозничная,
			|    ВТ_СвойстваТоваров.ЦенаОптовая КАК ЦенаОптовая,
			|    ВТ_СвойстваТоваров.ЦенаЗакупочная КАК ЦенаЗакупочная,
			|    ВТ_СвойстваТоваров.ЦенаB2B КАК ЦенаB2B,
			|    ВТ_СвойстваТоваров.ЦенаМИЦ КАК ЦенаМИЦ
			|ПОМЕСТИТЬ ВТ_ТоварыПоАкции
			|ИЗ
			|    ВТ_УсловияАкции КАК ВТ_УсловияАкции
			|        ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СвойстваТоваров КАК ВТ_СвойстваТоваров
			|        ПО ВТ_УсловияАкции.ВидНоменклатуры = ВТ_СвойстваТоваров.ВидНоменклатуры
			|            И (ВТ_СвойстваТоваров.ДопРеквизит = ВТ_УсловияАкции.ДопРеквизит)
			|            И (ВТ_СвойстваТоваров.Значение = ВТ_УсловияАкции.Значение)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|    ВТ_ТоварыПоАкции.КодСтроки КАК КодСтроки
			|ПОМЕСТИТЬ ВТ_ИсключаемыеСтроки
			|ИЗ
			|    ВТ_ТоварыПоАкции КАК ВТ_ТоварыПоАкции
			|ГДЕ
			|    ЕСТЬNULL(ВТ_ТоварыПоАкции.ИДТовара, """") = """"
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|    ВТ_ТоварыПоАкции.Акция КАК Акция,
			|    ВЫРАЗИТЬ(ВТ_ТоварыПоАкции.ВидАкции КАК СТРОКА(20)) КАК ВидАкции,
			|    ВЫРАЗИТЬ(ВТ_ТоварыПоАкции.Промокод КАК СТРОКА(50)) КАК Промокод,
			|    ВТ_ТоварыПоАкции.МожноИспользовать КАК МожноИспользовать,
			|    ВТ_ТоварыПоАкции.ВидНоменклатуры КАК ВидНоменклатуры,
			|    ВТ_ТоварыПоАкции.КодСтроки КАК КодСтроки,
			|    ВТ_ТоварыПоАкции.ПроцентСкидки КАК ПроцентСкидки,
			|    ВТ_ТоварыПоАкции.ВидЦены КАК ВидЦены,
			|    ВТ_ТоварыПоАкции.ИДТовара КАК ИДТовара,
			|    ВТ_ТоварыПоАкции.Номенклатура КАК Номенклатура,
			|    ВТ_ТоварыПоАкции.Количество КАК Количество,
			|    ВТ_ТоварыПоАкции.Сумма КАК Сумма,
			|    ВТ_ТоварыПоАкции.ЦенаРозничная КАК ЦенаРозничная,
			|    ВТ_ТоварыПоАкции.ЦенаОптовая КАК ЦенаОптовая,
			|    ВТ_ТоварыПоАкции.ЦенаЗакупочная КАК ЦенаЗакупочная,
			|    ВТ_ТоварыПоАкции.ЦенаB2B КАК ЦенаB2B,
			|    ВТ_ТоварыПоАкции.ЦенаМИЦ КАК ЦенаМИЦ
			|ПОМЕСТИТЬ ВТ_ДанныеДляРасчета
			|ИЗ
			|    ВТ_ТоварыПоАкции КАК ВТ_ТоварыПоАкции
			|        ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИсключаемыеСтроки КАК ВТ_ИсключаемыеСтроки
			|        ПО ВТ_ТоварыПоАкции.КодСтроки = ВТ_ИсключаемыеСтроки.КодСтроки
			|ГДЕ
			|    ВТ_ИсключаемыеСтроки.КодСтроки ЕСТЬ NULL
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|    ВложенныйЗапрос.ИДТовара КАК ИДТовара,
			|    ВложенныйЗапрос.Количество КАК Количество,
			|    ВложенныйЗапрос.Сумма КАК Сумма,
			|    ВложенныйЗапрос.МинСуммаСоСкидкой КАК МинСуммаСоСкидкой,
			|    МИНИМУМ(ВложенныйЗапрос.СуммаСоСкидкой) КАК СуммаСоСкидкой
			|ИЗ
			|    (ВЫБРАТЬ
			|        ВТ_ДанныеДляРасчета.ИДТовара КАК ИДТовара,
			|        ВТ_ДанныеДляРасчета.Количество КАК Количество,
			|        ВТ_ДанныеДляРасчета.Сумма КАК Сумма,
			|        ВЫБОР
			|            КОГДА ЕСТЬNULL(ОптовыеЦены.Цена, 0) = 0
			|                ТОГДА ВТ_ДанныеДляРасчета.ЦенаОптовая
			|            ИНАЧЕ ОптовыеЦены.Цена
			|        КОНЕЦ * ВТ_ДанныеДляРасчета.Количество КАК МинСуммаСоСкидкой,
			|        ВЫБОР
			|            КОГДА ВТ_ДанныеДляРасчета.ВидАкции ПОДОБНО ""%Процент%""
			|                ТОГДА ВТ_ДанныеДляРасчета.Сумма * (1 - ВТ_ДанныеДляРасчета.ПроцентСкидки / 100)
			|            КОГДА ВТ_ДанныеДляРасчета.ВидАкции ПОДОБНО ""%Вид цены%""
			|                ТОГДА ВЫБОР
			|                        КОГДА ВТ_ДанныеДляРасчета.Номенклатура ЕСТЬ NULL
			|                            ТОГДА ВЫБОР
			|                                    КОГДА ВТ_ДанныеДляРасчета.ВидЦены.Наименование = ""3.Оптовая""
			|                                        ТОГДА ВТ_ДанныеДляРасчета.ЦенаОптовая * ВТ_ДанныеДляРасчета.Количество
			|                                    КОГДА ВТ_ДанныеДляРасчета.ВидЦены.Наименование = ""B2B""
			|                                        ТОГДА ВТ_ДанныеДляРасчета.ЦенаB2B * ВТ_ДанныеДляРасчета.Количество
			|                                    КОГДА ВТ_ДанныеДляРасчета.ВидЦены.Наименование = ""МИЦ""
			|                                        ТОГДА ВТ_ДанныеДляРасчета.ЦенаМИЦ * ВТ_ДанныеДляРасчета.Количество
			|                                КОНЕЦ
			|                        ИНАЧЕ ЦеныПоАкции.Цена * ВТ_ДанныеДляРасчета.Количество
			|                    КОНЕЦ
			|            ИНАЧЕ ВТ_ДанныеДляРасчета.Сумма
			|        КОНЕЦ КАК СуммаСоСкидкой
			|    ИЗ
			|        ВТ_ДанныеДляРасчета КАК ВТ_ДанныеДляРасчета
			|            ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ОптовыеЦены
			|            ПО ВТ_ДанныеДляРасчета.Номенклатура = ОптовыеЦены.Номенклатура
			|                И (ОптовыеЦены.ВидЦены.Наименование = ""3.Оптовая"")
			|            ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныПоАкции
			|            ПО ВТ_ДанныеДляРасчета.Номенклатура = ЦеныПоАкции.Номенклатура
			|                И ВТ_ДанныеДляРасчета.ВидЦены = ЦеныПоАкции.ВидЦены) КАК ВложенныйЗапрос
			|ГДЕ
			|    ЕСТЬNULL(ВложенныйЗапрос.СуммаСоСкидкой, 0) <> 0
			|
			|СГРУППИРОВАТЬ ПО
			|    ВложенныйЗапрос.ИДТовара,
			|    ВложенныйЗапрос.Количество,
			|    ВложенныйЗапрос.Сумма,
			|    ВложенныйЗапрос.МинСуммаСоСкидкой
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|    ВТ_УсловияАкции.Акция КАК Акция,
			|    ВТ_УсловияАкции.ВидАкции КАК ВидАкции,
			|    ВТ_УсловияАкции.Промокод КАК Промокод,
			|    ВТ_УсловияАкции.МожноИспользовать КАК МожноИспользовать,
			|    ВТ_УсловияАкции.ВидНоменклатуры КАК ВидНоменклатуры,
			|    ВТ_УсловияАкции.КодСтроки КАК КодСтроки,
			|    ВТ_УсловияАкции.ДопРеквизит КАК ДопРеквизит,
			|    ВТ_УсловияАкции.Значение КАК Значение,
			|    ВТ_УсловияАкции.ПроцентСкидки КАК ПроцентСкидки,
			|    ВТ_УсловияАкции.ВидЦены КАК ВидЦены
			|ИЗ
			|    ВТ_УсловияАкции КАК ВТ_УсловияАкции";
	
	Запрос.УстановитьПараметр("Промокод", Промокод);
	Запрос.УстановитьПараметр("ТЗСвойствТоваров", ТЗСвойствТоваров);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатАкции = МассивРезультатов[6].Выгрузить();
	
	ПромокодНайден = Ложь;
	
	Если РезультатАкции.Количество() = 0 Тогда
		структураОтвет.errorCode = 110;
		структураОтвет.errorDescription = "Введенный промокод не обнаружен в базе";
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
	Иначе
		Промокоды = РезультатАкции.Скопировать(,"Промокод");
		Промокоды.Свернуть("Промокод");
		Если Промокоды.Найти(Промокод) <> Неопределено Тогда
			ПромокодНайден = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	АкцииПромокоды = РезультатАкции.Скопировать(Новый Структура("МожноИспользовать,Промокод",Истина,),"Акция,Промокод");
	
	Если АкцииПромокоды.Количество() > 0 И ПромокодНайден Тогда
		
		СкидкиПоТоварам = МассивРезультатов[5].Выгрузить();
		
		МассивСкидок = Новый Массив;
		Для каждого Стр Из СкидкиПоТоварам Цикл
			
			СуммаСоСкидкой = 0;
			
			Если Стр.СуммаСоСкидкой < Стр.МинСуммаСоСкидкой Тогда
				СуммаСоСкидкой = Стр.МинСуммаСоСкидкой;
			Иначе
				СуммаСоСкидкой = Окр(СуммаСоСкидкой,2);
			КонецЕсли;	
			
			СтруктураСкидки = Новый Структура();
			СтруктураСкидки.Вставить("good_id_market", Стр.ИДТовара);
			СтруктураСкидки.Вставить("good_discount_sum", СуммаСоСкидкой);
			СтруктураСкидки.Вставить("good_discount_price", Окр(СуммаСоСкидкой/Стр.Количество,2));
			
			МассивСкидок.Добавить(СтруктураСкидки);
			
		КонецЦикла;		
		
		структураОтвет.Вставить("order_discounts", МассивСкидок);
		
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	Иначе
		
		Если ПромокодНайден Тогда	
			структураОтвет.errorCode = 111;
			структураОтвет.errorDescription = "Введенный промокод уже использован ранее";
		Иначе
			структураОтвет.errorCode = 110;
			структураОтвет.errorDescription = "Введенный промокод не обнаружен в базе";
		КонецЕсли;
		
		Возврат ПреобразоватьСтруктуруВHTTPОтвет(структураОтвет);
		
	КонецЕсли;	
			
КонецФункции

Функция ИндексГрузоподъемности(Индексы)
	
	Результат = "";
	Для Н = 1 По стрДлина(Индексы) Цикл
		
		Если СтрНайти("0123456789/",Сред(Индексы,Н,1)) > 0 Тогда
			Результат = Результат + Сред(Индексы,Н,1);
		Иначе
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИндексСкорости(Индексы)
	
	Для Н = 1 По стрДлина(Индексы) Цикл
		
		Если СтрНайти("0123456789/",Сред(Индексы,Н,1)) = 0 Тогда
			Возврат Сред(Индексы,Н);
		КонецЕсли;
		
	КонецЦикла;	
		
КонецФункции

//Притула Р.В. Конец  07.11.2018
#КонецОбласти


