## Комментарии
```lua
--Плохо

-- Хорошо 
```

## Строки
```lua
-- Плохо
string = "hi"

-- Хорошо
string = 'hi'
```

## Переменные
```lua
-- Плохо
visota = 400

-- Хорошо
height = 400
```

## Условные операторы
```lua
-- Плохо
if not thing then
  -- ...код...
else
  -- ...код...
end

-- Хорошо
if thing then
  -- ...код...
else
  -- ...код...
end
```

## Пробелы
* Операторы
```lua
-- Плохо
name='John'

-- Хорошо
name = 'John'
```
* Запятые
```lua
-- Плохо
numbers = {1,2,3}
numbers = {1 , 2 , 3}
numbers = {1 ,2 ,3}

-- Хорошо
numbers = {1, 2, 3}
```
* В конце строк удалять
* В конце файла перенос строки

## Именование
```lua
-- Плохо
snake_case = 'blah'
PascalCase = 'meh'

-- Хорошо
camelCase = 'yay'
```
