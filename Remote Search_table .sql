-- Accept user input for nid
Clear screen;
SET SERVEROUTPUT ON;
SET VERIFY OFF;
-- Accept user input for nid
ACCEPT user_nid PROMPT 'Enter the nid number: '

-- Search for a user by nid in users_frg1 table
DECLARE
    v_user_nid VARCHAR2(30);
BEGIN
    v_user_nid := '&user_nid';
    
    -- Search for a user by nid in users_frg1 table
    FOR user_row IN (SELECT * FROM users_frg1@SERVER WHERE nid = v_user_nid) LOOP
        DBMS_OUTPUT.PUT_LINE('User Info (Fragment 1): ' ||'NID: '|| user_row.nid || ', ' ||'NAME: '|| user_row.name || ', ' ||'CITY: '|| user_row.city);
    END LOOP;

    -- Search for a user by nid in users_frg2 table
    FOR user_row IN (SELECT * FROM users_frg2@SERVER WHERE nid = v_user_nid) LOOP
        DBMS_OUTPUT.PUT_LINE('User Info (Fragment 2): ' || 'NID: '||user_row.nid || ', ' ||'VID: '|| user_row.vid || ', ' ||'CID: '|| user_row.cid);
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
