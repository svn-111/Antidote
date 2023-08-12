-- Clear the screen (SQL*Plus command)
CLEAR SCREEN;

-- Delete existing tables
DROP TABLE vaccine_record CASCADE CONSTRAINTS;
DROP TABLE vaccine_center CASCADE CONSTRAINTS;
DROP TABLE users_frg1 CASCADE CONSTRAINTS;
DROP TABLE users_frg2 CASCADE CONSTRAINTS;

-- Create vaccine_record and vaccine_center tables
CREATE TABLE vaccine_record (
    vid NUMBER,
    brand VARCHAR2(30),
    cnt INTEGER,
    PRIMARY KEY (vid)
);

CREATE TABLE vaccine_center (
    cid INTEGER,
    city VARCHAR2(30),
    cname VARCHAR2(30),
    PRIMARY KEY (cid)
);

-- Create users_frg1 and users_frg2 tables
CREATE TABLE users_frg1 (
    nid VARCHAR2(30),
    name VARCHAR2(30),
    city VARCHAR2(30),
    mob INTEGER,
    birth_date DATE,
    PRIMARY KEY (nid)
);

CREATE TABLE users_frg2 (
    nid VARCHAR2(30),
    vid INTEGER NULL,
    cid INTEGER NULL
);

-- Insert data into vaccine_center table
INSERT INTO vaccine_center VALUES (1, 'Dhaka', 'Mohanagar Institute');
INSERT INTO vaccine_center VALUES (2, 'Dhaka', 'Jahangir Institute');
INSERT INTO vaccine_center VALUES (3, 'Dhaka', 'Popular Diagnostics');
INSERT INTO vaccine_center VALUES (4, 'Sylhet', 'Sylhet Institute1');
INSERT INTO vaccine_center VALUES (5, 'Sylhet', 'Sylhet Institute2');
INSERT INTO vaccine_center VALUES (6, 'Sylhet', 'Sylhet Institute3');

-- Insert data into vaccine_record table
INSERT INTO vaccine_record VALUES (1, 'AstraZeneca', 100);
INSERT INTO vaccine_record VALUES (2, 'Pfizer', 100);
INSERT INTO vaccine_record VALUES (3, 'Sputnik V', 100);

-- Commit the changes
COMMIT;
