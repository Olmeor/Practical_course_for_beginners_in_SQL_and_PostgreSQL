--Вспомним прошлую проблему, запрос исполняется долго, метод сканирования Sequential scan
EXPLAIN
SELECT *
FROM perf_test
WHERE annotation LIKE 'AB%';

--Можно конечно построить индекс
CREATE INDEX idx_perf_test_annotation ON perf_test(annotation);

--Попробуем другой вариант (придется строить отдельный индекс)
EXPLAIN
SELECT *
FROM perf_test
WHERE LOWER(annotation) LIKE('ab%');

--Можно и для такой ситуации, конечно, построить отдельный индекс

CREATE INDEX idx_perf_test_annotation_lower ON perf_test(LOWER(annotation))

  По выражениям индекс не работает, поэтому надо строить либо нормальный запрос, без использования выражений, либо строить отдельный индекс
