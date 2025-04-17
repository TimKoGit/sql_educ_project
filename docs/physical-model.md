# Физическая модель

---

Таблица `student`:

| Название           | Описание                           | Тип данных     | Ограничение   |
|--------------------|------------------------------------|----------------|---------------|
| `studentid`        | Идентификатор                      | `INTEGER`      | `PRIMARY KEY` |
| `firstname`        | Имя ученика                        | `VARCHAR(100)` | `NOT NULL`    |
| `surname`          | Фамилия ученика                    | `VARCHAR(100)` | `NOT NULL`    |
| `groupid`          | В какой группе состоит             | `INTEGER`      | `FOREIGN KEY` |
| `codeforceshandle` | Хэндл на сайте codeforces.com      | `VARCHAR(100)` | `NOT NULL`    |
| `telegram`         | Телеграм                           | `VARCHAR(100)` |               |
| `grade`            | Класс ученика                      | `VARCHAR(100)` | `NOT NULL`    |
| `school`           | Школа ученика                      | `VARCHAR(100)` | `NOT NULL`    |

Таблица `teacher`:

| Название    | Описание                 | Тип данных     | Ограничение   |
|-------------|--------------------------|----------------|---------------|
| `teacherid` | Идентификатор            | `INTEGER`      | `PRIMARY KEY` |
| `firstname` | Имя учителя              | `VARCHAR(100)` | `NOT NULL`    |
| `surname`   | Фамилия учителя          | `VARCHAR(100)` | `NOT NULL`    |
| `telegram`  | Телеграм                 | `VARCHAR(100)` | `NOT NULL`    |

Таблица `group`:

| Название  | Описание        | Тип данных     | Ограничение   |
|-----------|-----------------|----------------|---------------|
| `groupid` | Идентификатор   | `INTEGER`      | `PRIMARY KEY` |
| `name`    | Название группы | `VARCHAR(100)` | `NOT NULL`    |
| `date`    | Дата создания   | `TIMESTAMP`    |  `NOT NULL`   |

Таблица `contest`:

| Название     | Описание          | Тип данных     | Ограничение   |
|--------------|-------------------|----------------|---------------|
| `contestid`  | Идентификатор     | `INTEGER`      | `PRIMARY KEY` |
| `name`       | Название контеста | `VARCHAR(100)` | `NOT NULL`    |
| `theme`      | Тема контеста     | `VARCHAR(200)` |               |
| `startdate`  | Начало контеста   | `TIMESTAMP`    | `NOT NULL`    |
| `duratation` | Длительность      | `INTERVAL`     | `NOT NULL`    |

Таблица `task`:

| Название   | Описание         | Тип данных     | Ограничение   |
|------------|------------------|----------------|---------------|
| `taskid`   | Идентификатор    | `INTEGER`      | `PRIMARY KEY` |
| `platform` | Платформа (сайт) | `VARCHAR(100)` | `NOT NULL`    |
| `link`     | Ссылка           | `VARCHAR(300)` | `NOT NULL`    |
| `name`     | Название задачи  | `VARCHAR(100)` | `NOT NULL`    |

Таблица `submission`:

| Название    | Описание        | Тип данных     | Ограничение                  |
|-------------|-----------------|----------------|------------------------------|
| `studentid` | Кто послал      | `INTEGER`      | `PRIMARY KEY`, `FOREIGN KEY` |
| `taskid`    | По какой задаче | `INTEGER`      | `PRIMARY KEY`, `FOREIGN KEY` |
| `validfrom` | Когда послал    | `TIMESTAMP`    | `PRIMARY KEY`                |
| `validto`   | Когда следующая | `TIMESTAMP`    | `NOT NULL`                   |
| `status`    | Статус          | `VARCHAR(300)` | `NOT NULL`                   |

Таблица `contest_in_group`:

| Название    | Описание                | Тип данных | Ограничение                  |
|-------------|-------------------------|------------|------------------------------|
| `groupid`   | Группа из соответствия  | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |
| `contestid` | Контест из соответствия | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |

Таблица `task_in_contest`:

| Название    | Описание                | Тип данных | Ограничение                  |
|-------------|-------------------------|------------|------------------------------|
| `contestid` | Контест из соответствия | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |
| `taskid`    | Задача из соответствия  | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |

Таблица `teacher_in_group`

| Название    | Описание                      | Тип данных | Ограничение                  |
|-------------|-------------------------------|------------|------------------------------|
| `teacherid` | Преподаватель из соответствия | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |
| `groupid`   | Группа из соответствия        | `INTEGER`  | `PRIMARY KEY`, `FOREIGN KEY` |
