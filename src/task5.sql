-- Создайте отдельную таблицу employee_rate_history. Внесите в таблицу текущие данные всех сотрудников. 
-- В качестве from_date используйте дату основания компании: '2020-12-26'. 
-- Напишите триггерную функцию save_employee_rate_history и триггер change_employee_rate.
-- При добавлении сотрудника в таблицу employees и изменении ставки сотрудника триггер автоматически 
-- вносит запись в таблицу employee_rate_history из трёх полей: id сотрудника, его ставки и текущей даты.

CREATE TABLE IF NOT EXISTS employee_rate_history(
	id UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	employee_id UUID REFERENCES employees(id) NOT NULL,
	rate NUMERIC(8, 2) NOT NULL CHECK(rate > 0),
	from_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO employee_rate_history(employee_id, rate, from_date)
	SELECT id, rate, '2020-12-26'::DATE FROM employees;

CREATE OR REPLACE FUNCTION save_employee_rate_history()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	IF OLD.rate IS DISTINCT FROM NEW.rate THEN
		INSERT INTO employee_rate_history(employee_id, rate)
		VALUES (NEW.id, NEW.rate);
	END IF;
	RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER change_employee_rate
AFTER UPDATE OR INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION save_employee_rate_history();
