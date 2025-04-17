--Получить все посылки ученика по контесту
CREATE OR REPLACE FUNCTION get_all_submissions(surname VARCHAR(100), firstname VARCHAR(100), contest_name VARCHAR(100)) RETURNS TABLE (
    task_name VARCHAR(100), platform VARCHAR(100), link VARCHAR(300), date TIMESTAMP, status VARCHAR(300)
) AS $$
DECLARE
    check_student INTEGER;
    check_contest INTEGER;
BEGIN
    SELECT COUNT(*) INTO check_student
    FROM proj.student AS st
    WHERE st.surname = $1 AND st.firstname = $2;
    
    IF check_student = 0 THEN
        RAISE EXCEPTION '% % is not in the student database!', surname, firstname;
    END IF;
    
    SELECT COUNT(*) INTO check_contest
    FROM proj.contest
    WHERE contest_name = name;
    
    IF check_contest = 0 THEN
        RAISE EXCEPTION '% is not in the contest database!', contest_name;
    END IF;
    
    DROP TABLE IF EXISTS right_submissions;
    CREATE TEMPORARY TABLE right_submissions AS
        SELECT studentid, validfrom, sub.status, t.name AS task_name, t.platform, t.link
        FROM proj.submission AS sub
        JOIN proj.task AS t ON sub.taskid = t.taskid
        JOIN proj.task_in_contest AS t_in_c ON t.taskid = t_in_c.taskid
        JOIN proj.contest AS c ON t_in_c.contestid = c.contestid
        WHERE c.name = contest_name;
    
    RETURN QUERY SELECT sub.task_name, sub.platform, sub.link, validfrom, sub.status
                 FROM right_submissions AS sub
                 JOIN proj.student AS st ON sub.studentid = st.studentid
                 WHERE st.surname = $1 AND st.firstname = $2
                 ORDER BY validfrom, task_name;
END;
$$ LANGUAGE plpgsql;

--Получить весь состав группы
CREATE OR REPLACE FUNCTION get_group_people(group_name VARCHAR(100)) RETURNS TABLE (
    surname VARCHAR(100),
    firstname VARCHAR(100),
    codeforceshandle VARCHAR(100),
    telegram VARCHAR(100),
    grade VARCHAR(100),
    school VARCHAR(100)
) AS $$
DECLARE
    check_if_exists INTEGER;
BEGIN
    SELECT COUNT(*) INTO check_if_exists
    FROM proj.group AS gr
    WHERE name = group_name;
    
    IF check_if_exists = 0 THEN
        RAISE EXCEPTION '% is not in the group database!', group_name;
    END IF;
    
    RETURN QUERY SELECT st.surname, st.firstname, st.codeforceshandle, st.telegram, st.grade, st.school
                 FROM proj.student AS st
                 JOIN proj.group AS gr ON st.groupid = gr.groupid
                 WHERE gr.name = group_name
                 ORDER BY surname, firstname;
END;
$$ LANGUAGE plpgsql;

--Получить в группе количество сданных задач в контесте
CREATE OR REPLACE FUNCTION get_contest_table_by_group(group_name VARCHAR(100), contest_name VARCHAR(100)) RETURNS TABLE (
    surname VARCHAR(100), firstname VARCHAR(100), ok_count INTEGER
) AS $$
DECLARE
    row_record RECORD;
BEGIN
    CREATE TEMPORARY TABLE group_table AS
        SELECT * FROM get_group_people(group_name);
    
    CREATE TEMPORARY TABLE result (surname VARCHAR(100), firstname VARCHAR(100), ok_count INTEGER);
    
    FOR row_record IN SELECT * FROM group_table LOOP
        INSERT INTO result (surname, firstname, ok_count)
        SELECT row_record.surname, row_record.firstname, SUM(CASE WHEN status = 'OK' THEN 1 ELSE 0 END)
        FROM get_all_submissions(row_record.surname, row_record.firstname, contest_name);
    END LOOP;
    
    RETURN QUERY SELECT * FROM result;
END;
$$ LANGUAGE plpgsql;

