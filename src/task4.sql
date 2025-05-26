-- Напишите процедуру log_work для внесения отработанных сотрудниками часов. 
-- Процедура добавляет новые записи о работе сотрудников над проектами.
-- Процедура принимает id сотрудника, id проекта, дату и отработанные часы и вносит данные в таблицу logs. 
-- Если проект завершён, добавить логи нельзя — процедура должна вернуть ошибку Project closed. 
-- Количество залогированных часов может быть в этом диапазоне: от 1 до 24 включительно — нельзя внести менее 1 часа или больше 24.
-- Если количество часов выходит за эти пределы, необходимо вывести предупреждение о недопустимых данных и остановить выполнение процедуры.

CREATE OR REPLACE PROCEDURE log_work(
	p_employee_id UUID,
	p_project_id UUID,
	p_work_date DATE,
	p_worked_hours INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
	_proj RECORD;
	_empl RECORD;
	_is_suspicious BOOLEAN;
BEGIN
	SELECT * INTO STRICT _empl FROM employees WHERE id = p_employee_id;
	SELECT * INTO STRICT _proj FROM projects WHERE id = p_project_id;
	
	IF NOT _proj.is_active THEN
		RAISE EXCEPTION 'project "%" is already closed', _proj.id;
	END IF;
	
	IF p_worked_hours < 1 OR p_worked_hours > 24 THEN
		RAISE EXCEPTION 'invalid worked hours provided; expected - 1..24, got - %', p_worked_hours;
	END IF;
	
	_is_suspicious := p_worked_hours > 16 OR CURRENT_DATE < p_work_date OR CURRENT_DATE - p_work_date > 7;
	
	INSERT INTO logs(employee_id, project_id, work_date, work_hours, required_review)
	VALUES (_empl.id, _proj.id, p_work_date, p_worked_hours, _is_suspicious);
END;
$$;
