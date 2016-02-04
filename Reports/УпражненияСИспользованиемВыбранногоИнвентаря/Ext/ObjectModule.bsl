﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
ИмяКолонкиИзображения = "Изображение";
ДокументРезультат.Очистить();

КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
//Получаем параметр отчета ШиринаКолонкиИзображения, и устанавливаем ширину колонки, в которой предполагаем выводить изображение
ШиринаКолонкиИзображения = ВернутьЗначениеПараметраНастройкиСКД(КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы, "ШиринаКолонкиИзображения", 30); //В средних символах

ПолеИзображения = СхемаКомпоновкиДанных.НаборыДанных.Список.Поля.Найти(ИмяКолонкиИзображения);
Если Не ПолеИзображения = Неопределено Тогда
     ОформлениеМинимальнойШириныКолонки = СхемаКомпоновкиДанных.НаборыДанных.Список.Поля.Найти(ИмяКолонкиИзображения).Оформление.Элементы.Найти("МинимальнаяШирина");
     ОформлениеМинимальнойШириныКолонки.Использование = Истина;
     ОформлениеМинимальнойШириныКолонки.Значение = ШиринаКолонкиИзображения;
КонецЕсли;
 

//Выводим макет, здесь все почти стандартно.

Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки);
ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
ПроцессорВывода.НачатьВывод();
Пока Истина Цикл
     ЭлементРезультата = ПроцессорКомпоновки.Следующий();
     Если ЭлементРезультата = Неопределено Тогда Прервать;КонецЕсли; 
     ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
     Если ЭлементРезультата.ЗначенияПараметров.Количество() = 0 Тогда Продолжить; КонецЕсли;
 
     Для Каждого ЭлементПараметра Из ЭлементРезультата.ЗначенияПараметров Цикл
         Если ТипЗнч(ЭлементПараметра.Значение) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
             Поля = ДанныеРасшифровки.Элементы[ЭлементПараметра.Значение].ПолучитьПоля();
             Для Каждого Поле Из Поля Цикл
                 Если Поле.Поле = "Изображение" Тогда
                     Если Поле.Значение="" Тогда Продолжить; КонецЕсли;
                     //Поиск номера колонки, с нужным именем ИмяКолонкиИзображения, для таки вывода изображения
                     Для НомерКолонки = 1 По ДокументРезультат.ШиринаТаблицы Цикл
                         Расшифровка = ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы, НомерКолонки, ДокументРезультат.ВысотаТаблицы, НомерКолонки).Расшифровка;
                         Если Расшифровка = Неопределено Тогда Продолжить; КонецЕсли;
                         Поля = ДанныеРасшифровки.Элементы.Получить(Расшифровка).ПолучитьПоля();
                         Если Поля.Найти(ИмяКолонкиИзображения) = Неопределено Тогда Продолжить; КонецЕсли;
                         ОбластьИзображения = ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы, НомерКолонки);
                         ВывестиИзображениеЭлементаНоменклатуры(ДокументРезультат, Поле.Значение, ОбластьИзображения, ШиринаКолонкиИзображения);
                     КонецЦикла;
                КонецЕсли;
            КонецЦикла;
        КонецЕсли;
    КонецЦикла;
КонецЦикла;
ПроцессорВывода.ЗакончитьВывод();
КонецПроцедуры

Процедура ВывестиИзображениеЭлементаНоменклатуры(ТД, ЭлементСправочника, Область, ШиринаКолонкиИзображения)
	 //Если ЭлементСправочника.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
	 //    СтуктураРег = РегистрыСведений.ПрисоединенныеФайлы.Получить(Новый Структура("ПрисоединенныйФайл", ЭлементСправочника));
	 //    ДанныеКартинки = СтуктураРег.ХранимыйФайл.Получить();
	 //Иначе
	 //    ДанныеКартинки = ?(ЗначениеЗаполнено(ЭлементСправочника.Том.ПолныйПутьWindows), ЭлементСправочника.Том.ПолныйПутьWindows, ЭлементСправочника.Том.ПолныйПутьLinux)
	 //    + ЭлементСправочника.ПутьКФайлу;
	 //КонецЕсли;
	 
	 ДанныеКартинки = ЭлементСправочника.Получить();
	 Если ДанныеКартинки=Неопределено Тогда
		 Возврат;
	 КонецЕсли;
	 Рисунок = ВывестиИзображениеВОбластиТД(ДанныеКартинки, ТД, Область);
	 Область.АвтоВысотаСтроки = Ложь;
	 Область.ВысотаСтроки = ШиринаКолонкиИзображения * 1.31 / 0.3759;// Среднее значение пункта 1 пункт = 0.3759 мм (по Wiki)
     Область.Расшифровка = ЭлементСправочника;
     Рисунок.ЦветЛинии = Область.ЦветРамки;
КонецПроцедуры 

 

Функция ВывестиИзображениеВОбластиТД(ДанныеКартинки, ТД, Область)
     Изображение = ТД.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
     Изображение.РазмерКартинки = РазмерКартинки.АвтоРазмер;
     Индекс = ТД.Рисунки.Индекс(Изображение);
     ТД.Рисунки[Индекс].Картинка = Новый Картинка(ДанныеКартинки, Истина);
     ТД.Рисунки[Индекс].Расположить(Область);
     Возврат ТД.Рисунки[Индекс]; 
КонецФункции



Функция ВернутьЗначениеПараметраНастройкиСКД(КоллекцияЭлементовНастройки, ИмяНастройки, ЗначениеПоУмолчанию = Неопределено)

     Настройка = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяНастройки);
     Если Настройка = Неопределено Тогда Возврат ЗначениеПоУмолчанию; КонецЕсли;
     НастрокаПоИД = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Настройка.ИдентификаторПользовательскойНастройки);
     Если Не ЗначениеЗаполнено(НастрокаПоИД.Значение) Тогда 
         Если Не ЗначениеПоУмолчанию = Неопределено Тогда
             НастрокаПоИД.Значение = ЗначениеПоУмолчанию;
         КонецЕсли;
     КонецЕсли;
     Возврат ?(НастрокаПоИД.Использование, НастрокаПоИД.Значение, ЗначениеПоУмолчанию); 
КонецФункции
