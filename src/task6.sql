-- Чтобы вычислить айтиголиков проекта, напишите функцию best_project_workers.
-- Функция принимает id проекта и возвращает таблицу с именами трёх сотрудников,
-- которые залогировали максимальное количество часов в этом проекте. 
-- Результирующая таблица состоит из двух полей: имени сотрудника и количества часов, отработанных на проекте.

CREATE OR REPLACE FUNCTION best_project_workers(p_project_id UUID)
RETURNS TABLE(
    name TEXT,
    total_hours NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
	_max_employees CONSTANT INTEGER := 3;
BEGIN
    RETURN QUERY
    SELECT 
        e.name::TEXT as name,
        SUM(work_hours)::NUMERIC as total_hours
    FROM logs AS l
    JOIN employees AS e ON e.id = l.employee_id
    WHERE l.project_id = p_project_id
    GROUP BY e.name
    ORDER BY total_hours DESC, COUNT(DISTINCT l.work_date) DESC, RANDOM()
    LIMIT _max_employees;
END;
$$;
