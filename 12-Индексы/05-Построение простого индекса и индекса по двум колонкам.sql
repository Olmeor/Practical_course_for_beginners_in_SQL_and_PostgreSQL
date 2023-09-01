--Создадим тестовую таблицу
CREATE TABLE perf_test(
	id int,
	reason text COLLATE "C",
	annotation text COLLATE "C"
);

--Забьем ее фейковыми данными
INSERT INTO perf_test(id, reason, annotation)
SELECT s.id, md5(random()::text), null
FROM generate_series(1, 10000000) AS s(id)
ORDER BY random();

UPDATE perf_test
SET annotation = UPPER(md5(random()::text));

--Пример 1
--Попробуем сделать SELECT

-- Запрос исполнялся 5 сек
SELECT *
FROM perf_test
WHERE id = 3700000
--Выясним, почему так долго с помощью EXPLAIN

-- Понимаем, что работал sequential scan метод сканирования
EXPLAIN
SELECT *
FROM perf_test
WHERE id = 3700000
--Для ускорения создадим индекс

-- Индексы создавались 11 сек.
CREATE INDEX idx_perf_test_id ON perf_test(id);
--Смотрим теперь еще раз метод сканирования

--  Теперь у нас Index scan using idx_perf_test_id
EXPLAIN
SELECT *
FROM perf_test
WHERE id = 3700000
--Теперь этот же запрос занимает меньше времени

-- 61 ms
SELECT *
FROM perf_test
WHERE id = 3700000

--Пример 2
--Сделаем запрос с LIKE

-- Такой запрос отрабатывал 8 сек
SELECT *
FROM perf_test
WHERE reason LIKE 'bc%' AND annotation LIKE 'AB%'
--Выясним, почему так долго

-- Видим опять sequential scan, 
EXPLAIN ANALYZE
SELECT *
FROM perf_test
WHERE reason LIKE 'bc%' AND annotation LIKE 'AB%'
--Построим еще один индекс, по двум колонкам

-- Заняло 27 сек
CREATE INDEX idx_perf_test_reason_annotation ON perf_test(reason, annotation);
--Снова проверим метод сканирования

-- Теперь index scan using idx_perf_test_reason_annotation
EXPLAIN ANALYZE
SELECT *
FROM perf_test
WHERE reason LIKE 'bc%' AND annotation LIKE 'AB%'
--Построение индекса сразу по двум колонкам, дает возможность искать и по одной колонке

-- Bitmap heap scan
EXPLAIN
SELECT *
FROM perf_test
WHERE reason LIKE 'bc%'
--Но, если сделать поиск ТОЛЬКО по другой колонке, то получим

-- Получаем Seq Scan
EXPLAIN
SELECT *
FROM perf_test
WHERE annotation LIKE 'bc%'
