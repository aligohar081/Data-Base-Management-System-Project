BEGIN;


CREATE TABLE faculty_member
(
    userid integer NOT NULL,
    job_title character varying(255) COLLATE pg_catalog."default",
    role character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT faculty_member_pkey PRIMARY KEY (userid)
);


CREATE TABLE student
(
    userid integer NOT NULL,
    skill_set text COLLATE pg_catalog."default",
    CONSTRAINT student_pkey PRIMARY KEY (userid)
);

CREATE TABLE users
(
    userid integer NOT NULL,
    uname character varying(255) COLLATE pg_catalog."default",
    pin character varying(255) COLLATE pg_catalog."default",
    usertype character varying(255) COLLATE pg_catalog."default",
    faculty_name character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (userid)
);


CREATE TABLE group_members
(
    project_id integer,
    mem_1 integer,
    mem_2 integer,
    mem_3 integer,
    mem_4 integer
);

CREATE TABLE project
(
    project_id integer NOT NULL,
    project_name character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT project_pkey PRIMARY KEY (project_id)
);

CREATE TABLE project_description
(
    project_id integer,
    project_title character varying(255) COLLATE pg_catalog."default",
    project_description text COLLATE pg_catalog."default",
    skill_set text COLLATE pg_catalog."default",
    userid integer,
    status character varying(255) COLLATE pg_catalog."default",
    s_id character varying COLLATE pg_catalog."default"
);


ALTER TABLE faculty_member
    ADD CONSTRAINT fk_faculty_member_users FOREIGN KEY (userid)
    REFERENCES users (userid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX IF NOT EXISTS faculty_member_pkey
    ON faculty_member(userid);


ALTER TABLE group_members
    ADD CONSTRAINT fk_group_members_project FOREIGN KEY (project_id)
    REFERENCES project (project_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE group_members
    ADD FOREIGN KEY (mem_1, mem_2, mem_3, mem_4)
    REFERENCES student (userid, userid, userid, userid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE project_description
    ADD CONSTRAINT fk_project_description_project FOREIGN KEY (project_id)
    REFERENCES project (project_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE project_description
    ADD CONSTRAINT fk_project_description_users FOREIGN KEY (userid)
    REFERENCES users (userid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE  student
    ADD CONSTRAINT fk_student_users FOREIGN KEY (userid)
    REFERENCES users (userid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX IF NOT EXISTS student_pkey
    ON student(userid);

END;