CREATE OR REPLACE PROCEDURE register_student_user(
    p_userid integer,
    p_uname character varying,
    p_pin character varying,
    p_usertype character varying,
    p_faculty_name character varying,
    p_skill_set text
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Inserting into the users table
    INSERT INTO users (userid, uname, pin, usertype, faculty_name)
    VALUES (p_userid, p_uname, p_pin, p_usertype, p_faculty_name);

    -- Check if the user is a student, then insert into the student table
    IF p_usertype = 'student' THEN
        INSERT INTO student (userid, skill_set)
        VALUES (p_userid, p_skill_set);
    END IF;
END;
$$;




-- This procedure registers a new project and optionally adds a project description.
CREATE OR REPLACE PROCEDURE register_project(
    p_project_id INTEGER,
    p_project_name CHARACTER VARYING,
    p_project_title CHARACTER VARYING DEFAULT NULL,
    p_project_description TEXT DEFAULT NULL,
    p_skill_set TEXT DEFAULT NULL,
    p_userid INTEGER DEFAULT NULL,
    p_status CHARACTER VARYING DEFAULT NULL,
    p_s_id CHARACTER VARYING DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into the project table
    INSERT INTO public.project (project_id, project_name)
    VALUES (p_project_id, p_project_name);

    -- Check if additional project description details are provided
    IF p_project_title IS NOT NULL THEN
        INSERT INTO public.project_description (
            project_id, 
            project_title, 
            project_description, 
            skill_set, 
            userid, 
            status, 
            s_id
        ) VALUES (
            p_project_id, 
            p_project_title, 
            p_project_description, 
            p_skill_set, 
            p_userid, 
            p_status, 
            p_s_id
        );
    END IF;
END;
$$;




GRANT INSERT, SELECT, UPDATE, DELETE ON public.project_description TO ali_db;


GRANT USAGE, SELECT ON SEQUENCE public.project_description_id_seq TO ali_db;

CALL register_student_user(2022081, 'Ali', 'mypassword123', 'student', 'FCSE', 'programming, data analysis');