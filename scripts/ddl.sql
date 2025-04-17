CREATE SCHEMA IF NOT EXISTS proj;

DROP TABLE IF EXISTS proj.group CASCADE;
CREATE TABLE proj.group (
    groupid INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date TIMESTAMP NOT NULL
);

DROP TABLE IF EXISTS proj.student;
CREATE TABLE proj.student (
    studentid INTEGER PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    groupid INTEGER NOT NULL,
    codeforceshandle VARCHAR(100) NOT NULL,
    telegram VARCHAR(100),
    grade VARCHAR(100) NOT NULL,
    school VARCHAR(100) NOT NULL,
        FOREIGN KEY (groupid) REFERENCES proj.group(groupid)
);

DROP TABLE IF EXISTS proj.teacher;
CREATE TABLE proj.teacher (
    teacherid INTEGER PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    telegram VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS proj.contest;
CREATE TABLE proj.contest (
    contestid INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    theme VARCHAR(200),
    startdate TIMESTAMP NOT NULL,
    duratation INTERVAL NOT NULL
);

DROP TABLE IF EXISTS proj.task;
CREATE TABLE proj.task (
    taskid INTEGER PRIMARY KEY,
    platform VARCHAR(100) NOT NULL,
    link VARCHAR(300) NOT NULL,
    name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS proj.submission;
CREATE TABLE proj.submission (
    studentid INTEGER NOT NULL,
    taskid INTEGER NOT NULL,
    validfrom TIMESTAMP NOT NULL,
    validto TIMESTAMP NOT NULL,
    status VARCHAR(300) NOT NULL,
        PRIMARY KEY (studentid, taskid, validfrom),
        FOREIGN KEY (studentid) REFERENCES proj.student(studentid),
        FOREIGN KEY (taskid) REFERENCES proj.task(taskid)
);

DROP TABLE IF EXISTS proj.contest_in_group;
CREATE TABLE proj.contest_in_group (
    groupid INTEGER NOT NULL,
    contestid INTEGER NOT NULL,
        FOREIGN KEY (groupid) REFERENCES proj.group(groupid),
        FOREIGN KEY (contestid) REFERENCES proj.contest(contestid),
        PRIMARY KEY (groupid, contestid)
);

DROP TABLE IF EXISTS proj.task_in_contest;
CREATE TABLE proj.task_in_contest (
    contestid INTEGER NOT NULL,
    taskid INTEGER NOT NULL,
        FOREIGN KEY (taskid) REFERENCES proj.task(taskid),
        FOREIGN KEY (contestid) REFERENCES proj.contest(contestid),
        PRIMARY KEY (contestid, taskid)
);

DROP TABLE IF EXISTS proj.teacher_in_group;
CREATE TABLE proj.teacher_in_group (
    teacherid INTEGER NOT NULL,
    groupid INTEGER NOT NULL,
        FOREIGN KEY (groupid) REFERENCES proj.group(groupid),
        FOREIGN KEY (teacherid) REFERENCES proj.teacher(teacherid),
        PRIMARY KEY (teacherid, groupid)
);
