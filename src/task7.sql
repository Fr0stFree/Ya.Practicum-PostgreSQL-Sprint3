-- Напишите для бухгалтерии функцию calculate_month_salary для расчёта зарплаты за месяц.
-- Функция принимает в качестве параметров даты начала и конца месяца и возвращает результат в виде таблицы с 
-- четырьмя полями: id (сотрудника), employee (имя сотрудника), worked_hours и salary.
-- Процедура суммирует все залогированные часы за определённый месяц и умножает на актуальную почасовую ставку сотрудника. 
-- Исключения — записи с флажками required_review и is_paid. Если суммарно по всем проектам сотрудник отработал 
-- более 160 часов в месяц, все часы свыше 160 оплатят с коэффициентом 1.25.

CREATE OR REPLACE FUNCTION calculate_month_salary(
	p_start_date DATE,
	p_end_date DATE
)
RETURNS TABLE(
	id UUID,
	employee TEXT,
	worked_hours INTEGER,
	salary NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
	_empl_record RECORD;
	_work_record RECORD;
	_has_notified BOOLEAN;
	_overtime_multiplier CONSTANT NUMERIC := 1.25;
	_hours_threshold CONSTANT INTEGER := 160;
BEGIN
	FOR _empl_record IN SELECT e.id, e.name, e.rate FROM employees AS e LOOP
		id := _empl_record.id;
		employee := _empl_record.name;
		worked_hours := 0;
		salary := 0;
		FOR _work_record IN
			SELECT
				l.employee_id,
				SUM(l.work_hours) AS total_hours,
				DATE_TRUNC('month', l.work_date) AS month,
				l.required_review
			FROM logs AS l
			WHERE l.employee_id = _empl_record.id 
				AND NOT l.is_paid
				AND l.work_date BETWEEN p_start_date AND p_end_date
			GROUP BY l.employee_id, DATE_TRUNC('month', l.work_date), l.required_review
		LOOP
			IF _work_record.required_review THEN
				RAISE NOTICE 'Warning! Employee "%" hours must be reviewed', _work_record.employee_id;
				CONTINUE;
			END IF;
			worked_hours := worked_hours + _work_record.total_hours;
			IF _work_record.total_hours <= _hours_threshold THEN
				salary := salary + _empl_record.rate * _work_record.total_hours;
			ELSE
				salary := salary + _empl_record.rate * _hours_threshold + _empl_record.rate * (_work_record.total_hours - _hours_threshold) * _overtime_multiplier;
			END IF;
		END LOOP;
		RETURN NEXT;
	END LOOP;
	RETURN;
END;
$$;
