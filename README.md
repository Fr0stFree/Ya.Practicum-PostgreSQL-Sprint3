# Система управления персоналом «Всё записано»

## Описание проекта

Вы работаете в растущей IT-компании Dream Big. Специализация компании — разработка программного обеспечения на заказ. Десятки сотрудников каждый день без устали трудятся над самыми разнообразными проектами: от скромных приложений до грандиозных платформ.

Вы попивали кофе во время перерыва, когда ворвался взъерошенный тимлид Арсений с новой горящей задачей — нужно автоматизировать некоторые процессы в Dream Big для внутренней системы управления персоналом под кодовым названием «Всё записано».

В компании есть база данных PostgreSQL с детализированной информацией о сотрудниках, проектах и логах времени. Сейчас структуре БД и механизмам запросов не хватает гибкости и производительности. Кроме того, политика безопасности проекта гласит: все запросы выполняются строго через функции и процедуры, сырые запросы к таблицам — запрещены.

Ваша задача — создать ряд хранимых процедур и функций, которые оптимизируют и автоматизируют процессы извлечения, анализа и изменения данных. Арсений предполагает, что это позволит менеджерам по персоналу и бухгалтерии Dream Big быстро получать отчёты, анализировать рабочие часы и корректировать данные в режиме реального времени.