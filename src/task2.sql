-- Напишите хранимую процедуру indexing_salary, которая повышает зарплаты всех сотрудников на определённый процент. 
-- Процедура принимает один целочисленный параметр — процент индексации p. 
-- Сотрудникам, которые получают зарплату по ставке ниже средней относительно всех сотрудников до индексации, начисляют дополнительные 2% (p + 2).
-- Ставка остальных сотрудников увеличивается на p%.

CREATE OR REPLACE PROCEDURE indexing_salary(p_percent INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
	_avg_rate FLOAT;
	_new_rate INTEGER;
	_record RECORD;
	_extra_percent CONSTANT INTEGER := 2;
BEGIN
	SELECT AVG(rate) INTO _avg_rate FROM employees;
	FOR _record IN SELECT id, rate FROM employees LOOP
		IF _record.rate < _avg_rate THEN
			_new_rate := FLOOR(_record.rate * ((p_percent + _extra_percent)::NUMERIC/100 + 1));
		ELSE
			_new_rate := FLOOR(_record.rate * (p_percent::NUMERIC/100 + 1));
		END IF;
		UPDATE employees SET rate = _new_rate WHERE id = _record.id;
	END LOOP;
END;
$$;
