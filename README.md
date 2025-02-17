# README

Нужно:
1. Использовать gem ActiveInteraction => https://github.com/AaronLasseigne/active_interaction отрефакторить класс Users::Create 

Intereset.where(name: params['interests'].split(',')) <---- Крайне не уверен в нужде map но если мы считаем что старый код работал то мы не будем использовать .split(',') (Хотя из названия следует что там дожно быть множество)
В реальном продовом коде params следует вынести в контроллер, но допустим что в текущем контексте мы используем User::Create в нескольких местах кода

2. Исправить опечатку Skil. Есть 2 пути решения. Описать оба.

Первый из них это переиминовать Skil во всех местах где он используется в Skill через поиск по IDE без чувствительности к регистру. Если несколько проектов то пройтись по всем и убедится что все везде верно.
+ Соответвует соглашениям Rails о чистоте кода
+ Дальнейшее поддержание проекта будет упрощенно, не будем плодить опечатки.
- Займет дольше и как следствие дороже в человекочасах (Не в данном случае, а в реальном кейсе)

Второй из них это использовать 
self.table_name = 'skills' в модели
+ Не потребует дополнительной работы
- Не соответвует принятым соглашениям Rails
- Будет сложно поддерживать

Я считаю что более правильный вариант будет использование 1-го подхода (Skil->Skill).
Во первых он будет соответствовать соглашениям в Rails.
Во вторых на длинной дистанции единовременно затраченные часы окупятся как инвестиция.

3. Исправить связи


4. Поднять Rails приложение и в нем использовать класс Users::Create
5. Написать тесты
6. При рефакторнге кода использовать Декларативное описание(подход в программировании)
