--Все школы, откуда присутствуют ученики
SELECT DISTINCT school
FROM proj.student;

--Количество учеников в каждой группе
SELECT gr.groupid, name AS group_name, COUNT(st.studentid) AS student_count
FROM proj.group AS gr
LEFT JOIN proj.student AS st ON st.groupid = gr.groupid
GROUP BY gr.groupid
ORDER BY student_count DESC;

--Количество OK посылок в каждой группе
SELECT gr.groupid, name AS group_name, COUNT(s.status) AS ok_count
FROM proj.submission AS s
JOIN proj.student AS st ON s.studentid = st.studentid
RIGHT JOIN proj.group AS gr ON st.groupid = gr.groupid
WHERE s.status = 'OK' OR s.status is NULL
GROUP BY gr.groupid
ORDER BY ok_count DESC;

--Ученики без успешных посылок
SELECT DISTINCT st.studentid, firstname, surname
FROM proj.student AS st
LEFT JOIN proj.submission AS sub ON st.studentid = sub.studentid AND status = 'OK'
WHERE sub.studentid IS NULL;

--Все группы, где больше одного учителя
SELECT g.groupid, name, COUNT(*) AS teacher_count
FROM proj.group g
JOIN proj.teacher_in_group t ON g.groupid = t.groupid
GROUP BY g.groupid, name
HAVING COUNT(*) > 1
ORDER BY g.groupid;

--Находит количество посылок в каждом контесте
SELECT c.contestid, c.name, COUNT(s.taskid) AS submissions_count
FROM proj.contest AS c
LEFT JOIN proj.task_in_contest AS t ON c.contestid = t.contestid
LEFT JOIN proj.submission AS s ON t.taskid = s.taskid
GROUP BY c.contestid
ORDER BY submissions_count DESC;

--Частота каждого статуса посылки
SELECT status, COUNT(*) AS status_count
FROM proj.submission
GROUP BY status
ORDER BY status_count DESC;

--Количество посылок со статусом ок у каждого ученика
SELECT DISTINCT st.studentid, SUM(CASE WHEN status = 'OK' THEN 1 ELSE 0 END) OVER (PARTITION BY st.studentid) AS ok_count
FROM proj.student AS st
LEFT JOIN proj.submission AS sub ON st.studentid = sub.studentid
ORDER BY ok_count DESC;

--Для каждой группы последняя посылку, кто ее сделал и по какой задаче
SELECT gr.groupid, sub.studentid, taskid, validfrom, status
FROM (
    SELECT st.groupid, sub.studentid, taskid, validfrom, validto, status,
        ROW_NUMBER() OVER (PARTITION BY st.groupid ORDER BY validfrom DESC) AS row
    FROM proj.group AS gr
    JOIN proj.student AS st ON gr.groupid = st.groupid
    JOIN proj.submission AS sub ON sub.studentid = st.studentid
) AS sub
RIGHT JOIN proj.group AS gr ON sub.groupid = gr.groupid
WHERE row = 1 OR row IS NULL;

--Для каждого ученика насколько меньше задач он заслал, чем максимум в его группе
WITH submission_count AS (
    SELECT st.studentid, groupid, SUM(CASE WHEN status = 'OK' THEN 1 ELSE 0 END) OVER (PARTITION BY st.studentid) AS ok_count
    FROM proj.student AS st
    LEFT JOIN proj.submission AS sub ON st.studentid = sub.studentid
),
max_in_group AS (
    SELECT groupid, MAX(ok_count) AS max_count
    FROM submission_count
    GROUP BY groupid
)
SELECT DISTINCT st.studentid, st.groupid, mx.max_count - cnt.ok_count AS difference
FROM proj.student AS st
LEFT JOIN max_in_group AS mx ON st.groupid = mx.groupid
LEFT JOIN submission_count AS cnt ON st.studentid = cnt.studentid
ORDER BY st.studentid;
