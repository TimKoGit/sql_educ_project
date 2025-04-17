--Проверка, что задача с поддерживаемых платформ
CREATE OR REPLACE FUNCTION correct_platform()
RETURNS TRIGGER AS $$
BEGIN
    IF new.platform != 'codeforces' AND new.platform != 'informatics'
        THEN RAISE EXCEPTION '% is not supported platform', new.platform;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER correct_platform
BEFORE INSERT OR UPDATE ON proj.task
FOR EACH ROW
EXECUTE PROCEDURE correct_platform();


--Автоматическое выставление даты создания группы
CREATE OR REPLACE FUNCTION group_date_trigger()
RETURNS TRIGGER AS $$
BEGIN
    new.date = CURRENT_TIMESTAMP;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER group_date_trigger
BEFORE INSERT ON proj.group
FOR EACH ROW
EXECUTE PROCEDURE group_date_trigger();


--Автоматическая поддержка valid_from/valid_to в посылках
CREATE OR REPLACE FUNCTION submission_time_trigger()
RETURNS TRIGGER AS $$
DECLARE
    infinity TIMESTAMP;
    right_now TIMESTAMP;
BEGIN
    infinity := MAKE_TIMESTAMP(2030, 1, 1, 0, 0, 0);
    right_now := CURRENT_TIMESTAMP;
    UPDATE proj.submission
    SET validto = right_now
    WHERE studentid = new.studentid AND taskid = new.taskid AND validto = infinity;
    new.validfrom = right_now;
    new.validto = infinity;
    return new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER submission_time_trigger
BEFORE INSERT ON proj.submission
FOR EACH ROW
EXECUTE PROCEDURE submission_time_trigger();

