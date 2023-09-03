--Создадим таблицу
CREATE TABLE chess_game (
	white_player text,
	black_player text,
	moves text[],
	final_state text[][]
);

--Заполним данными
INSERT INTO chess_game
VALUES(
    'Caruana',
    'Nakamura',
    '{"d4", "d5", "c4", "c6"}',
    '{
        {"Ra8", "Qe8", "x", "x", "x", "x", "x", "x"},
        {"a7", "x", "x", "x", "x", "x", "x", "x"},
        {"Kb5", "Bc5", "d5", "x", "x", "x", "x", "x"}
    }'
);

--Можно также было использовать такой синтаксис (лучше читается)
INSERT INTO chess_game
VALUES(
    'Caruana',
    'Nakamura',
    ARRAY['d4', 'd5', 'c4', 'c6'],
    ARRAY[
        ['Ra8', 'Qe8', 'x', 'x', 'x', 'x', 'x', 'x'],
        ['a7', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
        ['Kb5', 'Bc5', 'd5', 'x', 'x', 'x', 'x', 'x']
    ]
);

--Посмотрим на выборку
SELECT *
FROM chess_game;

--Выберем конкретные ходы (со 2 по 3)
-- (отсчет начинается с 1)
SELECT moves[2:3]
FROM chess_game

--Выберем конкретные ходы (с 1 по 3)
SELECT moves[:3]
FROM chess_game

--Выберем конкретные ходы (со 2 по последний)
SELECT moves[2:]
FROM chess_game

--Выберем размерность массива и его длину
SELECT array_dims(moves), array_length(moves, 1)
FROM chess_game;

--Обновим массив
UPDATE chess_game
SET moves = ARRAY['e4', 'd6', 'd4', 'Kf6'];

--Обновить конкретный элемент массива
UPDATE chess_game
SET moves[4] = 'g6';

--Найти записи, в которых в массиве содержится значение
SELECT *
FROM chess_game
WHERE 'g6' = ANY(moves);
