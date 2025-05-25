-- Создайте пользовательскую процедуру завершения проекта close_project. 
-- Если проект уже закрыт, процедура должна вернуть ошибку без начисления бонусных часов.
-- Завершая проект, нужно сделать два действия в системе учёта:
-- 1. Изменить значение поля is_active в записи проекта на false — чтобы рабочее время по этому проекту больше не учитывалось.
-- 2. Посчитать бонус, если он есть — то есть распределить неизрасходованное время между всеми членами команды проекта.
--    Неизрасходованное время — это разница между временем, которое выделили на проект (estimated_time), и фактически потраченным. 
--    Если поле estimated_time не задано, бонусные часы не распределятся. Если отработанных часов нет — расчитывать бонус не нужно.

CREATE OR REPLACE PROCEDURE close_project(p_project_id UUID)
LANGUAGE plpgsql
AS $$
DECLARE
	_proj RECORD;
	_bonus INTEGER;
	_contributor_id UUID;
	_total_contributors INTEGER;
	_hours_spent INTEGER;
	_bonus_multiplier CONSTANT NUMERIC := 0.75;
	_max_hours_per_day CONSTANT INTEGER := 16;
BEGIN
	SELECT * INTO STRICT _proj FROM projects WHERE id = p_project_id;

	IF NOT _proj.is_active THEN
		RAISE EXCEPTION 'project "%" is already closed', _proj.id;
	END IF;
	
	UPDATE projects SET is_active = FALSE WHERE id = _proj.id;
	
	IF _proj.estimated_time IS NULL THEN
		RAISE NOTICE 'project "%" is closed; no time was estimated', _proj.id;
		RETURN;
	END IF;
	
	_hours_spent := (SELECT COALESCE(SUM(work_hours), 0) FROM logs WHERE project_id = _proj.id);
	
	IF _hours_spent = 0 THEN
		RAISE NOTICE 'project "%" is close; no time was spent', _proj.id;
		RETURN;
	END IF;
	
	IF _hours_spent >= _proj.estimated_time THEN
		RAISE NOTICE 'project "%s" is closed; % hours are spent which is more than estimated %',
			_proj.id, _hours_spent, _proj.estimated_time;
		RETURN;
	END IF;
	
	_total_contributors = (
		SELECT COUNT(DISTINCT e.id)
		FROM logs AS l JOIN employees AS e ON e.id = l.employee_id
		WHERE l.project_id = _proj.id
	);
	FOR _contributor_id IN
		SELECT DISTINCT e.id
		FROM logs AS l JOIN employees AS e ON e.id = l.employee_id
		WHERE l.project_id = _proj.id
	LOOP
		_bonus := LEAST(_max_hours_per_day, FLOOR((_proj.estimated_time - _hours_spent) * _bonus_multiplier / _total_contributors));
		INSERT INTO logs(employee_id, project_id, work_date, work_hours)
		VALUES (_contributor_id, _proj.id, CURRENT_DATE, _bonus);
	END LOOP;
	RAISE NOTICE 'successfully closed project "%" and added % hour(s) of bonuses for % contributor(s)',
		_proj.id, _bonus, _total_contributors;
	RETURN;
END;
$$;
