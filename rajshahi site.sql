Clear screen;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE user_registration_pkg AS
  PROCEDURE register_user(name IN users.name%TYPE, nid IN users.nid%TYPE, vid IN vaccine_record.vid%TYPE,phn IN users.mob%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY user_registration_pkg AS
  PROCEDURE register_user(name IN users.name%TYPE, nid IN users.nid%TYPE, vid IN vaccine_record.vid%TYPE,phn IN users.mob%TYPE) IS
    random_center_no NUMBER;
    cnt INTEGER;
	X INTEGER := vid;
  BEGIN
    SELECT cnt INTO cnt FROM vaccine_record WHERE vid = X;
    DBMS_OUTPUT.PUT_LINE(cnt);
    random_center_no := trunc(dbms_random.value(1, cnt + 1));

    UPDATE vaccine_record SET cnt = cnt - 1 WHERE vid = X;

    INSERT INTO users VALUES (nid, name, 'Rajshahi',vid, random_center_no,phn);

    EXCEPTION 
      WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('User already exists');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Other errors');
  END;
END;
/

CREATE OR REPLACE TRIGGER INSERT_MSG
AFTER INSERT 
ON users
FOR EACH ROW
DECLARE
BEGIN
  DBMS_OUTPUT.PUT_LINE('User created!');
  -- Insert into users@server values(:new.nid, :new.name, 'Dhaka', '', '')
END;
/

ACCEPT NAME CHAR PROMPT "Enter your name = "
ACCEPT NID CHAR PROMPT "NID = "
ACCEPT PHN NUMBER PROMPT "Phone = "
ACCEPT VID NUMBER PROMPT "Vaccine ID = "

DECLARE
  name users.name%TYPE;
  nid users.nid%TYPE;
  vid vaccine_record.vid%TYPE;
  phn users.mob%TYPE;
  
BEGIN
  name := '&NAME';
  nid := '&NID';
  phn := &phn;
  vid := &VID;
  user_registration_pkg.register_user(name, nid, vid, phn);
END;
/