--Возможность получить информацию про группы и учителей в них
CREATE OR REPLACE VIEW group_information AS
SELECT name AS group_name, date AS creation_date, surname, firstname, telegram
FROM proj.group AS gr
LEFT JOIN proj.teacher_in_group AS t_in_g ON gr.groupid = t_in_g.groupid
LEFT JOIN proj.teacher AS t ON t.teacherid = t_in_g.teacherid
ORDER BY name, surname, firstname;

--Список учеников, и в каких они группах
CREATE OR REPLACE VIEW student_information AS
SELECT surname, firstname, name AS group_name
FROM proj.student AS st
JOIN proj.group AS gr ON st.groupid = gr.groupid
ORDER BY surname, firstname, name;

--Контесты в группах
CREATE OR REPLACE VIEW contest_information AS
SELECT gr.name AS group_name, c.name AS contest_name, startdate, duratation, theme
FROM proj.contest AS c
JOIN proj.contest_in_group AS c_in_gr ON c.contestid = c_in_gr.contestid
JOIN proj.group AS gr ON gr.groupid = c_in_gr.groupid
ORDER BY gr.name, startdate, c.name;

