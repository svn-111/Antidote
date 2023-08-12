Clear screen;
SET SERVEROUTPUT ON;
SET VERIFY OFF;
-- Create the package specification
CREATE OR REPLACE PACKAGE user_registration_pkg AS
  PROCEDURE register_user1(name IN users_frg1.name%TYPE, nid IN users_frg1.nid%TYPE, phn IN users_frg1.mob%TYPE, brd IN users_frg1.birth_date%TYPE);
  PROCEDURE register_user2(nid IN users_frg2.nid%TYPE, vid IN vaccine_record.vid%TYPE);
END;
/

-- Create the package body
CREATE OR REPLACE PACKAGE BODY user_registration_pkg AS
  PROCEDURE register_user1(name IN users_frg1.name%TYPE, nid IN users_frg1.nid%TYPE, phn IN users_frg1.mob%TYPE, brd IN users_frg1.birth_date%TYPE) IS
  BEGIN
    INSERT INTO users_frg1 VALUES (nid, name, 'Sylhet', phn, brd);
    EXCEPTION 
      WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('User already exists');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Other errors');
  END;
  
  PROCEDURE register_user2(nid IN users_frg2.nid%TYPE, vid IN vaccine_record.vid%TYPE) IS
    random_center_no NUMBER;
    cnt INTEGER;
    X INTEGER := vid;
  BEGIN
    SELECT cnt INTO cnt FROM vaccine_record WHERE vid = X;
    DBMS_OUTPUT.PUT_LINE(cnt);
    random_center_no := trunc(dbms_random.value(1, cnt + 1));

    UPDATE vaccine_record SET cnt = cnt - 1 WHERE vid = X;

    INSERT INTO users_frg2 VALUES (nid, vid, random_center_no);

    EXCEPTION 
      WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('User already exists');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Other errors');
  END;
END;
/

-- Create the trigger
CREATE OR REPLACE TRIGGER INSERT_MSG
AFTER INSERT 
ON users_frg1
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('User created!');
END;
/

-- Gather user input and call procedures
ACCEPT NAME CHAR PROMPT "Enter your name = "
ACCEPT NID CHAR PROMPT "NID = "
ACCEPT PHN NUMBER PROMPT "Phone = "
ACCEPT BRD CHAR PROMPT "Birth_Date(YYYY-MM-DD) = "
ACCEPT VID NUMBER PROMPT "Vaccine ID = "

DECLARE
  name users_frg1.name%TYPE;
  nid users_frg1.nid%TYPE;
  vid users_frg2.vid%TYPE;
  phn users_frg1.mob%TYPE;
  brd users_frg1.birth_date%TYPE;
BEGIN
  name := '&NAME';
  nid := '&NID';
  phn := &PHN;
  brd := TO_DATE('&BRD', 'YYYY-MM-DD');
  vid := &VID;
  
  user_registration_pkg.register_user1(name, nid, phn, brd);
  user_registration_pkg.register_user2(nid, vid);
  
  COMMIT; -- Don't forget to commit the changes
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK; -- Rollback changes if an error occurs
END;
/
commit;