-- Напишите хранимую процедуру update_employees_rate, которая обновляет почасовую ставку сотрудников на определённый процент.
-- При понижении ставка не может быть ниже минимальной — 500 рублей в час.
-- Если по расчётам выходит меньше, устанавливают минимальную ставку.

CREATE OR REPLACE PROCEDURE update_employees_rate(p_records JSON)
LANGUAGE plpgsql
AS $$
DECLARE
	_record JSON;
	_koef NUMERIC;
	_min_salary CONSTANT INTEGER := 500;
BEGIN
    FOR _record IN SELECT JSON_ARRAY_ELEMENTS(p_records) LOOP
		_koef := (_record ->> 'rate_change')::NUMERIC / 100 + 1;
        UPDATE employees 
			SET rate = GREATEST(rate * _koef, _min_salary)
			WHERE id = (_record ->> 'employee_id')::UUID;
    END LOOP;
END;
$$;